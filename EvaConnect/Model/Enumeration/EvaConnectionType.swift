//
//  EvaConnectionType.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/2/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

enum EvaConnectionType: Int {
    case followers = 0
    case pending = 1
    case blocked = 2
    
    var filterStatus: String {
        switch self {
        case .followers:
            return "active"
        case .pending:
            return "pending"
        case .blocked:
            return "deleted"
        }
    }
}

enum EvaRequestType: Int {
    case received = 0
    case sent = 1
}
