//
//  editJobPost.swift
//  EvaConnect
//
//  Created by Metis on 05/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class PostedJobDetailVC: BaseVC {
    
    //MARK: OutLets
    @IBOutlet weak var jobInfoView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var applicantCount: UILabel!
    @IBOutlet weak var jobContentLbl: UILabel!
    @IBOutlet weak var lastActiveLbl: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var applicantTableView: UITableView!
    @IBOutlet var boderView: UIView!
    
    //MARK: Variables
    var jobId: Int?
    var jobDetail: JobDetail?
    var jobApplicants: [JobApplicant] = []
    var userImage: String = ""
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isSeparatorHidden = true
        setLayout()
//        getPostDetail()
//        getJobApplicants()
    }
    
    //MARK: IBOutlet Action
    @IBAction func openEditVCAction(_ sender: Any) {
        navigateToEditJobDetailVC()
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension PostedJobDetailVC {
    
    func setLayout() {
        applicantTableView.dataSource = self
        applicantTableView.delegate = self
        makeImageRound(view: profileImg,setBoader: true)
        applicantTableView.registerCell(withType: ApplicantCell.self)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
    }
    
    func updateUI(jobDetail: JobDetail) {
        jobInfoView.isHidden = false
        companyNameLbl.text = jobDetail.jobTitle
        designationLbl.text = jobDetail.jobSector
        applicantCount.text = "\(jobDetail.applicantCount ?? 0) Applicants"
        jobContentLbl.text = jobDetail.content
        lastActiveLbl.text = "Active for \(jobDetail.activeHours ?? 0) days"
        profileImg.sd_setImage(with: URL(string: userImage), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        
    }
}

// MARK: Network Calls
private extension PostedJobDetailVC {

     func getPostDetail() {
        
         getJobDetial(jobId: jobId ?? 0) { (jobDetail, error) in
            if let job = jobDetail {
                self.jobDetail = job
                self.updateUI(jobDetail: job)
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
     func getJobApplicants() {
        
        let parameters: AFParameters = [ "job_id": jobId ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.getAllJobApplicant, method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let jobApplicantsRoot = try jsonDecoder.decode(JobApplicantsRoot.self, from:response.data!)
                    
                    if !jobApplicantsRoot.error, jobApplicantsRoot.data.count > 0 {
                        
                        self.jobApplicants = jobApplicantsRoot.data
                        self.applicantTableView.reloadData()
                    }
                    
                } catch {
                    self.presentAlert("failure", nil, error)
                }
            }
        }
    }
}

extension PostedJobDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobApplicants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bindData = jobApplicants[indexPath.row]
        let cell = applicantTableView.dequeueReusableCell(withIdentifier: ApplicantCell.id(), for: indexPath) as! ApplicantCell
        cell.userNameLbl.text = "\(bindData.user?.firstName ?? "") \(bindData.user?.lastName ?? "")"
        cell.designationLbl.text = "\(bindData.createdDatetime!.dateOnly()) \(showTimeOnly(date: bindData.createdDatetime!))"
        cell.openViewBtn.setTitle(bindData.isHidden == 1 ? "Hidden" : "View", for: .normal)
        cell.openViewBtn.tag = indexPath.row
        cell.openViewBtn.addTarget(self, action:#selector(openInterViewVC(sender:)), for: .touchUpInside)
        if bindData.user?.userImage != nil{
            cell.profileImg!.sd_setImage(with: URL(string: (bindData.user?.userImage!)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            
        } else {
            cell.profileImg.image = #imageLiteral(resourceName: "noImage")
        }
        return cell
    }
    
}

extension PostedJobDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
}

extension PostedJobDetailVC {
    
    @objc func openInterViewVC(sender: UIButton) {
        let vc = StoryboardRouter.userApplyJob()
        vc.jobApplicantDetail = jobApplicants[sender.tag]
        vc.jobId = jobId
        vc.jobDetail = jobDetail
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToEditJobDetailVC() {
       
        let editPostedJob = StoryboardRouter.createEditJobPost()
        editPostedJob.jobId = jobDetail?.id
        editPostedJob.roleType = .edit
        editPostedJob.delegate = self
        self.navigationController?.pushViewController(editPostedJob, animated: true)
    }
}

extension PostedJobDetailVC: RefreshUpdateable {
    func refresh(homeStatus: Bool) {
        getPostDetail()
        
    }
}

