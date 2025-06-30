//
//  UIDevice.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/29/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
