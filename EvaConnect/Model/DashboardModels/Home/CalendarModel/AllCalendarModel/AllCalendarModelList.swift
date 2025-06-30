//
//  AllCalendarModelList.swift
//  EvaConnect
//
//  Created by Metis on 31/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


import Foundation

// MARK: - Welcome
struct AllCalendarModelList: Codable {
    let error: Bool
    let message: String
    let data: [CalendarModelList]?
}

// MARK: - Datum
struct CalendarModelList: Codable, Equatable, Hashable {
    
    let id, userID: Int?
    let objectType: CalenderObjectType?
    let objectID: Int?
    let objectDetails: ObjectDetails?
    let occurrenceDate, notes, os, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case objectType = "object_type"
        case objectID = "object_id"
        case objectDetails = "object_details"
        case occurrenceDate = "occurrence_date"
        case notes, os, status
    }
    
    static func == (lhs: CalendarModelList, rhs: CalendarModelList) -> Bool {
        lhs.objectID == rhs.objectID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(objectID)
    }
}

// MARK: - ObjectDetails

struct ObjectDetails: Codable {
    let name, address: String?
    let startDate, endDate: String?
    let startTime, endTime: String?
    let content: String?
    let isPrivate: Int?
    let user: EvaUser?
    let title: String?
    let details: String?
    let occurrenceTime: String?
    let occurrenceDate: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case content
        case isPrivate = "is_private"
        case occurrenceTime = "occurrence_time"
        case occurrenceDate = "occurrence_date"
        case user
        case title, details
    }
}

enum CalenderObjectType: String, Codable {
    //case interview = "interview"
    case event = "event"
    case note = "note"
    case job = "interview"
    case meeting = "meeting"
}

