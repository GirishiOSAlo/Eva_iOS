//
//  MyNotificationModel.swift
//  EvaConnect
//
//  Created by Metis on 23/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllNotificationModel: Codable {
    let error: Bool
    let message: String
    let data: [NotificationModelData]
}

// MARK: - Datum
struct NotificationModelData: Codable {
    let id, userID: Int
    let user: UserNotification
    let receiverID, objectID: Int
    let objectType: ObjectType?
    let details: String?
    let isLike, isRead: Int
    let createdTime, createdDate, createdDatetime: String

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

enum ObjectType: String, Codable {
    case comment = "comment"
    case like = "like"
    case post = "post"
    case job = "job"
    case event = "event"
    case interview = "interview"
}

// MARK: - User
struct UserNotification: Codable {
    let id: Int
    let firstName: String
    let isConnected, isReceiver, connectionID: Int?
    let lastName: String?
    let bioData: String?
    let email, uniqueCode, username: String
    let dateOfBirth: String?
    let verificationPin: Int
    let userImage: String
    let os: String?
    let type: String?
    let createdByID: Int?
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

enum BioData: String, Codable {
    case abc = "abc"
    case hypernym = "hypernym"
    case iOSDeveloper = "iOS Developer"
    case test = "test"
    case writeABriefBioIntroductionHere200CharLimit = "Write a brief bio/introduction here(200 char limit)"
}

enum OSNotification: String, Codable {
    case android = "ANDROID"
    case osAndroid = "android"
    case web = "web"
}

enum Status: String, Codable {
    case active = "active"
}

enum TypeEnumNotification: String, Codable {
    case company = "company"
    case user = "user"
}
