//
//  ChatList.swift
//  EvaConnect
//
//  Created by Pranay Barua on 27/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation

// MARK: - ChatListDataModel
struct ChatListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [ChatData]?
}

// MARK: - DataClass
struct ChatData: Codable {
    let userDetails: UserDetails?
        let chatList: [ChatList]?

        enum CodingKeys: String, CodingKey {
            case userDetails = "user_details"
            case chatList = "chat_list"
        }
    }

    // MARK: - ChatList
    class ChatList: Codable {
        let id: Int?
        let createdDatetime, modifiedDatetime: String?
        let senderID: Int?
        let receiverID: ReceiverID?
        let message, image: String?
        let imageURL: String?
        let document, documentURL: String?
        let actualDocumentName: String?
        let audioFile, audioFileURL: String?
        let actualAudioFileName: String?
        let createdAt: String?
        let updatedAt: String?
        let isRead: Int?
        let readTime: String?
        let deletedAt: String?
        let replyMessageID: String?
        let type: ChatTypeEnum?
        let documentSize, audioSize: String?
        let replyMessage: ChatList?
        let chatTime: String?

        enum CodingKeys: String, CodingKey {
            case id
            case createdDatetime = "created_datetime"
            case modifiedDatetime = "modified_datetime"
            case senderID = "sender_id"
            case receiverID = "receiver_id"
            case message, image
            case imageURL = "image_url"
            case document
            case documentURL = "document_url"
            case actualDocumentName = "actual_document_name"
            case audioFile = "audio_file"
            case audioFileURL = "audio_file_url"
            case actualAudioFileName = "actual_audio_file_name"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case isRead = "is_read"
            case readTime = "read_time"
            case deletedAt = "deleted_at"
            case replyMessageID = "reply_message_id"
            case type
            case documentSize = "document_size"
            case audioSize = "audio_size"
            case replyMessage = "reply_message"
            case chatTime = "chat_time"
        }
    }

// MARK: - UserDetails
struct UserDetails: Codable {
    let id: Int?
    let firstName, lastName, userImage, lastOnline, loginStatus, blockedStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
        case lastOnline = "last_online"
        case loginStatus = "login_status"
        case blockedStatus = "blocked_status"
    }
}

enum ChatTypeEnum: String, Codable {
    case image = "image"
    case message = "message"
    case audio = "audio"
    case reply = "reply"
    case doc = "document"
}


enum ReceiverID: Codable {
    case int(Int)
    case bool(Bool)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                ReceiverID.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type for receiver_id")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

