//
//  UIActivityIndicatorView.swift
//  EvaConnect
//
//  Created by usama on 16/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func activityIndicatorView(controllerView: UIView) {
        self.center = controllerView.center
        self.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.color = .blue
        controllerView.addSubview(self)
    }
}
