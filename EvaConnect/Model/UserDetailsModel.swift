//
//  UserDetailsModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 09/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct UserDetailsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [UserDetailsData]?
}

// MARK: - Datum
struct UserDetailsData: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let resumes: [Resume]?
    let dateOfArrival, timeOfArrival, location, flightNo: String?
    let transferDetails: String?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let loginStatus: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: Int?
    let connectionCount: Int?
    let companyName, workAviation, type: String?
    let totalConnection: Int?
    let pendingConnection, otherSector, region, language: String?
    let delegatePaName, delegatePaEmail: String?
    let isPublic, categoryID: Int?
    let designation: String?
    let companyID: Int?
    let categoryName: String?
    let sectorID: Int?
    let sectorName: String?
    let description: String?
    let companyURL, countryCode, phoneNumber: String?
    let linkedinURL: String?
    let connectionStatus, city: String?
    let followers, following: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case resumes
        case dateOfArrival = "date_of_arrival"
        case timeOfArrival = "time_of_arrival"
        case location
        case flightNo = "flight_no"
        case transferDetails = "transfer_details"
        case bioData = "bio_data"
        case uniqueCode = "unique_code"
        case dateOfBirth = "date_of_birth"
        case status
        case loginStatus = "login_status"
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
        case pendingConnection = "pending_connection"
        case otherSector = "other_sector"
        case region, language
        case delegatePaName = "delegate_pa_name"
        case delegatePaEmail = "delegate_pa_email"
        case isPublic = "is_public"
        case designation
        case companyID = "company_id"
        case categoryID = "category_id"
        case categoryName = "category_name"
        case sectorID = "sector_id"
        case sectorName = "sector_name"
        case description
        case companyURL = "company_url"
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
        case linkedinURL = "linkedin_url"
        case connectionStatus = "connection_status"
        case city, followers, following
    }
}

// MARK: - CategoryList
struct CategoryList: Codable {
    let id: Int?
    let categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "category_name"
    }
}

// MARK: - Companylist
struct Companylist: Codable {
    let id: Int?
    let companyName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
    }
}

//// MARK: - SectorList
//struct SectorList: Codable {
//    let id: Int?
//    let name: String?
//}

// MARK: - Resume
struct Resume: Codable {
    let id, userID: Int?
    let title, resumeFile, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title
        case resumeFile = "resume_file"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
