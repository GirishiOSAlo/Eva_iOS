//
//  EventFavourite.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/21/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

// MARK: - EventFavourite
struct EventFavouriteResponse: Codable {
    let error: Bool
    let message: String
    let data: EventFavourite?

    enum CodingKeys: String, CodingKey {
        case error, message, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decode(Bool.self, forKey: .error)
        message = try container.decode(String.self, forKey: .message)
        
        if let eventFavourite = try? container.decode([EventFavourite].self, forKey: .data).first {
            data = eventFavourite
        } else {
            data = try? container.decode(EventFavourite.self, forKey: .data)
        }
        
    }
}

// MARK: - EventFavourite
struct EventFavourite: Codable {
    let id, eventId: Int
    let status: String
    let userId: Int
    let isFavourite: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case status
        case userId = "user_id"
        case isFavourite = "is_favourite"
    }
}
