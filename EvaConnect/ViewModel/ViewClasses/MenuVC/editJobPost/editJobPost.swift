//
//  editJobPost.swift
//  EvaConnect
//
//  Created by Metis on 05/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import IHProgressHUD
import Alamofire
import URLEmbeddedView
import SDWebImage
import MobileCoreServices

class EditJobPostVC: BaseVC, refreshJobDetailCall {
    
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
    var jobId : Int? = 0
    var jobEditModeler : JobEditModel?
    var jobApplicantArray=[JobApplicant]()
    var sizeCheck = false
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        getPostDetail(jobId: jobId!)
        jobApplicantArray.removeAll()
        getApplicantData(jobId: jobId!)
    }
    //MARK: IBOutlet Action
    @IBAction func openEditVCAction(_ sender: Any) {
        GotoEditProfileV2()
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
           navigationController?.popViewController(animated: true)
       }
    //MARK: Custom Protocol
    func refreshJobDetail(checkForCall: Bool, JobIdDetail: Int) {
        if checkForCall == true {
            getPostDetail(jobId:JobIdDetail)
            print("Protocol Called")
        }
        else {
            print("No Protocol Call")
        }
    }
}
extension EditJobPostVC {
    //MARK: ApiCALLING
    
    //getAllApplicantForJobServiceFunc
    private func getPostDetail(jobId: Int) {
        
        let userDefaults = UserDefaults.standard
        let getUserData = BaseVC.GetUser()
        let getToken = userDefaults.value(forKey: "UserToken") as? String
        let userID = getUserData?.id
        let param: Parameters = [:]
        print("param:\(param)\n\(getToken!)\n\(userID!)")
        IHProgressHUD.show()
        
        ApiCallerClass.getJobDetailByIdServiceFunc(usertoken:getToken!, jobId: jobId,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? AllJobEditModel
            let error = data?.error
            
            IHProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            //self.resetBtn.isUserInteractionEnabled = true
            if error == false {
                for i in data!.data  {
                    self.jobEditModeler = i
                }
                self.setUIData(modelSetter: self.jobEditModeler)
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.makeAlert(messageData:data?.message ?? "")
               
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            IHProgressHUD.dismiss()
            print(error.localizedDescription)
            
            self.view.isUserInteractionEnabled = true
        }
    }
    private func getApplicantData(jobId: Int) {
        
        let userDefaults = UserDefaults.standard
        let getUserData = BaseVC.GetUser()
        let getToken = userDefaults.value(forKey: "UserToken") as? String
        let userID = getUserData?.id
        let param:Parameters = [
            "job_id" : jobId
        ]
        
        print("param:\(param)\n\(getToken!)\n\(userID!)")
        ApiCallerClass.getAllApplicantForJobServiceFunc(usertoken:getToken!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? AllApplicantModel
            let error = data?.error
            
            IHProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if error == false {
                for i in data!.data{
                    self.jobApplicantArray.append(i)
                }
                self.applicantTableView.reloadData()
                
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.makeAlert(messageData:data?.message ?? "")
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            IHProgressHUD.dismiss()
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
        }
    }
    
}
extension EditJobPostVC: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    //MARK: TABLEVIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobApplicantArray.count == 0 {
            applicantTableView.isHidden = true
        }
        else {
            applicantTableView.isHidden = false
        }
        return jobApplicantArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if jobApplicantArray.count != 0 {
            var bindData = jobApplicantArray[indexPath.row]
            let cell = applicantTableView.dequeueReusableCell(withIdentifier: ApplicantCell.id(), for: indexPath) as! ApplicantCell
            cell.userNameLbl.text = "\(bindData.user?.firstName ?? "") \(bindData.user?.lastName ?? "")"
            cell.designationLbl.text = "\(showDateForDisplay(date: bindData.createdDatetime!)) \(showTimeOnly(date: bindData.createdDatetime!))"
            if bindData.isHidden == 1 {
                cell.openViewBtn.setTitle("Hidden", for: .normal)
                cell.openViewBtn.setTitleColor(.darkGray, for: .normal)
                cell.giveButtonCorner(actionBtn: cell.openViewBtn,setClipsBound: false,borderColor: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1),addBorder: true)
            }
            else {
                cell.openViewBtn.setTitle("View", for: .normal)
                cell.openViewBtn.setTitleColor(.darkGray, for: .normal)
                cell.giveButtonCorner(actionBtn: cell.openViewBtn,setClipsBound: false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
            }
            cell.openViewBtn.tag = indexPath.row
            cell.openViewBtn.addTarget(self, action:#selector(openInterViewVC(sender:)), for: .touchUpInside)
            if bindData.user?.userImage != nil{
                cell.profileImg!.sd_setImage(with: URL(string: (bindData.user?.userImage!)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
                
            } else{
                cell.profileImg.image = #imageLiteral(resourceName: "noImage")
            }
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    //MARK: LAYOUT SETTING
    func setLayout() {
        applicantTableView.delegate = self
        applicantTableView.dataSource = self
        makeImageRound(view: profileImg,setBoader: true)
        applicantTableView.registerCell(withType: ApplicantCell.self)
        buttonCustomization(actionBtn: self.actionBtn,setClipsBound:false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
    }
    
    //MARK: Custom Action
    @objc func openInterViewVC(sender: UIButton) {
        //ApplicantAppliedVC
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ApplicantAppliedVC") as! ApplicantAppliedVC
        vc.jobApplicantDetail = jobApplicantArray[sender.tag]
        vc.jobID = jobId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: LAYOUT DATA SETTING
    func setUIData(modelSetter: JobEditModel?){
        if !modelSetter.isNil {
            companyNameLbl.text = modelSetter?.jobTitle
            designationLbl.text = modelSetter?.jobSector
            applicantCount.text = "\(modelSetter?.applicantCount ?? 0) Applicants"
            jobContentLbl.text = modelSetter?.content
            lastActiveLbl.text = "Active for  \(modelSetter?.activeHours ?? 0) hr"
            profileImg.sd_setImage(with: URL(string: (modelSetter?.jobImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
         
        }
    }
    
    @objc func GotoEditProfileV2(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editJobPostV2") as! editJobPostV2
        vc.jobId = jobEditModeler?.id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

