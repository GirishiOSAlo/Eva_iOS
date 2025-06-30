//
//  JobFavourite.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/21/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

struct JobFavouriteResponse: Codable {
    let error: Bool
    let message: String
    let data: JobFavourite
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decode(Bool.self, forKey: .error)
        message = try values.decode(String.self, forKey: .message)
        if let first = try? values.decode([JobFavourite].self, forKey: .data).first {
            data = first
        } else {
            data = try values.decode(JobFavourite.self, forKey: .data)
        }
    }
}
// MARK: - JobFavourite
struct JobFavourite: Codable {
    let id: Int?
    let jobId: Int
    let status: String
    let userId: Int
    let isFavourite: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case status
        case userId = "user_id"
        case isFavourite = "is_favourite"
    }
}
