//
//  SendRequestDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 17/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct SendRequestDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: SendRequestData?
}

// MARK: - DataClass
struct SendRequestData: Codable {
    let senderID, receiverID, status, modifiedByID: Int?
    let createdDatetime, modifiedDatetime: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case status
        case modifiedByID = "modified_by_id"
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case id
    }
}
