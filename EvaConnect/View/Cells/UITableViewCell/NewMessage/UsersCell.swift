//
//  UsersCell.swift
//  EvaConnect
//
//  Created by usama on 17/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class UsersCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: User? {
        didSet {
            userName.text = user?.firstName
            if let imageUrl = user?.userImage, let url = URL(string: imageUrl) {
                userImage.sd_setImage(with: url) { (image, error, _, _) in
                    self.userImage.roundOnly()
                    self.userImage.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        userImage.roundOnly()
    }
    
    override func prepareForReuse() {
        userImage.image = nil
    }
}
