//
//  Firebase_Chat.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
import FirebaseDatabase

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

struct ChatMessage {
    var audio_file: String?
    var audio_file_url: String?
    var chat_time: String?
    var document: String?
    var document_url: String?
    var firebase_receiver_id: String?
    var firebase_sender_id: String?
    var image: String?
    var image_url: String?
    var message: String?
    var read: Bool?
    var receiver_id: Int?
    var sender_id: Int?
    var timestamp: Double?

}

//audio_file:""
//audio_file_url:""
//chat_time:"2025-08-21T13:40:33.286938Z"
//document:""
//document_url:""
//firebase_receiver_id:"-OYBbISTF-jtew0tLsd1"
//firebase_sender_id:"-OYBacBHJky7LRMQU3vz"
//image:"xPrLZ45RHx.jpeg"
//image_url:"https://demo.aviationconnect.com/storage/assets/messages/images/xPrLZ45RHx.jpeg"
//read:true
//receiver_id:10
//sender_id:2
//timestamp:1755783633

struct FirebaseNotification: Codable {
    var audio_file: String?
    var body: String?
    var created_at: Double?
    var document: String?
    var image: String?
    var message: String?
    var read: Bool?
    var receiver_id: Int?
    var sender_id: Int?
    var title: String?
    var type: String?
}

//audio_file:""
//body:"HEY"
//created_at:1755756963
//document:""
//image:""
//message:"HEY"
//read:false
//receiver_id:2
//sender_id:24
//title:"Kingfisher Airlines"
//type:"chat"
