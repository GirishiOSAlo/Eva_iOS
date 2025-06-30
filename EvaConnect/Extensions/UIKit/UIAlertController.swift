//
//  UIAlertController.swift
//  EvaConnect
//
//  Created by usama on 31/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

public extension UIAlertController {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    ///   - style: <#style description#>
    convenience init(title: String?, message: String?, style: UIAlertController.Style = .alert) {
        self.init(title: title, message: message, preferredStyle: style)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - style: <#style description#>
    ///   - handler: <#handler description#>
    func addAction(_ title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - animated: <#animated description#>
    ///   - completion: <#completion description#>
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
