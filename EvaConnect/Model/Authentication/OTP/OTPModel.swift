//
//  OTPModel.swift
//  EvaConnect
//
//  Created by Pranay Barua on 09/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - OTPModel
struct OTPModel: Codable {
    let error: Bool?
    let message: String?
    let data: OTPClass?
}

// MARK: - DataClass
struct OTPClass: Codable {
    let otp: Int?
}

struct forgotPasswordModel: Codable {
    let error: Bool?
    let message: String?
    let data: [String]?
}
