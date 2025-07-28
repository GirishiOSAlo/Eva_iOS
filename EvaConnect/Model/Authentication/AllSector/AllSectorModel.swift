//
//  AllSectorModel.swift
//  EvaConnect
//
//  Created by Metis on 24/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct AllSectorModel: Codable {
    let error: Bool
    let message: String
    let data: [Sectors]
    }

// MARK: - Datum
struct Sectors: Codable {
    let id: Int
    let name: String
}

// MARK: - Welcome
struct AllCategoryModel: Codable {
    let error: Bool?
    let message: String?
    let data: [AllCategoryList]?
}

// MARK: - Datum
struct AllCategoryList: Codable {
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
