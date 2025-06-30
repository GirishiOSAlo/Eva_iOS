////
////  NewsCommentModel.swift
////  EvaConnect
////
////  Created by Girish Bhuva on 05/06/25.
////  Copyright © 2025 HyperNym. All rights reserved.
////
//
//import Foundation
//
//// MARK: - Welcome
//struct NewsCommentModel: Codable {
//    let error: Bool?
//    let message: String?
//    let data: [Comment]?
//}
//
//// MARK: - Datum
//struct Comment: Codable {
//    let id, rssNewsID: Int?
//    let content: String?
//    let status: Status?
//    let createdDate, createdDatetime: String?
//    let createdByID: Int?
//    let commentID: Int?
//    let isCommentLike, isCommentDisLike, likeCount: Int?
//    let user: NewsCommentUser?
//    let replies: [CommentReplies]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case rssNewsID = "rss_news_id"
//        case content, status
//        case createdDate = "created_date"
//        case createdDatetime = "created_datetime"
//        case createdByID = "created_by_id"
//        case commentID = "comment_id"
//        case isCommentLike, isCommentDisLike, likeCount, user, replies
//    }
//}
//
//// MARK: - Datum
//struct CommentReplies: Codable {
//    let id, rssNewsID: Int?
//    let content: String?
//    let status: Status?
//    let createdDate, createdDatetime: String?
//    let createdByID: Int?
//    let commentID: Int?
//    let isCommentLike, isCommentDisLike, likeCount: Int?
//    let user: NewsCommentUser?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case rssNewsID = "rss_news_id"
//        case content, status
//        case createdDate = "created_date"
//        case createdDatetime = "created_datetime"
//        case createdByID = "created_by_id"
//        case commentID = "comment_id"
//        case isCommentLike, isCommentDisLike, likeCount, user
//    }
//}
//
//// MARK: - User
//struct NewsCommentUser: Codable {
//    let id: Int?
//    let firstName: String?
//    let lastName: String?
//    let userImage: String?
//    let bioData: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case userImage = "user_image"
//        case bioData = "bio_data"
//    }
//}
