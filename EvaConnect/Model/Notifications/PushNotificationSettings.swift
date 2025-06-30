//
//  PushNotificationSettings.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 3/15/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

// MARK: - PushNotificationSettings
struct PushNotificationSettings: Codable {
    let status, os: String
    let createdBy, id: Int
    let createdDateTime: String
    let userId: Int
    let notifications: [String: Int]

    enum CodingKeys: String, CodingKey {
        case status, os
        case createdBy = "created_by_id"
        case id
        case createdDateTime = "created_datetime"
        case userId = "user_id"
        case notifications
    }
}
