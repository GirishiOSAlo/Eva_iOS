//
//  Settings Options.swift
//  EvaConnect
//
//  Created by Pranay Barua on 19/06/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - SettingsOptionsDataModel
struct SettingsOptionsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let registrations, bookingMeetings, privateMessaging, meetingPlaceSelector: Bool?
    let eventVisibility, newsRSSFeed, meetingRequestLimit, meetingRescheduleOption: Bool?
    let deletedAt: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, registrations
        case bookingMeetings = "booking_meetings"
        case privateMessaging = "private_messaging"
        case meetingPlaceSelector = "meeting_place_selector"
        case eventVisibility = "event_visibility"
        case newsRSSFeed = "news_rss_feed"
        case meetingRequestLimit = "meeting_request_limit"
        case meetingRescheduleOption = "meeting_reschedule_option"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
