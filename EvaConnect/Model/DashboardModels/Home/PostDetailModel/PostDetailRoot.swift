//
//  PostDetailModel.swift
//  EvaConnect
//
//  Created by Metis on 21/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct PostDetailRoot: Codable {
    let error: Bool
    let message: String
    let data: [PostDetail]
}

// MARK: - Datum
struct PostDetail: Codable {
    let id, userID: Int
    let user: PostUserDetail?
    let isURL, blocked: Bool?
    let postVideo : String?
    var isPostLike: Int?
    let createdDate: String?
    let isConnected: String?
    let connectionId:Int?
    let isReceiver: Bool?
    let content: String?
    let postImage: [String]?
    let commentCount, likeCount, createdByID: Int?
    let documentFileName, documentSize: String?
    let createdDatetime: String?
    let modifiedByID: Int?
    let type: typeEnum?
    let modifiedDatetime: String?
    let os, status: String?
    var postDocument: String?
    let shareCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, isURL, blocked, userID, user, postVideo, isPostLike, createdDate
        case content, connectionId, commentCount, likeCount, postDocument, shareCount
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case postImage = "post_image"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case type
        case modifiedDatetime = "modified_datetime"
        case os, status
        case documentFileName = "document_file_name"
        case documentSize = "document_size"
    }
    
    var dateTime: (date: String, time: String) {
        if let (date, time) = createdDatetime?.dateTime(isUTC: true) {
            return (date, time)
        }
        return ("", "")
    }
    
}
enum typeEnum: String, Codable {
    case job = "job"
    case post = "post"
    case event = "event"
}

// MARK: - User
struct PostUserDetail: Codable {
    let id: Int?
    let userImage: String?
    let totalConnection: Int?
    let firstName: String?
    let lastName: String?
    let bioData: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userImage = "user_image"
        case totalConnection = "total_connection"
        case firstName = "first_name"
        case lastName = "last_name"
        case bioData = "bio_data"
    }

    var fullName: String {
        var title = ""
        title += firstName ?? ""
        if let lastName = lastName {
            //title += " " + String(lastName.first!)
            title += " " + String(lastName)
        }
        return title
    }
}
