//
//  UserJobListingVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/10/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class UserJobListingVC: BaseVC {

    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var jobContent: UITextView!
    @IBOutlet weak var jobPeriodLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var positionNameLbl: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var saveImgVw: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backBaseView: UIView!
    
//    var job: DashboardJob?
    var jobDetails: JobDetailsData?
    var jobId: Int = 0
//    var objectId: Int = 0
    private var isFav = false
    private var favJobId: Int? = nil
    private var favJobCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSeparatorHidden = true
        backBaseView.layer.cornerRadius = 12
        shareButton.layer.cornerRadius = self.shareButton.frame.size.height/2
        applyBtn.layer.cornerRadius = 14
//        initUI()
        self.fetchJobDetails(jobID: self.jobId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
//        if job?.isApplied == 0 {
//            let vc = StoryboardRouter.userApplyJob()
//            vc.job = job
//            vc.jobId = job?.id
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            showToastWithLogo(message: "You have already applied for this job.")
//        }
    }
    
    @IBAction func starBtnTapped(_ sender: Any) {
        showActivity()
        let param: AFParameters = [ "job_id": self.jobId]
        
        ApiCallerClass.saveJobServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                print("Job saved!!")
                self.fetchJobDetails(jobID: self.jobId)
//                self.getJobListingData(jobId: self.objectId)
            }
            else {
                print("Job error!!",error as Any)
            }
        })
        { (error) in
            self.hideActivity()
        }
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.jobId
        vc.type = .job
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
}

extension UserJobListingVC {
    
//    private func initUI() {
//        if let jobId = jobId {
////            applyBtn.isHidden.toggle()
//            scrollContentView.isHidden.toggle()
//            getJobListingData(jobId: jobId)
//        } else {
//            applyUserData()
//            //checkIsFavourite()
//        }
//        self.fetchJobDetails(jobID: self.jobId)
//    }
//    
//    private func applyUserData() {
//        jobTitle.text = job?.jobTitle ?? ""
//        positionNameLbl.text = job?.position ?? ""
//        jobImageView.sd_setImage(with: URL(string: job?.jobImage ?? ""), placeholderImage: UIImage(named: "profile")!)
//        salaryLbl.text = "£\(job?.salary?.format ?? "0")"
//        locationLbl.text = "\(job?.jobSector ?? ""), \(job?.location ?? "")"
//        jobPeriodLbl.text = job?.jobtype ?? ""
//        jobContent.text = job?.content
//        saveImgVw.image = job?.saved == 1 ? UIImage(named: "save_selected") : UIImage(named: "save")
////        starBtn.setImage(UIImage(named: "ic_star_tint"), for: .normal)
//    }
    
    func setData(data: JobDetailsData?) {
        self.jobTitle.text = data?.jobTitle ?? "--"
        self.positionNameLbl.text = data?.position ?? "--"
        self.locationLbl.text = data?.location ?? "--"
        self.jobImageView.sd_setImage(with: URL(string: data?.jobImage ?? ""), placeholderImage: UIImage(named: "profile")!)
        
        self.salaryLbl.text = "£\(data?.salary ?? 0)"
        self.jobPeriodLbl.text = data?.jobtype ?? "--"
        self.jobContent.text = data?.content ?? "--"
        
        saveImgVw.image = data?.saved == 1 ? UIImage(named: "save_selected") : UIImage(named: "save")
    }
}

extension UserJobListingVC {
    
//    private func checkIsFavourite() {
//        let params: Parameters = ["user_id": "\(LoggedUserDetails.shared.user?.id)", "status": "active", "job_id": "\(job?.id)"]
//        guard let url = params.getURL(EndPoints.jobFavourite) else { return }
//        showActivity()
//        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[JobFavourite]>>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            switch result {
//            case .success(let rsl):
//                if rsl.error {
//                    self.presentAlert("Error", rsl.message, nil)
//                } else if let last = rsl.data.last {
//                    self.isFav = last.isFavourite ?? false
//                    self.favJobId = last.id
////                    self.starBtn.setImage(UIImage(named: self.isFav ? "ic_star_selected" : "ic_star_tint"), for: .normal)
//                    self.favJobCreated = true
//                }
//            case .failure(let err):
//                self.presentAlert("Error", nil, err)
//            }
//        }
//    }
    
}

extension UserJobListingVC {
    func fetchJobDetails(jobID: Int) {
        let url = "\(EndPoints.showJobDetailById)\(jobId)"
        print(url)
        let parameters = ["user_id": myUserDefaults.userId] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let jobRoot = try jsonDecoder.decode(JobDetailsDataModel.self, from: response.data!)
                if !(jobRoot.error ?? false) {
                    print("Successfull...")
                    self.jobDetails = jobRoot.data?.first
                    self.setData(data: self.jobDetails)
                } else {
                    self.presentAlert("Error", "Unable to fetch job details") { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
                self.presentAlert("Error", error.localizedDescription) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
//    private func getJobListingData(jobId: Int) {
//        showActivity()
//        let endPoint = EndPoints.showJobDetailById + "\(jobId)"
//        let parameters: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id ?? 0]
//        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { [weak self] (result: Result<Wrapper<[DashboardItem]>>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            switch result {
//            case .success(let job):
//                self.scrollContentView.isHidden.toggle()
//                if job.error {
//                    self.presentAlert("Error", job.message) { [weak self] in
//                        self?.navigationController?.popViewController(animated: true)
//                    }
//                } else if let job = job.data.first {
//                    self.objectId = self.jobId ?? 0
//                    self.jobId = nil
//                    self.job = job
//                    self.initUI()
//                } else {
//                    self.presentAlert("Error", "Unable to fetch job details") { [weak self] in
//                        self?.navigationController?.popViewController(animated: true)
//                    }
//                }
//            case .failure(let error):
//                self.presentAlert("Error", error.localizedDescription) { [weak self] in
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//    }
    
}
