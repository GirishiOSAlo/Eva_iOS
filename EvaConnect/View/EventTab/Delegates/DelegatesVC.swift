//
//  DelegatesVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class DelegatesVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }

    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var delegateListTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var delegateData: [CommonEventMetaData] = []
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        searchUiView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        delegateListTable.delegate = self
        delegateListTable.dataSource = self
        delegateListTable.registerCell(withType: DelegatesTableCell.self)
        fetchDelegateList()
    }
}

extension DelegatesVC {
    func fetchDelegateList() {
        let parameters: AFParameters = [ "event_id": eventId,
                                         "page": 1,
                                         "user_type": 4] // "user_type": 4 = Delegates
        showActivity()
        NetworkManagerr.request(EndPoints.eventDropDwnList , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let DelegateDetail = try decoder.decode(CommonEventModel.self, from: response.data!)
                    
                    if !(DelegateDetail.error ?? false) {
                        self.delegateData = DelegateDetail.data?.data ?? []
                        self.delegateListTable.reloadData()
//                        self.eventDetail = eventDetail.data?[0]
//                        self.exhibitorsList = self.eventDetail?.exhibitorslists ?? []
//                        self.speakersLists = self.eventDetail?.speakerslists ?? []
//                        self.sponsorsList = self.eventDetail?.sponsorslists ?? []
//                        self.HotelList = self.eventDetail?.eventHotels ?? []
//                        self.VenueList = self.eventDetail?.eventVenu ?? []
//                        self.delegatelists = self.eventDetail?.delegatelists ?? []
//                        if self.isFromSidemenu {
//                            self.addModule(self.meetingListVC, to: self.meetingsView)
//                            self.drpDwnNameLable.text = "Meetings"
//                        } else {
//                            self.addModule(self.eventDetailsVC, to: self.eventDetailsView)
//                            self.drpDwnNameLable.text = "Event Details"
//                        }
                    } else {
                        self.presentAlert("Error","\(DelegateDetail.message ?? "")")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func viewProfileTapped(sender: UIButton) {
        let obj = delegateData[sender.tag]
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = obj.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DelegatesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = delegateListTable.dequeueReusableCell(withIdentifier: DelegatesTableCell.id(), for: indexPath) as! DelegatesTableCell
        let delegate = delegateData[indexPath.row]
        cell.nameLabel.text = delegate.firstName
        cell.companyLabel.text = delegate.companyName
        cell.designationLabel.text = delegate.designation
        cell.viewProfileBtn.tag = indexPath.row
        cell.viewProfileBtn.addTarget(self, action: #selector(self.viewProfileTapped(sender:)), for: .touchUpInside)
        if delegate.logo != nil {
            cell.profileImgView.sd_setImage(with: URL(string: delegate.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        }
        else {
            cell.profileImgView.image = #imageLiteral(resourceName: "profile")
        }
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
