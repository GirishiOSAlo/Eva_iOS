//
//  NewNotificaitions.swift
//  EvaConnect
//
//  Created by usama on 11/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Notifications
struct NotificationRoot: Codable {
    let error: Bool
    let message: String
    let data: [EvaNotification]?
}

// MARK: - Datum
struct EvaNotification: Codable {
    let id, userID: Int
    let user: EvaUser
    let receiverID: Int?
    let objectID: Int
    let objectType: String
    let content: String?
    let details: String?
    let isLike, isRead: Int?
    let createdTime, createdDate, createdDatetime, notificationTime: String?

//    var dateTime: String? {
//        if let (date, time) = createdDatetime?.dateTime(isUTC: true) {
//            return String(format: "%@ at %@", date, time)
//        }
//        return nil
//    }

    enum CodingKeys: String, CodingKey {
        case id, content
        case userID = "user_id"
        case user
        case receiverID = "receiver_id"
        case objectID = "object_id"
        case objectType = "object_type"
        case details
        case isLike = "is_like"
        case isRead = "is_read"
        case createdTime = "created_time"
        case createdDate = "created_date"
        case createdDatetime = "created_datetime"
        case notificationTime = "notification_time"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userID = try container.decode(Int.self, forKey: .userID)
        if let user = try? container.decode([EvaUser].self, forKey: .user).last {
            self.user = user
        } else {
            user = try container.decode(EvaUser.self, forKey: .user)
        }
        
        receiverID = try? container.decode(Int.self, forKey: .receiverID)
        objectID = try container.decode(Int.self, forKey: .objectID)
        objectType = try container.decode(String.self, forKey: .objectType)
        content = try? container.decode(String.self, forKey: .content)
        details = try? container.decode(String.self, forKey: .details)
        isLike = try? container.decode(Int.self, forKey: .isLike)
        isRead = try? container.decode(Int.self, forKey: .isRead)
        createdTime = try? container.decode(String.self, forKey: .createdTime)
        createdDate = try? container.decode(String.self, forKey: .createdDate)
        createdDatetime = try? container.decode(String.self, forKey: .createdDatetime)
        notificationTime = try? container.decode(String.self, forKey: .notificationTime)
    }
}
