//
//  FAQlistDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FAQlistDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [FAQlistData]?
}

// MARK: - Datum
struct FAQlistData: Codable {
    let id: Int?
    let question, answer: String?
    let eventID: String?
    let type, createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, question, answer
        case eventID = "event_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
