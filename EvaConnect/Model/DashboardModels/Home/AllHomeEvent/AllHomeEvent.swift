//
//  AllHomeEvent.swift
//  EvaConnect
//
//  Created by Metis on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct AllHomeEvent: Codable {
    let error: Bool
    let message: String
    let data: [AllHomeEvent2]
}

// MARK: - Datum
struct AllHomeEvent2: Codable {
    var id: Int?
    var eventName, eventCity, eventStartDate: String?
    var userID: Int?
    var type: Type?
    var isConnected: IsConnected?
    var createdDate: String?
    var user: HomeUser?
    var isEventLike: Int?
    var eventImage: [String?]?
    var content: String?
    var commentCount, likeCount, createdByID: Int?
    var createdDatetime: String?
    var modifiedByID: Int?
    var modifiedDatetime: String?
    var os: String?
    var status: String?
    var isPrivate: Int?
    var registrationLink: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventName = "name"
        case eventCity = "city"
        case eventStartDate = "start_date"
        case userID = "user_id"
        case type
        case isConnected = "is_connected"
        case createdDate = "created_date"
        case user
        case isEventLike = "is_event_like"
        case eventImage = "event_image"
        case content
        case commentCount = "comment_count"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
        case isPrivate = "is_private"
        case registrationLink = "registration_link"
    }
}

/*enum IsConnected: String, Codable {
    case active = "active"
    case deleted = "deleted"
    case notConnected = "not_connected"
    case pending = "pending"
}*/

/*enum TypeEnum: String, Codable {
    
}*/
