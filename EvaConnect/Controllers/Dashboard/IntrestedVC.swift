//
//  IntrestedVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/14/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class IntrestedVC: BaseVC { 

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var searchFieldView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var attendees = [EventIntrested]()
    var dashboardItem: DashboardItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSeparatorHidden = true
        // addDummyData()
        setCollectionView()
        searchFieldView.applyShadow()
        getAttendies()
        
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchImageTapped)))
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(cellNib: AddParticipantCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func getAttendies() {
        showActivity()
        let url = "\(EndPoints.eventIntrested)?event_id=\(dashboardItem.id)"
        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[EventIntrested]>>) in
            guard let self = self else { return }
            self.handleResult(result: result)
        }
    }
    
    @objc private func searchImageTapped() {
        let text = (searchTxt.text ?? "").trim
        let params: AFParameters = ["event_id": "\(dashboardItem.id)", "first_name": text.name.first]
        guard let url = params.getURL(EndPoints.eventIntrested) else { return }
        
        attendees.removeAll()
        collectionView.reloadData()
        showActivity()
        
        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[EventIntrested]>>) in
            guard let self = self else { return }
            self.handleResult(result: result)
        }
    }
    
    private func handleResult(result: Result<Wrapper<[EventIntrested]>>) {
        hideActivity()
        switch result {
        case .success(let data):
            if data.error {
                self.presentAlert("Error", data.message, nil)
            } else {
                self.attendees = data.data
                self.collectionView.reloadData()
            }
        case .failure(let error):
            self.presentAlert("Error", nil, error)
        }
    }
}

extension IntrestedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { attendees.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as! AddParticipantCell
//        cell.eventIntrested = attendees[indexPath.item]
        return cell
    }
    
}

extension IntrestedVC: UICollectionViewDelegate {
    
}

extension IntrestedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width / 4) - 16, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 5 }
}
