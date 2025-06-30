//
//  CategoryDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 13/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CategoryDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CategoryData]?
}

// MARK: - Datum
struct CategoryData: Codable {
    let id: Int?
    let categoryName: String?
    let isStatus: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "category_name"
        case isStatus = "is_status"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
