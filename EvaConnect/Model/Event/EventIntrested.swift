//
//  EventIntrested.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/21/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

struct EventIntrested: Codable {
    let id, eventId, userId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case user
        case userId = "user_id"
    }
}


struct EventIntrestedUser: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let userImage: String
    let designation: String
    
    enum CodingKeys: String, CodingKey {
        case id, designation
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
    }
}
