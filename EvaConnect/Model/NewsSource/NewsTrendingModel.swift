//
//  NewsTrendingModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 03/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NewsTrendingModel: Codable {
    let error: Bool?
    let message: String?
    let data: [NewsTrendingList]?
}

// MARK: - Datum
struct NewsTrendingList: Codable {
    let id: Int?
    let userID, isURL: String?
    let postVideo: String?
    let isPostLike, isPostdisLike, isNewsLike, isNewsDislike: Int?
    let createdDate, isConnected: String?
    let connectionID: Int?
    let isReceiver: ReceiverID?
    let content, title: String?
    let postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, os, status, documentFileName: String?
    let documentSize, postDocument, fileDatetime: String?
    let shareCount: Int?
    let type: String?
    let datumPostImage: [String]?
    let image: String?
    let newsSource: TrendingNewsSource?
    let isNewsSave: Int?
    let evaNewsCategory: [TrendingEvaNewsCategory]?
    let user: TrendingNewsUser?
    
    enum CodingKeys: String, CodingKey {
        case id, userID, isURL
        case postVideo = "post_video"
        case isPostLike, isPostdisLike
        case isNewsLike = "is_news_like"
        case isNewsDislike = "is_news_dislike"
        case createdDate, isConnected
        case connectionID = "connectionId"
        case isReceiver, content, title, postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, os, status
        case documentFileName = "document_file_name"
        case documentSize = "document_size"
        case postDocument = "post_document"
        case fileDatetime = "file_datetime"
        case shareCount, type
        case datumPostImage = "post_image"
        case image
        case newsSource = "news_source"
        case isNewsSave
        case evaNewsCategory = "eva_news_category"
        case user
    }
}

// MARK: - EvaNewsCategory
struct TrendingEvaNewsCategory: Codable {
    let id: Int?
    let createdDatetime, modifiedDatetime: String?
    let status: Int?
    let os: String?
    let name: String?
    let createdByID: StringOrInt?
    let modifiedByID: Int?
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

// MARK: - NewsSource
struct TrendingNewsSource: Codable {
    let id: Int?
    let name, status: String?
    let image: String?
    let url: String?
}

// MARK: - User
struct TrendingNewsUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: StringOrInt?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: Int?
    let companyName, workAviation, type, otherSector: String?
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
