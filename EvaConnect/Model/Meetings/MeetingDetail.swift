//
//  MeetingDetail.swift
//  EvaConnect
//
//  Created by usama on 09/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - MeetingDetailRoot
struct MeetingDetailRoot: Codable {
    let error: Bool?
    let message: String?
    let data: [MeetingDetail]?
}

//// MARK: - Datum
//struct MeetingDetail: Codable {
//    let id: Int
//    let name: String
//    let attendees: [Attendee]
//    let address, startDate, endDate, startTime, endTime: String
//    let userID: Int
//    let createdDate, content: String
//    let createdByID: Int
//    let createdDatetime: String
//    let modifiedByID: Int?
//    let os, status: String
//    let modifiedDatetime: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, attendees, address, content
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case userID = "user_id"
//        case createdDate = "created_date"
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case createdByID = "created_by_id"
//        case createdDatetime = "created_datetime"
//        case modifiedByID = "modified_by_id"
//        case modifiedDatetime = "modified_datetime"
//        case os, status
//    }
//}
//
//// MARK: - Attendee
//struct Attendee: Codable {
//    let id, userID: Int
//    let meetingID: Int?
//    let user: EvaUser
//    let status, attendanceStatus, createdDate: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case meetingID = "meeting_id"
//        case userID = "user_id"
//        case user, status
//        case attendanceStatus = "attendance_status"
//        case createdDate = "created_date"
//    }
//}
//

// MARK: - Datum
struct MeetingDetail: Codable {
    let id: Int?
    let gMeetId, title, createdDate, startDate, videoLink, gmeetLink: String?
    let startTime, endTime, details: String?
    let isViewed, isCreatedByUser: Bool?
    let users: [UserConnection]?

    enum CodingKeys: String, CodingKey {
        case title, id
        case gMeetId = "calendar_meeting_id"
        case createdDate = "created_date"
        case startDate = "start_date"
        case videoLink = "video_link"
        case gmeetLink = "meeting_link"
        case startTime = "start_time"
        case endTime = "end_time"
        case isViewed = "is_viewed"
        case isCreatedByUser = "is_created_by_user"
        case details, users
    }
}

// MARK: - User
//struct Attendee: Codable {
//    var isSelected = false
//    let id: Int?
//    let userName, company: String?
//    let userImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        
//        case id = "user_id"
//        case userName = "user_name"
//        case company
//        case userImage = "user_image"
//    }
//}
