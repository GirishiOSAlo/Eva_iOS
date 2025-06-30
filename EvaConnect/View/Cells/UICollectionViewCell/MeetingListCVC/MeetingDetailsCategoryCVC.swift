//
//  MeetingDetailsCategoryCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class MeetingDetailsCategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.titleLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
    }
}
