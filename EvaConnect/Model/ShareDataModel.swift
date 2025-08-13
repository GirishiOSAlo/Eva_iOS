//
//  ShareDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 13/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ShareDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: ShareData?
}

// MARK: - DataClass
struct ShareData: Codable {
    let whatsappLink: String?
    let facebookLink: String?
    let copyLink: String?

    enum CodingKeys: String, CodingKey {
        case whatsappLink = "whatsapp_link"
        case facebookLink = "facebook_link"
        case copyLink = "copy_link"
    }
}

