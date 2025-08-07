//
//  CompanyJobList.swift
//  EvaConnect
//
//  Created by Metis on 05/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class CompanyJobCell: BaseCellClass {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var applicantsCount: UILabel!
    @IBOutlet weak var jobContent: UILabel!
    @IBOutlet weak var lastActive: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet weak var openJobDetailBtn: UIButton!
    @IBOutlet var shadowView: UIView!
    
    var edit:((DashboardItem) -> Void)? = nil
    var goToAd:((JobListModel) -> Void)? = nil
    
    var job: CompanyJobs! {
        didSet {
            companyName.text = job.jobTitle
            designation.text = job.jobSector
            applicantsCount.text = "\(job.applicantCount ?? 0) Applicants"
            lastActive.text = "Active for \(job.activeHours ?? 0) days"
            jobContent.text = job.content
            if let image = job.jobImage, let url = URL(string: image) {
                profileImg.kf.indicatorType = .activity
                profileImg.kf.setImage(with: url)
            }
        }
    }
    
    var item: DashboardItem! {
        didSet {
//            companyName.text = item.jobTitle
//            designation.text = item.jobSector
//            applicantsCount.text = "\(item.applicantCount ?? 0) Applicants"
//            lastActive.text = "Active for \(item.activeHours ?? 0) days"
            jobContent.text = item.content
            if let image = item.user?.userImage, let url = URL(string: image) {
                profileImg.kf.indicatorType = .activity
                profileImg.kf.setImage(with: url)
            }
        }
    }
    
    var jobList: JobListModel! {
        didSet {
            
            companyName.text = jobList.jobTitle
            designation.text = jobList.jobSector
            applicantsCount.text = "\(jobList.applicantCount ) Applicants"
            lastActive.text = "Active for \(jobList.weeklyHours ?? "0") hrs"
            editButton.setTitle("Go to ad", for: .normal)
            jobContent.text = jobList.content
            if let image = jobList.jobImage, let url = URL(string: image) {
                profileImg.kf.indicatorType = .activity
                profileImg.kf.setImage(with: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        giveButtonCorner(actionBtn: editButton, setClipsBound: false, borderColor: Constants.AppColorLiteral.loginByNew, addBorder: true)
        //makeImageRound(view: profileImg, ConnerByHeight: false)
        shadowView.viewDropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        if let edit = edit, let item = item { edit(item) }
        else if let goToAd = goToAd, let jobList = jobList { goToAd(jobList) }
    }
}

extension CompanyJobCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
extension UIView {
    func viewDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

}
