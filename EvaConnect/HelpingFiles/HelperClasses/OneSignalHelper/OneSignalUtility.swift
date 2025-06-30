////
////  SignalOneUtility.swift
////  Instamunch
////
////  Created by Metis International on 20/01/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import Foundation
////import OneSignal
//import UIKit
//import Alamofire
//
//class OneSignalUtility: NSObject {
//    
//    static var shared: OneSignalUtility = {
//        return OneSignalUtility()
//    }()
//    
//    var appId = "44bb428a-54f5-4155-bea3-c0ac2d0b3c1a"
//    var authorization = "Basic OGY1MDlkNzItMzljNS00ZGY2LTg5MmItMmEwOGQ2YzMwZWU4"
//    private override init() {}
//    
//    
//    func setup(withLaunchingOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
//        //Insert OneSignal initialization code from above here
//        //START OneSignal initialization code
//        
//        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
//
//        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
//        OneSignal.initWithLaunchOptions(options, appId: appId, handleNotificationAction: nil, settings: onesignalInitSettings)
//
//        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
//
//        // Recommend moving the below line to prompt for push after informing the user about
//        //   how your app will use them.
//        OneSignal.promptForPushNotifications(userResponse: { accepted in
//            print("User accepted notifications: \(accepted)")
//        })
//        
//        OneSignal.add(self)
//        
//        //END OneSignal initializataion code
//    }
//    
//    func subscribe(_ email: String) {
//        OneSignal.sendTags(["email": email])
//       // OneSignal.setExternalUserId(String(user.id))
//        OneSignal.setSubscription(true)
//    }
//    
//    func unSubscribe() {
//       // OneSignal.removeExternalUserId()
//        OneSignal.deleteTags(["email"])
//        OneSignal.setSubscription(false)
//    }
//    
//    func sendPushNotification(email: String, title: String, message: String, notificationType: Int, objectId: Int, objectType: String, silent: Bool = true) {
//        let data = OneSingalNotification(email: email, title: title, message: message, notificationType: notificationType, objectId: objectId,
//                                         objectType: objectType).dictionary
//        
//        NetworkManagerr.request(EndPoints.oneSingal, method: .post, parameters: data, headers: ["Authorization": authorization]) { (result: Result<OneSingalNotificationResponse>) in
//            switch result {
//            case .success(let value):
//                print("notification message", value, "success")
//            case .failure(let error):
//                print("notification message", error, "error")
//            }
//        }
//    }
//}
//
//extension OneSignalUtility: OSSubscriptionObserver {
//    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
//        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
//            print("Subscribed for OneSignal push notifications! playerId: \(String(describing: stateChanges.to.userId))")
//        }
//        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
//    }
//}
//
//
