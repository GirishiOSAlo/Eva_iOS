//
//  DashboardBannerDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 23/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct DashboardBannerDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [DashboardBannerData]?
}

// MARK: - Datum
struct DashboardBannerData: Codable {
    let id: Int?
    let name: String?
    let status: Int?
    let content, city, country, startDate: String?
    let endDate, startTime, endTime: String?
    let eventStartDatetime, eventEndDatetime: String?
    let isPrivate: Int?
    let featuredImage: String?
    let isJoined: Int?
    let eventAttendeesStatus: EventAttendeeStatus?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, content, city, country
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case eventStartDatetime = "event_start_datetime"
        case eventEndDatetime = "event_end_datetime"
        case isPrivate = "is_private"
        case featuredImage = "featured_image"
        case isJoined = "is_joined"
        case eventAttendeesStatus = "attendeesstatus"
    }
}
