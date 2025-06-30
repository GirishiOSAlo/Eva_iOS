//
//  AllCalendarByMonth.swift
//  EvaConnect
//
//  Created by Metis on 02/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct AllCalendarModelByMonth: Codable {
    let error: Bool
    let message: String
    let data: [CalendarModelByMonth]?
}

// MARK: - Datum
struct CalendarModelByMonth: Codable {
    let id, userID: Int?
    let objectType: CalendarObjectType?
    let objectID: Int?
    let occurrenceDate, notes: String?
    let os: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case objectType = "object_type"
        case objectID = "object_id"
        case occurrenceDate = "occurrence_date"
        case notes, os, status
    }
}

enum CalendarObjectType: String, Codable {
    case event = "event"
    case note = "note"
    case job = "interview"
    case meeting = "meeting"
}

// MARK: - CalenderEventListDataModel
struct CalenderEventListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CalenderEventsdata]?
}

// MARK: - Datum
struct CalenderEventsdata: Codable {
    let id: Int?
    let title, details, createdDate, startTime, type: String?
    let objectType, occurrenceDate, occurrenceTime: String?

    enum CodingKeys: String, CodingKey {
        case id, title, details, type
        case createdDate = "created_date"
        case startTime = "start_time"
        case occurrenceDate = "occurrence_date"
        case occurrenceTime = "occurrence_time"
        case objectType = "object_type"
        
    }
}



