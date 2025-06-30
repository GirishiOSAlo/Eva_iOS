//
//  HomeBannerCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 28/04/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HomeBannerCVC: UICollectionViewCell {
    
    @IBOutlet weak var requestJoinBtn: UIButton!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    private var gradientLayer: CAGradientLayer?
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        
        // Force layout pass before gradient setup
        DispatchQueue.main.async {
            self.shadowView.layoutIfNeeded()
            self.setupGradient()
        }
    }

    func initUI() {
        self.requestJoinBtn.layer.cornerRadius = 14.0
        self.viewDetailsBtn.layer.cornerRadius = 14.0
        self.viewDetailsBtn.layer.borderWidth = 1
        self.viewDetailsBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        
        self.titleLbl.font = UIFont(name: Myfonts.bold, size: 24.0)
        self.subtitleLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.dateLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.locationLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.timeLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        
        self.requestJoinBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        self.viewDetailsBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
    }
    
    private func setupGradient() {
        if gradientLayer == nil {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.frame = shadowView.bounds
            shadowView.layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
        }
    }
    
    private func updateGradientFrame() {
        gradientLayer?.frame = shadowView.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
}
