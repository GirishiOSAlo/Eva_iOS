//
//  Reactions.swift
//  EvaConnect
//
//  Created by Pranay Barua on 26/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation

// MARK: - ReactionsDataModel
struct ReactionsDataModel: Codable {
//    let error: Bool?
//    let message: String?
//    let data: [ReactionData]?
//}
//
//// MARK: - Datum
//struct ReactionData: Codable {
//    let id, userID: Int?
//    let isURL: Bool?
//    let postVideo: String?
//    let isPostLike, isNewsLike: Int?
//    let createdDate, isConnected: String?
//    let connectionID: Int?
//    let isReceiver, content, title: String?
//    let postImage, commentCount, likeCount, createdByID: Int?
//    let createdDatetime: String?
//    let modifiedByID: Int?
//    let modifiedDatetime, os, status, documentFileName: String?
//    let postDocument: String?
//    let fileDatetime: String?
//    let shareCount: Int?
//    let type: String?
//    let datumPostImage: [String]?
//    let image: String?
//    let newsSource: ReactionNewsSource?
//    let isNewsSave: Int?
//    let user: ReactionUser?
//    let postLike, postComments, postCommentLike: [Post]?
//    let documentSize: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, userID, isURL
//        case postVideo = "post_video"
//        case isPostLike
//        case isNewsLike = "is_news_like"
//        case createdDate, isConnected
//        case connectionID = "connectionId"
//        case isReceiver, content, title, postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, os, status
//        case documentFileName = "document_file_name"
//        case postDocument = "post_document"
//        case fileDatetime = "file_datetime"
//        case shareCount, type
//        case datumPostImage = "post_image"
//        case image
//        case newsSource = "news_source"
//        case isNewsSave, user
//        case postLike = "post_like"
//        case postComments = "post_comments"
//        case postCommentLike = "post_comment_like"
//        case documentSize = "document_size"
//    }
//}
//
//// MARK: - NewsSource
//struct ReactionNewsSource: Codable {
//    let id: Int?
//    let name, status, image, url: String?
//}
//
//// MARK: - Post
//struct Post: Codable {
//    let id: Int?
//    let createdDatetime, modifiedDatetime: String?
//    let status: Int?
//    let os: String?
//    let createdDate: String?
//    let createdByID, modifiedByID, postID, commentID: Int?
//    let userdetails: Userdetails?
//    let action, content: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdDatetime = "created_datetime"
//        case modifiedDatetime = "modified_datetime"
//        case status, os
//        case createdDate = "created_date"
//        case createdByID = "created_by_id"
//        case modifiedByID = "modified_by_id"
//        case postID = "post_id"
//        case commentID = "comment_id"
//        case userdetails, action, content
//    }
//}
//
//// MARK: - Userdetails
//struct Userdetails: Codable {
//    let id: Int?
//    let firstName: String?
//    let lastName: String?
//    let userImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case userImage = "user_image"
//    }
//}
//
//// MARK: - User
//struct ReactionUser: Codable {
//    let id: Int?
//    let firstName: String?
//    let lastName: String?
//    let email, isConnected, isReceiver: String?
//    let connectionID: Int?
//    let bioData, uniqueCode, dateOfBirth, status: String?
//    let userImage, createdByID: String?
//    let isLinkedin: Int?
//    let facebookImageURL: String?
//    let isFacebook: Int?
//    let companyName, workAviation, type, otherSector: String?
//    let language: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email
//        case isConnected = "is_connected"
//        case isReceiver = "is_receiver"
//        case connectionID = "connection_id"
//        case bioData = "bio_data"
//        case uniqueCode = "unique_code"
//        case dateOfBirth = "date_of_birth"
//        case status
//        case userImage = "user_image"
//        case createdByID = "created_by_id"
//        case isLinkedin = "is_linkedin"
//        case facebookImageURL = "facebook_image_url"
//        case isFacebook = "is_facebook"
//        case companyName = "company_name"
//        case workAviation = "work_aviation"
//        case type
//        case otherSector = "other_sector"
//        case language
//    }
//}

    let error: Bool?
    let message: String?
    let data: [ReactionData]?
}

// MARK: - Datum
struct ReactionData: Codable {
    let id, userID: Int?
    let isURL: Bool?
    let postVideo: String?
    let isPostLike, isNewsLike: Int?
    let createdDate, isConnected: String?
    let connectionID: Int?
    let isReceiver: ReceiverID?
    let content: String?
    let title: String?
    let postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, os, status, documentFileName: String?
    let documentSize: String?
    let postDocument: String?
    let fileDatetime: String?
    let shareCount: Int?
    let type: String?
    let datumPostImage: [String]?
    let image: String?
    let newsSource: ReactionNewsSource?
    let isNewsSave: Int?
    let user: ReactionUser?
    let postLike, postComments, postCommentLike: [Post]?

    enum CodingKeys: String, CodingKey {
        case id, userID, isURL
        case postVideo = "post_video"
        case isPostLike
        case isNewsLike = "is_news_like"
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
        case isNewsSave, user
        case postLike = "post_like"
        case postComments = "post_comments"
        case postCommentLike = "post_comment_like"
    }
}

// MARK: - NewsSource
struct ReactionNewsSource: Codable {
    let id: Int?
    let name, status, image, url: String?
}

// MARK: - Post
struct Post: Codable {
    let id: Int?
    let createdDatetime, modifiedDatetime: String?
    let status: Int?
    let os: String?
    let createdDate: String?
    let createdByID, modifiedByID, postID, commentID: Int?
    let userdetails: Userdetails?
    let action, content: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case status, os
        case createdDate = "created_date"
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case postID = "post_id"
        case commentID = "comment_id"
        case userdetails, action, content
    }
}

// MARK: - Userdetails
struct Userdetails: Codable {
    let id: Int?
    let firstName, lastName: String?
    let userImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
    }
}

// MARK: - User
struct ReactionUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID: Int?
    let bioData, uniqueCode, dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
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
