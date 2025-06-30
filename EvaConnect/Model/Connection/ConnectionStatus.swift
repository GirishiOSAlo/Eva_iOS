//
//  ConnectionStatus.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 4/1/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

struct ConnectionStatus: Codable {
    
    let isBlocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case isBlocked = "is_blocked"
    }
}
