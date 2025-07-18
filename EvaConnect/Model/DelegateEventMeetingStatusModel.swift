//
//  DelegateEventMeetingStatusModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

//DelegateEventMeetingStatusModel

// MARK: - Welcome
struct DelegateEventMeetingStatusModel: Codable {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let data: Bool?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case message, data
    }
}
