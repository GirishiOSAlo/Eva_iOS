//
//  MessageVC.swift
//  EvaConnect
//
//  Created by Metis on 16/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD
import ImageSlideshow
import Kingfisher
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore

enum ChatListDataType {
    case chatList, notifications
}

class ChatListVC: BaseVC {
    
    // MARK: IBOutlets
    @IBOutlet weak var speratorLineTop: UIImageView!
    @IBOutlet weak var speratorLine: UIImageView!
    @IBOutlet weak var hideContentView: UIView!
    @IBOutlet weak var myActivityLbl: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageButton: UIButton!
    @IBOutlet weak var noContentView: UIView!
    
    
    @IBOutlet weak var buttonBaseVw: UIView!
    @IBOutlet weak var messagesBtn: UIButton!
    @IBOutlet weak var notificationsBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var conversations: [Conversation] = []
    var notificationList: [FirebaseNotification] = []
    
    // MARK: Properties
    var dataType: ChatListDataType = .chatList {
        didSet {
            if isViewLoaded {
                if dataType == .notifications {
//                    setActivity()
                }
            }
        }
    }
    
    var notifications: [EvaNotification] = [] {
        didSet {
            let count = notifications.count
            if count > 0 {
                noDataLabel.isHidden = true
            } else {
                noDataLabel.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    var paginatedNotifications: [EvaNotification] = []
    
    var messages: [MessageList] = [] {
        didSet {
            let count = messages.count
            if count > 0 {
                noDataLabel.isHidden = true
            } else {
                noDataLabel.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(reloadNotificationsData), for: .valueChanged)
        return refreshControl
    }()
    
    var isEmptyList = false {
        didSet {
            noContentView.isHidden = !isEmptyList
            tableView.isHidden = isEmptyList
        }
    }
    
//    var conversations: [Conversation] = [] {
//        didSet {
//            DispatchQueue.main.async {
//                self.isEmptyList = self.conversations.count == 0
//            }
//        }
//    }
    
    var newMessageNotification: ChatNotification?
    var isMyActivity = false
    var limit = 10
    var offSet = 1
    var isChatEnable = true
    
    
    // MARK: UI Life Cycle
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FirebaseHandler.handler.ref.child("users").removeValue()
//        FirebaseHandler.handler.ref.child("chats").removeValue()
//        FirebaseHandler.handler.ref.child("messages").removeValue()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
//        getSettings()
        if self.dataType == .chatList {
            print("Tapped Messages.")
            self.onMessageBtnTapped(self.messagesBtn)
        } else {
            print("Tapped Notifications.")
            self.onNotificationsBtnTapped(self.notificationsBtn)
        }

//        if let newMessage = self.newMessageNotification {
//            let filterConversation = conversations.filter { return $0.id == newMessage.chatID }
//            if let conversation = filterConversation.first {
//                self.openConversation(conversation)
//                self.newMessageNotification = nil
//            }
//        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? EventViewVC, let eventId = sender as? Int {
//            destination.eventId = eventId
//        } else if let destination = segue.destination as? MeetingViewVC, let meetingId = sender as? Int {
//            destination.meetingId = meetingId
//        }
//    }
    
    
    @IBAction func onMessageBtnTapped(_ sender: UIButton) {
        if isChatEnable {
            self.messagesBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.20)
            self.messagesBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
            self.messagesBtn.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 14.0)
            
            self.notificationsBtn.backgroundColor = UIColor.clear
            self.notificationsBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
            self.notificationsBtn.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14.0)
            
            dataType = .chatList
            //loadMessage()
            let loggedInUserId = myUserDefaults.userId
            observeConversations(loggedInUserId: loggedInUserId) { [weak self] conversations in
                DispatchQueue.main.async {
                    self?.conversations = []
                    self?.conversations = conversations
                    self?.tableView.reloadData()
                    print("Conversations Count: \(self?.conversations.count ?? 0)")
                }
            }
        } else {
            presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
    @IBAction func onNotificationsBtnTapped(_ sender: UIButton) {
        self.notificationsBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.20)
        self.notificationsBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.notificationsBtn.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 14.0)
        
        self.messagesBtn.backgroundColor = UIColor.clear
        self.messagesBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.messagesBtn.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14.0)
        
        dataType = .notifications
        //loadNotifications()
        let loggedInUserId = myUserDefaults.userId
        observeNotifications(for: loggedInUserId) { notifications in
            print("👉 Notifications for user Id \(loggedInUserId) : \(notifications.count)")
            DispatchQueue.main.async {
                self.notificationList = []
                self.notificationList = notifications
                self.tableView.reloadData()
            }
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
    func widthForLabel(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return ceil(boundingBox.width)
    }
}

extension ChatListVC {
    func observeConversations(loggedInUserId: Int, onUpdate: @escaping ([Conversation]) -> Void) {
        let messagesRef = Database.database().reference().child("messages")
        let usersRef = Database.database().reference().child("users")
        
        messagesRef.observe(.value) { snapshot, _ in
            var updatedConversations: [Conversation] = []
            
            for case let chatNode as DataSnapshot in snapshot.children {
                guard let key = chatNode.key as String?, key.contains("_") else { continue }
                
                let participants = key.split(separator: "_").map { String($0) }
                guard participants.contains(String(loggedInUserId)) else { continue }
                
                // Collect messages
                var messages: [ChatMessage] = []
                var unreadCount = 0
                
                for case let msgSnap as DataSnapshot in chatNode.children {
                    if let dict = msgSnap.value as? [String: Any] {
                        let message = ChatMessage(
                            audio_file: dict["audio_file"] as? String,
                            audio_file_url: dict["audio_file_url"] as? String,
                            chat_time: dict["chat_time"] as? String,
                            document: dict["document"] as? String,
                            document_url: dict["document_url"] as? String,
                            firebase_receiver_id: dict["firebase_receiver_id"] as? String,
                            firebase_sender_id: dict["firebase_sender_id"] as? String,
                            image: dict["image"] as? String,
                            image_url: dict["image_url"] as? String,
                            message: dict["message"] as? String,
                            read: dict["read"] as? Bool,
                            receiver_id: dict["receiver_id"] as? Int,
                            sender_id: dict["sender_id"] as? Int,
                            timestamp: dict["timestamp"] as? Double
                        )
                        messages.append(message)
                        
                        // Count unread messages not sent by me
                        if let senderId = dict["firebase_sender_id"] as? String,
                           senderId != String(loggedInUserId),
                           dict["read"] as? Bool == false {
                            unreadCount += 1
                        }
                    }
                }
                
                guard let lastMessage = messages.max(by: { ($0.timestamp ?? 0.0) < ($1.timestamp ?? 0.0) }) else { continue }
                
                // Determine other participant
                let otherUserId: Int
                if participants[0] == String(loggedInUserId) {
                    otherUserId = Int(participants[1]) ?? -1
                } else {
                    otherUserId = Int(participants[0]) ?? -1
                }
                guard otherUserId != -1 else { continue }
                
                // Fetch user info
                usersRef
                    .queryOrdered(byChild: "user_id")
                    .queryEqual(toValue: Double(otherUserId))
                    .observeSingleEvent(of: .value) { userSnap, _  in
                        for case let child as DataSnapshot in userSnap.children {
                            if let dict = child.value as? [String: Any] {
                                let user = FirebaseUser(
                                    avatar: dict["avatar"] as? String,
                                    created_at: dict["created_at"] as? String,
                                    email: dict["email"] as? String,
                                    last_changed: dict["last_changed"] as? Double,
                                    name: dict["name"] as? String,
                                    status: dict["status"] as? String,
                                    user_id: dict["user_id"] as? Int
                                )
                                
                                updatedConversations.append(
                                    Conversation(user: user, lastMessage: lastMessage, chatId: key, unreadCount: unreadCount)
                                )
                                
                                let sorted = updatedConversations.sorted {
                                    ($0.lastMessage?.timestamp ?? 0.0) > ($1.lastMessage?.timestamp ?? 0.0)
                                }
                                onUpdate(sorted)
                            }
                        }
                    }
            }
        }
    }


    func observeNotifications(for userId: Int, onUpdate: @escaping ([FirebaseNotification]) -> Void) {
        let notificationsRef = Database.database().reference()
            .child("notifications")
            .child("\(userId)")   // ✅ user-specific branch

        notificationsRef.observe(.value) { snapshot in
            var updatedNotifications: [FirebaseNotification] = []

            for case let notifSnap as DataSnapshot in snapshot.children {
                if let dict = notifSnap.value as? [String: Any] {
                    
                    // ✅ Handle "id" as Int or String
                    var notificationIdInt: Int = 0
                    if let idValue = dict["id"] as? Int {
                        notificationIdInt = idValue
                    } else if let idString = dict["id"] as? String, let idValue = Int(idString) {
                        notificationIdInt = idValue
                    }
                    
                    let notification = FirebaseNotification(
                        body: dict["body"] as? String ?? "",
                        created_at: dict["created_at"] as? String ?? "",
                        expire_at: dict["expire_at"] as? String ?? "",
                        id: notificationIdInt,  // ✅ fixed parsing
                        read: dict["read"] as? Bool ?? false,
                        redirect_url: dict["redirect_url"] as? String ?? "",
                        title: dict["title"] as? String ?? "",
                        type: dict["type"] as? String ?? "",
                        subtype: dict["subtype"] as? String ?? "",
                        notificationId: notifSnap.key,   // ✅ store Firebase key
                        meetingid: dict["meetingid"] as? Int ?? 0
                    )
                    updatedNotifications.append(notification)
                }
            }

            // ✅ Sort notifications by created_at or expire_at if needed
            let sorted = updatedNotifications.sorted { $0.created_at ?? "" > $1.created_at ?? "" }

            onUpdate(sorted)
        }
    }
}

extension ChatListVC {
    
    func initUI() {
        
        let bottomInset: CGFloat = 110.0
        if #available(iOS 11.0, *) {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            tableView.contentInsetAdjustmentBehavior = .always
        } else {
            // Fallback on earlier versions
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }

        // hideContentView.isHidden = !isMyActivity
        myActivityLbl.isHidden = !isMyActivity
        speratorLineTop.isHidden = !isMyActivity
        segmentControl.isHidden = isMyActivity
        speratorLine.isHidden = isMyActivity
        
//        newMessageButton.subviews.first?.contentMode = .scaleAspectFill
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColors.appBlue, .font: UIFont(defaultFontStyle: .bold, size: 13)], for: .selected)
//        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(hex: "707070"), .font: UIFont(defaultFontStyle: .regular, size: 12)], for: .normal)
        segmentControl.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100
        tableView.registerCell(withType: NotificationCell.self)
        tableView.tableFooterView = UIView()
        isSeparatorHidden = true
        //tableView.refreshControl = refresher
//        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "707070")]
//        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
//        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
//        setActivity()
        
        self.buttonBaseVw.layer.cornerRadius = 8.0
        self.messagesBtn.layer.cornerRadius = 8.0
        self.notificationsBtn.layer.cornerRadius = 8.0
        
//        if self.dataType == .chatList {
//            print("Tapped Messages.")
//            self.onMessageBtnTapped(self.messagesBtn)
//        } else {
//            print("Tapped Notifications.")
//            self.onNotificationsBtnTapped(self.notificationsBtn)
//        }
        
    }
    
    
    func loadNotifications() {
//        if notifications.count == 0 {
        getNotifications(offset: 1, paginationCalled: false) {
                self.tableView.reloadData()
//                self.readAllNotifications()
            }
//        } else {
//
//            print("didn't call the notifications service")
//            tableView.reloadData()
//        }
    }
    
    func loadMessage() {
//        if messages.count == 0 {
            getMessages {
                self.tableView.reloadData()
            }
//        } else {
//            tableView.reloadData()
//        }
    }
    
    func setActivity() {
        
        switch dataType {
        case .notifications:
            segmentControl.selectedSegmentIndex = 1
//            newMessageButton.isHidden = true
            loadNotifications()
        default:
//            registerObserver()
            print("didn't call the chat servide")
        }
    }
    
    private func getSettings() {
        NetworkManagerr.request(EndPoints.settingsOptions) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SettingsOptionsDataModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self.isChatEnable = data[0].privateMessaging ?? true
//                        self?.signup_Lbl.isUserInteractionEnabled = (self?.isRegistrationEnable ?? true) ? true : false
                        if self.dataType == .chatList && self.isChatEnable == true {
//                            print("Tapped Messages.")
//                            if self.isChatEnable {
                            self.presentAlert("Alert", "This action has been disabled, Please contact admin.") {
                                self.onMessageBtnTapped(self.messagesBtn)
                            }
                                
//                            } else {
//                                self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
//                            }
                        } else {
                            print("Tapped Notifications.")
                            self.onNotificationsBtnTapped(self.notificationsBtn)
                        }
                    }
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getMessages(completion: @escaping () -> Void) {
        showActivity(isUserInteractionEnabled: false)
        NetworkManagerr.request(EndPoints.messageList) { (response) in
            self.hideActivity(isUserInteractionEnabled: true)
            
            if response.result.isSuccess {
                let jsonDecoder = JSONDecoder()
                do {
                    let MessageListRes = try jsonDecoder.decode(MessageListRes.self, from: response.data!)
                    print(MessageListRes.data?.count ?? 0)
                    
                    if let messages = MessageListRes.data {
                        self.messages = messages
                        completion()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getNotifications(offset: Int, paginationCalled: Bool, completion: @escaping () -> Void) {
        
        var parameters: AFParameters = ["receiver_id": myUserDefaults.userId]
        var url =  "\(EndPoints.notifications)?limit=\(limit)&offset=\(offset)"
        if isMyActivity {
            parameters["id"] = myUserDefaults.userId
            url = EndPoints.userActivity
        }
        
        showActivity(isUserInteractionEnabled: false)
        NetworkManagerr.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default) { (response) in
            self.hideActivity(isUserInteractionEnabled: true)
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let notificationsRoot = try jsonDecoder.decode(NotificationRoot.self, from: response.data!)
                    
                    if let notifications = notificationsRoot.data {
                        if paginationCalled {
                            print("fresh notifications")
                        } else {
                            self.notifications = []
                        }
                        self.paginatedNotifications = notifications
                        self.notifications.append(contentsOf: self.paginatedNotifications)
                        if self.isMyActivity {
                            self.notifications = self.notifications.sorted(by: { $0.createdDatetime! > $1.createdDatetime! })
                        }
                        completion()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func readAllNotifications() {
        
        let parameters: AFParameters = ["user_id": myUserDefaults.userId]
        
        NetworkManagerr.request(EndPoints.readAllNotifications, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    print(genericRoot.message)
                    self.notificationsSeen = true
                } catch {
                    print("Error:: ", error)
                }
            }
        }
    }
    
    @objc
    func reloadNotificationsData() {
        if dataType == .chatList { //self.segmentControl.selectedSegmentIndex == 0 {
            getMessages {
                self.tableView.reloadData()
            }
        }
        else if dataType == .notifications { //self.segmentControl.selectedSegmentIndex == 1 {
            getNotifications(offset: 1, paginationCalled: false) {
                self.tableView.reloadData()
            }
        }
        
        self.refresher.endRefreshing()
    }
    
    private func openConversation(id: Int) {
        let chatVC = StoryboardRouter.chat()
        chatVC.userId = id
//        chatVC.msgId =
//        chatVC.conversation = conversation
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func segmentControl_valueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            dataType = .chatList
////            newMessageButton.isHidden = false
//            if conversations.count == 0 {
//                tableView.reloadData()
////                registerObserver()
//            } else {
//                
//                tableView.reloadData()
//            }
            if messages.count == 0 {
                getMessages {
                    self.tableView.reloadData()
                }
            } else {
                isEmptyList = false
                tableView.reloadData()
            }
            
        default:
            dataType = .notifications
//            newMessageButton.isHidden = true

            if notifications.count == 0 {
                getNotifications(offset: 1, paginationCalled: false) {
                    self.tableView.reloadData()
//                    self.readAllNotifications()
                }
            } else {
                isEmptyList = false
                tableView.reloadData()
            }
        }
    }
}

extension ChatListVC {
    
//    func registerObserver() {
//        
//        // show acitivity indicator
//        showActivity(isUserInteractionEnabled: false)
//        
//        fb.handler.ref.child("users/\(LoggedUserDetails.shared.user?.id ?? 0)").observeSingleEvent(of: .value) { [weak self] (snapshot) in
//            //hide acitivity indicator
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self?.hideActivity(isUserInteractionEnabled: true)
//                if !snapshot.hasChild("chats") {
//                    self?.isEmptyList = true
//                }
//            }
//        }
//        
////        loadFirstConverstaitons()
////        addNewConversationObservers()
//        
//    }
    
//    private func loadFirstConverstaitons() {
//        //        tableView.dataSource = nil
//        fb.handler.ref.child("users/\(LoggedUserDetails.shared.user?.id)/chats").queryOrdered(byChild: "last_update_time").observeSingleEvent(of: .value) { [weak self]( snapshot) in
//
//            guard let strongSelf = self else { return}
//            //            strongSelf.tableView.dataSource = self
//
//            if snapshot.hasChildren() {
//                //                strongSelf.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//
//                snapshot.children.forEach({ (chatSnap) in
//                    if let chatSnap = chatSnap as? DataSnapshot {
//
//                        let chatID = chatSnap.key
//                        var isUnread = false
//                        var unreadCountt = 0
//                        if let snapDic = chatSnap.value as? [String:Any],
//                            let unread = snapDic["unread"] as? Bool,
//                            let unreadCount = snapDic["unread_count"] as? Int {
//                            isUnread = unread
//                            unreadCountt = unreadCount
//                        }
//
//                        strongSelf.addChangeObserverFor(chatId: chatID)
//
//                        fb.handler.ref.child("chats/\(chatID)").observeSingleEvent(of: .value, with: {  (snapshot) in
//                            //Don't change table if its not chat
//                            guard strongSelf.dataType == .chatList else { return }
//                            let memberId = Conversation.getMemeberId(snapshot: snapshot)
//                            print("memberId", memberId)
//                            if memberId != -1 {
//                                ProfileManager.shared.fetchUserDetail(userId: memberId, showLoader: false) { user, _ in
//                                    if let user = user {
//                                        let conversation = Conversation(snapshot: snapshot)
//                                        conversation.isUnread = isUnread
//                                        conversation.unreadCount = unreadCountt
//                                        conversation.user = user
//                                        if strongSelf.conversations.first(where: { $0 == conversation }).isNil {
//                                            strongSelf.conversations.insert(conversation, at: 0)
//
//                                            strongSelf.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                                            if let newMessage = strongSelf.newMessageNotification,
//                                                newMessage.chatID == conversation.id {
//                                                strongSelf.openConversation(conversation)
//                                                strongSelf.newMessageNotification = nil
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        })
//                    }
//                })
////                self!.segmentControl.isEnabled = true
//            }
//        }
//    }
    
    
//    private func addChangeObserverFor(chatId: String) {
//
//        EvaNotificationHandler.shared.readAllMessagesNotification()
//
//        //Add change observeer on user/chat node.
//        fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id ?? 0)/chats/\(chatId)").observe(.childChanged) { [weak self] snapshot in
//
//            print("change in chat \(chatId): \(snapshot.key)")
//            guard let strongself = self else { return }
//            let conversationToUpdate = strongself.conversations.filter { return $0.id == chatId }.first!
//
//
//            //var isUnread = false
//            if snapshot.key == "unread" {
//                let isUnread = snapshot.value as! Bool
//                conversationToUpdate.isUnread = isUnread
//            }
//
//
//            if snapshot.key == "unread_count" {
//                let unreadCount = snapshot.value as! Int
//                conversationToUpdate.unreadCount = unreadCount
//            }
//
//            if let memberId = Int(conversationToUpdate.memebers.first(where: { $0.id != "\(LoggedUserDetails.shared.user!.id ?? 0)" })?.id ?? "") {
//                print("change memberId", memberId)
//                ProfileManager.shared.fetchUserDetail(userId: memberId, showLoader: false) { user, _ in
//                    if let user = user, let index = strongself.conversations.firstIndex(of: conversationToUpdate) {
//                        conversationToUpdate.user = user
//                        strongself.conversations[index] = conversationToUpdate
//                        //Don't change table if its not chat
//                        guard strongself.dataType == .chatList else { return }
//                        strongself.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//                    }
//                }
//            }
//        }
//
//        // add change observer on chat node
//
//        fb.handler.ref.child("chats/\(chatId)").observe(.childChanged) { [weak self] (snapshot) in
//            guard let strongself = self else { return }
//            if let _ = snapshot.value as? [String:Any] {
//
//                if let conversationToUpdate = strongself.conversations.first(where: { $0.id == chatId }) {
//                    conversationToUpdate.lastMessage = Message(snapshot: snapshot)
//
//                    if let index = strongself.conversations.firstIndex(of: conversationToUpdate) {
//                        strongself.conversations[index] = conversationToUpdate
//                        strongself.conversations.sort(by: { (conv1, conv2) -> Bool in
//                            conv1.lastMessage!.timeStamp > conv2.lastMessage!.timeStamp
//                        })
//                        strongself.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
    
//    private func addNewConversationObservers() {
//        fb
//            .handler
//            .ref
//            .child("users/\(LoggedUserDetails.shared.user?.id ?? 0)/chats")
//            .queryLimited(toLast: 1)
//            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
//
//                guard let strongSelf = self else { return }
//
//                // if we don't have any chats
//                if snapshot.childrenCount == 0 {
//
//                    fb
//                        .handler
//                        .ref
//                        .child("users/\(LoggedUserDetails.shared.user?.id ?? 0)/chats")
//                        .observe(.childAdded) { (snapshot) in
//
//                            //add change observer on the chats
//                            strongSelf.addChangeObserverFor(chatId: snapshot.key)
//
//                            var isUnread = false
//                            var unreadCountt = 0
//
//                            if let snapDic = snapshot.value as? [String: Any],
//                                let value = snapDic["unread"],
//                                let unread = value as? Bool,
//                                let unreadCount = snapDic["unread_count"] as? Int{
//                                unreadCountt = unreadCount
//                                isUnread = unread
//                            }
//
//                            // load chat content
//
//                            fb.handler.ref.child("chats/\(snapshot.key)").observeSingleEvent(of: .value, with: {  (snapshot) in
//                                let memberId = Conversation.getMemeberId(snapshot: snapshot)
//                                if memberId != -1 {
//                                    ProfileManager.shared.fetchUserDetail(userId: memberId, showLoader: false) { user, _ in
//                                        if let user = user {
//                                            let conversation = Conversation(snapshot: snapshot)
//                                            conversation.isUnread = isUnread
//                                            conversation.unreadCount = unreadCountt
//                                            conversation.user = user
//                                            if strongSelf.conversations.first(where: { $0 == conversation }).isNil {
//                                                strongSelf.conversations.insert(conversation, at: 0)
//                                                //Don't change table if its not chat
//                                                guard strongSelf.dataType == .chatList else { return }
//                                                strongSelf.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                                            }
//                                        }
//                                    }
//
//                                }
//                            })
//                        }
//                } else {
//
//                    let chatID = snapshot.children.map { ($0 as! DataSnapshot).key }.first!
//                    fb.handler
//                        .ref
//                        .child("users/\(String(describing: LoggedUserDetails.shared.user?.id))/chats")
//                        .queryOrderedByKey()
//                        .queryStarting(atValue: chatID)
//                        .observe(.childAdded) { (snapshot) in
//
//                            strongSelf.addChangeObserverFor(chatId: snapshot.key)
//
//                            var isUnread = false
//                            var unreadCountt = 0
//
//                            if let snapDic = snapshot.value as? [String:Any],
//                                let value = snapDic["unread"],
//                                let unread = value as? Bool,
//                                let unreadCount = snapDic["unread_count"] as? Int{
//                                isUnread = unread
//                                unreadCountt = unreadCount
//                            }
//
//                            fb.handler.ref.child("chats/\(snapshot.key)").observeSingleEvent(of: .value, with: {  (snapshot) in
//                                let memberId = Conversation.getMemeberId(snapshot: snapshot)
//                                if memberId != -1 {
//                                    ProfileManager.shared.fetchUserDetail(userId: memberId, showLoader: false) { user, _ in
//                                        if let user = user {
//                                            let conversation = Conversation(snapshot: snapshot)
//                                            conversation.isUnread = isUnread
//                                            conversation.unreadCount = unreadCountt
//                                            conversation.user = user
//
//                                            if strongSelf.conversations.first(where: { $0 == conversation }).isNil {
//                                                strongSelf.conversations.insert(conversation, at: 0)
//                                                //Don't change table if its not chat
//                                                guard strongSelf.dataType == .chatList else { return }
//                                                strongSelf.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                                            }
//                                        }
//                                    }
//                                }
//                            })
//                    }
//                }
//        }
//    }
}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataType == .notifications ? notifications.count : messages.count
////        notifications.count : conversations.count
        
        if dataType == .notifications {
            //return notifications.count
            return notificationList.count
        } else if dataType == .chatList {
            //return messages.count
            return conversations.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch dataType {
        case .notifications:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id()) as? NotificationCell {
                cell.delegate = self
                cell.notificationDelegate = self
//                let notification = notifications[indexPath.row]
//                cell.userAvatar.image = nil
////                cell.actionButton.tag = indexPath.row
////                cell.isMyActivity = isMyActivity
//                cell.notification = notification
                let notification = self.notificationList[indexPath.row]
                cell.configure(item: notification)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as? ChatListCell {
//                let conversation = messages[indexPath.row]
//                cell.conversation = conversation
                let conversation = self.conversations[indexPath.row]
                cell.configure(item: conversation)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { dataType == .chatList ? 105 : UITableView.automaticDimension }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataType == .notifications {
            //return UITableView.automaticDimension
            
            let notification = self.notificationList[indexPath.row]
            let txt = "\(notification.title ?? "")\n\(notification.body ?? "")"
            
            guard let date = notification.created_at?.formattedCreatedAt() else { return 0.0 }
            let dateLblWidth = widthForLabel(text: date, font: UIFont(name: Myfonts.regular, size: 10.0) ?? UIFont.systemFont(ofSize: 10.0), height: 12)
            let widthMargin = self.view.frame.width - dateLblWidth - 143.0
            
            let lblHeight = self.heightForView(text: txt, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: widthMargin)
            
            let totalHeight = lblHeight + 25.0
            
            if totalHeight > 80.0 {
                return totalHeight
            } else {
                return 80.0
            }
        }
        else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataType {
        case .notifications:
//            let notification = notifications[indexPath.row]
//            switch notification.objectType {
//            case "news":
//                let vc = StoryboardRouter.openNewsDetail() //openURLVC()
//                vc.selectedNewsId = notification.objectID
//                navigationController?.pushViewController(vc, animated: true)
//                break
//            case "post":
//                let vc = StoryboardRouter.textPostDetailVC()
//                vc.postId = notification.objectID
//                navigationController?.pushViewController(vc, animated: true)
//                break
//            case "job":
//                let jobListing = StoryboardRouter.userJobListing()
//                jobListing.jobId = notification.objectID
//                navigationController?.pushViewController(jobListing, animated: true)
//                break
//            case "meeting cancel":
//                let popupvc = NotificationPopupVC(nibName: "NotificationPopupVC", bundle: nil)
////                popupvc.tag = 1
////                popupvc.content = notification.content ?? ""
////                popupvc.notificationId = notification.objectID
////                self.navigationController?.present(popupvc, animated: true)
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
//                vc.meetingId = notification.objectID
//                self.navigationController?.pushViewController(vc, animated: true)
//                break
//            case "meeting created":
////                let vc = NotificationPopupVC(nibName: "NotificationPopupVC", bundle: nil)
////                vc.tag = 2
////                vc.content = notification.content ?? ""
////                vc.notificationId = notification.objectID
////                vc.completion = {
////                    let vc = DeclinePopupVC.instantiate()
////                    vc.meetingID = notification.objectID
////                    self.navigationController?.present(vc, animated: true)
////                }
////                self.navigationController?.present(vc, animated: true)
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
//                vc.meetingId = notification.objectID
//                self.navigationController?.pushViewController(vc, animated: true)
//                break
//            case "connection":
//                let vc = StoryboardRouter.othersProfileVC()
//                vc.isFrom = 1
//                vc.profileID = notification.userID
//                self.navigationController?.pushViewController(vc, animated: true)
//                break
//            case "event":
////                let vc = StoryboardRouter.eventCommentVC()
////                vc.eventId = notification.objectID
////                vc.isGalleryEnable = true
////                navigationController?.pushViewController(vc, animated: true)
//                break
//            case "eventPassed":
////                let vc = StoryboardRouter.eventCommentVC()
////                vc.eventId = notification.objectID
////                vc.isGalleryEnable = false
////                navigationController?.pushViewController(vc, animated: true)
//                break
//            default:
//                break
//            }
////            let popupvc = NotificationPopupVC(nibName: "NotificationPopupVC", bundle: nil)
////            if (indexPath.row == 0) {
////                popupvc.tag = 1
////            }
////            else if (indexPath.row == 1) {
////                popupvc.tag = 2
////            }
////            else if (indexPath.row == 2) {
////                popupvc.tag = 3
////            }
////            else if (indexPath.row == 3) {
////                popupvc.tag = 4
////            }
////            else {
////                print("Other")
////            }
////            self.navigationController?.present(popupvc, animated: true)
//            
////            let type = notifications[indexPath.row].objectType
////            switch type {
////            case "meeting":
////                performSegue(withIdentifier: Constants.Segues.meetingDetails, sender: notifications[indexPath.row].objectID)
////            case "event":
////                let vc = StoryboardRouter.eventCommentVC()
////                vc.eventId = notifications[indexPath.row].objectID
////                vc.userId = notifications[indexPath.row].userID
////                navigationController?.pushViewController(vc, animated: true)
////                //performSegue(withIdentifier: Constants.Segues.eventDetails, sender: notifications[indexPath.row].objectID)
////            case "news":
////                let newsVC = StoryboardRouter.newsVC()
////                newsVC.newId = notifications[indexPath.row].objectID
////                NavigationManager.shared.pushNotificationController(controller: newsVC)
////            case "post":
////                NavigationManager.shared.openController(objectID: notifications[indexPath.row].objectID, objectType: notifications[indexPath.row].objectType)
////            case "profile":
////                print("i am called profile")
////                didSelect(notification: notifications[indexPath.row])
////            case "connection":
////                break
////
////            default:
////                let jobVC = StoryboardRouter.userJobListing()
////                jobVC.jobId = notifications[indexPath.row].objectID
////                navigationController?.pushViewController(jobVC, animated: true)
////            }
            let notification = self.notificationList[indexPath.row]
            let type = notification.type?.lowercased()
            let notificationID = notification.id
            
            // ✅ Mark as read in Realtime Database
            self.markNotificationAsRead(userId: myUserDefaults.userId, notificationId: notification.notificationId ?? "")
            //--> chat,follower,meeting,event,post,job
            print("Notification Type :: \(type ?? "--")")
            if type == "chat" {
                let chatVC = StoryboardRouter.chat()
                chatVC.userId = notificationID ?? 0
                chatVC.notificationChat = notification
                chatVC.isComeFromNotification = true
                navigationController?.pushViewController(chatVC, animated: true)
            }
            else if type == "follower" {
                let vc = StoryboardRouter.othersProfileVC()
                vc.profileID = notificationID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "meeting" {
                print("Meeting Subtype : \(notification.subtype ?? "")")
                if notification.subtype == "" {
                    print("Notification Meeting Subtype is nil")
                } else if notificationID == 0 {
                    print("Notification Event Meeting Id is 0")
                } else {
                    let vc = MeetingListDetailsVC.instantiate()
                    vc.eventId = notificationID ?? 0
                    vc.notificationMeetingId = notification.meetingid ?? 0
                    vc.isComeFromNotification = true
                    vc.notificationType = notification.subtype ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if type == "event" {
                let vc = EventMainVC.instantiate()
                vc.eventId = notificationID ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "post" {
                let vc = StoryboardRouter.textPostDetailVC()
                //vc.postType = .video
                vc.postId = notificationID ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "job" {
                let jobListing = StoryboardRouter.userJobListing()
                jobListing.jobId = notificationID ?? 0
                navigationController?.pushViewController(jobListing, animated: true)
            }
            else if type == "news" {
                let vc = StoryboardRouter.openNewsDetail()
                vc.selectedNewsId = notificationID ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "post_like" {
            }
            else if type == "post_comment" {
            }
            else if type == "news_like" {
            }
            else if type == "news_comment" {
            }
            
        default:
//            let conversation = messages[indexPath.row]
//            openConversation(id: conversation.userid ?? 0)
            
            let conversation = self.conversations[indexPath.row]
            guard let chatPartner = conversation.user else { return }
            
            // ✅ Mark unread messages as read
            self.markMessagesAsRead(chatId: conversation.chatId ?? "",
                                    currentUserId: "\(myUserDefaults.userId)")
            
            // ✅ Navigate to ChatVC
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = chatPartner.user_id ?? 0
            chatVC.conversationDetails = conversation
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if dataType == .notifications {
//            print("Indexpath: \(indexPath.row)")
//            print("Notification: \(notifications.count)")
//            print("paginatedNotifications: \(paginatedNotifications.count)")
//            if ((indexPath.row + 1) == notifications.count) && (paginatedNotifications.count > 9) {
//                self.offSet += 1
//                getNotifications(offset: self.offSet, paginationCalled: true) {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
    func markMessagesAsRead(chatId: String, currentUserId: String) {
        let dbRef = Database.database().reference()
            .child("messages")
            .child(chatId)

        dbRef.observeSingleEvent(of: .value) { snapshot in
            for case let msgSnap as DataSnapshot in snapshot.children {
                if let dict = msgSnap.value as? [String: Any] {
                    let senderId = dict["firebase_sender_id"] as? String ?? ""
                    let isRead = dict["read"] as? Bool ?? false

                    if senderId != currentUserId && !isRead {
                        dbRef.child(msgSnap.key).updateChildValues([
                            "read": true
                        ]) { error, _ in
                            if let error = error {
                                print("❌ Error marking message as read: \(error)")
                            } else {
                                print("✅ Message \(msgSnap.key) marked as read")
                            }
                        }
                    }
                }
            }
        }
    }

    
    func markNotificationAsRead(userId: Int, notificationId: String) {
        let dbRef = Database.database().reference()
            .child("notifications")
            .child("\(userId)")
            .child(notificationId)
        
        dbRef.updateChildValues(["read": true]) { error, _ in
            if let error = error {
                print("❌ Error marking notification as read: \(error)")
            } else {
                print("✅ Notification marked as read (ID: \(notificationId))")
            }
        }
    }

    
    func addConnection(connectionId: Int, completion: @escaping () -> Void) {
        let parameters: AFParameters = [ "modified_datetime" : "2020-08-12 12:30:35",
                                         "modified_by_id" : myUserDefaults.userId,
                                         "status": "active" ]
        
        let endPoint = EndPoints.updateConnection + "\(connectionId)/"
        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                let decoder = JSONDecoder()
                let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
                
                if let generic = generic {
                    if !generic.error && generic.message == "Update Record Successful." {
                        self.presentAlertWithAction(title: "Success", message: "Added to Connections") {
                            completion()
                        }
                    }
                }
            }
        }
    }
}

extension ChatListVC: SelectionCellActionable {
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        addConnection(connectionId: notifications[sender.tag].objectID) {
            completion()
        }
    }
}

extension ChatListVC: NotificationCellDelegate {
    
    func didSelect(notification: EvaNotification) {
        if notification.content?.contains("commented") ?? false {
            NavigationManager.shared.openController(objectID: notification.objectID, objectType: notification.objectType)
        } else {
            let profile = StoryboardRouter.newProfile()
            profile.userId = notification.userID
            navigationController?.pushViewController(profile, animated: true)
        }
    }
    
}
