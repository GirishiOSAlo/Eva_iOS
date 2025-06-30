//
//  NewsSource.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - NewsSourceRoot
struct NewsSourceRoot: Codable {
    let error: Bool
    let message: String
    let data: [NewsSource]
}

// MARK: - Datum
struct NewsSource: Codable {
    var selected = false
    let id: Int
    let name: String
    let image: String?
    let status: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case image = "image_url"
    }
}
