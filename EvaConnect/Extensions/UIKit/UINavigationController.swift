//
//  UINavigationController.swift
//  EvaConnect
//
//  Created by Pranay Barua on 17/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
