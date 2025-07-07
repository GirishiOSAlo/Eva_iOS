//
//  HelpDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 07/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//HelpDataModel

// MARK: - Welcome
struct HelpDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: HelpData?
}

// MARK: - DataClass
struct HelpData: Codable {
    let userID: Int?
    let descriptions, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case descriptions
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
