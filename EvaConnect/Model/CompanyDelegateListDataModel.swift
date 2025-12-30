//
//  CompanyDelegateListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 30/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//CompanyDelegateListDataModel

// MARK: - Welcome
struct CompanyDelegateListDataModel: Codable {
    let success: Bool?
    let message, eventID, eventName: String?
    let search: String?
    let totalCompanies, totalDelegates: Int?
    let data: CompanyListData?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case eventID = "event_id"
        case eventName = "event_name"
        case search
        case totalCompanies = "total_companies"
        case totalDelegates = "total_delegates"
        case data
    }
}

// MARK: - DataClass
struct CompanyListData: Codable {
    let companies: [EventCompanyList]?
    let loginUser: String?
    
    enum CodingKeys: String, CodingKey {
        case companies
        case loginUser = "login_user"
    }
}

// MARK: - Company
struct EventCompanyList: Codable {
    let companyName: String?
    let delegates: [CompanyDelegate]?
    
    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case delegates
    }
}

// MARK: - Delegate
struct CompanyDelegate: Codable {
    let id: Int?
    let firebaseID: String?
    let fcmToken: String?
    let firstName: String?
    let lastName, username: String?
    let email: String?
    let linkedinURL: String?
    let telephoneNumber, emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic: String?
    let dateOfBirth: String?
    let userImage: String?
    let gender: String?
    let phoneNumber: String?
    let delegatePaEmail: String?
    let countryCode: String?
    let description, sponsorTypeID, sponsorURL, postcode: String?
    let address, os: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin: String?
    let dateJoined: String?
    let modifiedDatetime, sort: String?
    let status: Int?
    let verificationPin: Int?
    let createdByID, modifiedByID: String?
    let bioData: String?
    let companyName: String?
    let companyID, categoryID: Int?
    let logo, companyURL: String?
    let designation: String?
    let field: String?
    let sectorID: Int?
    let otherSector, workAviation, city, country: String?
    let region: String?
    let isFacebook: String?
    let isLinkedin: Int?
    let facebookImageURL, linkedinImageURL: String?
    let isNotifications: Int?
    let lastOnlineDatetime: String?
    let isOnline: Bool?
    let language: String?
    let isPublic: Int?
    let userImageURL: String?
    let createdAt, updatedAt, deletedAt, deviceToken: String?
    let deviceType, delegateJobTitle, delegateLinkedin, delegateURL: String?
    let delegatePaName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firebaseID = "firebase_id"
        case fcmToken = "fcm_token"
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email
        case linkedinURL = "linkedin_url"
        case telephoneNumber = "telephone_number"
        case emailVerifiedAt = "email_verified_at"
        case isSuperuser = "is_superuser"
        case uniqueCode = "unique_code"
        case cnic
        case dateOfBirth = "date_of_birth"
        case userImage = "user_image"
        case gender
        case phoneNumber = "phone_number"
        case delegatePaEmail = "delegate_pa_email"
        case countryCode = "country_code"
        case description
        case sponsorTypeID = "sponsor_type_id"
        case sponsorURL = "sponsor_url"
        case postcode, address, os, type
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
        case companyID = "company_id"
        case categoryID = "category_id"
        case logo
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
        case deletedAt = "deleted_at"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case delegateJobTitle = "delegate_job_title"
        case delegateLinkedin = "delegate_linkedin"
        case delegateURL = "delegate_url"
        case delegatePaName = "delegate_pa_name"
    }
}


