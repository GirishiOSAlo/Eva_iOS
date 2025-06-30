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
    var editedJob: EditedJob?
    var jobApplicants: [JobApplicant] = []
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setLayout()
        getPostDetail()
        getJobApplicants()
    }
    
    //MARK: IBOutlet Action
    @IBAction func openEditVCAction(_ sender: Any) {
        GotoEditProfileV2()
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension PostedJobDetailVC {
    
    func setLayout() {
        applicantTableView.dataSource = self
        makeImageRound(view: profileImg,setBoader: true)
        applicantTableView.registerCell(withType: ApplicantCell.self)
        buttonCustomization(actionBtn: self.actionBtn,setClipsBound:false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
    }
    
    func setUIData(editedJob: EditedJob) {
        companyNameLbl.text = editedJob.jobTitle
        designationLbl.text = editedJob.jobSector
        applicantCount.text = "\(editedJob.applicantCount ?? 0) Applicants"
        jobContentLbl.text = editedJob.content
        lastActiveLbl.text = "Active for  \(editedJob.activeHours ?? 0) hr"
        profileImg.sd_setImage(with: URL(string: (editedJob.jobImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        
    }
}

// MARK: Network Calls
private extension PostedJobDetailVC {

     func getPostDetail() {
        
        let endPoint = EndPoints.getJobDetailById + "\(jobId!)/"
        showActivity()
        NetworkManagerr.request(endPoint) { (response) in
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let editedJobRoot = try jsonDecoder.decode(EditedJobRoot.self, from: response.data!)
                    if !editedJobRoot.error, editedJobRoot.data.count > 0 {
                        
                        self.editedJob = editedJobRoot.data[0]
                        self.setUIData(editedJob: editedJobRoot.data[0])
                        
                    }
                    
                } catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            }
        }
    }
    
     func getJobApplicants() {
        
        let parameters: AFParameters = [ "job_id": jobId! ]
        
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
        cell.designationLbl.text = "\(showDateForDisplay(date: bindData.createdDatetime!)) \(showTimeOnly(date: bindData.createdDatetime!))"
        if bindData.isHidden == 1 {
            cell.openViewBtn.setTitle("Hidden", for: .normal)
            cell.openViewBtn.setTitleColor(.darkGray, for: .normal)
            cell.giveButtonCorner(actionBtn: cell.openViewBtn,setClipsBound: false,borderColor: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1),addBorder: true)
        } else {
            cell.openViewBtn.setTitle("View", for: .normal)
            cell.openViewBtn.setTitleColor(.darkGray, for: .normal)
            cell.giveButtonCorner(actionBtn: cell.openViewBtn,setClipsBound: false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        }
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

extension PostedJobDetailVC {
    
    @objc func openInterViewVC(sender: UIButton) {
        //ApplicantAppliedVC
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ApplicantAppliedVC") as! ApplicantAppliedVC
        vc.jobApplicantDetail = jobApplicants[sender.tag]
        vc.jobID = jobId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func GotoEditProfileV2() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editJobPostV2") as! editJobPostV2
        vc.jobId = editedJob?.id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PostedJobDetailVC: refreshJobDetailCall {
    func refreshJobDetail(checkForCall: Bool, JobIdDetail: Int) {
        if checkForCall {
            getPostDetail()
        }
    }
}

