//
//  AllHomePost.swift
//  EvaConnect
//
//  Created by Metis on 14/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct DashboardItemRoot: Codable {
    let error: Bool?
    let message: String?
    let data: [DashboardItem]?
}

//// MARK: - DashboardItem
//struct DashboardItem: Codable {
//    var id: Int
//    var userID, agenda: Int?
//    var user: EvaUser?
//    var jobTitle, jobDescription, registrationLink: String?
//    var jobNature: String?
//    var jobtype : TypeJobEnum?
//    var jobSector: String?
//    var position, weeklyHours, location: String?
//    var salary: Int?
//    var content, listingDuration: String?
//    var jobImage: String?
//    let attendees: Int?
//    var commentCount: Int?
//    var applicantCount: Int?
//    var isJobLike: Int?
//    var isApplied: Int?
//    var likeCount, createdByID: Int?
//    var createdDatetime: String?
//    var modifiedByID: Int?
//    var modifiedDatetime: String?
//    var type: TypePostEnum?
//    var os: String?
//    var status: String?
//    var isURL: Bool?
//    var postVideo: String?
//    var isConnected: String?//IsConnected?
//    var connectionId:Int?
//    var isReceiver: Bool?
//    var isPostLike: Int?
//    var createdDate: String?
//    var postImage: [String?]?
//    var connectionID: Int?
//    var eventName, eventCity, eventCountry ,eventAddress, eventStartDate, eventEndDate: String?
//    var isEventLike: Int?
//    var eventImage: [String?]?
//    var newsSource: HomeNewsSource?
//    var title, summary, author, published: String?
//    var link: String?
//    var image: String?
//    var isNewsLike: Int?
//    var isNewsSave: Int?
//    var isPrivate: Int?
//    var postDocument: String?
//    var activeHours: Int?
//    let connectionCount: Int?
//    let shareCount: Int?
//    let startTime: String?
//    let endTime: String?
//    var isAttending: String?
//    let saved: Int?
//    let tempImage: String?
//    let tempImageUser: String?
//    let applicationsCount: String?
////    let image: String?
//    let value: String?
//    let evaNewsCategory: [EvaNewsCategory]?
//    let documentFileName: String?
//    let documentSize: String?
//    let interestedUsersCount: String?
//    let interestedUsers: [UserConnection]?
//    let savedEventPassed: Bool?
//    let eventAttendeesStatus: String?
//    
//
//    enum CodingKeys: String, CodingKey {
//        case id, isNewsSave, saved, value, agenda
//        case applicationsCount = "applications_count"
//        case userID = "user_id"
//        case user, attendees
//        case eventAttendeesStatus = "attendeesstatus"
//        case jobtype //= "job_type"
//        case isPrivate = "is_private"
//        case shareCount //= "share_count"
//        case connectionId
//        case isNewsLike = "is_news_like"
//        case jobTitle //= "job_title"
//        case jobNature = "job_nature"
//        case jobSector //= "job_sector"
//        case jobDescription = "job_description"
//        case registrationLink = "registration_link"
//        case listingDuration = "listing_duration"
//        case position
//        case eventAddress = "address"
//        case newsSource = "news_source"
//        case title, summary, author, published, link, image
//        case weeklyHours = "weekly_hours"
//        case location, salary, content
//        case jobImage = "job_image"
//        case commentCount //= "comment_count"
//        case applicantCount = "applicant_count"
//        case isJobLike = "is_job_like"
//        case isApplied //= "is_applied"
//        case likeCount //= "like_count"
//        case createdByID //= "created_by_id"
//        case createdDatetime// = "created_datetime"
//        case modifiedByID //= "modified_by_id"
//        case modifiedDatetime = "modified_datetime"
//        case type, os, status
//        case isURL //= "is_url"
//        case postVideo = "post_video"
//        case isConnected //= "is_connected"
//        case isReceiver = "is_receiver"
//        case isPostLike //= "is_post_like"
//        case createdDate //= "created_date"
//        case postImage = "post_image"
//        case connectionID = "connection_id"
//        case eventName = "name"
//        case eventCity = "city"
//        case eventCountry = "country"
//        case eventStartDate = "event_start_datetime" //"start_date"
//        case eventEndDate = "event_end_datetime" //"end_date"
//        case isEventLike //= "is_event_like"
//        case eventImage = "event_image"
//        case postDocument = "post_document"
//        case activeHours = "active_hours"
//        case connectionCount = "connection_count"
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case isAttending = "is_attending"
//        case tempImage = "temp_image"
//        case tempImageUser = "temp_image_user"
//        case evaNewsCategory = "eva_news_category"
//        case documentFileName = "document_file_name"
//        case documentSize = "post_document_size"
//        case interestedUsersCount = "interested_users_count"
//        case interestedUsers = "interested_users"
//        case savedEventPassed = "saved_event_passed"
//    }
//    
//    var dateTime: (date: String, time: String) {
//        if let (date, time) = createdDatetime?.dateTime(isUTC: true) {
//            return (date, time)
//        }
//        return ("", "")
//    }
//    
//    enum AttendeeStatus: String, Codable {
//        case requestToJoin = "Request_To_Join"
//        case accepted = "accepted"
//        case decline = "Decline"
//    }
//}
// MARK: - Datum
struct DashboardItem: Codable {
    let id, userID: Int?
    let isURL: Bool?
    let postVideo: String?
    var isPostLike, isPostdisLike: Int?
    let createdDate, isConnected: String?
    let connectionID: Int?
    let isReceiver: ReceiverID?
    let content: String?
    var postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime: String?
    let os: String?
    let status, postDocument: String?
    let shareCount: Int?
    let type: TypePostEnum?
    let datumPostImage: [String]?
    let postDocuments: [String]?
    let user: EvaUser?
    
    let isNewsLike, isNewsDislike: Int?
    let newsImage, title: String?
    let documentFileName, documentSize, fileDatetime: String?
    let image: String?
    let newsSource: HomeNewsSource?
    let isNewsSave: Int?
    let evaNewsCategory: [EvaNewsCategory]?

    enum CodingKeys: String, CodingKey {
        case id, userID, isURL, postVideo, isPostLike, isPostdisLike, createdDate, isConnected
        case connectionID = "connectionId"
        case isReceiver, content, postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, os, status, postDocument, shareCount, type
        case datumPostImage = "post_image"
        case postDocuments = "post_documents"
        case user
        
        case isNewsLike = "is_news_like"
        case isNewsDislike = "is_news_dislike"
        case newsImage = "news_image"
        case title
        case documentFileName = "document_file_name"
        case documentSize = "document_size"
        case fileDatetime = "file_datetime"
        case image
        case newsSource = "news_source"
        case isNewsSave
        case evaNewsCategory = "eva_news_category"
    }
}




// MARK: - NewsSource
struct HomeNewsSource: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let status: String?
    let url: String?
}

enum TypeJobEnum: String, Codable {
    case evening = "Evening"
    case fullTime = "Full Time"
    case morning = "Morning"
    case nights = "Nights"
    case partTime = "Part Time"
    case termTime = "Term Time"
    case weekends = "Weekends"
}

enum TypePostEnum: String, Codable {
    case event = "event"
    case job = "job"
    case post = "post"
    case news = "news"
    case meet = "meeting"
    case eventPassed = "eventPassed"
}
// MARK: - User
struct HomeUser: Codable {
    
    let id: Int?
    let userImage: String?
    let totalConnection: Int?
    let firstName: String?
    let lastName: String?
    let bioData: String?
    let address: String?
    let companyName: String?
    let field: String?
    let designation: String?
    let isLinkedin: Int?
    let linkedinImageURL: String?
    let facebookImageURL: String?
    let isFacebook: Int?
    let workAviation, sector, city, country: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userImage = "user_image"
        case totalConnection = "total_connection"
        case firstName = "first_name"
        case lastName = "last_name"
        case bioData = "bio_data"
        case address
        case companyName = "company_name"
        case field, designation
        case isLinkedin = "is_linkedin"
        case linkedinImageURL = "linkedin_image_url"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case workAviation = "work_aviation"
        case sector, city, country
    }
}

// MARK: - EvaNewsCategory
struct EvaNewsCategory: Codable {
    let id: Int?
    let createdDatetime, modifiedDatetime: String?
    let status: Int?
    let os: String?
    let name: String?
    let createdByID, modifiedByID: Int?
    let image, imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case status, os, name
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case image
        case imageURL = "image_url"
    }
}

// MARK: - InterestedUser
struct InterestedUser: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let username: String?
    let email: String?
    let emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic: String?
    let dateOfBirth: String?
    let userImage: String?
    let gender, phoneNumber, address, os: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin: String?
    let dateJoined: String?
    let modifiedDatetime, sort: String?
    let status: Int?
    let verificationPin: Int?
    let createdByID: String?
    let modifiedByID: Int?
    let bioData: BioData?
    let companyName: String?
    let companyURL: String?
    let designation: String?
    let field: String?
    let sectorID: Int?
    let otherSector: String?
    let workAviation: Int?
    let city: String?
    let country: String?
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


extension DashboardItem {
    var totalConnection: Int? { user?.totalConnection ?? user?.connectionCount }
}
