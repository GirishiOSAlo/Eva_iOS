//
//  AgendaListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 23/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EventAgendaListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [EventAgendaData]?
}

// MARK: - Datum
struct EventAgendaData: Codable {
    let day, date: String?
    let conferencePrograms: [ConferenceProgram]?

    enum CodingKeys: String, CodingKey {
        case day, date
        case conferencePrograms = "conference_programs"
    }
}

// MARK: - ConferenceProgram
struct ConferenceProgram: Codable {
    let id: Int?
    let name, description: String?
    let addToCalendar: String?
    let timeFrom, timeTo, eventDay: String?
    let eventID: Int?
    let sponsorID: String?
    let locationID: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let sponsorlists: [AgendaSponsorlist]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case addToCalendar = "add_to_calendar"
        case timeFrom = "time_from"
        case timeTo = "time_to"
        case eventDay = "event_day"
        case eventID = "event_id"
        case sponsorID = "sponsor_id"
        case locationID = "location_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case sponsorlists
    }
}

// MARK: - Sponsorlist
struct AgendaSponsorlist: Codable {
    let id: Int?
    let name, status, createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
