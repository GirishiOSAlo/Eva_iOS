//
//  VenueCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class VenueCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var venueImgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.baseView.cornerRadius = 20.0
        self.venueImgVw.cornerRadius = 20.0
    }
}
