//
//  MeetingCancelDetails.swift
//  EvaConnect
//
//  Created by Pranay Barua on 04/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - CancelDetailsModel
struct CancelDetailsModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CancelDetails]?
}

// MARK: - Datum
struct CancelDetails: Codable {
    let id: Int?
    let title, createdDate, startDate, videoLink: String?
    let startTime, endTime, notification, location: String?
    let details: String?
    let users: [MeetingUser]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case createdDate = "created_date"
        case startDate = "start_date"
        case videoLink = "video_link"
        case startTime = "start_time"
        case endTime = "end_time"
        case notification
        case location = "Location"
        case details, users
    }
}

// MARK: - User
struct MeetingUser: Codable {
    let id: Int?
    let userName, companyName, userImage: String?

    enum CodingKeys: String, CodingKey {
        case id, userName, companyName
        case userImage = "user_image"
    }
}
