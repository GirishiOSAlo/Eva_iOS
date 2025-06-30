//
//  AllSectorModel.swift
//  EvaConnect
//
//  Created by Metis on 24/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct AllSectorModel: Codable {
    let error: Bool
    let message: String
    let data: [Sectors]
    }

// MARK: - Datum
struct Sectors: Codable {
    let id: Int
    let name: String
}
