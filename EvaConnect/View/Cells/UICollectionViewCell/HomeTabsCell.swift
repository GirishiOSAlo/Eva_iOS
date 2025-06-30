//
//  MainCollectionCell.swift
//  EvaConnect
//
//  Created by Metis on 04/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class HomeTabsCell: BaseCVCell {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var tab: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        tab.backgroundColor = AppColors.lightGrayBG
//        tab.setTitle("", for: .normal)
//        tab.setTitleColor(AppColors.lightBg, for: .normal)
    }
    
    override func prepareForReuse() {
        
//        //cellBtn.setTitle("", for: .normal)
//        tab.setTitleColor(AppColors.lightBg, for: .normal)
    }
}
