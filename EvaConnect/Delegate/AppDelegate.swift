//
//  AppDelegate.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Reachability
//import OneSignal
import UIKit
import UserNotifications
//import FacebookCore
//import FBSDKCoreKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import FirebaseMessaging
import FirebaseCore
//import netfox
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.Message_ID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        Thread.sleep(forTimeInterval: 2.0)
        
//        let notificationOption = launchOptions?[.remoteNotification]

    // GMSPlacesClient.provideAPIKey("AIzaSyBWLZpMElA_Kcgqs3WRg2Yo5fUDfi3f9ZM")
//        #if Debug
//        NFX.sharedInstance().start()
//        #endif
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        
//        OneSignal.setLocationShared(false)
//        OneSignalUtility.shared.setup(withLaunchingOptions: launchOptions)
//        if #available(iOS 12.0, *) {
//            NetworkConnection.shared.startObserving()
//        } else {
//            // Fallback on earlier versions
//        }
//
//        _ = AppearanceProxyManager.shared.applyDefaultControllsApperance()
        FirebaseApp.configure()
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) { } else {
            NavigationManager.rootViewController(window: window!)
        }
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
        //scheduleTestNotification()

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        // Messaging Delegate
        Messaging.messaging().delegate = self
        
        
//        print("firebase database url", FirebaseHandler.handler.ref)
//        Messaging.messaging().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if granted {
                print("Permission granted ✅")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission denied ❌")
                self.showNotificationSettingsAlert()
            }
        }
        
//MARK: To print all the available fonts
//        for family in UIFont.familyNames {
//            print("Family: \(family)")
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("  Font: \(name)")
//            }
//        }

        return true
    }
    
    func showNotificationSettingsAlert() {
        let alert = UIAlertController(
            title: "Notifications Disabled",
            message: "Please enable notifications in Settings to stay updated.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }))

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome"
        content.body = "Thanks for opening the app!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "welcome", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
//        if let tabBarVC = window?.rootViewController as? TabBar {
//            tabBarVC.refreshUserNotificationCounters()
//        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
//        OnlineStatusManager.updateOnlineStatus(isOnline: false)
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if url.scheme != nil && url.scheme!.hasPrefix("fb\(1347985605397406)") && url.host == "authorize" {
//            return ApplicationDelegate.shared.application(
//                app,
//                open: url,
//                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//            )
//        }
        return true
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
////        let userInfo = notification.request.content.userInfo
////
////        if !(userInfo["gcm.notification.type"] as? String).isNil { //firebase messaging
////
////               if let tabBarVC = window?.rootViewController as? TabBar {
////                tabBarVC.refreshUserNotificationCounters()
////
////                if tabBarVC.selectedIndex != tabBarMessagesItemIndex {
////                    completionHandler([.alert,.badge,.sound])
////                } else {
////                    completionHandler([])
////                }
////                return
////            }
////        }
//        
//        // handle notifications in will present
//
//        completionHandler([.alert,.badge,.sound])
//    }
}


// MARK: UNUserNotificationCenterDelegate
@available(iOS 13.0.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    //gets called in active state
    print(userInfo)

    // Change this to your preferred presentation option
    return [[.alert]]//, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo
      print("User tapped notification with info: \(userInfo)")
    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.

      // Accessing the redirect_url
      if let redirectURL = userInfo["redirect_url"] as? String {
          print("Redirect URL: \(redirectURL)")
          let urlString = redirectURL
          if let range = urlString.range(of: "aviationconnect.com") {
              let endPoints = String(urlString[range.upperBound...])
              print(endPoints)
              self.deepLinkNavigation(endPoints: endPoints)
              return
          }

      } else {
          print("Redirect URL not found")
      }
      
    print(userInfo)
  }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
//        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
          
//          guard let notificationType = userInfo[AnyHashable("type")] as? String else {
//              print("no notification type")
//            return UIBackgroundFetchResult.newData
//          }
////          userDefaults.notificationType = notificationType
//          guard let alldetails = userInfo[AnyHashable("alldetails")] as? NSDictionary,
//                let custDetails = alldetails["customer_details"] as? NSDictionary,
//                let astroDetails = alldetails["customer_details"] as? NSDictionary,
//                let custImage = custDetails["image"] as? String,
//                let custName = custDetails["name"] as? String,
//                let custId = custDetails["id"] as? String,
//                let astroImage = astroDetails["image"] as? String,
//                let astroName = astroDetails["name"] as? String,
//                let astroId = astroDetails["id"] as? String,
//                let roleId = astroDetails["role_id"] as? String
//                else {
//                  // handle any error here
//                  print("Error found!!")
//                return UIBackgroundFetchResult.newData
//              }
////          userDefaults.roleId = Int(roleId) ?? 0
//          print("name: \(custName)\\Id:\(custId)")
          
          if let redirectURL = userInfo["redirect_url"] as? String {
              print("Redirect URL: \(redirectURL)")
              let urlString = redirectURL
              if let range = urlString.range(of: "aviationconnect.com") {
                  let endPoints = String(urlString[range.upperBound...])
                  print(endPoints)
                  self.deepLinkNavigation(endPoints: endPoints)
              }
          } else {
              print("Redirect URL not found")
          }
          
          
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
      
      // Print full message.
    //gets called when app is minimised
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
    
    func deepLinkNavigation(endPoints: String) {
        if (endPoints.contains("/") == true) {
            let split = endPoints.split(separator: "/")
            print("Split ==> \(split)")
            
            if split.count == 2 {
                let deepLinkData:[String: String] = ["param1": String(split[0]),
                                                     "param2": String(split[1])]
                NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
            } else if split.count == 3 {
                let deepLinkData:[String: String] = ["param1": String(split[0]),
                                                     "param2": String(split[1]),
                                                     "param3": String(split[2])]
                NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
            }
            
        }
//        else {
//            let deepLinkData:[String: String] = ["param1": endPoints]
//            NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
//        }
    }
    
}

extension AppDelegate {
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func makeRoot<T: UIViewController>(controller: T) {
        window?.makeKeyAndVisible()
        window?.rootViewController = controller
    }
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        print("notifications",response.notification.request.content.userInfo)
//        let userInfo = response.notification.request.content.userInfo
//
//        if !(userInfo["gcm.notification.type"] as? String).isNil {
//            let chatID = userInfo["gcm.notification.chat_room_id"] as! String
//
//            NotificationsHandler.shared.addChatNotifications(chatNotification: ChatNotification(chatID: chatID))
//            completionHandler()
//
//        } else {
//
//            if let notificationObject = ((userInfo["custom"] as? [String: Any])?["a"] as? [String: Any]) {
//                if let type = notificationObject["notification_type"] as? Int,
//                    let objectId =  notificationObject["object_id"] as? Int,
//                    let objectType =  notificationObject["object_type"] as? String {
//
//                    let notification = PushNotification(message: nil, notificationType: type, objectID: objectId, objectType: objectType)
//
//                    NotificationsHandler.shared.addNotifications(pushNotification: notification)
//                }
//                completionHandler()
//            }
//        }
//    }
//}

//extension AppDelegate: MessagingDelegate {
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        if let fcmToken = fcmToken {
//            LoggedUserDetails.shared.fcmToken = fcmToken
//        }
//    }
//}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        myUserDefaults.deviceToken = fcmToken ?? ""
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FCMToken"), object: nil)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
