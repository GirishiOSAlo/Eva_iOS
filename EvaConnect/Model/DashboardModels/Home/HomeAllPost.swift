//
//  HomeAllPost.swift
//  EvaConnect
//
//  Created by Metis on 21/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
struct DashBoardMain: Codable {
    let error: Bool
    let message: String
    let data: [DashBoardModel]?
}

// MARK: - Datum
struct DashBoardModel: Codable {
    let id, userID: Int
    let user: UserDashBoardModel
    let postVideo: String?
    var isConnected: String
    var isRecevier : Bool?
    var isPostLike: Int?
    let createdDate: String
    let content: String?
    let postImage: [String]?
    var commentCount, likeCount, createdByID: Int
    let createdDatetime: String
    let modifiedByID: String?
    let type: String
    let modifiedDatetime: String?
    let is_Url: Bool?
    let os, status: String

    enum CodingKeys: String, CodingKey {
        case isRecevier = "is_receiver"
        case id
        case userID = "user_id"
        case user
        case postVideo = "post_video"
        case isConnected = "is_connected"
        case isPostLike = "is_post_like"
        case createdDate = "created_date"
        case content
        case postImage = "post_image"
        case commentCount = "comment_count"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case type
        case modifiedDatetime = "modified_datetime"
        case os, status
        case is_Url = "is_url"
    }
}
extension DashBoardModel{
    
}

// MARK: - User
struct UserDashBoardModel: Codable {
    let id: Int
    let userImage: String
    let totalConnection: Int?
    let firstName: String?
    let lastName: String?=""
    let bioData : String?

    enum CodingKeys: String, CodingKey {
        case id
        case userImage = "user_image"
        case totalConnection = "total_connection"
        case firstName = "first_name"
        case lastName = "last_name"
        case bioData = "bio_data"
    }
}
