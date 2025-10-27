//
//  SpeakerDetailsDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 27/10/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct SpeakerDetailsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [SpeakerDetails]?
}

// MARK: - Datum
struct SpeakerDetails: Codable {
    let id, eventID: Int?
    let eventName: String?
    let speakerID: Int?
    let firstName: String?
    let lastName: String?
    let userImage: String?
    let designation: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case eventName = "event_name"
        case speakerID = "speaker_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
        case designation, description
    }
}
