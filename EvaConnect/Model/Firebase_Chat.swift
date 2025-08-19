//
//  Firebase_Chat.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Helper to generate a consistent chat ID for a one-to-one chat.
struct ChatIdGenerator {
    static func makeChatId(user1: Int64, user2: Int64) -> String {
        let lower = min(user1, user2)
        let higher = max(user1, user2)
        return "\(lower)_\(higher)"
    }
}

class ChatService {
    private let dbRef = Database.database().reference()

    /// Starts observing messages for a given chat ID
    func observeMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        let chatRef = dbRef.child("messages").child(chatId)
        chatRef.queryOrdered(byChild: "timestamp").observe(.value) { snapshot in
            var messages: [Message] = []
            for child in snapshot.children {
                guard
                    let snap = child as? DataSnapshot,
                    let dict = snap.value as? [String: Any],
                    let message = Message.from(dict: dict, id: snap.key)
                else {
                    continue
                }
                messages.append(message)
            }

            completion(messages.sorted { $0.timestamp < $1.timestamp })
        }
    }

    // Sends a message — assumes your backend uploads attachments and writes to Firebase
    func sendMessageViaApi(_ text: String, senderId: Int64, receiverId: Int64) {
        // Hit your own API to send/upload. Firebase only stores the result.
        print("Send message '\(text)' from \(senderId) → \(receiverId)")
    }
}


struct Message {
    let audio_file: String?
    let audio_file_url: String?
    let chat_time: String?
    let document: String?
    let document_url: String?
    let image: String?
    let image_url: String?
    let message: String?
    let read: Bool?
    let receiver_id: String?
    let sender_id: Int?
    let timestamp: TimeInterval

    static func from(dict: [String: Any], id: String) -> Message? {
        guard
//            let text = dict["message"] as? String,
//            let senderId = dict["sender_id"] as? Int64,
//            let receiverId = dict["receiver_id"] as? String,
//            let timestampInt = dict["timestamp"] as? Int64
            
            let audio_file = dict["audio_file"] as? String,
            let audio_file_url = dict["audio_file_url"] as? String,
            let chat_time = dict["chat_time"] as? String,
            let document = dict["document"] as? String,
            let document_url = dict["document_url"] as? String,
            let image = dict["image"] as? String,
            let image_url = dict["image_url"] as? String,
            let message = dict["message"] as? String,
            let read = dict["read"] as? Bool,
            let receiver_id = dict["receiver_id"] as? String,
            let sender_id = dict["sender_id"] as? Int64,
            let timestamp = dict["timestamp"] as? Int64
        else {
            return nil
        }

        return Message(
            id: id,
            audio_file: audio_file,
            audio_file_url: audio_file_url,
            chat_time: chat_time,
            document: document,
            document_url: document_url,
            image: image,
            image_url: image_url,
            message: message,
            read: read,
            receiver_id: receiver_id,
            sender_id: sender_id,
            timestamp: Date(timeIntervalSince1970: TimeInterval(timestamp))

//            text: message,
//            senderId: senderId,
//            receiverId: receiverId,
//            timestamp: Date(timeIntervalSince1970: TimeInterval(timestampInt)),
//            imageUrl: dict["image_url"] as? String,
//            documentUrl: dict["document_url"] as? String,
//            audioUrl: dict["audio_file_url"] as? String,
//            isRead: dict["read"] as? Bool ?? false
        )
    }
}
