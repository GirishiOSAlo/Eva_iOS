//
//  AllMyCurrentNotificationModel.swift
//  EvaConnect
//
//  Created by Metis on 03/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct AllMyCurrentNotificationModel: Codable {
    let error: Bool
    let message: String
    let data: [MyCurrentNotificationModel]?
}

// MARK: - Datum
struct MyCurrentNotificationModel: Codable {
    let id, userID: Int?
    let user: CurrentNotificationUser1?
    let receiverID, objectID: Int?
    let objectType, details: String?
    let isLike, isRead: Int?
    let createdTime, createdDate, createdDatetime: String?

    enum CodingKeys: String, CodingKey {
        case id
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
    }
}

// MARK: - User
struct CurrentNotificationUser1: Codable {
    let id: Int?
    let firstName: String?
    let isConnected, connectionID, lastName: String?
    let isReceiver: ReceiverID?
    let bioData: String?
    let email, uniqueCode, username: String?
    let dateOfBirth: String?
    let verificationPin: Int?
    let userImage: String?
    let os, type: String?
    let createdByID: StringOrInt?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case lastName = "last_name"
        case bioData = "bio_data"
        case email
        case uniqueCode = "unique_code"
        case username
        case dateOfBirth = "date_of_birth"
        case verificationPin = "verification_pin"
        case userImage = "user_image"
        case os, type
        case createdByID = "created_by_id"
        case status
    }
}
