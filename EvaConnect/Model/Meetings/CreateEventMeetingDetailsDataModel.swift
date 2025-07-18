//
//  CreateEventMeetingDetailsDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 17/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CreateEventMeetingDetailsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CreateEventMeetingDetailsData]?
}

// MARK: - Datum
struct CreateEventMeetingDetailsData: Codable {
    let id: Int?
    let name: String?
    let status: Int?
    let content, city, country, startDate: String?
    let endDate, startTime, endTime, eventStartDatetime: String?
    let eventEndDatetime: String?
    let isPrivate: Int?
    let eventLocations: [EventLocation]?
    let attendeesList: [AttendeesList]?

    enum CodingKeys: String, CodingKey {
        case id, name, status, content, city, country
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case eventStartDatetime = "event_start_datetime"
        case eventEndDatetime = "event_end_datetime"
        case isPrivate = "is_private"
        case eventLocations = "event_locations"
        case attendeesList
    }
}

// MARK: - AttendeesList
struct AttendeesList: Codable, Equatable {
    var isSelected = false
    let id: Int?
    let name, companyName: String?
    let status: Int?
    let userImage: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case companyName = "company_name"
        case status
        case userImage = "user_image"
    }
}

// MARK: - EventLocation
struct EventLocation: Codable {
    let id: Int?
    let name: String?
    let eventID: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventID = "event_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
