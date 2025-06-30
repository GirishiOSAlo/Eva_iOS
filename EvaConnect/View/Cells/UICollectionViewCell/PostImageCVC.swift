//
//  PostImageCVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 04/04/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class PostImageCVC: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String! {
        didSet {
            if let url = URL(string: image), url.containsImage {
                imageView.kf.setImage(with: url, placeholder: UIImage(named: "noPhoto"))
                imageView.kf.indicatorType = .activity
                layoutIfNeeded()
            } else {
                imageView.image = UIImage(named: "noPhoto")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
