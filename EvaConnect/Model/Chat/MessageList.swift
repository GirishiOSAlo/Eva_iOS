//
//  MessageList.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 03/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
class MessageListRes: Codable {
    let error: Bool?
    let message: String?
    let data: [MessageList]?
}

// MARK: - Datum
class MessageList: Codable {
    let userid: Int?
        let userName: String?
        let userAvatar, image, imageURL, document: String?
        let documentURL, audioFile, audioFileURL: String?
        let unreadCount, blockedStatus: String?
        let lastMessage, loginStatus, createdAt, lastMsgtime: String?

        enum CodingKeys: String, CodingKey {
            case userid
            case userName = "user_name"
            case userAvatar = "user_avatar"
            case image
            case imageURL = "image_url"
            case document
            case documentURL = "document_url"
            case audioFile = "audio_file"
            case audioFileURL = "audio_file_url"
            case unreadCount = "unread_count"
            case lastMessage = "last_message"
            case createdAt = "created_at"
            case loginStatus = "login_status"
            case lastMsgtime = "last_message_time"
            case blockedStatus = "blocked_status"
    }
}
