//
//  GradientView.swift
//  CSRViews
//
//  Created by Muhammad Sajad on 15/01/2019.
//  Copyright © 2019 Muhammad Sajad. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UITextView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
       // setGradient()
    }
    
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateGradientLayer()
    }
    
    func updateGradientLayer() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        
        gradientLayer.colors = [AppColors.blueHigherGradient.cgColor,
                                AppColors.lowerGradient.cgColor,
                                AppColors.higherGradient.cgColor,
                                AppColors.lowestGradient.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer {
            topLayer.removeFromSuperlayer()
        }
    }
}
