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
    let chatId: String?        // ✅ key like "2_23"
    let unreadCount: Int?      // ✅ optional unread messages count
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

struct FirebaseNotification {
    var image: String?
    let body: String?
    let created_at: String?
    let expire_at: String?
    let id: Int?
    let read: Bool?
    let redirect_url: String?
    let title: String?
    let type: String?
    let subtype: String?
    let notificationId: String?   // ✅ Add Firebase key (snapshot.key)
    let meetingid: Int?
}
//2
//-OYbHMGdFE5pNeGJWsbY
//    body:"final test"
//    created_at:"2025-08-26 16:50:07"
//    expire_at:"2025-08-28 16:50:07"
//    id:10
//    read:false
//    redirect_url:"http://127.0.0.1:8000/events/message/10"
//    title:"Satyam Tripathi"
//    type:"chat" // follower, meeting, event, post, job
