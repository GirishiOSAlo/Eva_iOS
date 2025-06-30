//
//  GalleryCVCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 26/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class GalleryCVCell:  BaseCVCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var playImgView: UIImageView!
    @IBOutlet weak var videoParentView: UIView!
    @IBOutlet weak var videoThumbImg: UIImageView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var presentationVw: UIView!
    @IBOutlet weak var presentationTitleLbl: UILabel!
    @IBOutlet weak var presentationImgVw: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
    }

}

