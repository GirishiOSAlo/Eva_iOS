//
//  Debug.swift
//  Instamunch
//
//  Created by Metis on 10/12/2019.
//  Copyright © 2019 HyperNym. All rights reserved.
//

import Foundation
struct Debug {
    static let DebugReservationInput = false
    
    static func debug(jsonData: Data) {
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
        print(json as Any)
    }
}
