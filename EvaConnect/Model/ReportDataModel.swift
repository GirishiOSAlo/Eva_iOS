//
//  ReportDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ReportDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [ReportData]?
}

// MARK: - Datum
struct ReportData: Codable {
    let id: Int?
    let tagName, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case tagName = "tag_name"
        case status
    }
}

