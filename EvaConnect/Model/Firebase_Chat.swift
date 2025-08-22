//
//  Firebase_Chat.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChatMessage: Codable {
    var messageId: String?
    var senderId: Int?
    var text: String?
    var timestamp: Double?
}

struct FirebaseUser: Codable {
    var user_id: Int?
    var name: String?
    var profileImage: String?
}

struct Conversation {
    let user: FirebaseUser?
    let lastMessage: ChatMessage?
}


