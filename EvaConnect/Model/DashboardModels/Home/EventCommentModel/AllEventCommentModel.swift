//
//  AllEventCommentModel.swift
//  EvaConnect
//
//  Created by Metis on 18/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllEventCommentModel: Codable {
    let error: Bool
    let message: String?
    let data: [EventCommentModel]?
}

// MARK: - Datum
struct EventCommentModel: Codable {
    let id, eventID: Int?
    let user: EventCommentUser?
    let createdDate, content: String?
    let createdByID: StringOrInt?
    let createdDatetime: String?
    let modifiedByID:Int?
    let modifiedDatetime: String?
    let os, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case user
        case createdDate = "created_date"
        case content
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}

// MARK: - User
struct EventCommentUser: Codable {
    let id: Int?
    let firstName,lastName: String?
    let isConnected, connectionID : Int?
    let isReceiver: ReceiverID?
    let bioData, email, uniqueCode, username: String?
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
