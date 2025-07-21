//
//  ReportCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ReportCVC: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        baseView.layer.cornerRadius = 12.0
        titleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
    }
}
