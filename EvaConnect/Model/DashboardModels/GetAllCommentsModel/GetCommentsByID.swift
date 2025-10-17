//
//  GetCommentsByID.swift
//  EvaConnect
//
//  Created by Metis on 24/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct CommentDetailRoot: Codable {
    let error: Bool
    let message: String
    let data: [Comments]
}

// MARK: - Datum
struct Comments: Codable {
    let id: Int
    let isCommentLike, likeCount : Int?
    let postID: Int? //modifiedByID
    let createdDate, content: String?
    let createdByID: StringOrInt
    let user: CommentUserData
    let createdDatetime, status: String
//    let modifiedDatetime: String?
//    let os : String
    
    
    var time: String {
        if let date = createdDatetime.date(formatter: .standardDateWithTime) {
            let timeOnly =  date.toString(formatter: .timeOnly)
            return timeOnly
        }
        return ""
    }

    enum CodingKeys: String, CodingKey {
        case id, isCommentLike, likeCount
        case postID = "post_id"
        case createdDate = "created_date"
        case content, status
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
//        case modifiedByID = "modified_by_id"
//        case modifiedDatetime = "modified_datetime"
//        case os, status
        case user
    }
    
}
struct CommentUserData: Codable {
    let id: Int
    let firstName: String
    //let isConnected, isReceiver, connectionID,
    let lastName: String?
//    let bioData, email, uniqueCode, username: String?
//    let dateOfBirth: String?
//    let verificationPin: Int
    let userImage: String?
//    let os, type: String
//    let createdByID: Int?
//    let status: String


    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
//        case isConnected = "is_connected"
//        case isReceiver = "is_receiver"
//        case connectionID = "connection_id"
        case lastName = "last_name"
//        case bioData = "bio_data"
//        case email
//        case uniqueCode = "unique_code"
//        case username
//        case dateOfBirth = "date_of_birth"
//        case verificationPin = "verification_pin"
        case userImage = "user_image"
//        case os, type
//        case createdByID = "created_by_id"
//        case status
    }
}
