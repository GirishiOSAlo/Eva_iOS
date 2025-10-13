//
//  DashboardPostDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct DashboardPostDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [DashboardPostData]?
}

// MARK: - Datum
struct DashboardPostData: Codable {
//    let id, userID: Int?
//    let isURL: Bool?
//    let postVideo: String?
//    var isPostLike, isPostdisLike, isNewsLike, isNewsDislike: Int?
//    let createdDate, isConnected: String?
//    let connectionID: Int?
//    let isReceiver: String?
//    let content: String?
//    let title: String?
//    var postImage, commentCount, likeCount, createdByID: Int?
//    let createdDatetime: String?
//    let modifiedByID: Int?
//    let modifiedDatetime, os, status, documentFileName: String?
//    let documentSize, postDocument, fileDatetime: String?
//    let shareCount: Int?
//    let type: String?
//    let datumPostImage: [String]?
//    let image: String?
//    let newsSource: PostNewsSource?
//    let isNewsSave: Int?
//    let user: DashboardPostUser?
        
    let id, userID: Int?
    let isURL: Bool?
    let postVideo: String?
    var isPostLike, isPostdisLike, isNewsLike, isNewsDislike: Int?
    let newsImage, createdDate, isConnected: String?
    let connectionID: Int?
    let isReceiver: ReceiverID?
    let content, title: String?
    var postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, os, status, documentFileName: String?
    let documentSize, postDocument, fileDatetime: String?
    let shareCount: Int?
    let type: String?
    let datumPostImage: [String]?
    let postDocuments: [String]?
    let image: String?
    let newsSource: PostNewsSource?
    let isNewsSave: Int?
    let user: DashboardPostUser?
    var isExpand: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, userID, isURL
        case postVideo = "post_video"
        case isPostLike, isPostdisLike
        case isNewsLike = "is_news_like"
        case isNewsDislike = "is_news_dislike"
        case newsImage = "news_image"
        case createdDate, isConnected
        case connectionID = "connectionId"
        case isReceiver, content, title, postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, os, status
        case documentFileName = "document_file_name"
        case documentSize = "document_size"
        case postDocument = "post_document"
        case fileDatetime = "file_datetime"
        case shareCount, type
        case datumPostImage = "post_image"
        case postDocuments = "post_documents"
        case image
        case newsSource = "news_source"
        case isNewsSave, user
    }
}

struct PostNewsSource: Codable {
    let id: Int?
    let name, status, image, url: String?
}

// MARK: - User
struct DashboardPostUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: String?
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
