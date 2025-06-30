//
//  EventDetailTabsCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class EventDetailTabsCell: BaseCVCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
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
