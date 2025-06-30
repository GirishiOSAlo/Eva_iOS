//
//  PendingListModel.swift
//  EvaConnect
//
//  Created by Pranay Barua on 12/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - PendingListModel
struct PendingListModel: Codable {
    let error: Bool?
    let message: String?
    let data: [PendingData]?
}

// MARK: - Datum
struct PendingData: Codable {
    let id, modifiedByID: Int?
    let os: String?
    let receiverID: Int?
    let receiver: Receiver?
    let senderID: Int?
    let sender: Receiver?
    let status, isConnected, modifiedDatetime, createdDatetime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case modifiedByID = "modified_by_id"
        case os
        case receiverID = "receiver_id"
        case receiver
        case senderID = "sender_id"
        case sender, status
        case isConnected = "is_connected"
        case modifiedDatetime = "modified_datetime"
        case createdDatetime = "created_datetime"
    }
}

// MARK: - Receiver
struct Receiver: Codable {
    let id: Int?
    let firstName, lastName: String?
    let address: String?
    let bioData: String?
    let city: String?
    let companyName: String?
    let companyURL, connectionCount: String?
    let connectionID: Int?
    let country: String?
    let createdByID: String?
    let dateOfBirth, designation: String?
    let email: String?
    let facebookImageURL, field, isConnected: String?
    let isFacebook, isLinkedin, isNotifications: Int?
    let isReceiver: String?
    let language: String?
    let linkedinImageURL, os, otherSector: String?
    let sector: Sector?
    let status, type: String?
    let uniqueCode: String?
    let userImage: String?
    let username: String?
    let verificationPin: Int?
    let workAviation: Int?
    let isOnline: Bool?
    let lastOnlineDatetime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case address
        case bioData = "bio_data"
        case city
        case companyName = "company_name"
        case companyURL = "company_url"
        case connectionCount = "connection_count"
        case connectionID = "connection_id"
        case country
        case createdByID = "created_by_id"
        case dateOfBirth = "date_of_birth"
        case designation, email
        case facebookImageURL = "facebook_image_url"
        case field
        case isConnected = "is_connected"
        case isFacebook = "is_facebook"
        case isLinkedin = "is_linkedin"
        case isNotifications = "is_notifications"
        case isReceiver = "is_receiver"
        case language
        case linkedinImageURL = "linkedin_image_url"
        case os
        case otherSector = "other_sector"
        case sector, status, type
        case uniqueCode = "unique_code"
        case userImage = "user_image"
        case username
        case verificationPin = "verification_pin"
        case workAviation = "work_aviation"
        case isOnline = "is_online"
        case lastOnlineDatetime = "last_online_datetime"
    }
}

// MARK: - Sector
struct Sector: Codable {
    let id: Int?
    let name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
