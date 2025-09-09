//
//  CurrenciesDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 09/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//CurrenciesDataModel
// MARK: - Welcome
struct CurrenciesDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CurrenciesData]?
}

// MARK: - Datum
struct CurrenciesData: Codable {
    let id: Int?
    let name, symbol, code: String?
    let status: String?
}
