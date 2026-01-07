//
//  SpeakersViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SpeakersViewController: UIViewController, XIBed {
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    @IBOutlet weak var collectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    var speakersList: [CommonEventMetaData] = []
    var eventId = 0
    var selectedIndex: Int?
    var currentPage = 1
    var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if myUserDefaults.isEventFlow {
            self.eventId = myUserDefaults.isEventFlowEventID
        } else { print("Social FLow") }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSpeakersList(page: currentPage)
    }
    
    func setupUI() {
        self.registerCell()
        noDataLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        noDataLbl.isHidden = true
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: SpeakersCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
        listCollectionVw.reloadData()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    func updateCollectionHeigth() {
        var finalHeight = 0.0
        for speaker in self.speakersList {
            let nameLblHeight = self.heightForView(text: speaker.firstName ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
            let subLblHeight = self.heightForView(text: speaker.description ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            let totalHeight = nameLblHeight + subLblHeight + 350.0
            finalHeight = finalHeight + totalHeight
        }
        self.collectionVwHeight.constant = finalHeight
    }
}

extension SpeakersViewController {
    func fetchSpeakersList(page: Int) {
        let parameters: AFParameters = [ "event_id": eventId,
                                         "page": page,
                                         "user_type": 2] //user_type == 2: speakers
        showActivity()
        NetworkManagerr.request(EndPoints.eventDropDwnList , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let speakerDetail = try decoder.decode(CommonEventModel.self, from: response.data!)
                    
                    if !(speakerDetail.error ?? false) {
                        self.speakersList = speakerDetail.data?.data ?? []
                        self.listCollectionVw.reloadData()
                        self.lastPage = speakerDetail.data?.lastPage ?? 1
                        
                        if self.speakersList.count == 0 {
                            self.noDataLbl.isHidden = false
                            self.collectionVwHeight.constant = 0.0
                        } else {
                            self.noDataLbl.isHidden = true
                            self.updateCollectionHeigth()
                        }
                        
                    } else {
                        self.presentAlert("Error","\(speakerDetail.message ?? "")")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

//MARK: UICollection Delegate & DataSource....
extension SpeakersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.speakersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: SpeakersCVC.ReuseId, for: indexPath) as! SpeakersCVC
        
        let speaker = self.speakersList[indexPath.row]
        
        if let imageUrl = speaker.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            cell.profileImgVw.image = UIImage(named: "profile")
        }
        
        cell.nameLbl.text = speaker.firstName ?? ""
        cell.subLbl.text = speaker.designation ?? ""
        cell.viewProfileBtn.tag = indexPath.row
        cell.viewProfileBtn.addTarget(self, action: #selector(openViewProfile(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let speaker = self.speakersList[indexPath.row]
        let nameLblHeight = self.heightForView(text: speaker.firstName ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
        let subLblHeight = self.heightForView(text: speaker.description ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
        let totalHeight = nameLblHeight + subLblHeight + 350.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
    
    @objc func openViewProfile(sender: UIButton) {
        let vc = SpeakersDetailsVC.instantiate()
        vc.speakerID = speakersList[sender.tag].speakerID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == speakersList.count - 1 {
            print("👉 Last cell is visible")
            // Load next page if not at the end
            if currentPage < lastPage {
                currentPage += 1
                fetchSpeakersList(page: currentPage)
            } else {
                print("Page completed. No Api call")
            }
        }
    }
}
