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
    
    @IBOutlet weak var industryVw: UIView!
    @IBOutlet weak var indivisualVw: UIView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var grayDotView: UIView!
    @IBOutlet weak var jobActiveTimeLbl: UILabel!
    @IBOutlet weak var applicantBtn: UIButton!
    
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
        self.editBtn.layer.cornerRadius = 14.0
        self.editBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        self.titleLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        self.subTitleLbl_1.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.subTitleLbl_2.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.salaryLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.jobTimeLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
    }

    func setData(job: DashboardJob) {
        if let imageUrl = job.jobImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "jobLogoPlaceholder"))
        } else {
            self.profileImgVw.image = UIImage(named: "jobLogoPlaceholder")
        }

        self.titleLbl.text = job.jobTitle ?? ""
        self.subTitleLbl_1.text = job.position ?? ""
        self.subTitleLbl_2.text = job.location ?? ""
        self.salaryLbl.text = "£\(job.salary ?? 0)"
        self.jobTimeLbl.text = job.jobtype ?? ""
        
        let jobSaved = job.saved ?? 0
        if jobSaved == 0 {
            self.saveImgVw.image = UIImage(named: "save")
        } else {
            self.saveImgVw.image = UIImage(named: "save_selected")
        }
        
        self.industryVw.isHidden = true
        self.indivisualVw.isHidden = true
        
        if isIndivisualUser {
            print("Indivisual User")
            self.indivisualVw.isHidden = false
        } else {
            self.industryVw.isHidden = false
            applicantBtn.setTitle("\(job.applicationsCount ?? 0) Applicants", for: .normal)
            
            let status = job.isConnected ?? ""
            if status.lowercased() == "active" {
                grayDotView.isHidden = false
                jobActiveTimeLbl.text = job.value ?? ""
            } else {
                grayDotView.isHidden = true
                jobActiveTimeLbl.text = ""
            }
        }
    }
    
}
