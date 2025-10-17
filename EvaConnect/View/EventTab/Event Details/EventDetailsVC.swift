//
//  EventDetailsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 12/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

class EventDetailsVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var eventImgVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var eventHeadingLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var per1imgView: UIImageView!
    @IBOutlet weak var per2imgView: UIImageView!
    @IBOutlet weak var per3imgView: UIImageView!
    @IBOutlet weak var noOfJoinedPeopleLabel: UILabel!
    
    @IBOutlet weak var eventTypeHeadingLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventNameHeadingLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventWebsiteHeadingLabel: UILabel!
    @IBOutlet weak var eventWebsiteLabel: UILabel!
    
    @IBOutlet weak var eventDateHeadingLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimingsHeadingLabel: UILabel!
    @IBOutlet weak var eventTimingsLabel: UILabel!
    @IBOutlet weak var eventLocationHeadingLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    @IBOutlet weak var descriptionHeadingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var infoIconImgView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var requestToJoinBtnVw: UIView!
    @IBOutlet weak var requstToJoinBtn: UIButton!
    @IBOutlet weak var acceptDeclineBtnVw: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var interestedBtnVw: UIView!
    @IBOutlet weak var interestedBtn: UIButton!
    
    
    
    var eventId = 0
    var eventDetail: NewEventDetailsData?
    var isEventLiked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        fetchEventDetail()
    }
    
    func setupUI() {
        eventImgView.layer.cornerRadius = 12
        eventHeadingLabel.font = UIFont(name: Myfonts.bold, size: 18)
        createdByLabel.font = UIFont(name: Myfonts.regular, size: 14)
        
        per1imgView.layer.cornerRadius = per1imgView.frame.size.height / 2
        per2imgView.layer.cornerRadius = per2imgView.frame.size.height / 2
        per3imgView.layer.cornerRadius = per3imgView.frame.size.height / 2
        
        noOfJoinedPeopleLabel.font = UIFont(name: Myfonts.medium, size: 10)
        noOfJoinedPeopleLabel.textColor = UIColor(hex: "#848397")
        
        eventTypeHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventTypeHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventTypeLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventTypeLabel.textColor = UIColor(hex: "#030229")
        
        eventNameHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventNameHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventNameLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventNameLabel.textColor = UIColor(hex: "#030229")
        
        eventWebsiteHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventWebsiteHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventWebsiteLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventWebsiteLabel.textColor = UIColor(hex: "#030229")
        
        eventDateHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventDateHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventDateLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventDateLabel.textColor = UIColor(hex: "#030229")
        
        eventTimingsHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventTimingsHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventTimingsLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventTimingsLabel.textColor = UIColor(hex: "#030229")
        
        eventLocationHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        eventLocationHeadingLabel.textColor = UIColor(hex: "#707070")
        
        eventLocationLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        eventLocationLabel.textColor = UIColor(hex: "#030229")
        
        descriptionHeadingLabel.font = UIFont(name: Myfonts.regular, size: 14)
        descriptionHeadingLabel.textColor = UIColor(hex: "#707070")
        
        descriptionLabel.font = UIFont(name: Myfonts.medium, size: 14)
        descriptionLabel.textColor = UIColor(hex: "#030229")
        
        infoLabel.font = UIFont(name: Myfonts.regular, size: 14)
        infoLabel.textColor = UIColor(hex: "#030229")
        
        requstToJoinBtn.layer.cornerRadius = 14
        requstToJoinBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        acceptBtn.layer.cornerRadius = 14
        acceptBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        rejectBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 14)
        rejectBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        interestedBtn.layer.cornerRadius = 14
        interestedBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        if let eventDetail = self.eventDetail {
            self.setUIData(eventDetail: eventDetail)
        }
    }
    
    func setUIData(eventDetail: NewEventDetailsData) {
//        if  eventDetail.tempImage != nil {
//            eventImgView.sd_setImage(with: URL(string: (eventDetail.tempImage)!), placeholderImage: #imageLiteral(resourceName: "eventPlaceholder"), options: .progressiveLoad, completed: .none)
//        } else {
//            eventImgView.image = #imageLiteral(resourceName: "eventPlaceholder")
//        }
        
        eventImgView.kf.setImage(with: URL(string: eventDetail.tempImage ?? ""), placeholder: UIImage(named: "eventPlaceholder"))
        
        //Set image Height base on original image size.....
        let originalSize = eventImgView.image?.size
        let screenWidth = UIScreen.main.bounds.width - 40
        let ratio = (originalSize?.height ?? 0.0) / (originalSize?.width ?? 0.0)
        let newHeight = screenWidth * ratio
        self.eventImgVwHeight.constant = newHeight
        
        eventHeadingLabel.text = "\(eventDetail.name ?? "")"
        
        createdByLabel.text = "Created By \(eventDetail.createdByUser ?? "")"
        
//        let Count: Int = Int(eventDetail.interestedUsersCount ?? "") ?? 0
//        noOfJoinedPeopleLabel.text = Count > 100 ? "\(eventDetail.interestedUsersCount ?? "")+ joined" : "\(eventDetail.interestedUsersCount ?? "")"
        let attendees = self.eventDetail?.evaEventsAttendees ?? []
        let attendeesCount = eventDetail.attendeesCount ?? 0
        noOfJoinedPeopleLabel.text = "\(attendeesCount)+ Joined"
        
        self.per1imgView.isHidden = true
        self.per2imgView.isHidden = true
        self.per3imgView.isHidden = true
            
        if attendeesCount == 1 {
            let imgURL = URL(string: attendees[0].evaEventsAttendeeUser?.userImage ?? "")
            self.per1imgView.isHidden = false
            self.per1imgView.kf.setImage(with: imgURL, placeholder: UIImage(named: "profile"))
        }
        else if attendeesCount == 2 {
            self.per1imgView.isHidden = false
            let imgURL = URL(string: attendees[0].evaEventsAttendeeUser?.userImage ?? "")
            self.per1imgView.kf.setImage(with: imgURL, placeholder: UIImage(named: "profile"))
            self.per2imgView.isHidden = false
            let imgURL1 = URL(string: attendees[1].evaEventsAttendeeUser?.userImage ?? "")
            self.per2imgView.kf.setImage(with: imgURL1, placeholder: UIImage(named: "profile"))
        }
        else if attendeesCount >= 3 {
            self.per1imgView.isHidden = false
            let imgURL = URL(string: attendees[0].evaEventsAttendeeUser?.userImage ?? "")
            self.per1imgView.kf.setImage(with: imgURL, placeholder: UIImage(named: "profile"))
            self.per2imgView.isHidden = false
            let imgURL1 = URL(string: attendees[1].evaEventsAttendeeUser?.userImage ?? "")
            self.per2imgView.kf.setImage(with: imgURL1, placeholder: UIImage(named: "profile"))
            self.per3imgView.isHidden = false
            let imgURL2 = URL(string: attendees[2].evaEventsAttendeeUser?.userImage ?? "")
            self.per3imgView.kf.setImage(with: imgURL2, placeholder: UIImage(named: "profile"))
        }
            
        
        eventTypeLabel.text = "\(eventDetail.isPrivate ?? 0 == 1 ? "Private" : "Public")"
        
        eventNameLabel.text = "\(eventDetail.name ?? "")"
        
        eventWebsiteLabel.text = "\(eventDetail.registrationLink ?? "")"
        
        eventDateLabel.text = "\(eventDetail.startDate ?? "")"
        eventTimingsLabel.text = "\(eventDetail.startTime ?? "") - \(eventDetail.endTime ?? "")"
        
        eventLocationLabel.text = "\(eventDetail.address ?? ""), \(eventDetail.city ?? ""), \(eventDetail.country ?? "")"
        
        //descriptionLabel.text = "\(eventDetail.content ?? "")"
        let content = eventDetail.content ?? ""
//        if let attributed = content.htmlToAttributedString {
//            descriptionLabel.attributedText = attributed
//        }
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#030229")) {
            descriptionLabel.attributedText = attributed
        }
        
        //--> Bottom Button Ui Managed...
        self.requestToJoinBtnVw.isHidden = true
        self.acceptDeclineBtnVw.isHidden = true
        self.interestedBtnVw.isHidden = true
        let isInvited = eventDetail.isinvited ?? 0
        let eventAttendeesStatus = eventDetail.eventAttendeesStatus ?? ""
        let isPrivate = self.eventDetail?.isPrivate ?? 0
        
        if isPrivate == 0 && eventAttendeesStatus == "" {
            self.interestedBtnVw.isHidden = false
        }
        else if eventAttendeesStatus == "" && isInvited == 1 {
            self.acceptDeclineBtnVw.isHidden = false
        }
        else {
            self.requestToJoinBtnVw.isHidden = false
            if eventAttendeesStatus == "" {
                requstToJoinBtn.isEnabled = true
                requstToJoinBtn.setTitle("Request To Join", for: .normal)
                requstToJoinBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 1.0)
                requstToJoinBtn.titleLabel?.textColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
            } else {
                requstToJoinBtn.isEnabled = false
                requstToJoinBtn.setTitle(eventAttendeesStatus, for: .normal)
                requstToJoinBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.5)
                requstToJoinBtn.titleLabel?.textColor = UIColor(hex: "#000000", alpha: 0.5)
            }
        }
    }
    
    @IBAction func reqToJoinTapped(_ sender: UIButton) {
        if self.eventDetail?.eventAttendeesStatus == "Approved" {
            print("already approved.")
        } else {
            reqToJoin(eventId: self.eventId, type: 1)
        }
    }
    
    @IBAction func acceptBtnTapped(_ sender: UIButton) {
        reqToJoin(eventId: self.eventId, type: 2)
    }
    
    @IBAction func rejectBtnTapped(_ sender: UIButton) {
        reqToJoin(eventId: self.eventId, type: 3)
    }
    
    @IBAction func interestedBtn(_ sender: Any) {
        print("Intereted Btn Tapped.")
        reqToJoin(eventId: self.eventId, type: 2)
    }
}

extension EventDetailsVC {
    
    func fetchEventDetail() {
        let parameters: AFParameters = [ "id": eventId]
        showActivity()
        NetworkManagerr.request(EndPoints.eventDetail , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let eventDetail = try decoder.decode(NewEventDetailsModel.self, from: response.data!)
                    
                    if !(eventDetail.error ?? false), ((eventDetail.data?.count ?? 0) > 0) {
                        self.eventDetail = eventDetail.data?[0]
//                        self.isEventLiked = self.eventDetail?.isEventLike == 1 ? true : false
                        self.setUIData(eventDetail: eventDetail.data![0])
//                        self.ImgUrlString = eventDetail.data[0].floorPlan ?? ""
//                        self.registrationLink = eventDetail.data[0].registrationLink
//                        self.agenda = eventDetail.data[0].agenda == 1 ? true : false
                        
//                        self.fetchInvitedPeople()
                        let eventAttendeesStatus = self.eventDetail?.eventAttendeesStatus ?? ""
                        self.requstToJoinBtn.setTitle(eventAttendeesStatus, for: .normal)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func reqToJoin(eventId: Int, type: Int) {
        
        let param: AFParameters = [ "event_id": eventId,
                                    "type": type]
        print(param)
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.reqToJoinFunc(usertoken: myUserDefaults.token, para: param) { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
//            self.hideActivity()
            if error == 0 {
                print("Success!!")
                self.fetchEventDetail()
                self.view.isUserInteractionEnabled = true

            }
            else {
                self.hideActivity()
                print("error!!",error as Any)
                self.view.isUserInteractionEnabled = true
            }
        } failure: { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func convertToAMPM(from time24: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Input format: 24-hour
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent behavior
        
        if let date = dateFormatter.date(from: time24) {
            dateFormatter.dateFormat = "h:mm a" // Output format: 12-hour with AM/PM
            return dateFormatter.string(from: date)
        } else {
            return nil // Return nil if input format is invalid
        }
    }
}
