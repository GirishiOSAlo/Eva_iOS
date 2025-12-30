//
//  LoginModel.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct LoginStruct: Codable {
    let error: Bool
    let message: String
    let data: [EvaUser]?
}

struct EvaUser: Codable {
    
    let id: Int?
    let firebaseID: String?
    let firstName: String?
    let lastName: String?
    let isConnected: String?//IsConnected?
    let isReceiver: ReceiverID?
    let city, country, region: String?
    let connectionID: Int?
    let bioData: String?
    let about: String?
    let email, uniqueCode, username: String?
    let dateOfBirth: String?
    let verificationPin: Int?
    let userImage: String?
    let os, type: String?
    let createdByID: StringOrInt?
    let status: String?
    let isLinkedin: Int?
    let linkedinImageURL, address, facebookImageURL: String?
    let isFacebook, connectionCount: Int?
    let companyName, field: String?
    let designation: String?
    let workAviation, sector, token: String?
    let totalConnection, notificationCount: Int?
    let is_notifications: Int?
    var socialMedia: SocialMedia?
    var otherSector: String?
    var language,pendingConnection: String?
    let companyID: Int?
    let isPublic: Int?
    let employeesCount: Int?
    // let companyUrl: String
    let loginType: Int?
    let eventID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firebaseID = "firebase_id"
        case firstName = "first_name"
        case isConnected = "is_connected" 
        case isReceiver = "is_receiver"
        case city, country, region
        case connectionID //= "connection_id"
        case lastName = "last_name"
        case bioData = "bio_data"
        case about, email
        case uniqueCode = "unique_code"
        case username
        case dateOfBirth = "date_of_birth"
        case verificationPin = "verification_pin"
        case userImage = "user_image"
        case os, type, is_notifications
        case createdByID = "created_by_id"
        case status
        case isLinkedin = "is_linkedin"
        case linkedinImageURL = "linkedin_image_url"
        case address
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case connectionCount = "connection_count"
        case companyName = "company_name"
        case field, designation
        case workAviation = "work_aviation"
        case sector, token
        case totalConnection = "total_connection"
        case otherSector = "other_sector"
        case language = "language"
        case notificationCount = "notification_count"
        case isPublic = "is_public"
//        case companyUrl = "company_url"
        case employeesCount = "employees_count"
        case companyID = "company_id"
        case pendingConnection = "pending_connection"
        case loginType
        case eventID = "event_id"
    }
    
    var fullName: String {
        var title = ""
        title += firstName ?? ""
        if let lastName = lastName {
            //title += " " + String(lastName.first!)
            title += " " + String(lastName)
        }
        return title
    }
    
    var locationAddress: String {
        guard let city = city else {
            return ""
        }
        guard let country = country else {
            return ""
        }
        return city + "," + country
    }
    
    var isCompany: Bool { type == userType.company.rawValue }
    var isUser: Bool { type == userType.user.rawValue }
   
}

enum userType: String {
    case user = "user"
    case company = "company"
}

// MARK: - OtherUserDataModel
struct OtherUserDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [OtherUserData]?
}

// MARK: - Datum
struct OtherUserData: Codable {
    let id, firstName, lastName, email: String?
    let isConnected: IsConnected
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: StringOrInt?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook, connectionCount: Int?
    let companyName, workAviation, type: String?
    let totalConnection: Int?
    let otherSector, language, designation, loginStatus, connectionStatus: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case bioData = "bio_data"
        case uniqueCode = "unique_code"
        case dateOfBirth = "date_of_birth"
        case status
        case userImage = "user_image"
        case createdByID = "created_by_id"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case connectionCount = "connection_count"
        case companyName = "company_name"
        case workAviation = "work_aviation"
        case type
        case totalConnection = "total_connection"
        case otherSector = "other_sector"
        case language, designation
        case connectionStatus = "connection_status"
        case loginStatus = "login_status"
    }
}
