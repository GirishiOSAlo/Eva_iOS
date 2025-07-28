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
    let eventIDS: [String]?

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

    enum CodingKeys: String, CodingKey {
        case id
    }
}
