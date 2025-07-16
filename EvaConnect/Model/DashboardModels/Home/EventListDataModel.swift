//
//  EventListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 16/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EventListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [EventListData]?
}

// MARK: - Datum
struct EventListData: Codable {
    let id, userID: Int?
    let isURL, postVideo: String?
    let isPostLike, isEventLike, isNewsLike: Int?
    let createdDate: String?
    let isConnected: String?
    let connectionID: Int?
    let isReceiver, content, title: String?
    let isPrivate: Int?
    let datumCreatedDatetime, datumModifiedDatetime: String?
    let country: String?
    let city, address, featuredImage: String?
    let isJoined: Int?
    let attendeesstatus: String?
    let endDate: String?
    let savedEventPassed: Bool?
    let startTime, endTime, name, startDate: String?
    let registrationLink: String?
    let agenda: Int?
    let eventEndDatetime, eventStartDatetime: String?
    let postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, os: String?
    let status: Status?
    let postDocument: String?
    let shareCount: Int?
    let type: String?
    let datumPostImage: [String]?
    let image: String?
    let newsSource: NewsSource?
    let isNewsSave: Int?
    let tempImage, tempImageUser: String?
    let user: EventUser?

    enum CodingKeys: String, CodingKey {
        case id, userID, isURL, postVideo, isPostLike, isEventLike
        case isNewsLike = "is_news_like"
        case createdDate, isConnected
        case connectionID = "connectionId"
        case isReceiver, content, title
        case isPrivate = "is_private"
        case datumCreatedDatetime = "created_datetime"
        case datumModifiedDatetime = "modified_datetime"
        case country, city, address
        case featuredImage = "featured_image"
        case isJoined = "is_joined"
        case attendeesstatus
        case endDate = "end_date"
        case savedEventPassed = "saved_event_passed"
        case startTime = "start_time"
        case endTime = "end_time"
        case name
        case startDate = "start_date"
        case registrationLink = "registration_link"
        case agenda
        case eventEndDatetime = "event_end_datetime"
        case eventStartDatetime = "event_start_datetime"
        case postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, os, status, postDocument, shareCount, type
        case datumPostImage = "post_image"
        case image
        case newsSource = "news_source"
        case isNewsSave
        case tempImage = "temp_image"
        case tempImageUser = "temp_image_user"
        case user
    }
}

// MARK: - User
struct EventUser: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let isConnected: String?
    let isReceiver: String?
    let connectionID: Int?
    let bioData: String?
    let uniqueCode: String?
    let dateOfBirth: String?
    let status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: Int?
    let companyName: String?
    let workAviation: String?
    let type: String?
    let otherSector: String?
    let language: String?

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
        case companyName = "company_name"
        case workAviation = "work_aviation"
        case type
        case otherSector = "other_sector"
        case language
    }
}

