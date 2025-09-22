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
    private var settings = UserSetting.allCases
    
    
    @IBOutlet weak var privateAccountBtn: UIButton!
    @IBOutlet weak var privateTitleLbl: UILabel!
    @IBOutlet weak var privateDescLbl: UILabel!
    
    
    @IBOutlet weak var scheduleNotificationBaseVw: UIView!
    @IBOutlet weak var otherNotificationBaseVw: UIView!
    
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
    @IBOutlet var labelCollection: [UILabel]!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    var surveySections: [SurveySectionList] = []
    var selectedIds: [Int] = []
    
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
        registerCell()
        
        scheduleNotificationBaseVw.layer.cornerRadius = 20.0
        otherNotificationBaseVw.layer.cornerRadius = 20.0
        
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
    
    func registerCell() {
        tblVw.dataSource = self
        tblVw.delegate = self
        tblVw.registerCell(withType: SurveyNotificationTVC.self)
    }
    
    func setLabelUI() {
        headerLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateTitleLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateDescLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        for label in sectionHeaderlabelCollection {
            label.font = UIFont(name: Myfonts.bold, size: 16.0)
        }
        for label in labelCollection {
            label.font = UIFont(name: Myfonts.regular, size: 14.0)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.fetchNotificationList()
        self.fetchSurveySectionLists()
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
    
    func setTableVwHeight(data: SurveySectionListData?) {
        var finalHeight = 0.0
        let sections = data?.sections ?? []
        for surveySection in sections {
            var optionHeight = 0.0
            let optionsList = surveySection.options ?? []
            for option in optionsList {
                let optionTitle = ((option.optionTitle?.isEmpty ?? true) ? "--" : option.optionTitle) ?? ""
                
                let optionLblHeight = self.heightForView(text: optionTitle, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 105.0)
                let totalHeight = optionLblHeight + 16.0
                
                if totalHeight > 45.0 {
                    optionHeight += totalHeight
                } else {
                    optionHeight += 50
                }
            }
            finalHeight = finalHeight + optionHeight + 70.0 //70 is section header height...
        }
        
        // Set the height constraint
        self.tblVwHeight.constant = finalHeight
        self.view.layoutIfNeeded()
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
                    print("Error :: \(privacyRoot.message ?? "")")
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
                let root = try jsonDecoder.decode(NotificationDataDictResponse.self, from: response.data!)
                if !(root.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    self.titlePopupLbl.text = "Notification Successfully Updated."//root.message ?? "--"
                    self.fetchNotificationList()
                } else {
                    print("Error :: \(root.message ?? "")")
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
    
    func fetchSurveySectionLists() {
        showActivity()
        let url = EndPoints.surveySectionlists
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
                let response = try JSONDecoder().decode(SurveySectionListDataModel.self, from: data)
                if let data = response.data {
                    print("Success ::", data.sections?.count ?? 0)
                    DispatchQueue.main.async {
                        self.surveySections = data.sections ?? []
                        self.selectedIds = data.selected ?? []
                        self.tblVw.reloadData()
                        self.setTableVwHeight(data: data)
                    }
                } else {
                    print("Error ::", response.message as? Error ?? "Default Error")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
    
    func updateSurveySection(checked: Int, optionID: Int, sectionID: Int) {
        let parameters: AFParameters = [ "checked": checked,
                                         "option_id": optionID,
                                         "section_id": sectionID]
        showActivity()
        NetworkManagerr.request(EndPoints.UpdateSurveySectionlists , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(GenericResponse.self, from: response.data!)
                    if !(root.error) {
                        self.successPopupVw.isHidden = false
                        self.addAnimation()
                        self.titlePopupLbl.text = "Notification Successfully Updated."
                        self.fetchSurveySectionLists()
                    } else {
                        print("Error :: \(root.message)")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

//extension UserSettingsVC: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { settings.count }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: EditUserProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.selectionStyle = .none
//        cell.title = settings[indexPath.item].rawValue
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 63 }
//    
//}
//
//extension UserSettingsVC: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        navigationController?.navigationBar.isHidden = true
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        switch settings[indexPath.item] {
//        case .profile:
//            let vc = StoryboardRouter.editUserProfile()
//            vc.userDetail = LoggedUserDetails.shared.user
//            navigationController?.pushViewController(vc, animated: true)
//        case .notification:
//            let vc = StoryboardRouter.userNotificationSettings()
//            navigationController?.pushViewController(vc, animated: true)
//        case .rss:
//            let vc = StoryboardRouter.newsSources()
//            vc.updateNewsSource = true
//            vc.mode = .edit
//            navigationController?.pushViewController(vc, animated: true)
//        case .blockList:
//            let vc = BlockListVC.instantiate()
//            navigationController?.pushViewController(vc, animated: true)
//        case .security:
//            let vc = StoryboardRouter.editPasswordVC()
//            navigationController?.pushViewController(vc, animated: true)
//        case .help:
//            let vc = StoryboardRouter.help()
//            vc.section = .help
//            navigationController?.pushViewController(vc, animated: true)
//        case .language:
//            let vc = StoryboardRouter.signUpLocationDOB()
//            vc.isFromSettings = true
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        case .terms:
//            let vc = StoryboardRouter.help()
//            vc.section = .termsOfServices
//            navigationController?.pushViewController(vc, animated: true)
//        case .cookies:
//            let vc = StoryboardRouter.help()
//            vc.section = .cookies
//            navigationController?.pushViewController(vc, animated: true)
//        case .privacy:
//            let vc = StoryboardRouter.help()
//            vc.section = .privacy
//            navigationController?.pushViewController(vc, animated: true)
//        case .account:
//            let vc = StoryboardRouter.account()
//            
//            navigationController?.pushViewController(vc, animated: true)
//            print("Coming soon")
//        }
//        
//        
//    }
//    
//}
//
//extension UserSettingsVC: EditUserProfileDelegate {
//    
//    func didProfileUpdated(item: EditProfile, value: String) {
//        
//    }
//
//}


// MARK: - TableView Delegate & DataSource
extension UserSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.surveySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveySections[section].options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: SurveyNotificationTVC.id(),
                                                   for: indexPath) as! SurveyNotificationTVC
        
        let option = self.surveySections[indexPath.section].options?[indexPath.row]
        cell.titleLbl.text = option?.optionTitle ?? ""
        
        let optionId = option?.id
        if let id = optionId, self.selectedIds.contains(id) {
            cell.checkmarkImgVw.image = UIImage(named: "ic_checkMark_select")
        } else {
            cell.checkmarkImgVw.image = UIImage(named: "ic_checkMark_unselect")
        }
        
        // Button setup
        cell.checkmarkBtn.tag = indexPath.row
        cell.checkmarkBtn.accessibilityIdentifier = "\(indexPath.section)"
        cell.checkmarkBtn.addTarget(self, action: #selector(self.checkmarkBtnTapped(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    // Custom Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.clipsToBounds = true
        
        // Background view (fills header)
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#F8F6F8")
        bgView.clipsToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        // Base card view (rounded top corners)
        let baseView = UIView()
        baseView.backgroundColor = UIColor(hex: "#FFFFFF")
        baseView.layer.cornerRadius = 20.0
        baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // top-right + top-left
        baseView.clipsToBounds = true
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Label
        let label = UILabel()
        label.text = self.surveySections[section].sectionTitle ?? ""
        label.textColor = UIColor(hex: "#030229")
        label.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Underline
        let underline = UIView()
        underline.backgroundColor = UIColor(hex: "#B8C4CE")
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        // Hierarchy
        headerView.addSubview(bgView)
        headerView.addSubview(baseView)
        baseView.addSubview(label)
        baseView.addSubview(underline)
        
        NSLayoutConstraint.activate([
            // bgView fills header
            bgView.topAnchor.constraint(equalTo: headerView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            // baseView inside header (10pt from top)
            baseView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            baseView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            baseView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0),
            baseView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // label inside baseView
            label.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            
            // underline inside baseView
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
        ])
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    // Dynamic row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let option = self.surveySections[indexPath.section].options?[indexPath.row]
        let optionTitle = ((option?.optionTitle?.isEmpty ?? true) ? "--" : option?.optionTitle) ?? ""
        
        let optionLblHeight = self.heightForView(text: optionTitle, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 105.0)
        let totalHeight = optionLblHeight + 16.0
        
        if totalHeight > 45.0 {
            return totalHeight
        } else {
            return 50
        }
    }
}

// MARK: - Drop Down Button Action
extension UserSettingsVC {
    @objc func checkmarkBtnTapped(sender: UIButton) {
        guard let sectionStr = sender.accessibilityIdentifier,
              let section = Int(sectionStr) else { return }
        let indexPath = IndexPath(row: sender.tag, section: section)
        //Update api call...
        let surveySection = self.surveySections[indexPath.section]
        let option = surveySection.options?[indexPath.row]
        
        let optionId = option?.id
        if let id = optionId, self.selectedIds.contains(id) { //available in list...
            self.updateSurveySection(checked: 0, optionID: option?.id ?? 0, sectionID: surveySection.id ?? 0)
        } else {
            self.updateSurveySection(checked: 1, optionID: option?.id ?? 0, sectionID: surveySection.id ?? 0)
        }
    }
}
