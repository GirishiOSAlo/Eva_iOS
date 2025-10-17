//
//  ResponseModel.swift
//  EvaConnect
//
//  Created by Pranay Barua on 10/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

//struct ResponseModel: Codable {
//    let error: Bool?
//    let message: String?
//    let data: DataClass?
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let firstName, email, phoneNumber, countryCode: String?
//    let isLinkedin: Int?
//    let linkedinURL: String?
//    let type, sectorID: Int?
//    let companyName, companyURL: String?
//    let categoryID, companyID, designation, region: String?
//    let language, userImage, userImageURL: String?
//    let status: Int?
//    let dateJoined: String?
//    let bioData: String?
//    let id: Int?
//    let token: String?
//
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case email
//        case phoneNumber = "phone_number"
//        case countryCode = "country_code"
//        case isLinkedin = "is_linkedin"
//        case linkedinURL = "linkedin_url"
//        case type
//        case companyName = "company_name"
//        case companyURL = "company_url"
//        case sectorID = "sector_id"
//        case categoryID = "category_id"
//        case companyID = "company_id"
//        case designation, region, language
//        case userImage = "user_image"
//        case userImageURL = "user_image_url"
//        case status
//        case dateJoined = "date_joined"
//        case bioData = "bio_data"
//        case id, token
//    }
//}

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let error: Bool?
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: StringOrInt?
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
