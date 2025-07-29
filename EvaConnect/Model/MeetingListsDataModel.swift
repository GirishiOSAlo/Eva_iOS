//
//  MeetingListsDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 28/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
struct MeetingListsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: MeetingListsData?
}

// MARK: - DataClass
struct MeetingListsData: Codable {
    let approvedmeeting: [approvedMeetingLists]?
    let authCompanyID: Int?
    let startDate, endDate: String?
    let eventIDS: [Int]?

    enum CodingKeys: String, CodingKey {
        case approvedmeeting
        case authCompanyID = "auth_company_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case eventIDS = "eventIds"
    }
}

// MARK: - Datum
struct approvedMeetingLists: Codable {
    let id: Int?
    let eventName: String?
    let eventID: Int?
    let startDay, startTime, endTime: String?
    let location, locationName: String?
    let meetingNotes: String?
    let rescheduleReason: String?
    let meetingDetails: String?
    let meetingWithID: Int?
    let meetingWith, withColleagues: String?
    let requestedByID, requestedToID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventName = "event_name"
        case eventID = "event_id"
        case startDay = "start_day"
        case startTime = "start_time"
        case endTime = "end_time"
        case location
        case locationName = "location_name"
        case meetingNotes = "meeting_notes"
        case rescheduleReason = "reschedule_reason"
        case meetingDetails = "meeting_details"
        case meetingWithID = "meeting_with_id"
        case meetingWith = "meeting_with"
        case withColleagues = "with_colleagues"
        case requestedByID = "requested_by_id"
        case requestedToID = "requested_to_id"
    }
}
