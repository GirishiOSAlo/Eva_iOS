//
//  MyLikeModel.swift
//  EvaConnect
//
//  Created by Metis on 23/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllLikeModel: Codable {
    let error: Bool
    let message: String
    let data: [LikeModelData]?
}

// MARK: - Datum
struct LikeModelData: Codable {
   let objectID: Int
     let objectType: ObjectType?
     let createdDatetime: String
     let createdByID: Int
     let user: [UserLike]?
     let details: String?
     let isLike: Int
    enum CodingKeys: String, CodingKey {
        case objectID = "object_id"
        case objectType = "object_type"
        case createdDatetime = "created_datetime"
        case createdByID = "created_by_id"
        case user, details
        case isLike = "is_like"
    }
}

enum Details: String, Codable {
    case test = "test"
}

enum ObjectTypeLike: String, Codable {
    case post = "post"
    
    
}

// MARK: - User
struct UserLike: Codable {
    let id: Int
    let firstName: String?
    let isConnected, isReceiver : Bool?
    let connectionID : Int?
    let lastName: String?
    let bioData: String?
    let email: String?
    let uniqueCode: String?
    let username: String?
    let dateOfBirth: String?
    //let verificationPin: Int
    let userImage: String?
    //let os: OSLike
    let type: String?
    let createdByID: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case lastName = "last_name"
        case bioData = "bio_data"
        case email
        case uniqueCode = "unique_code"
        case username
        case dateOfBirth = "date_of_birth"
        //case verificationPin = "verification_pin"
        case userImage = "user_image"
        case type
        case createdByID = "created_by_id"
        case status
    }
}
enum BioDataLike: String, Codable {
    case qwertyyyyu = "qwertyyyyu"
}

enum Email: String, Codable {
    case majeedAbcCOM = "majeed@abc.com"
}

enum FirstName: String, Codable {
    case majeed = "majeed"
}

enum OSLike: String, Codable {
    case android = "android"
}

enum StatusLike: String, Codable {
    case active = "active"
}

enum TypeEnumLike: String, Codable {
    case user = "user"
}

enum UniqueCode: String, Codable {
    case the11E671615D87 = "11e671615d87"
}
