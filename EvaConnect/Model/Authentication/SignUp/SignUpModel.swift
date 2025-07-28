//
//  SignUpModel.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct SignUpModel: Codable {
    let error: Bool?
    let message: String?
    let data: SignupData?
}

// MARK: - DataClass
struct SignupData: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email, isConnected, isReceiver: String?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: String?
    let connectionCount: Int?
    let companyName, workAviation, type: String?
    let totalConnection: Int?
    let otherSector, language, token: String?
    
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
        case language, token
    }
}
