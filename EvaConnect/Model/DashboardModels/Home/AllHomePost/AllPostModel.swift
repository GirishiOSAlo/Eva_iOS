//
//  AllPostModel.swift
//  EvaConnect
//
//  Created by Metis on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct AllHomePost: Codable {
    let error: Bool
    let message: String
    let data: [HomePosts]
}

// MARK: - Datum
struct HomePosts: Codable {
    var id, userID: Int
    var user: EvaUser?
    var isURL: Bool?
    var postVideo: String?
    var isConnected: IsConnected?
    var isReceiver: Bool?
    var isPostLike: Int?
    var createdDate: String?
    var content: String?
    var postImage: [String?]
    var commentCount, likeCount, createdByID: Int?
    var createdDatetime: String?
    var modifiedByID: String?
    var connectionID: Int?
    var type: Type?
    var modifiedDatetime: String?
    var os: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case user
        case isURL = "is_url"
        case postVideo = "post_video"
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case isPostLike = "is_post_like"
        case createdDate = "created_date"
        case content
        case postImage = "post_image"
        case commentCount = "comment_count"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case connectionID = "connection_id"
        case type
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}

/*enum IsConnected: String, Codable {
    case active = "active"
    case deleted = "deleted"
    case notConnected = "not_connected"
    case pending = "pending"
}*/

/*enum OS: String, Codable {
    case android = "android"
    case iOS = "iOS"
    case web = "web"
}*/

enum Type: String, Codable {
    case post = "post"
    case event = "event"
    case job = "job"
}

// MARK: - User
/*struct User: Codable {
    let id: Int
    let userImage: String
    let totalConnection: Int
    let firstName: String
    let lastName: LastName?
    let bioData: String?
    let address: Address?
    let companyName: CompanyName?
    let field: Field?
    let designation: Designation?
    let isLinkedin: Int
    let linkedinImageURL: JSONNull?
    let facebookImageURL: String?
    let isFacebook: Int
    let workAviation: WorkAviation?
    let sector, city, country: String?

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
}*/
