//
//  UserSettingsVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/30/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Lottie

class UserSettingsVC: BaseVC {

    @IBOutlet weak var headerLbl: HeadingLabel!
    @IBOutlet weak var tableView: UITableView!
    private var settings = UserSetting.allCases
    
    
    @IBOutlet weak var privateAccountBtn: UIButton!
    @IBOutlet weak var privateTitleLbl: UILabel!
    @IBOutlet weak var privateDescLbl: UILabel!
    
    
    @IBOutlet weak var scheduleNotificationBaseVw: UIView!
    @IBOutlet weak var otherNotificationBaseVw: UIView!
    @IBOutlet weak var conferanceGoalsBaseVw: UIView!
    @IBOutlet weak var responsibilitiesBaseVw: UIView!
    
    
    @IBOutlet weak var pushBrowserBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var meetingRequestedBtn: UIButton!
    @IBOutlet weak var meetingCancelledBtn: UIButton!
    @IBOutlet weak var meetingRescheduledBtn: UIButton!
    @IBOutlet weak var meetingReminderBtn: UIButton!
    
    @IBOutlet weak var messagesBtn: UIButton!
    @IBOutlet weak var postCommentsBtn: UIButton!
    @IBOutlet weak var postLikesBtn: UIButton!
    @IBOutlet weak var connectionRequestBtn: UIButton!
    @IBOutlet weak var newConnectionsBtn: UIButton!
    @IBOutlet weak var profileViewsBtn: UIButton!
    @IBOutlet weak var newEventsBtn: UIButton!
    @IBOutlet weak var newJobPostBtn: UIButton!
    @IBOutlet weak var newUpdateBtn: UIButton!
    @IBOutlet weak var companyPostUpdatesBtn: UIButton!
    @IBOutlet weak var calendarRemindersBrn: UIButton!
    @IBOutlet weak var meetingRemindersBtn: UIButton!
        
    
    @IBOutlet var sectionHeaderlabelCollection: [UILabel]!
    @IBOutlet var responsibilityTitlerlabelCollection: [UILabel]!
    @IBOutlet var labelCollection: [UILabel]!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successPopupVw.isHidden = true
//        if LoggedUserDetails.shared.user?.isCompany ?? false { settings = settings.filter({ $0 != .rss }) }
        if !isIndivisualUser {
            settings = settings.filter({$0 != .rss })
        }
        setLayout()
        setLabelUI()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) { logOut() }
    
    private func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
//        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        scheduleNotificationBaseVw.layer.cornerRadius = 20.0
        otherNotificationBaseVw.layer.cornerRadius = 20.0
        conferanceGoalsBaseVw.layer.cornerRadius = 20.0
        responsibilitiesBaseVw.layer.cornerRadius = 20.0
        
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 20)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        if myUserDefaults.isPrivate {
            self.privateAccountBtn.isSelected = true
        } else {
            self.privateAccountBtn.isSelected = false
        }
    }
    
    func setLabelUI() {
        headerLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateTitleLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateDescLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        for label in sectionHeaderlabelCollection {
            label.font = UIFont(name: Myfonts.bold, size: 16.0)
        }
        for label in responsibilityTitlerlabelCollection {
            label.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
        for label in labelCollection {
            label.font = UIFont(name: Myfonts.regular, size: 14.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.fetchNotificationList()
    }
    
    func setData(data:NotificationList?) {
        pushBrowserBtn.isSelected = (data?.pushBrowser == 1)
        mailBtn.isSelected = (data?.email == 1)
        meetingRequestedBtn.isSelected = (data?.meetingRequested == 1)
        meetingCancelledBtn.isSelected = (data?.meetingCancelled == 1)
        meetingRescheduledBtn.isSelected = (data?.meetingRescheduled == 1)
        meetingReminderBtn.isSelected = (data?.meetingReminder == 1)
        
        messagesBtn.isSelected = (data?.messages == 1)
        postCommentsBtn.isSelected = (data?.postComments == 1)
        postLikesBtn.isSelected = (data?.postLikes == 1)
        connectionRequestBtn.isSelected = (data?.connectionRequest == 1)
        newConnectionsBtn.isSelected = (data?.newConnections == 1)
        profileViewsBtn.isSelected = (data?.profileViews == 1)
        newEventsBtn.isSelected = (data?.newEvents == 1)
        newJobPostBtn.isSelected = (data?.newJobPost == 1)
        newUpdateBtn.isSelected = (data?.newUpdate == 1)
        companyPostUpdatesBtn.isSelected = (data?.companyPostUpdates == 1)
        calendarRemindersBrn.isSelected = (data?.calendarReminders == 1)
        meetingRemindersBtn.isSelected = (data?.meetingReminders == 1)
    }
    
    @IBAction func onPrivateAccountBtn(_ sender: UIButton) {
        if self.privateAccountBtn.isSelected {
            self.privateAccountBtn.isSelected = false
            self.isAccountPrivacyMode(isPrivate: 1) //make Public...
        } else {
            self.privateAccountBtn.isSelected = true
            self.isAccountPrivacyMode(isPrivate: 0) //make Private...
        }
    }
    
    @IBAction func onScheduleNotificationButtons(_ sender: UIButton) {
        var key = ""
        var value = 0
        
        // 1️⃣ Toggle first
        sender.isSelected.toggle()
        
        // 2️⃣ Decide which key to update
        switch sender.tag {
        case 101:
            key = "push_browser"
        case 102:
            key = "email"
        case 103:
            key = "meeting_requested"
        case 104:
            key = "meeting_cancelled"
        case 105:
            key = "meeting_rescheduled"
        case 106:
            key = "meeting_reminder"
        default:
            break
        }
        // 3️⃣ Map selection to 0/1
        value = sender.isSelected ? 1 : 0
        // 4️⃣ Call API
        if !key.isEmpty {
            self.notificationUpdate(key: key, isEnable: value)
        }
    }
    
    @IBAction func onOtherNotificationButtons(_ sender: UIButton) {
        var key = ""
        var value = 0
        
        // 1️⃣ Toggle first
        sender.isSelected.toggle()
        
        // 2️⃣ Decide which key to update
        switch sender.tag {
        case 201:
            key = "messages"
        case 202:
            key = "post_comments"
        case 203:
            key = "post_likes"
        case 204:
            key = "connection_request"
        case 205:
            key = "new_connections"
        case 206:
            key = "profile_views"
        case 207:
            key = "new_events"
        case 208:
            key = "new_job_post"
        case 209:
            key = "new_update"
        case 210:
            key = "company_post_updates"
        case 211:
            key = "calendar_reminders"
        case 212:
            key = "meeting_reminders"
        default:
            break
        }
        // 3️⃣ Map selection to 0/1
        value = sender.isSelected ? 1 : 0
        // 4️⃣ Call API
        if !key.isEmpty {
            self.notificationUpdate(key: key, isEnable: value)
        }
    }
    
    @IBAction func onConfernceGoalsButtons(_ sender: UIButton) {
        if sender.tag == 301 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 302 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 303 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 304 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 305 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 306 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 307 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 308 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 309 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onRegionButtons(_ sender: UIButton) {
        if sender.tag == 401 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 402 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 403 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 404 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 405 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 406 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 407 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 408 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 409 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 410 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onHandlingButtons(_ sender: UIButton) {
        if sender.tag == 501 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 502 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 503 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 504 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 505 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 506 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onResponsibilitiesButtons(_ sender: UIButton) {
        if sender.tag == 601 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 602 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 603 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animationView.center = animationContainerView.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
}

extension UserSettingsVC {
    
    func isAccountPrivacyMode(isPrivate: Int) {
        let url = EndPoints.privacyMode
        let parameters = ["is_public": isPrivate] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let privacyRoot = try jsonDecoder.decode(DataStringResponse.self, from: response.data!)
                if !(privacyRoot.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    self.titlePopupLbl.text = privacyRoot.data ?? "--"
                    //Set Private & Public value...
                    if isPrivate == 0 {
                        myUserDefaults.isPrivate = true
                    } else {
                        myUserDefaults.isPrivate = false
                    }
                } else {
                    print("Error :: \(privacyRoot.message ?? "Default Message")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func notificationUpdate(key: String, isEnable: Int) {
        //isEnable : 0 disable, 1 enable
        let url = EndPoints.updateNotification
        let parameters = ["key": key, "is_enabled": isEnable] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(DataDictResponse.self, from: response.data!)
                if !(root.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    self.titlePopupLbl.text = "Notification Successfully Updated."//root.message ?? "--"
                    self.fetchNotificationList()
                } else {
                    print("Error :: \(root.message ?? "Default Message")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func fetchNotificationList() {
        showActivity()
        let url = EndPoints.getNotificationList
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription as? Error ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let response = try JSONDecoder().decode(NotificationListDataModel.self, from: data)
                if let data = response.data {
                    DispatchQueue.main.async {
                        self.setData(data: data)
                    }
                } else {
                    print("Error ::", response.message as? Error ?? "Default Error")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
}

extension UserSettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { settings.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditUserProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.title = settings[indexPath.item].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 63 }
    
}

extension UserSettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.navigationBar.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch settings[indexPath.item] {
        case .profile:
            let vc = StoryboardRouter.editUserProfile()
            vc.userDetail = LoggedUserDetails.shared.user
            navigationController?.pushViewController(vc, animated: true)
        case .notification:
            let vc = StoryboardRouter.userNotificationSettings()
            navigationController?.pushViewController(vc, animated: true)
        case .rss:
            let vc = StoryboardRouter.newsSources()
            vc.updateNewsSource = true
            vc.mode = .edit
            navigationController?.pushViewController(vc, animated: true)
        case .blockList:
            let vc = BlockListVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case .security:
            let vc = StoryboardRouter.editPasswordVC()
            navigationController?.pushViewController(vc, animated: true)
        case .help:
            let vc = StoryboardRouter.help()
            vc.section = .help
            navigationController?.pushViewController(vc, animated: true)
        case .language:
            let vc = StoryboardRouter.signUpLocationDOB()
            vc.isFromSettings = true
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .terms:
            let vc = StoryboardRouter.help()
            vc.section = .termsOfServices
            navigationController?.pushViewController(vc, animated: true)
        case .cookies:
            let vc = StoryboardRouter.help()
            vc.section = .cookies
            navigationController?.pushViewController(vc, animated: true)
        case .privacy:
            let vc = StoryboardRouter.help()
            vc.section = .privacy
            navigationController?.pushViewController(vc, animated: true)
        case .account:
            let vc = StoryboardRouter.account()
            
            navigationController?.pushViewController(vc, animated: true)
            print("Coming soon")
        }
        
        
    }
    
}

extension UserSettingsVC: EditUserProfileDelegate {
    
    func didProfileUpdated(item: EditProfile, value: String) {
        
    }
    
}
