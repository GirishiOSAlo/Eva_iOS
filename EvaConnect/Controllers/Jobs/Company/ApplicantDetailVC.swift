//
//  ApplicantAppliedVC.swift
//  EvaConnect
//
//  Created by Metis on 09/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import MobileCoreServices

class ApplicantDetailVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var jobImageContainerView: UIView!
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDetailTF: UITextView!

    @IBOutlet weak var applicantProfileImage: UIImageView!
    @IBOutlet weak var applicantName: UILabel!
    @IBOutlet weak var applicantTimeLbl: UILabel!
    @IBOutlet weak var applicantCoverTV: UITextView!
    @IBOutlet weak var totalApplicants: UILabel!
    @IBOutlet weak var activeTimeLbl: UILabel!
    @IBOutlet weak var userDesignationLbl: UILabel!
    @IBOutlet weak var editJobBtn: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var offerInterviewBtn: UIButton!
    @IBOutlet weak var declineInterviewBtn: UIButton!
    
    @IBOutlet var userImageContainerView: UIView!
    @IBOutlet var applicantView: UIView!

    
    //MARK: VARIABLES
    var jobApplicantDetail: JobApplicant!
    var jobDetails: JobDetail?
    var pdfURL: URL?
    var jobID: Int?
    var checkHidden = 0
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getJobDetail()
        self.getApplicantDetail()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? ChatVC, let user = sender as? User {
//            chatVC.user = user
        }
    }
}

// MARK: IB Actions
extension ApplicantDetailVC {
    
    @IBAction func openEditVC(_ sender: Any) {
        navigateToEditJobDetails()
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func offerInterviewAction(_ sender: Any) {
        connectionRequest()
        //postInterViewDetails()
    }
    
    @IBAction func declineAction(_ sender: Any) {
        cancelInterview(hiddenValue: checkHidden)
    }
    
    @IBAction func openCVAction(_ sender: Any) {
         openWebVC()
     }
}

extension ApplicantDetailVC {
    
    func setLayout() {
          makeImageRound(view: jobImage,setBoader: true)
          makeImageRound(view: applicantProfileImage,setBoader: true)
          buttonCustomization(actionBtn: declineInterviewBtn,setClipsBound:false,giveShadow:false,borderColor: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1),addBorder: true)
          buttonCustomization(actionBtn: offerInterviewBtn,setClipsBound:false,giveShadow:false,borderColor: #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1),addBorder: true)
          buttonCustomization(actionBtn: editJobBtn,setClipsBound:false,giveShadow:true,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
          jobImageContainerView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
          userImageContainerView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
      }
    
    func updateUI(jobApplicant: JobApplicant) {
        
        applicantName.text = jobApplicant.user?.firstName
        let getFullTimeStamp = "Applied (\(timeAgo2(jobApplicant.createdDatetime!)) ago)"
        applicantTimeLbl.text = getFullTimeStamp
        let urlData = URL(string: jobApplicant.applicationAttachment!)
        let components = URLComponents(url: urlData!, resolvingAgainstBaseURL: false)
        print(components!)
        let file = jobApplicant.applicationAttachment!
        let fileNameWithoutExtension = file.fileName()
        let fileExtension = file.fileExtension()
        let fileName = "\(fileNameWithoutExtension).\(fileExtension)"
        fileNameLbl.text = fileName
        applicantCoverTV.text = jobApplicant.content
        applicantProfileImage.sd_setImage(with: URL(string: (jobApplicant.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        if jobApplicant.isHidden == 0 {
            declineInterviewBtn.setTitle("Hide", for: .normal)
            checkHidden = 1
            applicantView.alpha = 1
            offerInterviewBtn.isHidden = false
        } else {
            declineInterviewBtn.setTitle("Hidden", for: .normal)
            checkHidden = 0
            applicantView.alpha = 0.75
            offerInterviewBtn.isHidden = true
        }
    }

    func updateUI(jobDetail: JobDetail) {
        
        jobTitle.text = jobDetail.jobTitle
        userDesignationLbl.text = jobDetail.jobSector ?? "no designation"
        totalApplicants.text = "\(jobDetail.applicantCount ?? 0) Applicants"
        jobDetailTF.text = jobDetail.content
        activeTimeLbl.text = "Active for  \(jobDetail.activeHours ?? 0) hr"
        jobImage.sd_setImage(with: URL(string: (jobDetail.jobImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
    }
}

// MARK: Network Calls
extension ApplicantDetailVC {
    
    func getApplicantDetail() {
        
        let endPoint = EndPoints.getApplicantDetail + "\(jobApplicantDetail.id)/"

        NetworkManagerr.request(endPoint) { (response) in
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let jobApplicantsRoot = try jsonDecoder.decode(JobApplicantsRoot.self, from: response.data!)
                    if !jobApplicantsRoot.error, jobApplicantsRoot.data.count > 0 {
                        
                        self.jobApplicantDetail = jobApplicantsRoot.data[0]
                        self.updateUI(jobApplicant: self.jobApplicantDetail)
                    }
                    
                } catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.result.error)
            }
        }
    }

    func connectionRequest() {
        
        let parameters = [ "sender_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                           "status":"active",
                           "receiver_id": jobApplicantDetail?.user?.id ?? 0] as [String : Any]
        
        let url = String(format: "%@%@", EndPoints.baseURL, "user/connection/")

        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                let jsonDecoder = JSONDecoder()
                let connectionResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if let connectionResponse = connectionResponse {
                    self.performSegue(withIdentifier: Constants.Segues.chat, sender: self.jobApplicantDetail?.user!)
                    print(connectionResponse.message)
                }
            }
        }
    }
    
    private func getJobDetail() {
        
         getJobDetial(jobId: jobID!) { (editedJob, error) in
            if let job = editedJob {
                self.updateUI(jobDetail: job)
            }

            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    private func cancelInterview(hiddenValue: Int) {

        let parameters: AFParameters = [ "modified_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                       "is_hidden": hiddenValue,
                                       "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        
        showActivity()
        
        let endPoint = EndPoints.declineApplicant + "\(jobApplicantDetail.id)/"
        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                let jsonDecoder = JSONDecoder()
                let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if let genericResponse = genericResponse, !(genericResponse.error) {
                    // check if the response is okay. proceed
                    self.getApplicantDetail()
                    self.presentAlert("Success", "Details Updated", nil)
                    
                }
            }
        }
    }
}

extension ApplicantDetailVC {
    
    func openWebVC() {
        if let urlString = jobApplicantDetail?.applicationAttachment, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            webVC.modalPresentationStyle = .formSheet
            present(webVC, animated: true, completion: nil)
        }
    }
    
    @objc func navigateToEditJobDetails() {
        
        let editPostedJob = StoryboardRouter.createEditJobPost()
        editPostedJob.jobId = jobDetails?.id
        editPostedJob.roleType = .edit
        navigationController?.pushViewController(editPostedJob, animated: true)
    }
}

//MARK: DocumentPicker Delegate
extension ApplicantDetailVC: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedUrl = urls.first else {
            return
        }
        let dir = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first!
        let sandboxFileUrl = dir.appendingPathComponent(selectedUrl.lastPathComponent)
        pdfURL = sandboxFileUrl
        openWebVC()
    }
}
