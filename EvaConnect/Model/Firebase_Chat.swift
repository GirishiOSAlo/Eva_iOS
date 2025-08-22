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
    var audio_file: String?
    var chat_time: String?
    var document: String?
    var firebase_receiver_id: String?
    var firebase_sender_id: String?
    var image: String?
    var message: String?
    var read: Bool?
    var receiver_id: Int?
    var sender_id: Int?
    var timestamp: Double?
}

struct FirebaseUser: Codable {
    var avatar: String?
    var created_at: String?
    var email: String?
    var last_changed: Double?
    var name: String?
    var status: String?
    var user_id: Int?
}

//var avatar:"https://demo.aviationconnect.com/storage/assets/images/users/3JoGxqgNuD.jpeg"
//var created_at:"2025-08-21 13:39:56"
//var email:"bhuvagirish@yopmail.com"
//var last_changed:1755783596815
//var name:"Girish iOS"
//var status:"online"
//var user_id:2

struct Conversation {
    let user: FirebaseUser?
    let lastMessage: ChatMessage?
}

struct Message {
    var audio_file: String?
    var chat_time: String?
    var document: String?
    var firebase_receiver_id: String?
    var firebase_sender_id: String?
    var image: String?
    var message: String?
    var read: Bool?
    var receiver_id: Int?
    var sender_id: Int?
    var timestamp: Double?

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
