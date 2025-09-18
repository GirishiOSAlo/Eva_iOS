//
//  DashboardTabbarVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 08/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore


class DashboardTabbarVC: BaseVC, XIBed {
        
    
    lazy var homePageVC: HomePageVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
        return vc
    }()
    
    lazy var homeVC: HomeVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        return vc
    }()
        
    lazy var notifVC: ChatListVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        vc.dataType = .notifications
        return vc
    }()
        
    lazy var messageVC: ChatListVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        vc.dataType = .chatList
        return vc
    }()

    lazy var profileVC: UserProfileVC = {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        return vc
    }()
    
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var tabStackView: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var tabBGImgView: UIImageView!
    
    @IBOutlet weak var homeView: CustomTabView!
    @IBOutlet weak var notifView: CustomTabView!
    @IBOutlet weak var messageView: CustomTabView!
    @IBOutlet weak var profileView: CustomTabView!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var createJobBtn: UIButton!
    
    @IBOutlet weak var createPostBottomConst: NSLayoutConstraint!
    @IBOutlet weak var createJobBottomConst: NSLayoutConstraint!
    
    var tabType = 0  // 0= home 1= profile 2= notification
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        setTabViewssDelegates()
        
        fetchUnreadChatCount()
        fetchUnreadNotificationCount()
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(deeplinkData),
                         name: NSNotification.Name("DeepLinkingCall"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
      

    func setupUI(){
        
        homeView.imageName = "homeTab"
        notifView.imageName = "notifTab"
        messageView.imageName = "msgTab"
        profileView.imageName = "profileTab"
        
        // ✅ Show badge only for notif & message
        messageView.setBadge(count: 0)
        notifView.setBadge(count: 0)
        homeView.setBadge(count: 0)
        profileView.setBadge(count: 0)
        
        createJobBtn.layer.cornerRadius = 20
        createPostBtn.layer.cornerRadius = 20
        
        createPostBottomConst.constant = -78
        createPostBtn.alpha = 0
        
        createJobBottomConst.constant = -132
        createPostBtn.alpha = 0
        
        switch tabType {
        case 0:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homePageVC)
        case 1:
            singleSelectTab(tab: profileView)
            showOnContainer(vc: profileVC)
        case 2:
            singleSelectTab(tab: notifView)
            showOnContainer(vc: notifVC)
        case 3:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homeVC)
        default:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homePageVC)
        }
    }
    
    func setTabViewssDelegates() {
        homeView.delegate = self
        notifView.delegate = self
        messageView.delegate = self
        profileView.delegate = self
    }
    
    func fetchUnreadChatCount() {
        let loggedInUserId = myUserDefaults.userId
        observeConversations(loggedInUserId: loggedInUserId) { conversations in
            DispatchQueue.main.async {
                let totalUnread = conversations.reduce(0) { $0 + ($1.unreadCount ?? 0) }
                print("ID : \(loggedInUserId), Conversations Dashboard: \(conversations.count), Unread: \(totalUnread)")
                self.messageView.setBadge(count: totalUnread)
            }
        }
    }
    
    func fetchUnreadNotificationCount() {
        let loggedInUserId = myUserDefaults.userId
        observeNotifications(for: loggedInUserId) { [weak self] notifications, unreadCount in
            print("ID : \(loggedInUserId), Notifications Dashboard: \(notifications.count), Unread: \(unreadCount)")
            DispatchQueue.main.async {
                self?.notifView.setBadge(count: unreadCount)
            }
        }
    }
    
    @IBAction func addPostTapped(_ sender: UIButton) {
        homeView.state = .unselected
        notifView.state = .unselected
        messageView.state = .unselected
        profileView.state = .unselected
        
//        let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:"HomePageVC") as! HomePageVC
//        navigationController?.pushViewController(vc, animated: true)
                
        if isIndivisualUser {
            let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:
                                                                                "AddPostVC") as! AddPostVC
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if createPostBottomConst.constant == 14 {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                    self?.createPostBottomConst.constant = -68
                    self?.createJobBottomConst.constant = -68
                }) { (_) in
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.createPostBtn.alpha = 0
                        self?.createJobBtn.alpha = 0
                    }) { (_) in }
                }
            }else{
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                    self?.createPostBottomConst.constant = 14
                }) { (_) in
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.createPostBtn.alpha = 1.0
                    }) { (_) in
                        UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       options: .curveEaseOut,
                                       animations: { [weak self] in
                            self?.view.layoutIfNeeded()
                            self?.createJobBottomConst.constant = 10
                        }) { (_) in
                            UIView.animate(withDuration: 0.3,
                                           delay: 0,
                                           options: .curveEaseOut,
                                           animations: { [weak self] in
                                self?.view.layoutIfNeeded()
                                self?.createJobBtn.alpha = 1.0
                            }) { (_) in }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func createPostTapped(_ sender: UIButton) {
        self.addPostTapped(addBtn)
        let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:"AddPostVC") as! AddPostVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createJobTapped(_ sender: UIButton) {
        self.addPostTapped(addBtn)
        let vc = StoryboardRouter.createEditJobPost()
        vc.roleType = .add
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//extension DashboardTabbarVC {
//    func select(name: String) {
//        if name.elementsEqual("Events") {
//            
//        }
//    }
//}

extension DashboardTabbarVC {
    func observeConversations(loggedInUserId: Int, onUpdate: @escaping ([Conversation]) -> Void) {
        let messagesRef = Database.database().reference().child("messages")
        let usersRef = Database.database().reference().child("users")
        
        messagesRef.observe(.value) { snapshot, _ in
            var updatedConversations: [Conversation] = []
            
            let dispatchGroup = DispatchGroup() // wait for all user fetches
            
            for case let chatNode as DataSnapshot in snapshot.children {
                guard let key = chatNode.key as String?, key.contains("_") else { continue }
                
                let participants = key.split(separator: "_").map { String($0) }
                guard participants.contains(String(loggedInUserId)) else { continue }
                
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
                        
                        if let senderId = dict["firebase_sender_id"] as? String,
                           senderId != String(loggedInUserId),
                           dict["read"] as? Bool == false {
                            unreadCount += 1
                        }
                    }
                }
                
                guard let lastMessage = messages.max(by: { ($0.timestamp ?? 0.0) < ($1.timestamp ?? 0.0) }) else { continue }
                
                let otherUserId: Int
                if participants[0] == String(loggedInUserId) {
                    otherUserId = Int(participants[1]) ?? -1
                } else {
                    otherUserId = Int(participants[0]) ?? -1
                }
                guard otherUserId != -1 else { continue }
                
                // Fetch user info
                dispatchGroup.enter()
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
                            }
                        }
                        dispatchGroup.leave()
                    }
            }
            
            // ✅ Ensure callback fires even if no chats
            dispatchGroup.notify(queue: .main) {
                let sorted = updatedConversations.sorted {
                    ($0.lastMessage?.timestamp ?? 0.0) > ($1.lastMessage?.timestamp ?? 0.0)
                }
                onUpdate(sorted)
            }
        }
    }
    
    func observeNotifications(for userId: Int, onUpdate: @escaping ([FirebaseNotification], Int) -> Void) {
        let notificationsRef = Database.database().reference()
            .child("notifications")
            .child("\(userId)")

        notificationsRef.observe(.value) { snapshot in
            var updatedNotifications: [FirebaseNotification] = []
            var unreadCount = 0

            for case let notifSnap as DataSnapshot in snapshot.children {
                if let dict = notifSnap.value as? [String: Any] {
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
                        id: notificationIdInt,
                        read: dict["read"] as? Bool ?? false,
                        redirect_url: dict["redirect_url"] as? String ?? "",
                        title: dict["title"] as? String ?? "",
                        type: dict["type"] as? String ?? "",
                        subtype: dict["subtype"] as? String ?? "",
                        notificationId: notifSnap.key,
                        meetingid: dict["meetingid"] as? Int ?? 0
                    )
                    updatedNotifications.append(notification)

                    // ✅ Count unread
                    if notification.read == false {
                        unreadCount += 1
                    }
                }
            }

            let sorted = updatedNotifications.sorted {
                ($0.created_at ?? "") > ($1.created_at ?? "")
            }

            onUpdate(sorted, unreadCount)
        }
    }

}

extension DashboardTabbarVC: CustomTabSelectDelegate {
    func didSelectTab(tab: CustomTabView) {
        if tab == homeView && homeView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: homePageVC)
        } else if tab == notifView && notifView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: notifVC)
        } else if tab == messageView && messageView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: messageVC)
        } else if tab == profileView && profileView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: profileVC)
        }
    }
    
    func singleSelectTab(tab: CustomTabView) {
        homeView.state = tab == homeView ? .selected : .unselected
        notifView.state = tab == notifView ? .selected : .unselected
        messageView.state = tab == messageView ? .selected : .unselected
        profileView.state = tab == profileView ? .selected : .unselected
    }
    
    func showOnContainer(vc: UIViewController) {
        container.subviews.forEach({ $0.removeFromSuperview() })
        
        self.addChild(vc)
        container.addSubview(vc.view)
        vc.view.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor)
    }
    
}

// MARK: Deeplink Redirection
extension DashboardTabbarVC {
    
    @objc func deeplinkData(_ notification: NSNotification) {
        
        if let endPoint = notification.userInfo?["param1"] as? String {
            
            switch endPoint {
            case "post":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postId = Int(endpoint2)
                    navigationController?.pushViewController(vc, animated: true)
                    break
                }

            case "event":
//                if let endpoint2 = notification.userInfo?["param2"] as? String {
//                    print(endpoint2)
//                    let vc = StoryboardRouter.eventCommentVC()
//                    vc.eventId = Int(endpoint2)
//                    vc.isGalleryEnable = true
//                    navigationController?.pushViewController(vc, animated: true)
                    break
//                }
            case "passedEvent":
//                if let endpoint2 = notification.userInfo?["param2"] as? String {
//                    print(endpoint2)
//                    let vc = StoryboardRouter.eventCommentVC()
//                    vc.eventId = Int(endpoint2)
//                    vc.isGalleryEnable = false
//                    navigationController?.pushViewController(vc, animated: true)
                    break
//                }
            case "news":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    let vc = StoryboardRouter.openNewsDetail() //openURLVC()
                    vc.selectedNewsId = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(vc, animated: true)
                    break
                }
            case "jobs":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let jobListing = StoryboardRouter.userJobListing()
                    jobListing.jobId = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(jobListing, animated: true)
                    break
                }
            case "job":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let jobListing = StoryboardRouter.userJobListing()
                    jobListing.jobId = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(jobListing, animated: true)
                    break
                }
            case "meeting":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
                    vc.meetingId = Int(endpoint2) ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case "message":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let chatVC = StoryboardRouter.chat()
                    chatVC.userId = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(chatVC, animated: true)
                }
            case "profile":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let vc = StoryboardRouter.othersProfileVC()
                    vc.profileID = Int(endpoint2) ?? 0
                    vc.isFrom = 0
                    navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
                
            }
        }
    }
    
}
