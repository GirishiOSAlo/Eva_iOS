//
//  CommonEvent.swift
//  EvaConnect
//
//  Created by Pranay Barua on 19/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//
import Foundation

// MARK: - CommonEventModel
struct CommonEventModel: Codable {
    let error: Bool?
    let message: String?
    let data: CommonEventClass?
}

// MARK: - CommonEventClass
struct CommonEventClass: Codable {
    let currentPage: Int?
    let data: [CommonEventMetaData]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct CommonEventMetaData: Codable {
    let id: Int?
    let firebaseID: String?
    let fcmToken: String?
    let firstName: String?
    let lastName, username: String?
    let email: String?
    let linkedinURL: String?
    let telephoneNumber: String?
    let emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic, dateOfBirth: String?
    let userImage: String?
    let gender, phoneNumber, delegatePaEmail, countryCode: String?
    let description, sponsorTypeID, sponsorURL, postcode: String?
    let address, os: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin: String?
    let dateJoined: String?
    let modifiedDatetime, sort: String?
    let status, verificationPin: Int?
    let createdByID, modifiedByID: StringOrInt?
    let bioData, companyName: String?
    let companyID, categoryID: Int?
    let logo, companyURL: String?
    let designation, field: String?
    let sectorID: Int?
    let speakerID: Int?
    let otherSector: String?
    let workAviation: Int?
    let city: String?
    let country, region: String?
    let location: String?
    let isFacebook, isLinkedin: Int?
    let facebookImageURL, linkedinImageURL: String?
    let isNotifications: Int?
    let lastOnlineDatetime: String?
    let isOnline: Bool?
    let language: String?
    let isPublic: Int?
    let userImageURL: String?
    let createdAt, updatedAt, deletedAt, deviceToken: String?
    let deviceType: String?
    let delegateJobTitle, delegateLinkedin, delegateURL, delegatePaName: String?
    
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
        case speakerID = "speaker_id"
        case logo
        case companyURL = "company_url"
        case designation, field
        case sectorID = "sector_id"
        case otherSector = "other_sector"
        case workAviation = "work_aviation"
        case city, country, region, location
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

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
