//
//  connectionByFilter.swift
//  EvaConnect
//
//  Created by Metis on 04/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


import Foundation

// MARK: - Welcome
struct ConnectionRoot: Codable {
    let error: Bool
    let message: String
    let data: [User]
}

// MARK: - Datum
struct User: Codable, Equatable {
    var isSelected = false
    let id: Int
    let firstName, email: String
    let uniqueCode: String?
    let lastName: String?
    let username: String?
    let dateOfBirth: String?
    let userImage: String?
    let city, country: String?
    let bioData, type: String?
    let status: String?
    let address, companyName, field, designation: String?
    let isConnected: String?
    let isReceiver: Bool?
    let isOnline: Bool?
    let lastOnlineDateTime: String?
    let connectionID, isNotifications: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case uniqueCode = "unique_code"
        case username
        case dateOfBirth = "date_of_birth"
        case userImage = "user_image"
        case isOnline = "is_online"
        case lastOnlineDateTime = "last_online_datetime"
        case city, country
        case bioData = "bio_data"
        case type
        case status
        case address
        case companyName = "company_name"
        case field, designation
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case isNotifications = "is_notifications"
    }
    
    var fullName: String {
        var title = ""
        title += firstName
        if let lastName = lastName {
            title += " " + String(lastName.first!)
        }
        return title
    }
}

enum IsConnected: String, Codable {
    case active = "active"
    case notConnected = "not_connected"
    case pending = "pending"
    case deleted = "deleted"
}

enum OS: String, Codable {
    case android = "ANDROID"
    case osAndroid = "android"
    case web = "web"
}

enum TypeEnum: String, Codable {
    case admin = "admin"
    case company = "company"
    case user = "user"
}


struct ConnectionFilterModel: Codable {
    let error: Bool
    let message: String
    let data: [UserConnection]
}

struct UserConnection: Codable , Equatable {
    var isSelected = false
    let id: Int?
    let firstName: String?
    var isConnected: String?
    var isReceiver: Bool? 
    var connectionID, userId: Int?
    let lastName, bioData: String?
    let email, uniqueCode, userName: String?
    let dateOfBirth: String?
    let verificationPin: Int?
    let userImage: String?
    let userImageUrl: String?
    let os: OS?
    let type: TypeEnum?
    let createdByID: StringOrInt?
    let status: IsConnected?
    let isLinkedin: Int?
    let linkedinImageURL, address, companyName, company_Name, field: String?
    let designation, loginStatus: String?

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
        case userName
        case dateOfBirth = "date_of_birth"
        case verificationPin = "verification_pin"
        case userImage = "user_image"
        case userImageUrl = "user_image_url"
        case userId = "user_id"
        case os, type
        case createdByID = "created_by_id"
        case status
        case isLinkedin = "is_linkedin"
        case linkedinImageURL = "linkedin_image_url"
        case address
        case company_Name = "companyName"
        case companyName = "company_name"
        case field, designation
        case loginStatus = "login_status"
    }
}


struct MakeConnection: Codable {
    let error: Bool
    let message: String
    let data: [String]?
}

struct InvitationRoot: Codable {
    let error: Bool
    let message: String
    let data: [InvitationScheduledId]?
}

struct InvitationScheduledId: Codable {
    
    let id: Int
}

struct PendingBlockFilterModel: Codable {
    let error: Bool
    let message: String
    let data: [PendingBlockResponse]
}

// MARK: - PendingBlockResponse
struct PendingBlockResponse: Codable {
    let id, senderID: Int?
    var sender: UserConnection?
    let receiverID: Int?
    var receiver: UserConnection?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, os, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case sender
        case receiverID = "receiver_id"
        case receiver
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}

