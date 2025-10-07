//
//  PostImageCVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 04/04/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

class PostImageCVC: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String! {
        didSet {
            if let imageUrl = image,
               !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
               let url = URL(string: imageUrl),
               UIApplication.shared.canOpenURL(url) {
                imageView.kf.setImage(with: url, placeholder: UIImage(named: "noPhoto"))
            } else {
                imageView.image = UIImage(named: "noPhoto")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20.0
    }

}
