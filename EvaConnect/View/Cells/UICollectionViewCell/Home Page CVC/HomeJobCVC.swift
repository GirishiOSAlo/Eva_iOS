//
//  HomeJobCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 30/04/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HomeJobCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl_1: UILabel!
    @IBOutlet weak var subTitleLbl_2: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var jobTimeLbl: UILabel!
    
    @IBOutlet weak var saveImgVw: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var applyNowBtn: UIButton!
    @IBOutlet weak var viewDetailBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    func initUI() {
        self.baseView.layer.cornerRadius = 20.0
        self.profileImgVw.layer.cornerRadius = self.profileImgVw.frame.size.height / 2
        self.applyNowBtn.layer.cornerRadius = 14.0
        self.applyNowBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        self.viewDetailBtn.layer.cornerRadius = 14.0
        self.viewDetailBtn.layer.borderWidth = 1.0
        self.viewDetailBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        self.viewDetailBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        self.titleLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        self.subTitleLbl_1.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.subTitleLbl_2.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.salaryLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.jobTimeLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
    }

}
