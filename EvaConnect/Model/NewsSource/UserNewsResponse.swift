//
//  UserNewsResponse.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/10/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

// MARK: - UserNewsResponse
struct UserNewsResponse: Codable {
    let error: Bool
    let message: String
    let data: [UserNewsData]
}

// MARK: - UserNewsData
struct UserNewsData: Codable {
    let id, userID: Int
    let news: NewsSource
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case news, status
    }
}
