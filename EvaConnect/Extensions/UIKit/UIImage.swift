//
//  UIImage.swift
//  EvaConnect
//
//  Created by usama on 09/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
         let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
         UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
         defer { UIGraphicsEndImageContext() }
         draw(in: CGRect(origin: .zero, size: canvasSize))
         return UIGraphicsGetImageFromCurrentImageContext()
     }
    
     func resizedTo1MB() -> UIImage? {
         guard let imageData = self.pngData() else { return nil }
         
         var resizingImage = self
         var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
         
         while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
             guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                 let imageData = resizedImage.pngData()
                 else { return nil }
             
             resizingImage = resizedImage
             imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
         }
         
         return resizingImage
     }
}

