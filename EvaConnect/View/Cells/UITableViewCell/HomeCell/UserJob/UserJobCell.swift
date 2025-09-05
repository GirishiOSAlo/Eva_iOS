//
//  UserJobCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/7/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

class UserJobCell: UITableViewCell {
    
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var positionNameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var contractLbl: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var indivisualViewStack: UIStackView!
    
    @IBOutlet weak var grayDotView: UIView!
    @IBOutlet weak var saveJobBtn: UIButton!
    @IBOutlet weak var indivisualVw: UIView!
    @IBOutlet weak var industryView: UIView!
    @IBOutlet weak var industryJobDescLbl: UILabel!
    @IBOutlet weak var jobActiveTimeLbl: UILabel!
    @IBOutlet weak var applicantBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var baseMainView: UIView!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var applyNowBtn: UIButton!
    @IBOutlet weak var applyNowBtnHeight: NSLayoutConstraint!
    
    var goToAd: ((DashboardItem) -> Void)? = nil
    
    var job: DashboardItem! {
        didSet {
//            positionNameLbl.text = job.jobTitle ?? ""
//            companyNameLbl.text = job.position ?? ""
//            jobImageView.sd_setImage(with: URL(string: job.tempImage ?? ""), placeholderImage: UIImage(named: "profile")!)
//            salaryLbl.text = "£\(job.salary ?? 0)"
//            locationLbl.text = job.location ?? ""
//            contractLbl.text = job.jobtype?.rawValue ?? ""
//            job.saved == 1 ? saveJobBtn.setImage(UIImage(named: "save_selected"), for: .normal) : saveJobBtn.setImage(UIImage(named: "save"), for: .normal)
//            grayDotView.isHidden = false
//            if !isIndivisualUser {
//                grayDotView.isHidden = true
//                jobActiveTimeLbl.text = job.value
//                applicantBtn.setTitle("\(job.applicationsCount ?? "") Applicants", for: .normal)
//                industryJobDescLbl.text = job.content
//                jobImageView.sd_setImage(with: URL(string: job.image ?? ""), placeholderImage: UIImage(named: "profile")!)
//            }
        }
    }
    
    func setData(data: DashboardJob) {
        positionNameLbl.text = data.jobTitle ?? ""
        companyNameLbl.text = data.position ?? ""
        jobImageView.sd_setImage(with: URL(string: data.jobImage ?? ""), placeholderImage: UIImage(named: "profile")!)
        salaryLbl.text = "\(data.currencySymbol ?? "£") \(data.salary ?? 0)"
        locationLbl.text = data.location ?? ""
        contractLbl.text = data.jobtype ?? ""
        if data.saved == 1 {
            saveJobBtn.setImage(UIImage(named: "save_selected"), for: .normal)
        } else {
            saveJobBtn.setImage(UIImage(named: "save"), for: .normal)
        }
        
        if isIndivisualUser {
            print("Indivisual User")
        } else {
            applicantBtn.setTitle("\(data.applicationsCount ?? "") Applicants", for: .normal)
            industryJobDescLbl.text = data.description ?? ""
            jobActiveTimeLbl.text = data.value ?? ""
            let value = data.value ?? ""
            if value == "" {
                grayDotView.isHidden = true
            } else {
                grayDotView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseMainView.dropShadow()
        applyNowBtn.layer.cornerRadius = 14
        applyNowBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        editBtn.layer.cornerRadius = 14
        editBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        viewDetailsBtn.layer.cornerRadius = 14
        viewDetailsBtn.layer.borderWidth = 1
        viewDetailsBtn.layer.borderColor = AppColors.appBlue.cgColor
        viewDetailsBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        jobActiveTimeLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        applicantBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
    }
        
    @IBAction func addBtnTapped(_ sender: Any) {
        if let goToAd = goToAd { goToAd(job) }
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        
    }
}

extension UserJobCell: Dequeueable {
    static func id() -> String { String(describing: self) }
    static func hasNib() -> Bool { true }
}
