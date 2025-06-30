//
//  NotificationsHandler.swift
//  EvaConnect
//
//  Created by usama on 19/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum NotificationType {
    case post, event, job
}

class NotificationsHandler {
    
    static let shared = NotificationsHandler()

    private(set) var pushNotification: PushNotification? {
        didSet {
            
            guard let pushNotifcaiton = pushNotification else {
                return
            }
            
            if NavigationManager.shared.handlePushNotification(pushNotification: pushNotifcaiton) {
                
                removeNotifications()
            }
        }
    }
    
    private(set) var chatNotification: ChatNotification? {
        didSet {
            guard let chatNotfication = chatNotification else {
                return
            }
            
            if NavigationManager.shared.handleChatNotification(chatNotification: chatNotfication) {
                removeChatNotifications()
            }
        }
    }
    
    
    func addNotifications(pushNotification: PushNotification) {
        
        self.pushNotification = pushNotification
    }
    
    func removeNotifications() {
        
        pushNotification = nil
    }
    
    func addChatNotifications(chatNotification: ChatNotification) {
          
          self.chatNotification = chatNotification
      }
    
    func removeChatNotifications() {
        
        chatNotification = nil
    }
}
