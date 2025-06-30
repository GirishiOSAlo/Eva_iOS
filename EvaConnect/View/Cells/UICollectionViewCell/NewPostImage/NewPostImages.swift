//
//  NewPostImages.swift
//  EvaConnect
//
//  Created by Metis on 07/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class NewPostImages: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 15
        removeBtn.roundOnly()
    }

}
