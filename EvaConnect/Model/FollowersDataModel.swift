//
//  FollowersDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 08/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FollowersDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: FollowersData?
}

// MARK: - DataClass
struct FollowersData: Codable {
    let delegatesDetails: DelegatesDetails?
    let activeTab: String?
}

// MARK: - DelegatesDetails
struct DelegatesDetails: Codable {
    let followers: [Follower]?
    let following, request, mutual, senderFollow: [Follower]?

    enum CodingKeys: String, CodingKey {
        case followers, following, request, mutual
        case senderFollow = "sender_follow"
    }
}

// MARK: - Follower
struct Follower: Codable {
    let id, status: Int?
    let firstName, companyName, designation, userImage, action, imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case companyName = "company_name"
        case designation
        case userImage = "user_image"
        case status
        case action
        case imageURL = "image_url"
    }
}
