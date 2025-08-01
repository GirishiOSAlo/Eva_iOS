//
//  ScheduleMeetingDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 01/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ScheduleMeetingDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: ScheduleMeetingData?
}

// MARK: - DataClass
struct ScheduleMeetingData: Codable {
    let userID: Int?
    let username: String?
    let scheduleMeetingDate: [String]?
    let eventname: String?
    let eventid: Int?
    let scheduleMeetinglist: [ScheduleMeetinglist]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username, scheduleMeetingDate, eventname, eventid, scheduleMeetinglist
    }
}

// MARK: - ScheduleMeetinglist
struct ScheduleMeetinglist: Codable {
    let startDay: String?
    let scheduleDateList: [scheduleMeeting]?

    enum CodingKeys: String, CodingKey {
        case startDay = "start_day"
        case scheduleDateList = "day_related_data"
    }
}

// MARK: - DayRelatedDatum
struct scheduleMeeting: Codable {
    let id, eventID: Int?
    let startDay, title, startTime, endTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case startDay = "start_day"
        case title
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
