//
//  UserDetails.swift
//  EvaConnect
//
//  Created by Pranay Barua on 19/10/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation

// MARK: - UserDetailsModel
struct UserDetailsModel: Codable {
    let error: Bool?
    let message: String?
    let data: [UserData]
}

// MARK: - Datum
struct UserData: Codable {
    let id: Int?
        let firstName, lastName, email, isConnected: String?
        let isReceiver, connectionID: Int?
        let bioData, uniqueCode, dateOfBirth, status: String?
        let userImage, createdByID: String?
        let isLinkedin: Int?
        let facebookImageURL: String?
        let isFacebook, connectionCount: Int?
        let companyName, workAviation, type: String?
        let totalConnection: Int?
        let otherSector, language: String?

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
        case language
    }
}
