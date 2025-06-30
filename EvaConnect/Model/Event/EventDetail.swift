////
////  EventDetail.swift
////  EvaConnect
////
////  Created by usama on 15/06/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import Foundation
//
//// MARK: - MeetingDetailRoot
//struct EventDetailRoot: Codable {
//    let error: Bool
//    let message: String?
//    let data: [EventDetail]
//}
//
//// MARK: - Datum
//struct EventDetail: Codable {
//    let id, agenda: Int?
//    let name, userName, createdByUser, floorPlan: String?
//    let address, startDate, endDate: String?
//    let attendees: [UserConnection]?
//    let isNewsSave: Int? //isPrivate, 
//    let isAttending: String?
//    let userID: Int?
//    let createdDate, startTime, endTime: String?
//    let eventImage: [String?]?
//    let content: String?
//    let createdByID: Int?
//    let isEventLike: Int?
//    let createdDatetime: String?
//    let modifiedDatetime: String?
//    let modifiedByID, status: Int?
//    let likeCount, commentCount: Int?
//    let os, registrationLink: String?
//    let tempImage: String?
//    let interestedUsersCount: String?
//    let interestedUsers: [InterestedUser]?
////    let user: User?
//
//    enum CodingKeys: String, CodingKey {
//        case id, agenda, name, address, isNewsSave
//        case startDate = "event_start_datetime"
//        case endDate = "event_end_datetime"
//        case attendees
//        case floorPlan = "floor_plan"
////        case user
//        case createdByUser = "created_by_user"
//        case userName = "user_name"
////        case isPrivate = "is_private"
//        case isAttending = "is_attending"
//        case userID = "user_id"
//        case createdDate = "created_date"
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case eventImage = "event_image"
//        case content
//        case createdByID = "created_by_id"
//        case createdDatetime = "created_datetime"
//        case modifiedByID = "modified_by_id"
//        case modifiedDatetime = "modified_datetime"
//        case os, status
//        case registrationLink = "registration_link"
//        case isEventLike //= "is_event_like"
//        case likeCount = "like_count"
//        case commentCount = "comment_count"
//        case tempImage = "temp_image"
//        case interestedUsersCount = "interested_users_count"
//        case interestedUsers = "interested_users"
//    }
//}
//
//// MARK: - GalleryDataModel
//struct GalleryDataModel: Codable {
//    let error: Bool?
//    let message: String?
//    let data: [GalleryDataClass]?
//}
//
//// MARK: - DataClass
struct GalleryDataClass: Codable {
    let id, eventID, userID: Int?
    let type: String?
    let file: String?
    let createdAt, updatedAt: String?
    let title, thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id, eventID, userID, type, file
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title, thumbnail
    }
}
