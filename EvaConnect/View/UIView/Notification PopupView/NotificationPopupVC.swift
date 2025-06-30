//
//  NotificationPopupVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class NotificationPopupVC: UIViewController {

    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var imageview_1: UIImageView!
    @IBOutlet weak var imageview_2: UIImageView!
    @IBOutlet weak var peopleCountLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    
    var tag = 0
    var content = ""
    var notificationId = 0
    var meetingID = ""
    var completion: (() -> ())? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        popupView(uiView: mainView)
        
        if tag == 1 {
            self.okButton.isHidden = false
            self.btnStackView.isHidden = true
            self.joinButton.isHidden = true
            self.locationLabel.isHidden = false
            self.fetchDetails()
        }
        else if tag == 2 {
            self.okButton.isHidden = true
            self.btnStackView.isHidden = false
            self.joinButton.isHidden = true
            self.locationLabel.isHidden = false
            self.fetchDetails()
        }
        else if tag == 3 {
            self.okButton.isHidden = true
            self.btnStackView.isHidden = true
            self.joinButton.isHidden = false
            self.locationLabel.isHidden = false
        }
        else if tag == 4 {
            self.okButton.isHidden = true
            self.btnStackView.isHidden = true
            self.joinButton.isHidden = false
            self.locationLabel.isHidden = true
        }
        
        self.okButton.layer.cornerRadius = self.okButton.frame.size.height/2
        self.joinButton.layer.cornerRadius = self.joinButton.frame.size.height/2
        self.acceptButton.layer.cornerRadius = self.acceptButton.frame.size.height/2
        self.declineButton.layer.cornerRadius = self.declineButton.frame.size.height/2
        self.imageview_1.layer.cornerRadius = self.imageview_1.frame.size.height/2
        self.imageview_2.layer.cornerRadius = self.imageview_2.frame.size.height/2
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(dismissTapGesture)

    }

    @IBAction func onOkBtnTapped(_ sender: UIButton) {
    }
    @IBAction func onJoinBtnTapped(_ sender: UIButton) {
    }
    @IBAction func onAcceptBtnTapped(_ sender: UIButton) {
        self.acceptMeeting()
    }
    @IBAction func onDeclineBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.completion?()
    }
    
    @objc func dismissDidTap() {
        self.dismiss(animated: true)
    }
    
    func updateUI(meetingDetail: CancelDetails) {
        self.titleLabel.text = meetingDetail.title
        self.locationLabel.text = "Location: \(meetingDetail.location ?? "")"
        self.timeLabel.text = "Time: \(meetingDetail.startTime ?? "") - \(meetingDetail.endTime ?? "")"
        if (meetingDetail.users?.count ?? 0) > 0 {
            if (meetingDetail.users?.count ?? 0) > 1 {
                self.peopleCountLbl.text = "\(meetingDetail.users?.first?.userName ?? "") and \(meetingDetail.users?.count ?? 0) Others"
                self.imageview_1.isHidden = false
                imageview_1.sd_setImage(with: URL(string: (meetingDetail.users?[0].userImage)!), placeholderImage: #imageLiteral(resourceName: "default_profile"), options: .progressiveLoad, completed: .none)
                imageview_2.sd_setImage(with: URL(string: (meetingDetail.users?[1].userImage)!), placeholderImage: #imageLiteral(resourceName: "default_profile"), options: .progressiveLoad, completed: .none)
            } else {
                self.peopleCountLbl.text = "\(meetingDetail.users?.first?.userName ?? "") joined"
                self.imageview_1.isHidden = true
                imageview_2.sd_setImage(with: URL(string: (meetingDetail.users?[0].userImage)!), placeholderImage: #imageLiteral(resourceName: "default_profile"), options: .progressiveLoad, completed: .none)
            }
        }
        
        self.meetingID = "\(meetingDetail.id ?? 0)"
        
    }
    
}

// MARK: API Calls

extension NotificationPopupVC {
    
    func fetchDetails() {
        showActivity()
        let parameters = ["id": self.notificationId] as [String : Any]
        
        NetworkManagerr.request(EndPoints.cancelMeetingPopup, method: .post, parameters: parameters) { (response) in
//            if response.result.isSuccess {
                
                
            self.hideActivity()
                do {
                    let jsonDecoder = JSONDecoder()
                    let meetingRoot = try jsonDecoder.decode(CancelDetailsModel.self, from: response.data!)
                    if meetingRoot.error == false {
                        if let meetingDetail = meetingRoot.data?.first {
                            self.updateUI(meetingDetail: meetingDetail)
                            
                        }
                        print(meetingRoot.message ?? "")
                    } else {
                        print(meetingRoot.message ?? "")
                    }
                    print(meetingRoot.message ?? "")
                } catch {
                    print("Error:: ",error)
                }
//            }
        }
    }
    
    func acceptMeeting() {
        let parameters = ["filter": "accept",
                          "attending_user": "\(LoggedUserDetails.shared.user?.id ?? 0)",
                          "meeting_id": self.meetingID,
                          "reason": ""] as [String : Any]
        
        NetworkManagerr.request(EndPoints.acceptMeetingPopup, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let meetingRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if meetingRoot.error == false {
                    
                        self.showToast(message: "Accepted Invitation")
                        self.dismiss(animated: true)
                        print(meetingRoot.message )
                    } else {
                        print(meetingRoot.message )
                    }
                    print(meetingRoot.message )
                } catch {
                    //
                }
            }
        }
    }
    
    
}
