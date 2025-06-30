//
//  EventDelegateProfileDelegateList.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 02/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
class EventDelegateProfileDelegateListRes: Codable {
    let error: Bool?
    let message: String?
    let data: [EventDelegateProfileDelegateList]?
}

// MARK: - Datum
class EventDelegateProfileDelegateList: Codable {
    let id: Int?
    let firstName, lastName: String?
    let username: String?
    let email: String?
    let emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic: String?
    let dateOfBirth: String?
    let userImage, gender, phoneNumber, address: String?
    let os: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin: String?
    let dateJoined: String?
    let modifiedDatetime, sort: String?
    let status, verificationPin: Int?
    let createdByID: Int?
    let modifiedByID: Int?
    let bioData, companyName: String?
    let companyURL: String?
    let designation: String?
    let field: Int?
    let sectorID: Int?
    let otherSector: String?
    let workAviation: Int?
    let city, country: String?
    let region: String?
    let isFacebook, isLinkedin: Int?
    let facebookImageURL, linkedinImageURL: String?
    let isNotifications: Int?
    let lastOnlineDatetime: String?
    let isOnline: Bool?
    let language: String?
    let isPublic: Int?
    let userImageURL: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email
        case emailVerifiedAt = "email_verified_at"
        case isSuperuser = "is_superuser"
        case uniqueCode = "unique_code"
        case cnic
        case dateOfBirth = "date_of_birth"
        case userImage = "user_image"
        case gender
        case phoneNumber = "phone_number"
        case address, os, type
        case resetPasswordTokenGenerateDay = "reset_password_token_generate_day"
        case resetPasswordTokenExpiryDay = "reset_password_token_expiry_day"
        case isStaff = "is_staff"
        case isActive = "is_active"
        case isDefaultMenu = "is_default_menu"
        case lastLogin = "last_login"
        case dateJoined = "date_joined"
        case modifiedDatetime = "modified_datetime"
        case sort, status
        case verificationPin = "verification_pin"
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case bioData = "bio_data"
        case companyName = "company_name"
        case companyURL = "company_url"
        case designation, field
        case sectorID = "sector_id"
        case otherSector = "other_sector"
        case workAviation = "work_aviation"
        case city, country, region
        case isFacebook = "is_facebook"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case linkedinImageURL = "linkedin_image_url"
        case isNotifications = "is_notifications"
        case lastOnlineDatetime = "last_online_datetime"
        case isOnline = "is_online"
        case language
        case isPublic = "is_public"
        case userImageURL = "user_image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
