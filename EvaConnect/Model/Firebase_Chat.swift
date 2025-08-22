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
//avatar:"https://demo.aviationconnect.com/storage/assets/images/users/3JoGxqgNuD.jpeg"
//created_at:"2025-08-21 13:39:56"
//email:"bhuvagirish@yopmail.com"
//last_changed:1755783596815
//name:"Girish iOS"
//status:"online"
//user_id:2

struct Message {
    let id: String?
    let text: String?
    let senderId: String?
    let timestamp: Double
    let imageUrl: String?
    let documentUrl: String?
    let audioUrl: String?
    let isRead: Bool?
}

//audio_file:""
//chat_time:"2025-08-21T12:54:33.420044Z"
//document:""
//firebase_receiver_id:"-OYBbISTF-jtew0tLsd1"
//firebase_sender_id:"-OYBcMt-5KjUYHEIV0E5"
//image:""
//message:"hey"
//read:true
//receiver_id:10
//sender_id:23
//timestamp:1755780873
