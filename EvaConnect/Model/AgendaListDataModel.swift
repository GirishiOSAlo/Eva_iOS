//
//  AgendaListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 23/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

struct AnyDecodable: Decodable {}

// MARK: - Welcome
struct EventAgendaListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [EventAgendaData]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try? container.decode(Bool.self, forKey: .error)
        message = try? container.decode(String.self, forKey: .message)
        
        // Try to decode `data` as an array
        if let dataArray = try? container.decode([EventAgendaData].self, forKey: .data) {
            data = dataArray
        }
        // If it's a dictionary (like {}) → treat as empty array
        else if let _ = try? container.decode([String: AnyDecodable].self, forKey: .data) {
            data = []
        }
        else {
            data = nil
        }
    }
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
    let sponsorname: String?
    let speakers: [AgendaSpeakerList]?
    let attendeesstatus: String?
    let evaUserNetworkingMappings: [EvaUserNetworkingMapping]?

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
        case sponsorname, speakers, attendeesstatus
        case evaUserNetworkingMappings = "eva_user_networking_mappings"
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

// MARK: - Speaker
struct AgendaSpeakerList: Codable {
    let id: Int?
    let name: String?
    let designation: String?
    let company: String?
    let profile: String?
}
