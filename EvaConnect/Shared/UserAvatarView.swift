//
//  ProfilePictureView.swift
//  ySkolar
//
//  Created by Sajad on 9/20/18.
//  Copyright © 2018 AAA. All rights reserved.
//

import UIKit
import SDWebImage

class UserAvatarView: UIImageView {
    
    var outline: Outline = Outline(width: 2.0, color: AppColors.lightBlue) {
        didSet {
            layer.borderColor = outline.color.cgColor
            layer.borderWidth = outline.width
        }
    }
    
    func setImageSource(source: URL?, with placeHolderImage: UIImage? = UIImage(named: "dateIcon")) {

        self.image = placeHolderImage
    }
    
    private func setupUI() {
        layer.cornerRadius = frame.size.height / 2
//        layer.borderColor = UIColor.clear.cgColor
//        layer.borderWidth = 0.0
        clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentMode = .scaleAspectFill
        setupUI()
    }

}

extension UserAvatarView {
    struct Outline {
        let width: CGFloat
        let color: UIColor
        var inset: CGFloat = 0.0
        
        init(width: CGFloat, color: UIColor) {
            self.width = width
            self.color = color
        }
    }
}
