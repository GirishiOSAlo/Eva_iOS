//
//  editJobPostV2.swift
//  EvaConnect
//
//  Created by Metis on 06/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

//
//  CreateEditPostedJobVC.swift
//  EvaConnect
//
//  Created by Metis on 26/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import Alamofire
//import LabelSwitch
import Lottie

class CreateEditPostedJobVC: UIViewController {//, LabelSwitchDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var listingDurationTF: UITextField!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleLeadingConstraint: NSLayoutConstraint!
    //@IBOutlet weak var JobSwitch: LabelSwitch!
    @IBOutlet weak var sectorTF: UITextField!
    @IBOutlet weak var companyTF: UITextField!
    
    @IBOutlet weak var salaryTF: UITextField!
    @IBOutlet weak var countrySymbolLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    
    @IBOutlet weak var designationTF: UITextField!
    @IBOutlet weak var updateJobBtn: UIButton!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
//    @IBOutlet weak var jobTimings: UITextField!
    @IBOutlet var imageContainerView: UIView!
    
    @IBOutlet weak var enterTitleView: UIView!
    @IBOutlet weak var enterTitleTF: UITextField!
    @IBOutlet weak var enterTitleButton: UIButton!
    
    @IBOutlet weak var enterJobSecView: UIView!
    @IBOutlet weak var enterJobSecTF: UITextField!
    @IBOutlet weak var enterJobSecButton: UIButton!
    
    @IBOutlet weak var enterLocationView: UIView!
    @IBOutlet weak var enterLocationTF: UITextField!
    @IBOutlet weak var enterLocationButton: UIButton!
    
    @IBOutlet weak var enterSalaryView: UIView!
    @IBOutlet weak var enterSalaryTF: UITextField!
    @IBOutlet weak var enterSalaryButton: UIButton!
    
    @IBOutlet weak var enterJobTypeView: UIView!
    @IBOutlet weak var enterJobTypeTF: UITextField!
    @IBOutlet weak var enterJobTypeButton: UIButton!
    
    @IBOutlet weak var enterDurationView: UIView!
    @IBOutlet weak var enterDurationTF: UITextField!
    @IBOutlet weak var enterDurationButton: UIButton!
    
    @IBOutlet weak var enterDesLbl: UILabel!
    @IBOutlet weak var enterDesView: UIView!
    
    @IBOutlet weak var enterDesTextView: UITextView!
    
    @IBOutlet weak var applyJobSuccessPopupVw: UIView!
    @IBOutlet weak var subPopupView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var animationContainerView: UIView!
    
    @IBOutlet weak var successfulLabel: UILabel!
    @IBOutlet weak var successfulDescLbl: UILabel!
    
    enum RoleType {
        case add, edit
    }
    
    //MARK: VARIABLES
    var pickerView: UIPickerView!
    var animationView: LottieAnimationView!
    weak var delegate: RefreshUpdateable?
    var jobId: Int?
    var jobDetail: JobDetail?
    var sectors: [String] = []
    var jobTimingsList: [String] = []
//    private var listingDuration = [String]()
    private var pickerType: SelectionType = .sector
    var roleType: RoleType = .add
    private let textViewColor = UIColor(named: "DocumentBorder")!
    private var jobSuccessAlert: JobApplicationAlert!
    var jobType = ""
    var jobSectorID = 0
    var listingDuration = 0
    var jobStatus = "active"
    var isActive = false
    var currencyList: [CurrenciesData] = []
    var selectedCurrencyID = 0
    
    var jobSectorList: [Sectors] = []
    var durationArr: [Sectors] = [
        Sectors(id: 30, name: "30 Days"),
        Sectors(id: 45, name: "45 Days"),
        Sectors(id: 60, name: "60 Days")
        ]
//    var jobTypeList: [Sectors] = [
//        Sectors(id: 1, name: "Evening"),
//        Sectors(id: 2, name: "Full Time"),
//        Sectors(id: 3, name: "Morning"),
//        Sectors(id: 4, name: "Nights"),
//        Sectors(id: 5, name: "Part Time"),
//        Sectors(id: 6, name: "Term Time"),
//        Sectors(id: 7, name: "Weekends")
//    ]
    
    var jobTypeList: [String] = [
        "Evening",
        "Full Time",
        "Morning",
        "Nights",
        "Part Time",
        "Term Time",
        "Weekends"
    ]
    
    private enum SelectionType {
        case sector, timings, duration
    }
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
       super.viewDidLoad()
        setLayOut()
//        setSwitchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        jobSuccessAlert?.removeFromSuperview()
    }
    
    func toggleInactiveBtn() {
        self.jobStatus = "deactivate"
        toggleButton.setTitle("Inactive", for: .normal)
        toggleButton.setTitleColor(UIColor.white, for: .normal)
        toggleButton.backgroundColor = UIColor(hex: "#DCDCDC")
        toggleButton.contentHorizontalAlignment = .left
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        self.circleLeadingConstraint.constant = 4
    }
    
    func toggleActiveBtn() {
        self.jobStatus = "active"
        toggleButton.setTitle("Active", for: .normal)
        toggleButton.setTitleColor(UIColor.white, for: .normal)
        toggleButton.backgroundColor = UIColor(hex: "#4D76CD")
        toggleButton.contentHorizontalAlignment = .right
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 35)
        self.circleLeadingConstraint.constant = self.toggleButton.frame.width - self.circleView.frame.width - 4
    }
    
    @IBAction func onToggleBtnTap(_ sender: UIButton) {
        isActive.toggle()
        
        UIView.animate(withDuration: 0.3) {
            if self.isActive {
                self.toggleActiveBtn()
            } else {
                self.toggleInactiveBtn()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func update_touchUpInside(_ sender: Any) { //!jobTimings.text!.isEmpty &&
        if !enterTitleTF.text!.isEmpty &&
            !enterJobSecTF.text!.isEmpty &&
            !enterLocationTF.text!.isEmpty &&
            !enterSalaryTF.text!.isEmpty &&
            !enterJobTypeTF.text!.isEmpty &&
            !enterDurationTF.text!.isEmpty &&
            !enterDesTextView.text!.isEmpty &&
            profileImg.image != nil &&
            selectedCurrencyID != 0 &&
            jobSectorID != 0 {
            
            if Int(enterSalaryTF.text ?? "") == nil {
                presentAlert("Alert", "Salary should be in integer")
            } else {
                addUpdateJob()
            }
            
        } else {
            presentAlert("Alert", "All Fields are mandatory (including currency)")
        }
    }
    
//    @IBAction func browseAction(_ sender: Any) {
//        openGalleryy()
//    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func TitleBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func JobSecBtnTapped(_ sender: UIButton) {
//        showActivity()
//        getSectors()
        if self.jobSectorList.count == 0 {
            self.presentAlert("Job Sector list not found.")
        } else {
        }
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        self.hideActivity()
        popupvc.activeDataType = .sector
        popupvc.sectorsArray = self.jobSectorList
        popupvc.completion = { passedAns, passedId in
            self.enterJobSecTF.text = passedAns
            self.jobSectorID = passedId
        }
        self.navigationController?.present(popupvc, animated: true)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func jobTypeBtnTapped(_ sender: Any) {
        
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        popupvc.activeDataType = .string
        popupvc.stringArray = self.jobTypeList
        popupvc.completion = { passedAns, passedId in
            self.enterJobTypeTF.text = "\(passedAns)"
            self.jobType = passedAns
        }
        self.navigationController?.present(popupvc, animated: true)
    }
    
    @IBAction func durationBtnTapped(_ sender: UIButton) {
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        popupvc.activeDataType = .sector
        popupvc.sectorsArray = self.durationArr
        popupvc.completion = { passedAns, passedId in
            self.enterDurationTF.text = passedAns
            self.listingDuration = passedId
        }
        self.navigationController?.present(popupvc, animated: true)
    }
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        self.applyJobSuccessPopupVw.isHidden = true
        self.animationView.stop()
        self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
//        self.navigationController?.popToRootViewController(animated: true)
    }
        
    @IBAction func onSelectCountryBtn(_ sender: UIButton) {
        if self.currencyList.count == 0 {
            self.presentAlert("Currency list not found.")
        } else {
            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
            popupvc.modalPresentationStyle = .overFullScreen
            popupvc.activeDataType = .currency
            popupvc.currencyList = currencyList
            popupvc.currencyCompletion = { selectedCurrency in
                self.countryCodeLbl.text = selectedCurrency.code
                self.countrySymbolLbl.text = selectedCurrency.symbol
                self.selectedCurrencyID = selectedCurrency.id ?? 0
            }
            self.navigationController?.present(popupvc, animated: true)
        }
    }
    
    
}

// MARK: APIs Calls
extension CreateEditPostedJobVC {
    
    private func getSectors() {
        NetworkManagerr.request(EndPoints.getSectors, method: .post) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
                self?.jobSectorList = sectors.data
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func getJobListingData(jobId: Int) {
        showActivity()
        let endPoint = EndPoints.showJobDetailById + "\(jobId)"
        let parameters: AFParameters = ["user_id": myUserDefaults.userId]
        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { [weak self] (result: Result<Wrapper<[EditJobDetailsData]>>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let job):
                if job.error {
                    self.presentAlert("Error", job.message) { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else if let job = job.data.first {
//                    self.objectId = self.jobId ?? 0
//                    self.jobId = nil
//                    self.job = job
                    //self.initUI(job: job)
                    self.setData(job: job)
                } else {
                    self.presentAlert("Error", "Unable to fetch job details") { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                self.presentAlert("Error", error.localizedDescription) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            default:
                break
            }
        }
    }
    
    func addUpdateJob() {
        
        showActivity()
        
        //let url = roleType == .add ? EndPoints.postJobAd : EndPoints.jobDetails + "\(jobId ?? 0)"
        let url = roleType == .add ? EndPoints.postJobAd : EndPoints.postJobAd + "/\(jobId ?? 0)"
        
        let method: HTTPMethod = roleType == .add ? .post : .patch

//        let userId = LoggedUserDetails.shared.user?.id ?? 0
        var parameters: Parameters = [:]
        
        if roleType == .add {
            parameters = ["job_title": enterTitleTF.text!,
                          "job_type": self.jobType,
                          //"job_sector": enterJobSecTF.text!,
                          "job_sector_id": self.jobSectorID,
                          "listing_duration": self.listingDuration,
                          "location": enterLocationTF.text!,
                          "salary": enterSalaryTF.text!,
                          "job_description": enterDesTextView.text!,
                          //"status": self.jobStatus,
                          "currency_id": self.selectedCurrencyID]
        } else {
            parameters = ["job_title": enterTitleTF.text!,
                          "job_type": self.jobType,
                          //"job_sector": enterJobSecTF.text!,
                          "job_sector_id": self.jobSectorID,
                          "listing_duration": self.listingDuration,
                          "location": enterLocationTF.text!,
                          "salary": enterSalaryTF.text!,
                          "job_description": enterDesTextView.text!,
                          "status": self.jobStatus,
                          "currency_id": self.selectedCurrencyID]
        }
        
        NetworkManagerr.request(url, method: method, parameters: parameters) { [weak self] (response) in
            self?.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !root.error {
                    self?.addAnimation()
                } else {
                    self?.presentAlert("Error: ", root.message)
                }
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        
//        if roleType == .add {
//            parameters["created_by_id"] = userId
//            parameters["published_date"] = Date().toString(formatter: .apiBody)
//        } else {
//            parameters["modified_by_id"] = userId
//            parameters["modified_datetime"] = Date().toString(formatter: .standardDateWithTime)
//        }
        
//        self.showActivity()
//        let profileImage = self.profileImg.image
//        Alamofire.upload(multipartFormData: { (multiFormData) in
//
//            if let image = profileImage {
//                let imageData = image.jpegData(compressionQuality: 0.8)
//                multiFormData.append(imageData!, withName: "job_image", fileName: "image.jpg", mimeType: "image/png")
//            }
//
//            for (key, value) in parameters {
//
//                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, to: url, method: method, headers: SharedHeaders.headers) { (result) in
            
//            switch result {
//            case .success(let successfulResponse, _, _):
//
//                successfulResponse.responseJSON { (response) in
//                    self.hideActivity()
//                    let jsonDecoder = JSONDecoder()
//                    let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
//
//                    if !genericResponse.error {
//                        self.jobSuccessAlert.showAlert()
//                        self.jobSuccessAlert.okAction = {
//                            self.delegate?.refresh(homeStatus: true)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    } else {
//                        self.presentAlert("Failure", genericResponse.message, nil)
//                    }
//                }
//            case .failure(let error):
//
//                self.presentAlert("Failure", nil, error)
//            }
        }
    }
    
    func fetchCurrenciesList() {
        showActivity()
        let url = "\(EndPoints.currencies)"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription as? Error ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let response = try JSONDecoder().decode(CurrenciesDataModel.self, from: data)
                if let data = response.data {
                    self.currencyList = data
                    if self.currencyList.count == 0 {
                        print("Currency is Empty.")
                    } else {
                        self.selectedCurrencyID = self.currencyList[0].id ?? 0
                        self.countrySymbolLbl.text = self.currencyList[0].symbol ?? ""
                        self.countryCodeLbl.text = self.currencyList[0].code ?? ""
                    }
                } else {
                    print("Error ::", response.message as? Error ?? "Default Error")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
}

//MARK: TextField Delegates

extension CreateEditPostedJobVC: UITextFieldDelegate {
    
    private func changePickerValue(_ textField: UITextField) {
//        if textField == sectorTF {
//            pickerType = .sector
//        } else if textField == jobTimings {
//            pickerType = .timings
//        } else {
//            pickerType = .duration
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        changePickerValue(textField)ws
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        changePickerValue(textField)
//        pickerView.selectedRow(inComponent: 0)
//        pickerView.reloadAllComponents()
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        if textField == enterSalaryTF {
//            let maxLength = 9
//            guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
//                return false
//            }
//            let currentString: NSString = textField.text! as NSString
//
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        } else {
//            return false
//        }
//    }
}

//extension CreateEditPostedJobVC: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        pickerType == .sector ? sectors.count : pickerType == .timings ? jobTimingsList.count : listingDuration.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        pickerType == .sector ? sectors[row] : pickerType == .timings ? jobTimingsList[row] : listingDuration[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        if pickerType == .sector {
//            sectorTF.text = sectors[row]
//        } else if pickerType == .timings {
////            jobTimings.text = jobTimingsList[row]
//        } else {
//            listingDurationTF.text = listingDuration[row]
//        }
//    }
//
//    @objc func doneSelection() {
//        if sectorTF.isFirstResponder {
//            sectorTF.resignFirstResponder()
//        } else {
////            jobTimings.resignFirstResponder()
//        }
//    }
//}

extension CreateEditPostedJobVC {
    
    func setLayOut() {
        headerTitleLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        headerTitleLbl.text = "\(roleType == .add ? "Create" : "Edit") Job listing"
        updateJobBtn.setTitle(roleType == .add ? "Post" : "Submit Changes", for: .normal)
        updateJobBtn.layer.cornerRadius = 24
//        getSectors()
//        getJobTimings()
//        picker.delegate = self
        enterDesTextView.textColor = roleType == .edit ? .black : textViewColor
//        descriptionTF.delegate = self
        enterTitleTF.delegate = self
        enterJobTypeTF.delegate = self
        enterSalaryTF.delegate = self
        enterJobTypeTF.delegate = self
        enterLocationTF.delegate = self
        enterDurationTF.delegate = self
        enterDesTextView.delegate = self
        
        setCornerRadius(view: enterTitleView)
        setCornerRadius(view: enterJobSecView)
        setCornerRadius(view: enterJobTypeView)
        setCornerRadius(view: enterLocationView)
        setCornerRadius(view: enterSalaryView)
        setCornerRadius(view: enterDurationView)
        setCornerRadius(view: enterDesView)
        
        countrySymbolLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        countryCodeLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        self.fetchCurrenciesList()
        self.getSectors()
        
        toggleButton.layer.cornerRadius = 16
        toggleButton.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.isUserInteractionEnabled = false
        
        
        
        
//        JobSwitch.isHidden = roleType == .add
        
        if isIndivisualUser {
            self.toggleButton.isHidden = true
            self.circleView.isHidden = true
        }
        else {
            if roleType == .edit {
                //getJobDetails()
                getJobListingData(jobId: self.jobId ?? 0)
                
                successfulLabel.text = "Your Job is Successfully Updated"//"Job Edit Successful"
                successfulDescLbl.text = ""//"Your job edit was successful. Please check your notifications for their reply"
                
                self.toggleButton.isHidden = false
                self.circleView.isHidden = false
            } else {
                self.toggleActiveBtn()
                successfulLabel.text = "Your Job is Successfully Created"//"Job Post Successful"
                successfulDescLbl.text = ""//"Your job post has been created. Please check your notifications for their reply"
                
                self.toggleButton.isHidden = true
                self.circleView.isHidden = true
            }
        }
        
        self.applyJobSuccessPopupVw.isHidden = true
        self.subPopupView.layer.cornerRadius = 13
        self.okButton.layer.cornerRadius = self.okButton.frame.size.height/2
        
//        pickerView =  UIPickerView()
//        pickerView.backgroundColor = .white
////        picker.delegate = self
//        pickerView.showsSelectionIndicator = true
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        sectorTF.delegate = self
////        jobTimings.delegate = self
        
//        listingDurationTF.delegate = self
        
//        companyTF.text = "\(LoggedUserDetails.shared.user?.companyName ?? "No Company")"
//        companyTF.isUserInteractionEnabled = false
//        let tool = UIToolbar()
//        tool.barStyle = .default
//        tool.isTranslucent  = true
//        tool.tintColor = AppColors.appColor
//
//        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSelection))
//        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(doneSelection))
//        tool.setItems([doneBtn,spaceBtn,cancel], animated: false)
//        tool.isUserInteractionEnabled = true
//        tool.sizeToFit()
        
        enterJobSecTF.isUserInteractionEnabled = false
        enterDurationTF.isUserInteractionEnabled = false
        enterJobTypeTF.isUserInteractionEnabled = false
        
//        sectorTF.inputView = pickerView
//        jobTimings.inputView = pickerView
//        listingDurationTF.inputView = pickerView
//        sectorTF.inputAccessoryView = tool
//        jobTimings.inputAccessoryView = tool
//        listingDurationTF.inputAccessoryView = tool
        imageContainerView.makeRoundView(boderColor: AppColors.appColor)
        jobSuccessAlert = JobApplicationAlert(type: roleType == .add ? .job : .jobUpdated)
    }
    
    func setCornerRadius(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 0.5
    }
    
    func initUI(job: DashboardItem) {
//        self.jobStatus = job.status == "active" ? "active" : "pending"
//        enterTitleTF.text = job.jobTitle
//        enterJobSecTF.text = job.jobSector
//        
//        enterLocationTF.text = job.location
//        enterSalaryTF.text = "\(job.salary ?? 0)"
//        enterJobTypeTF.text = job.jobtype?.rawValue
//        self.jobType = job.jobtype?.rawValue ?? ""
//        enterDurationTF.text = "\(job.listingDuration ?? "") Days"
//        self.listingDuration = Int(job.listingDuration ?? "") ?? 0
//        enterDesTextView.text = job.jobDescription
    }
    
    func setData(job: EditJobDetailsData) {
        if job.status?.lowercased() == "active" {
            self.toggleActiveBtn()
        } else {
            self.toggleInactiveBtn()
        }
        
        enterTitleTF.text = job.jobTitle ?? ""
        enterJobSecTF.text = job.jobSector ?? ""
        enterLocationTF.text = job.location ?? ""
        enterSalaryTF.text = "\(job.salary ?? 0)"
        enterJobTypeTF.text = job.jobtype ?? ""
        enterDurationTF.text = "\(job.listingDuration ?? 0) Days"
        listingDuration = job.listingDuration ?? 0
        enterDesTextView.text = job.jobDescription ?? ""
        
        //Edit Job Sector Id data...
        let jobSectorName = job.jobSector ?? ""
        if let jobSector = self.jobSectorList.first(where: { $0.name == jobSectorName }) {
            print("Found Job Sector")
            jobSectorID = jobSector.id
        } else {
            print("Job Sector not found")
            jobSectorID = 0
        }
        
        self.selectedCurrencyID = job.currencyID ?? 0
        //Edit Job Currency Id data...
        if let currency = self.currencyList.first(where: { $0.id == selectedCurrencyID }) {
            print("Found currency")
            countrySymbolLbl.text = currency.symbol ?? ""
            countryCodeLbl.text = currency.code ?? ""
        } else {
            print("Currency not found")
            countrySymbolLbl.text = "--"
            countryCodeLbl.text = "--"
        }
    }
    
    func updateUI(jobDetail: JobDetail) {
        
        jobTitleTF.text = jobDetail.jobTitle
        sectorTF.text = jobDetail.jobSector
        companyTF.text = jobDetail.jobNature
        salaryTF.text = "\(jobDetail.salary ?? 0)"
        profileImg.sd_setImage(with: URL(string: (jobDetail.jobImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        descriptionTF.text = jobDetail.content
        designationTF.text = jobDetail.position
        locationTF.text = jobDetail.location
//        jobTimings.text = jobDetail.jobType
        listingDurationTF.text = "\(jobDetail.activeHours ?? 0)"
    }
    
//    func setSwitchButton(){
//        JobSwitch.delegate = self
//        JobSwitch.curState = .L
//        JobSwitch.circleShadow = false
//        JobSwitch.fullSizeTapEnabled = true
//        
//        // Do any additional setup after loading the view, typically from a nib.
//
//
//        // Set the default state of the switch,
//        
////        let ls2 = LabelSwitchConfig(text: "Left",
////                              textColor: .white,
////                                   font: .boldSystemFont(ofSize: 20),
////                         gradientColors: [UIColor.red.cgColor, UIColor.purple.cgColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
////
////        let rs2 = LabelSwitchConfig(text: "Right",
////                              textColor: .white,
////                                   font: .boldSystemFont(ofSize: 20),
////                         gradientColors: [UIColor.yellow.cgColor, UIColor.orange.cgColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
////
////        let gradientLabelSwitch = LabelSwitch(center: CGPoint(x: view.center.x, y: view.center.y + 100), leftConfig: ls2, rightConfig: rs2, defaultState: .L)
////        view.addSubview(gradientLabelSwitch)
//    }
    
//    func switchChangToState(sender: LabelSwitch ) {
//        switch sender.curState {
//                    case .L: print("Active")
//                            self.jobStatus = "active"
//                            
//                    case .R: print("Inactive")
//                            self.jobStatus = "pending"
//                }
//    }
    
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
}

extension CreateEditPostedJobVC {
    
     func getJobDetails() {
        
        getJobDetial(jobId: jobId!) { (editedJob, error) in
            if let job = editedJob {
                self.jobDetail = job
                self.updateUI(jobDetail: self.jobDetail!)
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
//    func getSectors() {
//
//        let parameters = [:] as [String: Any]
//        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: parameters) { (response) in
//
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
//                    self.sectors.append(contentsOf: sectors.data)
//                    self.sectorTF.text = self.sectors.first ?? ""
//                } catch {
//                    self.presentAlert("Failure", nil, response.result.error)
//                }
//            }
//        }
//    }
    
//    func getJobTimings() {
//
//        NetworkManagerr.request(EndPoints.fetchJobTypes) { (response) in
//
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
//                    self.jobTimingsList = sectors.data
//                    self.jobTimings.text = sectors.data.first ?? ""
//                    for i in 1...self.jobTimingsList.count { self.listingDuration.append("\(i * 3)") }
//                    self.listingDurationTF.text = self.listingDuration.first ?? ""
//                } catch {
//                    self.presentAlert("Failure", nil, response.result.error)
//                }
//            }
//        }
//    }
    
    
}

//extension CreateEditPostedJobVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//
//
//        let editImage = info[.editedImage] as? UIImage
//        var orignalImage = info[.originalImage] as? UIImage
//        if editImage != orignalImage {
//            orignalImage = editImage
//        }
//        let imgData = NSData(data: (orignalImage)!.jpegData(compressionQuality: 0.8)!)
//        let imageSize: Int = imgData.count
//        //chekcing size if its 4mb
//        if  imageSize <= 4194304 {
//            self.profileImg.contentMode = .scaleAspectFill
//            self.profileImg.image = orignalImage
//
//        } else {
//            makeAlert(messageData: "Image File must be less than equal to 4 MB")
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//}

extension CreateEditPostedJobVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textViewColor {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe the role"
            textView.textColor = textViewColor
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == enterSalaryTF || textField == enterDurationTF {
            // Allow only numbers
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        // For other textfields → allow normal input
        return true
    }
}
