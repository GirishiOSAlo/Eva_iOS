//
//  Encodable.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 3/22/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}
