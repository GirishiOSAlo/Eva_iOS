//
//  NewsDetail.swift
//  EvaConnect
//
//  Created by Metis on 05/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - MeetingDetailRoot
struct NewsDetailRoot: Codable {
    let error: Bool?
    let message: String?
    let data: [NewsDetail]?
}
// MARK: - Datum
struct NewsDetail: Codable {
    let id: Int?
    let newsSource: HomeNewsSource?
    let title, summary, author, published: String
    let link: String?
    let image: String?
    let content: String?
    let commentCount, isNewsLike, likeCount: Int?
    let createdByID: StringOrInt?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime: String?
    let type, status: String?
    let shareCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case newsSource = "news_source"
        case title, summary, author, published, link, image, content
        case commentCount = "comment_count"
        case isNewsLike = "is_news_like"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case shareCount = "share_count"
        case type, status
    }
}

// MARK: - NewsDetailsDataModel
struct NewsDetailsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [NewsDetailData]?
}

struct NewsDetailData: Codable {
    let id, categoryID : Int?
    let title, content: String?
    let href: String?
    let newsSource: String?
    let newsTags: [NewsTag]?
    let sourceImage, newsImage: String?
    let published, relativeTime: String?
    let likesCount, commentsCount, sharesCount, isNewsSave: Int?
    let isNewsLike, isNewsdisLike: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, href
        case categoryID = "category_id"
        case newsSource = "news_source"
        case newsTags = "news_tags"
        case sourceImage = "source_image"
        case newsImage = "news_image"
        case published
        case relativeTime = "relative_time"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case sharesCount = "shares_count"
        case isNewsSave, isNewsLike, isNewsdisLike
    }
}

struct NewsTag: Codable {
    let id: Int?
    let name: String?
}


// MARK: - RelatedNewsDataModel
struct RelatedNewsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [RelatedNewsData]?
}

// MARK: - Datum
struct RelatedNewsData: Codable {
    let id: Int?
    let userID, isURL: String?
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
    let documentSize, postDocument, fileDatetime: String?
    let shareCount: Int?
    let type: String?
    let datumPostImage: [String]?
    let image: String?
    let newsSource: RelatedNewsSource?
    let isNewsSave: Int?
    let evaNewsCategory: [EvaNewsCategory]?
//    let user: User?

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
        case isNewsSave
        case evaNewsCategory = "eva_news_category"
//        case user
    }
}

// MARK: - NewsSource
struct RelatedNewsSource: Codable {
    let id: Int?
    let name, status: String?
    let image: String?
    let url: String?
}

// MARK: - User
//struct User: Codable {
//    let id: Int?
//    let firstName, lastName, email, isConnected: String?
//    let isReceiver: String?
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

