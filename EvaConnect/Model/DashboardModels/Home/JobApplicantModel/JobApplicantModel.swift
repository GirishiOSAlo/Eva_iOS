//
//  JobApplicantModel.swift
//  EvaConnect
//
//  Created by Metis on 05/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct JobApplicantsRoot: Codable {
    let error: Bool
    let message: String
    let data: [JobApplicant]
}

// MARK: - Datum
struct JobApplicant: Codable {
    let id, jobID: Int
    let user: User?
    let userID: Int?
    let content: String?
    let applicationAttachment: String?
    let createdByID: StringOrInt?
    let createdDatetime, os, status: String?
    let isHidden : Int?
    enum CodingKeys: String, CodingKey {
        case id
        case isHidden = "is_hidden"
        case jobID = "job_id"
        case user
        case userID = "user_id"
        case content
        case applicationAttachment = "application_attachment"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case os, status
    }
}

// MARK: - User
struct applicantUser: Codable {
    let id: Int?
    let firstName: String?
    let isConnected, connectionID, lastName: String?
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
