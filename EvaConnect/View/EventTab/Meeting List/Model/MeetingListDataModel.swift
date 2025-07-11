//
//  MeetingListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//MeetingListDataModel


// MARK: - Welcome
struct MeetingListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: MeetingListData?
}

// MARK: - DataClass
struct MeetingListData: Codable {
    let pendingMeetings, acceptedMeetings, cancelledMeetings, rescheduledMeetings: [EventMeeting]?
}

// MARK: - AcceptedMeeting
struct EventMeeting: Codable {
    let id, userid: Int?
    let startDay, startTime, endTime: String?
    let location: String?
    let meetingNotes: String?
    let locationName: String?
    let rescheduleReason: String?
    let meetingDetails, meetingWith, withColleagues: String?
    let requestedByID, requestedToID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, userid
        case startDay = "start_day"
        case startTime = "start_time"
        case endTime = "end_time"
        case location
        case meetingNotes = "meeting_notes"
        case locationName = "location_name"
        case rescheduleReason = "reschedule_reason"
        case meetingDetails = "meeting_details"
        case meetingWith = "meeting_with"
        case withColleagues = "with_colleagues"
        case requestedByID = "requested_by_id"
        case requestedToID = "requested_to_id"
    }
}
