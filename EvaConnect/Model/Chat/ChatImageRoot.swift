//
//  ChatImageRoot.swift
//  EvaConnect
//
//  Created by usama on 04/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - ChatImageRoot
struct ChatImages: Codable {
    let error: Bool
    let message: String
    let data: ChatAttachments
}

struct ChatAttachments: Codable {
    let images: [String]
    let documents: [String]
}

struct GenericResponse: Codable {
    let error: Bool
    let message: String
}
