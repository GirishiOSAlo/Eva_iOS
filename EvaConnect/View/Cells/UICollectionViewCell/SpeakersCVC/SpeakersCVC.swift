//
//  SpeakersCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SpeakersCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var viewProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.baseView.cornerRadius = 20.0
        self.profileImgVw.cornerRadius = self.profileImgVw.frame.size.height / 2
        self.nameLbl.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        self.subLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.viewProfileBtn.cornerRadius = 14.0
        self.viewProfileBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
    }
}
