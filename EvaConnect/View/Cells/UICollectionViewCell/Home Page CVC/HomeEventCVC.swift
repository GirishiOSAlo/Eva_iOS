//
//  HomeEventCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 29/04/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HomeEventCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var saveImgVw: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    @IBOutlet weak var detailNavigateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    func initUI() {
        self.baseView.layer.cornerRadius = 20.0
        self.viewDetailsBtn.layer.cornerRadius = 14.0
        
        self.titleLbl.font = UIFont(name: Myfonts.semiBold, size: 14.0)
        self.dateLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.locationLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.timeLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.saveBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
    }
}
