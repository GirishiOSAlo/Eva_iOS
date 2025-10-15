//
//  NetworkEventListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//NetworkEventListDataModel

// MARK: - Welcome
struct NetworkEventListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: NetworkEventListData?
}

// MARK: - DataClass
struct NetworkEventListData: Codable {
    let eventName: String?
    let attendeesstatus: String?
    let networkingList: NetworkingList?
}

// MARK: - NetworkingList
struct NetworkingList: Codable {    
    let currentPage: Int?
    let data: [NetworkEventList]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [NetworkingListLink]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL, to: String?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct NetworkEventList: Codable {
    let id: Int?
    let networkingeventName, location: String?
    let theme: String?
    let date, startTime: String?
    let endTime: String?
    let description, notes: String?
    let userInput: String?
    let eventID: Int?
    let evaUserNetworkingMappings: [EvaUserNetworkingMapping]?

    enum CodingKeys: String, CodingKey {
        case id
        case networkingeventName = "networkingevent_name"
        case location, theme, date
        case startTime = "start_time"
        case endTime = "end_time"
        case description, notes
        case userInput = "user_input"
        case eventID = "event_id"
        case evaUserNetworkingMappings = "eva_user_networking_mappings"
    }
}

// MARK: - Link
struct NetworkingListLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}

//// MARK: - EvaUserNetworkingMapping
//struct EvaUserNetworkingMapping: Codable {
//    let id, eventNetworkingID, userID, status: Int?
//    let deletedAt: String?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case eventNetworkingID = "event_networking_id"
//        case userID = "user_id"
//        case status
//        case deletedAt = "deleted_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
