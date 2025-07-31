//
//  FollowersCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 08/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class FollowersCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    
    @IBOutlet weak var unfollowVw: UIView!
    @IBOutlet weak var unfollowBtn: UIButton!
    @IBOutlet weak var followVw: UIView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var acceptrejectVw: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var gotoProfileBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.baseView.cornerRadius = 20.0
        self.profileImgVw.cornerRadius = self.profileImgVw.frame.size.height / 2
        self.nameLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.designationLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.companyLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        
        self.followBtn.cornerRadius = 12.0
        self.followBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.unfollowBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 12.0)
        self.unfollowBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
    }
    
    func setData(obj: Follower) {
        self.nameLbl.text = obj.firstName
        self.designationLbl.text = obj.designation
        self.companyLbl.text = obj.companyName
        
        if let imageUrl = obj.imageURL,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.profileImgVw.image = UIImage(named: "profile")
        }
        
        self.followVw.isHidden = true
        self.unfollowVw.isHidden = true
        self.acceptrejectVw.isHidden = true
        
        if obj.action == "follow" {
            self.followVw.isHidden = false
        }
        else if obj.action == "unfollow" {
            self.unfollowVw.isHidden = false
        }
        else {
            self.acceptrejectVw.isHidden = false
        }
    }
}
