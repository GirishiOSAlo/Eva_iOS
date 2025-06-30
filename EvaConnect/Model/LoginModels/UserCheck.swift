//
//  UserCheck.swift
//  EvaConnect
//
//  Created by usama on 02/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - UserCheck
struct UserCheckRoot: Codable {
    let error: Bool
    let message: String?
    let data: [UserCheck]
}

// MARK: - Datum
struct UserCheck: Codable {
    let id: Int?
    let is_linkedin: Int?
    let is_facebook: Int?
}
