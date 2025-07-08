//
//  AcceptRejectDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 08/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//AcceptRejectDataModel
// MARK: - Welcome
struct AcceptRejectDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: AcceptRejectData?
}

// MARK: - DataClass
struct AcceptRejectData: Codable {
    let id: Int?
    let createdDatetime, modifiedDatetime: String?
    let status: Int?
    let os: String?
    let modifiedByID, receiverID, senderID: Int?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case status, os
        case modifiedByID = "modified_by_id"
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case deletedAt = "deleted_at"
    }
}
