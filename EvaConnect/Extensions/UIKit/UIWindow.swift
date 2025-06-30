//
//  UIWindow.swift
//  EvaConnect
//
//  Created by usama on 20/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController,
                                    animated: Bool = true,
                                    duration: TimeInterval = 0.5,
                                    options: UIView.AnimationOptions = .transitionCrossDissolve,
                                    completion: (() -> Void)? = nil) {
          guard animated else {
              rootViewController = viewController
              return
          }

          UIView.transition(with: self, duration: duration, options: options, animations: {
              let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
//            self.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
              // swiftlint:disable:next multiple_closures_with_trailing_closure
          }) { _ in
              completion?()
          }
      }
}
