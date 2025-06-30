//
//  MainCollectionCell.swift
//  EvaConnect
//
//  Created by Metis on 04/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class HomeTabsCell: BaseCVCell {
    
    @IBOutlet weak var tabButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        tabButton.layer.cornerRadius = (tabButton.frame.height)/2
        tabButton.setTitle("", for: .normal)
        tabButton.setTitleColor(.darkGray, for: .normal)
        tabButton.backgroundColor = Constants.AppColorLiteral.postTypeBackground
    }
    
    override func prepareForReuse() {
        
        //cellBtn.setTitle("", for: .normal)
        tabButton.setTitleColor(.darkGray, for: .normal)
        tabButton.backgroundColor = Constants.AppColorLiteral.postTypeBackground
    }
}
