//
//  Int.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/10/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

extension Int {
    
    var format: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
