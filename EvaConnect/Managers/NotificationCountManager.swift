//
//  NotificationCountManager.swift
//  EvaConnect
//
//  Created by usama on 26/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

class NotificationCountManager {
    
    class func getNotificationCount(completion: @escaping () -> Void) {
        NetworkManagerr.request(EndPoints.notificationCount) { (response) in
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let notificationCountRoot = try jsonDecoder.decode(NotificationCountRoot.self, from: response.data!)
                    
                    let notificationCount = notificationCountRoot.data[0]
                    SharedLogger.logInfo("\(notificationCount.notification_count)")
                    completion()
                } catch {
                    //
                }
            } else {
                //
            }
        }
    }
}

