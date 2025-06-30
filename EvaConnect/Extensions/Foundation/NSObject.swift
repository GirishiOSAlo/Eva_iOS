//
//  NSObject.swift
//  EvaConnect
//
//  Created by usama on 27/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Alamofire

public protocol With {}

public extension With where Self: Any {

    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().with {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    @discardableResult
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: With {}

extension Parameters {
    
    func getURL(_ url: String) -> String? {
        var component = URLComponents(string: url)
        component?.queryItems = self.map({ URLQueryItem(name: $0.key, value: $0.value as? String) })
        return component?.url?.absoluteString
    }
    
}
