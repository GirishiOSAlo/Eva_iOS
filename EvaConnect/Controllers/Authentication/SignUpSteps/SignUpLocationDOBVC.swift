//
//  SignUpLocationDOBVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/21/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class SignUpLocationDOBVC: BaseForAuthentication {

    @IBOutlet weak var haveAnAccountBtn: UIButton!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var dobStackView: UIStackView!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var inputCountryView: UIView!
    @IBOutlet var dobViews: [UIView]!
    @IBOutlet var dobButtons: [UIButton]!
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var inputCountry: UITextField!
    @IBOutlet weak var inputLanguage: UITextField!
    @IBOutlet weak var locatedTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTitleLbl: NameLabel!
    @IBOutlet weak var headerTitleLbl2: UILabel!
    
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var regionsView: UIView!
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyInnerView: UIView!
    @IBOutlet weak var showCompanyBtn: UIButton!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var jobTitleView: UIView!
    @IBOutlet weak var jobTitleInnerView: UIView!
    @IBOutlet weak var jobTitleLabel: UITextField!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryHeadingLabel: UILabel!
    @IBOutlet weak var categoryInnerView: UIView!
    @IBOutlet weak var categoryDropDwnImgVw: UIImageView!
    @IBOutlet weak var showCategoryListBtn: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!

    @IBOutlet weak var countryDropDownMainVw: UIView!
    @IBOutlet weak var countryListTblVw: UITableView!
    
    @IBOutlet weak var cityDropDownMainVw: UIView!
    @IBOutlet weak var cityListTblVw: UITableView!
    
    @IBOutlet weak var languageDropDownMainVw: UIView!
    @IBOutlet weak var languageListTblVw: UITableView!
    
    
    private var contentPickerView: ContentPickerView!
    var cityList = [String]()
    private var cities = [String]()
    private let locationManager = CLLocationManager()
    private var selectedInput = ""
    var signUpDetails: SignUpDetails?
    var delegate: EditUserProfileDelegate? = nil
    var selectedAns = ""
    var companyId = 0
    var jobSectorList: [Sectors] = []
    var categoryList: [AllCategoryList] = []
    var isFromSettings = false
    private var user = LoggedUserDetails.shared.user
    var params = [:] as [String: Any]
    var passedId:Int = 0
    
    private var languages = ["English", "Arabic", "French", "Mandarin", "Spanish", "Russian"]
    var languageList = ["English", "Arabic", "French", "Mandarin", "Spanish", "Russian"]
    var countryList = ["Africa", "Asia", "Central Asia", "Europe", "Latin America", "Middle East", "North America", "Oceania", "South Asia", "Southest Asia", "Western Asia"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setContentPickerView()
        setLayoutStyle()
//        setLocationManager()
    }
    
//    override func viewWillDisappear(_ animated: Bool) { stopLocationManager() }
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
    
//    @IBAction func dobBtnTapped(_ sender: Any) {
//        selectedInput = "dob"
//        showContentPickerView(title: "Pick your date of birth", showDatePicker: true)
//    }
    
    @IBAction func showCompanyListTapped(_ sender: UIButton) {
        let vc = CompanyListPopupVC.instantiate()
        vc.activeDataType = .company
        vc.modalPresentationStyle = .overFullScreen
        vc.completion = { name, id in
            self.companyNameTextField.text = name
            self.companyId = id
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func showCategoryListTapped(_ sender: UIButton) {
        showActivity()
        //getSectors()
        getCategory()
    }
    
    @IBAction func dobBtnTapped(_ sender: UIButton) {
        selectedInput = "dob"
//        showContentPickerView(title: "Pick your date of birth", showDatePicker: true)
    }
    
    @IBAction func countryBtnTapped(_ sender: UIButton) {
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        popupvc.activeDataType = .string
        popupvc.stringArray = self.countryList
        popupvc.completion = { passedAns, passedId in
//            self.selectedAns = passedAns
            self.inputCountry.text = passedAns
        }
        self.navigationController?.present(popupvc, animated: true)
        
//        self.countryDropDownMainVw.isHidden = false
    }
    
    @IBAction func cityBtnTapped(_ sender: Any) {
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(popupvc, animated: true)
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        //==> Open Drop View....
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        popupvc.activeDataType = .string
        popupvc.stringArray = self.languageList
        popupvc.completion = { passedAns, passedID in
            self.inputLanguage.text = passedAns
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if isFromSettings {
            if LoggedUserDetails.shared.user?.region != self.inputCountry.text {
                updateProfile(region: self.inputCountry.text ?? "Asia") { success, error in
                    if success ?? false {
                        print("Done!!")
                        self.navigationController?.popViewController(animated: true)
                    }
                    if let error = error {
                        print(error)
                        print(error.localizedDescription)
                    }
                }
            } else {
                goBack()
            }
        } else {
            if nextValidation() {
                signUpDetails?.country = inputCountry.text?.trimmingCharacters(in: .whitespaces)
                myUserDefaults.region = inputCountry.text?.trimmingCharacters(in: .whitespaces) ?? ""
                signUpDetails?.language = inputLanguage.text?.trim
                myUserDefaults.Language = inputLanguage.text?.trim ?? ""
                myUserDefaults.companyName = companyNameTextField.text?.trim ?? ""
                myUserDefaults.jobTitle = jobTitleLabel.text?.trim ?? ""
                myUserDefaults.companyId = self.companyId
                
                goToAboutSection()
                
//                if myUserDefaults.user == "user" {
//                    let year = (dobButtons[2].title(for: .normal) ?? "").trim
//                    let month = (dobButtons[1].title(for: .normal) ?? "").trim
//                    let day = (dobButtons[0].title(for: .normal) ?? "").trim
////                    signUpDetails?.dateOfBirth = "\(year)-\(month)-\(day)"
//                    myUserDefaults.DOB = "\(year)-\(month)-\(day)"
//                }
                //
//                if signUpDetails?.dateOfBirth == "YY-MM-DD" && myUserDefaults.user == "user" {
//                    makeAlert(titleMsg: "Warning", messageData: "Please select valid date of birth")
//                } else {
//                    goToSectorVC()
//                }
            }
        }
    }
    
    func nextValidation() -> Bool {
//        if self.dobBtn.titleLabel!.text!.elementsEqual("dd/mm/yyyy") {
//            makeAlert(titleMsg: "Warning", messageData: "Please select date of birth")
//            return false
//        }
        if myUserDefaults.isIndivisualUser {
            if self.companyNameTextField.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please select Company Name")
                return false
            }
            else if self.jobTitleLabel.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please Enter Job Title")
                return false
            }
            else if self.categoryTextField.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please Select Category")
                return false
            }
            else if self.inputCountry.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please Select Region")
                return false
            } else {
                return true
            }
        } else {
            if self.categoryTextField.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please Select Business Sector")
                return false
            }
            else if self.inputCountry.text!.elementsEqual("") {
                makeAlert(titleMsg: "Warning", messageData: "Please Select Region")
                return false
            } else {
                return true
            }
        }
    }
}

extension SignUpLocationDOBVC {
    
    private func setLayoutStyle() {
        
        if myUserDefaults.isIndivisualUser || (myUserDefaults.user == "user") {
            self.dobView.isHidden = false
            self.companyView.isHidden = false
            self.jobTitleView.isHidden = false
            self.categoryHeadingLabel.text = "Category"
            self.categoryTextField.placeholder = "Select Category"
        } else {
            self.dobView.isHidden = true
            self.companyView.isHidden = true
            self.jobTitleView.isHidden = true
            self.categoryHeadingLabel.text = "Business Sector"
            self.categoryTextField.placeholder = "Select Business Sector"

        }
        
        headerTitleLbl.isHidden = isFromSettings ? true : false
        headerTitleLbl2.isHidden = isFromSettings ? false : true
        companyNameTextField.isUserInteractionEnabled = false
        
//        (dobButtons + [dobBtn ,languageBtn, cityBtn, inputCountryView]).forEach({
//            $0.applyBorderWithRadius()
//        })
        
        self.companyInnerView.applyBorderWithRadius()
        self.jobTitleInnerView.applyBorderWithRadius()
        self.categoryInnerView.applyBorderWithRadius()
        self.inputCountryView.applyBorderWithRadius()
        
        
        self.nextBtn.layer.cornerRadius = 14 //self.nextBtn.frame.size.height/2
        
        
        self.dobView.isHidden = isFromSettings
        if isFromSettings {
            self.inputCountry.text = LoggedUserDetails.shared.user?.region
        } else {
            self.countryBtn.isUserInteractionEnabled = true
        }
        
        self.countryDropDownMainVw.isHidden = true
        self.countryDropDownMainVw.cornerRadius = 10
        self.countryDropDownMainVw.dropShadow()
        
        self.cityDropDownMainVw.isHidden = true
        self.cityDropDownMainVw.cornerRadius = 10
        self.cityDropDownMainVw.dropShadow()

        self.languageDropDownMainVw.isHidden = true
        self.languageDropDownMainVw.cornerRadius = 10
        self.languageDropDownMainVw.dropShadow()

        self.inputLanguage.text = "English"
        self.inputLanguage.textColor = UIColor(hex: "#000000", alpha: 0.25)
        
        if delegate != nil {
            haveAnAccountBtn.isHidden = true
            nextBtn.setTitle("Continue", for: .normal)
        }
    }
    
    private func goToAboutSection() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpAboutInfoVC.storyboardIdentifier) as? SignUpAboutInfoVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToSectorVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpJobSectorVC.storyboardIdentifier) as? SignUpJobSectorVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: getSector
extension SignUpLocationDOBVC {
    
    private func getSectors() {
        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: params) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
                
                self?.jobSectorList = sectors.data
                let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                self?.hideActivity()
                popupvc.activeDataType = .sector
                popupvc.sectorsArray = self?.jobSectorList ?? []
                popupvc.completion = { passedAns, passedId in
                    self?.categoryTextField.text = passedAns
                    self?.passedId = passedId
                    myUserDefaults.Cat_id = "\(passedId)"
                    myUserDefaults.sector = "\(passedId)"
                }
                self?.navigationController?.present(popupvc, animated: true)
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
    
    func getCategory() {
        NetworkManagerr.request(EndPoints.getCategory, method: .post, parameters: params) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let category = try jsonDecoder.decode(AllCategoryModel.self, from: response.data!)
                
                self?.categoryList = category.data ?? []
                let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                self?.hideActivity()
                popupvc.activeDataType = .allCategory
                popupvc.allCategoryList = self?.categoryList ?? []
                popupvc.completion = { passedAns, passedId in
                    self?.categoryTextField.text = passedAns
                    self?.passedId = passedId
                    myUserDefaults.Cat_id = "\(passedId)"
                    myUserDefaults.sector = "\(passedId)"
                }
                self?.navigationController?.present(popupvc, animated: true)
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
}

extension SignUpLocationDOBVC {
    
//    private func fetchCities(country code: String) {
//        let url = EndPoints.cities.replacingOccurrences(of: "[ciso]", with: code)
//        NetworkManagerr.request(url, headers: ["X-CSCAPI-KEY": EndPoints.countryApiKey]) { [weak self] (result: Result<[CitiesResponse]>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            switch result {
//            case .success(let data):
//                self.cities = data.map({ $0.name })
//            case .failure(let error):
//                print("cannot fetch cities", error)
//            }
//        }
//    }
    
    func updateProfile(region: String, completion: @escaping (Bool?, Error?) -> Void) {

        let parameters: AFParameters = ["region": region]
        
        
        let endPoint = EndPoints.userDetail

        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in

            if response.result.isSuccess {

                let jsonDecoder = JSONDecoder()

                do {

                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        self.presentAlert(genericRoot.error ? "Error" : "Success", "Profile Updated.", nil) {
                            if !genericRoot.error {
                                self.fetchUserDetail()
                            }
                        }
                        completion(true, nil)
                    }
                } catch {
                    
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    private func fetchUserDetail() {
        ProfileManager.shared.fetchUserDetail(userId: user?.id ?? 0, showLoader: false) { user, error in
            if let error = error {
                self.presentAlert("Error", error)
            } else if let user = user {
                self.user = user
                LoggedUserDetails.shared.updateUser(userModel: user)
                self.goBack()
            } else {
                self.presentAlert("Error", "Unable to fetch user details")
            }
        }
    }

    
}
