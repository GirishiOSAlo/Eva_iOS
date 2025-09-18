//
//  CompanyListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct ComapnyListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CompanyList]?
}

// MARK: - Datum
struct CompanyList: Codable {
    let id: Int?
    let firebaseID, fcmToken: String?
    let firstName: String?
    let lastName, username: String?
    let email: String?
    let linkedinURL: String?
    let telephoneNumber, emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic: String?
    let dateOfBirth, userImage: String?
    let gender: String?
    let phoneNumber, delegatePaEmail, countryCode, description: String?
    let sponsorTypeID: Int?
    let sponsorURL: String?
    let postcode, address, os: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin: String?
    let dateJoined: String?
    let modifiedDatetime, sort: String?
    let status: Int?
    let verificationPin, createdByID, modifiedByID: Int?
    let bioData: String?
    let companyName: String?
    let companyID, categoryID: Int?
    let logo: String?
    let companyURL: String?
    let designation: String?
    let field: String?
    let sectorID: Int?
    let otherSector, workAviation: String?
    let city, country: String?
    let region: String?
    let isFacebook: Int?
    let isLinkedin: Int?
    let facebookImageURL, linkedinImageURL: String?
    let isNotifications: Int?
    let lastOnlineDatetime: String?
    let isOnline: Bool?
    let language: String?
    let isPublic: Int?
    let userImageURL: String?
    let createdAt, updatedAt, deletedAt: String?
    let deviceToken, deviceType: String?
    let delegateJobTitle, delegateLinkedin, delegateURL: String?
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
