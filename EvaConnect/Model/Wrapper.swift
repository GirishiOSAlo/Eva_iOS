//
//  Wrapper.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/21/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

struct Wrapper<T: Codable>: Codable {
    let error: Bool
    let message: String
    let data: T
}
