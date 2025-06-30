//
//  SponsorsCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SponsorsCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var profileImgHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.baseView.cornerRadius = 20.0
        self.profileImgVw.cornerRadius = 20.0
        self.nameLbl.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        self.subLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
    }

}
