//
//  NavigationManager.swift
//  EvaConnect
//
//  Created by usama on 19/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class NavigationManager {
    
    //    private init { }
    static let shared = NavigationManager()
    var rootVC: UIViewController?
    
    var isAppLoaded: Bool {
        return !rootVC.isNil
    }
    
    func handleChatNotification(chatNotification: ChatNotification) -> Bool {
        
        if isAppLoaded {
            openChatVC(chat: chatNotification)
            return true
        }
        
        return false
    }
    
    public func handlePushNotification(pushNotification: PushNotification) -> Bool {
        // check type and handle controller to be presented.
        
        if isAppLoaded {
            controllerTobePushed(pushNotification: pushNotification) { (controller) in
                self.pushNotificationController(controller: controller)
            }
            
            return true
        }
        // success message. if i have pushed the notif or not.
        return false
    }
    
    func openChatVC(chat: ChatNotification) {
        if let tabBar = rootVC as? TabBar,
            let navVC = tabBar.viewControllers![2] as? UINavigationController,
            let chatListVC = navVC.topViewController as? ChatListVC {
            chatListVC.newMessageNotification = chat
            navVC.popViewController(animated: true)
            
            if tabBar.selectedViewController != navVC {
                tabBar.selectedViewController = navVC
            }
            
            
        } else {
            print("Didn't get a navigationController")
        }
    }
    
    public func openController(objectID: Int, objectType: String, userId: String? = nil) {
        // check type and handle controller to be presented.
        if isAppLoaded {
            
            let pushNotification = PushNotification(message: nil, notificationType: 0, objectID: objectID, objectType: objectType)
                        
            controllerTobePushed(pushNotification: pushNotification, isEventCommentVC: true, userId: Int(userId ?? "")) { (controller) in
                self.pushNotificationController(controller: controller)
            }
        }
    }
    
    static func rootViewController(window: UIWindow) {
        
        var rootVC: UIViewController?
        let token = UserDefaults.standard.value(forKey: "UserToken")
        
        if !token.isNil {
//            LoggedUserDetails.shared.updateUser(userModel: BaseVC.GetUser())
//            if let user = LoggedUserDetails.shared.user, user.status == Constants.Label.active {
//                rootVC = TabBar()
            if myUserDefaults.userId > 0 {
                (myUserDefaults.user == "user") ? (isIndivisualUser = true) : (isIndivisualUser = false)
                let vc = DashboardTabbarVC.instantiate()
//                OnlineStatusManager.updateOnlineStatus()
                rootVC = UINavigationController(rootViewController: vc)
            } else {
//                LoggedUserDetails.shared.logoutUser()
                let loginVC = StoryboardRouter.login()
                rootVC = UINavigationController(rootViewController: loginVC)
            }
        } else {
            let loginVC = StoryboardRouter.login()
            rootVC = UINavigationController(rootViewController: loginVC)
        }
        
        NavigationManager.shared.rootVC = rootVC
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        // if there is a notification then handle it, remove the notification as well.
        
//        if let notification = NotificationsHandler.shared.pushNotification {
//            
//            self.shared.handlePushNotification(pushNotification: notification)
//            
//        }
    }
    
    func pushNotificationController(controller: UIViewController) {
        
        if let tabBar = rootVC as? TabBar,
            let navVC = tabBar.selectedViewController as? UINavigationController {
            print("\(NavigationManager.self): pushNotificationController will push \(type(of: controller))")
            navVC.pushViewController(controller, animated: true)
            //navVC.viewControllers.first!.present(navVC, animated: true)
        } else {
            print("Didn't get a navigationController")
        }
    }
}

private extension NavigationManager {
    
    func controllerTobePushed(pushNotification: PushNotification, isEventCommentVC: Bool = false, userId: Int? = nil, completion:@escaping (UIViewController) -> ()) {
        
        switch pushNotification.objectType {
        case "post":
            
            let postManger = PostManager()
            print("\(NavigationManager.self): controllerTobePushed will calling api)")
            postManger.postDetail(postId: pushNotification.objectID) { (post, postType, error) in
                print("\(NavigationManager.self): controllerTobePushed back from completion)")
                if let post = post {
                    print("\(NavigationManager.self): controllerTobePushed got the post)")
                    let postController = postManger.postDetailType(postDetail: post)
                    switch postController {
                    case is TextPostDetailVC:
                        (postController as? TextPostDetailVC)?.postId = pushNotification.objectID
                    case is UrlCommentVC:
                        (postController as? UrlCommentVC)?.postId = pushNotification.objectID
                    default:
                        (postController as? OtherCommentVC)?.postId = pushNotification.objectID
                        
                    }
                    completion(postController)
                }
            }
            
        case "event":
//            if let userId = userId {
//                if isEventCommentVC {
//                    let eventViewVC = StoryboardRouter.eventCommentVC()
//                    eventViewVC.eventId = pushNotification.objectID
//                    eventViewVC.userId = userId
//                    completion(eventViewVC)
//                } else {
////                    let eventViewVC = StoryboardRouter.eventView()
////                    eventViewVC.eventId = pushNotification.objectID
////                    eventViewVC.navigationType = .notifications
////                    completion(eventViewVC)
//                }
//            }
            break
        case "meeting":
            let meetingVC = StoryboardRouter.meetingView()
            meetingVC.meetingId = pushNotification.objectID
            completion(meetingVC)
            
        case "news":
            let newsViewVC = StoryboardRouter.newsVC()
            newsViewVC.newId = pushNotification.objectID
            completion(newsViewVC)
            
        case "connection":
            let connectionVC = StoryboardRouter.connectionVC()
            completion(connectionVC)
            
        case "job":
//            let jobVC = StoryboardRouter.jobVC()
//            jobVC.jobId = pushNotification.objectID
            let jobVC = StoryboardRouter.userJobListing()
            jobVC.jobId = pushNotification.objectID
            completion(jobVC)
            
        default:
            break
        }
    }
}

