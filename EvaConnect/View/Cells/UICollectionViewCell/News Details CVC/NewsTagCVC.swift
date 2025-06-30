//
//  NewsTagCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 06/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NewsTagCVC: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tagLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initui()
    }

    func initui() {
        self.baseView.layer.cornerRadius = 6.0
    }
}
