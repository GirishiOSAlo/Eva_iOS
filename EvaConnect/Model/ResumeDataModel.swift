//
//  ResumeDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 17/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ResumeDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [ResumeData]?
}

// MARK: - Datum
struct ResumeData: Codable {
    let id, userID: Int?
    let title, resumeFile, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title
        case resumeFile = "resume_file"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

