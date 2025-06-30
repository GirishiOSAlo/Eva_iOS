//
//  ImageSaver.swift
//  Divine
//
//  Created by Pranay Barua on 22/09/22.
//

import UIKit

class ImageSaver: NSObject {
    
    var completion: (() -> ())? = nil
    
    func writeToPhotoAlbum(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        print("Image saved successfully!!")
        self.completion?()
    }
}
