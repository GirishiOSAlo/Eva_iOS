//
//  UserApplyJobVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/10/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage
import MobileCoreServices
import Alamofire
import SafariServices
import Lottie

protocol SelectedResumePassingDelegate: AnyObject {
    func didPassData(_ data: ResumeData)
}

class UserApplyJobVC: BaseVC {
    
//    @IBOutlet weak var uploadWidthConst: NSLayoutConstraint!
//    @IBOutlet weak var uploadCVBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var successLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var pdfImgView: UIImageView!
    @IBOutlet weak var pdfImgWidthConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var coverLetterTxt: UITextView!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var positionNameLbl: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var jobPeriodLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var jobTimeLbl: UILabel!
    
    @IBOutlet weak var profileMainView: UIView!
    @IBOutlet weak var coverLaterBaseVw: UIView!
    
    @IBOutlet weak var successResumeBaseVw: UIView!
    @IBOutlet weak var uploadResumeBaseVw: UIView!
    
    @IBOutlet weak var applyJobSuccessPopupVw: UIView!
    @IBOutlet weak var subPopupView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var animationContainerView: UIView!
    
    
    var animationView: LottieAnimationView!
    private var cvDocumentURL: URL? = nil
//    var job: DashboardItem?
    var dashboardJob: DashboardJob?
    var job: JobDetailsData?
    private var jobSuccessAlert: JobApplicationAlert!
    
    var jobApplicantDetail: JobApplicant?
    var jobDetail: JobDetail?
    var jobId: Int?
    var isCVUploaded = false
    var selectedResume: ResumeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUserData()
        setupUI()
    }
    
    func setupUI(){
        isSeparatorHidden = true
        self.navigationController?.isNavigationBarHidden = true
        submitBtn.layer.cornerRadius = 14

        self.profileMainView.layer.cornerRadius = 13
        self.coverLaterBaseVw.layer.cornerRadius = 13
        self.uploadResumeBaseVw.layer.cornerRadius = 13
        self.successResumeBaseVw.layer.cornerRadius = 13
        
        coverLetterTxt.delegate = self
        coverLetterTxt.textColor = .lightGray
        self.coverLetterTxt.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        self.applyJobSuccessPopupVw.isHidden = true
        self.subPopupView.layer.cornerRadius = 13
        self.okButton.layer.cornerRadius = self.okButton.frame.size.height/2
        
        self.successResumeBaseVw.isHidden = true
        self.uploadResumeBaseVw.isHidden = false
        
        
//        uploadCVBtn.setTitle("", for: .normal)
//        uploadCVBtn.setImage(UIImage(named: "addInvite"), for: .normal)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        pdfImgView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        if let docURL = cvDocumentURL {
            let webVC = WebVC(url: docURL)
            present(webVC, animated: true, completion: nil)
        }
    }
    
    func addAnimation(){
        self.applyJobSuccessPopupVw.isHidden = false
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animationView.center = animationContainerView.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit

        animationContainerView.addSubview(animationView)

        animationView.play()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.jobId ?? 0
        vc.type = .job
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        //if cvDocumentURL == nil {
        if selectedResume == nil {
            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please attach resume")
        } else if coverLetterTxt.textColor == .lightGray {
            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please enter someting in cover letter")
        } else {
            submitBtn.isUserInteractionEnabled.toggle()
            applyJob()
            //applyForJob()
        }
    }
    
    
    @IBAction func onCancelBtnTap(_ sender: UIButton) {
        print("Cancel uploaded resume....")
        self.successResumeBaseVw.isHidden = true
        self.uploadResumeBaseVw.isHidden = false
        
        self.selectedResume = nil
        self.fileNameLbl.text = "--"
    }
    
    @IBAction func onOkBtnTapped(_ sender: UIButton) {
        self.applyJobSuccessPopupVw.isHidden = true
        self.animationView.stop()
        self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
    }
    
    @IBAction func uploadCVBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(storyboard: .jobs).instantiateViewController(withIdentifier: "UploadCVVC") as! UploadCVVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
////        if uploadWidthConst.constant == 130 {
////            if let url = URL(string: jobApplicantDetail?.applicationAttachment ?? "") {
////                present(SFSafariViewController(url: url), animated: true, completion: nil)
////            }
////        } else {
//        if !isCVUploaded{
//            openFile()
//        } else {
//            cvDocumentURL = nil
//            fileNameLbl.text = "Upload Resume*"
//            fileNameLbl.isHidden = false
//            successLbl.isHidden = true
//            pdfImgWidthConst.constant = 0
//            uploadCVBtn.setTitle("", for: .normal)
//            uploadCVBtn.setImage(UIImage(named: "addInvite"), for: .normal)
//            isCVUploaded = false
//        }
////        }
    }
}

extension UserApplyJobVC: SelectedResumePassingDelegate {
    func didPassData(_ data: ResumeData) {
        self.successResumeBaseVw.isHidden = false
        self.uploadResumeBaseVw.isHidden = true
        
        self.selectedResume = data
        self.fileNameLbl.text = data.title ?? "--"
    }
}

extension UserApplyJobVC {
    
    private func applyUserData() {
        
        if let job = job {
            jobTitle.text = job.jobTitle ?? ""
            positionNameLbl.text = job.position ?? ""
            salaryLbl.text = "£\(job.salary ?? 0)"
            locationLbl.text = job.location ?? ""
            jobTimeLbl.text = job.jobtype ?? ""
            jobImageView.sd_setImage(with: URL(string: job.user?.userImage ?? ""), placeholderImage: UIImage(named: "profile")!)
            jobSuccessAlert = JobApplicationAlert(type: .application)
        }
        else if let job = dashboardJob {
            jobTitle.text = job.jobTitle ?? ""
            positionNameLbl.text = job.position ?? ""
            locationLbl.text = job.location ?? ""
            salaryLbl.text = "£\(job.salary ?? 0)"
            jobTimeLbl.text = job.jobtype ?? ""
            jobImageView.sd_setImage(with: URL(string: job.jobImage ?? ""), placeholderImage: UIImage(named: "profile")!)
            jobSuccessAlert = JobApplicationAlert(type: .application)
        }
//        else if let applicant = jobApplicantDetail, let job = jobDetail {
//            jobTitle.text = job.jobTitle ?? ""
//            positionNameLbl.text = job.position ?? ""
//            jobImageView.sd_setImage(with: URL(string: applicant.user?.userImage ?? ""), placeholderImage: UIImage(named: "profile")!)
//            coverLetterTxt.text = applicant.content ?? ""
//            fileNameLbl.text = URL(string: applicant.applicationAttachment ?? "")?.lastPathComponent ?? ""
////            uploadCVBtn.setTitle("Download CV", for: .normal)
////            uploadWidthConst.constant = 130
//            coverLetterTxt.textColor = .black
//            coverLetterTxt.isEditable = false
//            submitBtn.isHidden = true
//            fileNameLbl.isHidden = false
//        }
        
    }
    
    func encodeToBase64(reqURL: URL) -> String? {
        if FileManager.default.fileExists(atPath: reqURL.path) {
            // The file exists, proceed with encoding
            do {
                let myData = try Data(contentsOf: reqURL)
                let base64String = myData.base64EncodedString()
                return base64String
            } catch {
                print("Error encoding video to base64: \(error)")
                return nil
            }
        } else {
            print("File does not exist at: \(reqURL.path)")
            return nil
        }
    }
    
}

extension UserApplyJobVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trim.isEmpty {
            textView.text = "Enter something"
            textView.textColor = .lightGray
        }
    }
    
}

extension UserApplyJobVC: UIDocumentPickerDelegate {
    private func openFile() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypeCompositeContent]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        cvDocumentURL = url
        fileNameLbl.text = url.lastPathComponent
        fileNameLbl.isHidden = false
        successLbl.isHidden = false
        pdfImgWidthConst.constant = 40
//        uploadCVBtn.setTitle("Cancel", for: .normal)
//        uploadCVBtn.setImage(nil, for: .normal)
        isCVUploaded = true
    }
    
}

extension UserApplyJobVC {
    
    func applyJob() {
        let parameters = [ "created_by_id" : myUserDefaults.userId,
                           "status": 2,
                           "job_id": jobId ?? 0,
                           "resume_id": "\(self.selectedResume?.id ?? 0)",
                           "platform": "iOS",
                           "content": coverLetterTxt.text ?? ""] as [String: Any]
        print(parameters)
        showActivity()
        NetworkManagerr.request(EndPoints.applyForJob, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let applyJobRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(applyJobRoot.error) {
                    print("Success :: \(applyJobRoot.message)")
                    self.addAnimation()
                } else {
                    print("Error :: \(applyJobRoot.message)")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    private func applyForJob(){
        
        guard coverLetterTxt.text != "" else {
            presentAlert("Alert", "Cover letter is mandatory")
            return
        }
        
        var parameters: Parameters = [ "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                       "status": 1, //"active",
                                       "job_id": jobId ?? 0,
                                       "content": coverLetterTxt.text ?? ""]
        
        if let myDocUrl = cvDocumentURL {
            let base64Doc = encodeToBase64(reqURL: myDocUrl)
            parameters["application_attachment"] = "data:application/pdf;base64,\(base64Doc ?? "")"
        } else {
            presentAlert("Alert", "Please Upload Your Resume")
            return
        }

        self.showActivity()
        
        NetworkManagerr.request(EndPoints.applyForJob, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                
                if !genericResponse.error, genericResponse.message == "creation_success" {
                    
//                    self.showToast(message: "Shared successfully")
                    self.addAnimation()
                } else {
//                    self.addAnimation()
                    self.presentAlert("Failure", genericResponse.message, nil)
                }
            }
            
        }
//        Alamofire.upload(multipartFormData: { (multiFormData) in
//
//            for (key, value) in parameters {
//                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//            let pdfData = try? Data(contentsOf: self.cvDocumentURL!)
//            multiFormData.append(pdfData!, withName: "application_attachment", fileName: self.cvDocumentURL!.lastPathComponent, mimeType: "pdf")
//
//        }, to: EndPoints.applyForJob, method: .post, headers: SharedHeaders.headers) { (result) in

//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    //Print progress
//                    print("uploading \(progress)")
//                })
//
//                upload.responseJSON { (response) in
//                    self.hideActivity()
//                    self.submitBtn.isUserInteractionEnabled.toggle()
//                    if response.result.isSuccess {
//                        let jsonDecoder = JSONDecoder()
//                        let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
//
//                        if let genericResponse = genericResponse, !genericResponse.error {
//                            self.jobSuccessAlert.showAlert()
//                            self.jobSuccessAlert.okAction = { [weak self] in
//                                self?.navigationController?.popToRootViewController(animated: true)
//                            }
//                        }
//                        else {
//                            self.presentAlert("Failure", nil, response.result.error)
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print (error.localizedDescription)
//            }
//        }
        
    }
}
