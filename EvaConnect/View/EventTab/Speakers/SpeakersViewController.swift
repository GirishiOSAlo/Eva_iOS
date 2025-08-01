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
    var speakersList: [CommonEventMetaData] = []
    var eventId = 0
    var selectedIndex: Int?
    var currentPage = 1
    var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    func setupUI() {
        self.registerCell()
        fetchSpeakersList(page: currentPage)
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
        let totalHeight = nameLblHeight + subLblHeight + 340.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
    
    @objc func openViewProfile(sender: UIButton) {
        let vc = SpeakersDetailsVC.instantiate()
        vc.speakerData = speakersList[sender.tag]
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
