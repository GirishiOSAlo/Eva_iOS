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
//    let id, userID: Int?
//    let user: PostUserDetail?
//    let isURL, blocked: Bool?
//    let postVideo : String?
//    var isPostLike: Int?
//    let createdDate: String?
//    let isConnected: String?
//    let connectionId:Int?
//    let isReceiver: Bool?
//    let content: String?
//    let postImage: [String]?
//    let commentCount, likeCount, createdByID: Int?
//    let documentFileName, documentSize: String?
//    let createdDatetime: String?
//    let modifiedByID: Int?
//    let type: typeEnum?
//    let modifiedDatetime: String?
//    let os, status: String?
//    var postDocument: String?
//    let shareCount: Int?
    
    let id, userID: Int?
    let isURL, blocked: Bool?
    let postVideo: String?
    var isPostLike: Int?
    let createdDate, isConnected: String?
    let connectionID: Int?
    let isReceiver: String?
    let content, postTitle: String?
    let postImage, commentCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let type, modifiedDatetime: String?
    let os: String?
    let status, documentFileName, documentSize, postDocument: String?
    let fileDatetime: String?
    let shareCount: Int?
    let datumPostImage: [String]?
    let postDocuments: [String]?
    let user: PostUserDetail?

    enum CodingKeys: String, CodingKey {
        case id, userID, isURL, blocked, postVideo, isPostLike, createdDate, isConnected
        case connectionID = "connectionId"
        case isReceiver, content
        case postTitle = "post_title"
        case postImage, commentCount, likeCount, createdByID, createdDatetime, modifiedByID, type, modifiedDatetime, os, status
        case documentFileName = "document_file_name"
        case documentSize = "document_size"
        case postDocument
        case fileDatetime = "file_datetime"
        case shareCount
        case datumPostImage = "post_image"
        case postDocuments = "post_documents"
        case user
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
    let firstName, lastName, companyName, logo: String?
    let totalConnection: Int?
    let userImage: String?
    let bioData: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case companyName = "company_name"
        case logo
        case totalConnection = "total_connection"
        case userImage = "user_image"
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
