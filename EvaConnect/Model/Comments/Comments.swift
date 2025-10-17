//
//  Comments.swift
//  EvaConnect
//
//  Created by Pranay Barua on 04/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - ProfileModel
struct CommentsModel: Codable {
    let error: Bool?
    let message: String?
    let data: [Comment]?
}

// MARK: - Datum
struct Comment: Codable {
    let id, rssNewsID: Int?
    let content, status, createdDate, createdDatetime: String?
    let createdByID: StringOrInt?
    let commentID: Int?
    let isCommentLike, isCommentDisLike, likeCount, dislikeCount: Int?
    let user: CommentUser?
    let replies: [RepliesComment]?

    enum CodingKeys: String, CodingKey {
        case id
        case rssNewsID = "rss_news_id"
        case content, status
        case createdDate = "created_date"
        case createdDatetime = "created_datetime"
        case createdByID = "created_by_id"
        case commentID = "comment_id"
        case isCommentLike, isCommentDisLike, likeCount, dislikeCount, user, replies
    }
}

// MARK: - Datum
struct RepliesComment: Codable {
    let id, rssNewsID: Int?
    let content, status, createdDate, createdDatetime: String?
    let createdByID: StringOrInt?
    let commentID: Int?
    let isCommentLike, isCommentDisLike, likeCount, dislikeCount: Int?
    let user: CommentUser?

    enum CodingKeys: String, CodingKey {
        case id
        case rssNewsID = "rss_news_id"
        case content, status
        case createdDate = "created_date"
        case createdDatetime = "created_datetime"
        case createdByID = "created_by_id"
        case commentID = "comment_id"
        case isCommentLike, isCommentDisLike, likeCount, dislikeCount, user
    }
}

// MARK: - User
struct CommentUser: Codable {
    let id: Int?
    let firstName, lastName: String?
    let userImage: String?
    let bioData: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
        case bioData = "bio_data"
    }
}
