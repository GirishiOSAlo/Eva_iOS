//
//  Agenda.swift
//  EvaConnect
//
//  Created by Pranay Barua on 03/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - AgendaDataModel
struct AgendaDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [AgendaData]?
}

// MARK: - AgendaData
struct AgendaData: Codable {
    let day: Int?
    let date: String?
    let downloadLink: String?
    let dayRelatedData: [DayRelatedDatum]?

    enum CodingKeys: String, CodingKey {
        case day, date
        case downloadLink = "download_link"
        case dayRelatedData = "day_related_data"
    }
}

// MARK: - DayRelatedDatum
struct DayRelatedDatum: Codable {
    let id, eventID: Int?
    let agendaType: String?
    let startTime, endTime, title: String?
    let description, speaker, location: String?
    let dayid: Int?
    let dayDate: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case agendaType = "agenda_type"
        case startTime = "start_time"
        case endTime = "end_time"
        case title, description, speaker, location, dayid
        case dayDate = "day_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - AgendaListDataModel
struct AgendaListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [AgendaDatum]?
}

// MARK: - Datum
struct AgendaDatum: Codable {
    let agendaType: String?

    enum CodingKeys: String, CodingKey {
        case agendaType = "agenda_type"
    }
}
