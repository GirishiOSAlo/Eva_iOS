//
//  EditProfileViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

class EditProfileViewController: UIViewController, XIBed {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet var baseViewCollection: [UIView]!
    @IBOutlet var baseViewTitleLblCollection: [UILabel]!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet var headerLbllCollection: [UILabel]!
    @IBOutlet var textFieldBaseVwCollection: [UIView]!
    
    @IBOutlet weak var jobTitleBaseVw: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var companyBaseVw: UIView!
    @IBOutlet weak var companyTxtField: UITextField!
    @IBOutlet weak var jobTitleTxtField: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var businessSectorTxtField: UITextField!
    @IBOutlet weak var descriptionTxtVw: UITextView!
    @IBOutlet weak var descTxtVwHeight: NSLayoutConstraint!
    @IBOutlet weak var resumeBaseVw: UIView!
    @IBOutlet weak var resumeTitleLbl: UILabel!
    @IBOutlet weak var resumeSubLbl: UILabel!
    
    @IBOutlet weak var countryFlagLbl: UILabel!
    @IBOutlet weak var dropDownImgVw: UIImageView!
    @IBOutlet weak var countryPhnCodeTxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var websiteTxtField: UITextField!
    @IBOutlet weak var linkedinTxtField: UITextField!
    
    @IBOutlet weak var regionTxtField: UITextField!
    @IBOutlet weak var languageTxtField: UITextField!
    
    @IBOutlet weak var paNameTxtField: UITextField!
    @IBOutlet weak var paEmailTxtfield: UITextField!
    
    @IBOutlet weak var airportTransferInfoVw: UIView!
    @IBOutlet weak var airportTransferInfoLbl: UILabel!
    @IBOutlet weak var arrivalDateTxtField: UITextField!
    @IBOutlet weak var arrivalTimeTxtField: UITextField!
    @IBOutlet weak var airportLocationTxtField: UITextField!
    @IBOutlet weak var flightNumberTxtField: UITextField!
    @IBOutlet weak var otherTransferTxtVw: UITextView!
    @IBOutlet weak var otherTransferTxtVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var persionalDetailEditBtn: UIButton!
    @IBOutlet weak var contactInfoEditBtn: UIButton!
    @IBOutlet weak var regionLanguageEditBtn: UIButton!
    @IBOutlet weak var paEditBtn: UIButton!
    @IBOutlet weak var otherTransferEditBtn: UIButton!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!

    var arrivalTimePicker = UIDatePicker()
    var animationView: LottieAnimationView!
    var isPersionalDetailsEdit: Bool = false
    var isContactInfoEdit: Bool = false
    var isRegionLanguageEdit: Bool = false
    var isPAinfoEdit: Bool = false
    var isOtherTransferEdit: Bool = false
    var userDetails: UserDetailsData?
    var companyId = 0
    var categoryId = 0
    var businessSectorId = 0
    var base64String: String = ""
    var countries: [Country] = []
    
    var languageList = ["English", "Hindi", "Marathi"]
    var regionList = ["Africa", "Asia", "Central Asia", "Europe", "Latin America", "Middle East", "North America", "Oceania", "South Asia", "Southest Asia", "Western Asia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        if let user = self.userDetails {
            setData(user: user)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.successPopupVw.isHidden = true
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        for baseView in baseViewCollection {
            baseView.cornerRadius = 19.0
        }
        
        for baseVwTitleLbl in baseViewTitleLblCollection {
            baseVwTitleLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        }
        
        
        if isIndivisualUser {
            self.jobTitleBaseVw.isHidden = false
            self.resumeBaseVw.isHidden = false
            self.companyBaseVw.isHidden = false
        } else {
            self.jobTitleBaseVw.isHidden = true
            self.resumeBaseVw.isHidden = true
            self.companyBaseVw.isHidden = true
        }
        
        //country data from json string....
        self.loadCountries()
        
        profileView.applyBorderWithRadius(color: UIColor(hex: "#5894DD"), value: 2.0, radius: profileView.frame.size.width/2)
        profileImageView.cornerRadius = profileImageView.frame.size.width/2
        
        for lbl in headerLbllCollection {
            lbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
        for baseVw in textFieldBaseVwCollection {
            baseVw.applyBorderWithRadius(color: UIColor(hex: "#C3CCDF"), value: 1.0, radius: 8.0)
        }
        descriptionTxtVw.font = UIFont(name: Myfonts.regular, size: 14.0)
        descriptionTxtVw.delegate = self
        descriptionTxtVw.isScrollEnabled = false
        descriptionTxtVw.textContainer.lineFragmentPadding = 0
        descriptionTxtVw.textContainer.lineBreakMode = .byWordWrapping
        
        self.resumeBaseVw.cornerRadius = 12.0
        self.resumeTitleLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.resumeSubLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        self.persionalDetailEditBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 12.0)
        self.contactInfoEditBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 12.0)
        self.regionLanguageEditBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 12.0)
        self.paEditBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 12.0)
        self.otherTransferEditBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 12.0)
        
        self.persionalDetailEditBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.contactInfoEditBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.regionLanguageEditBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.paEditBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.otherTransferEditBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        
        self.airportTransferInfoVw.cornerRadius = 20.0
        self.airportTransferInfoLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        otherTransferTxtVw.font = UIFont(name: Myfonts.regular, size: 14.0)
        otherTransferTxtVw.delegate = self
        otherTransferTxtVw.isScrollEnabled = false
        otherTransferTxtVw.textContainer.lineFragmentPadding = 0
        otherTransferTxtVw.textContainer.lineBreakMode = .byWordWrapping
        
        
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
        
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 22)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
    }
    
    func setData(user: UserDetailsData) {
        if let imageUrl = user.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.profileImageView.image = UIImage(named: "profile")
        }
        
        self.nameTxtField.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        self.dobTxtField.text = user.dateOfBirth ?? ""
        self.companyTxtField.text = user.companyName ?? ""
        self.jobTitleTxtField.text = user.designation ?? ""
        self.categoryTxtField.text = user.categoryName ?? ""
        self.businessSectorTxtField.text = user.sectorName ?? ""
//        self.categoryTxtField.text = user.categoryLists?.first(where: { $0.id == user.categoryID })?.categoryName
//        self.businessSectorTxtField.text = user.sectorLists?.first(where: { $0.id == user.sectorID })?.name
        self.descriptionTxtVw.text = user.bioData ?? ""
        
        let descLblHeight = self.heightForView(text: self.descriptionTxtVw.text, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 100.0)
        self.descTxtVwHeight.constant = descLblHeight + 30.0
        self.companyId = Int(user.companyID ?? 0)
        self.categoryId = user.categoryID ?? 0
        self.businessSectorId = user.sectorID ?? 0
        
        self.countryPhnCodeTxtField.text = user.countryCode ?? ""
        self.mobileTxtField.text = user.phoneNumber ?? ""
        self.emailTxtField.text = user.email ?? ""
        self.websiteTxtField.text = user.companyURL ?? ""
        self.linkedinTxtField.text = user.linkedinURL ?? ""
        
        self.regionTxtField.text = user.region ?? ""
        self.languageTxtField.text = user.language ?? ""
        
        self.paNameTxtField.text = user.delegatePaName ?? ""
        self.paEmailTxtfield.text = user.delegatePaEmail ?? ""
        
        self.arrivalDateTxtField.text = user.dateOfArrival ?? ""
        self.arrivalTimeTxtField.text = user.timeOfArrival ?? ""
        self.airportLocationTxtField.text = user.location ?? ""
        self.flightNumberTxtField.text = user.flightNo ?? ""
        self.otherTransferTxtVw.text = user.transferDetails ?? ""
        
        let otherTransferLblHeight = self.heightForView(text: self.otherTransferTxtVw.text, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 100.0)
        self.otherTransferTxtVwHeight.constant = otherTransferLblHeight + 30.0
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    func loadCountries(){
        // Decode JSON into Swift objects
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                self.countries = try JSONDecoder().decode([Country].self, from: jsonData)
                if self.countries.count == 0 {
                    self.countryFlagLbl.text = "🇮🇳"
                    self.countryPhnCodeTxtField.text = "+91"
                } else {
                    self.countryFlagLbl.text = "\(countries[0].flag)"
                    self.countryPhnCodeTxtField.text = "\(countries[0].dialCode)"
                }
            } catch {
                print("❌ Decoding error:", error)
            }
        }
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
    }
    
    @IBAction func onUploadResumeBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
            let vc = UIStoryboard(storyboard: .jobs).instantiateViewController(withIdentifier: "UploadCVVC") as! UploadCVVC
            navigationController?.pushViewController(vc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onEditProfileImgBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
            self.openGallery()
        } else { print("Not Editable.") }
    }
    
    @IBAction func onCalenderBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
            self.openDatePicker()
        } else { print("Not Editable.") }
    }
    
    @IBAction func onCompanyDropBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
//            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
//            popupvc.modalPresentationStyle = .overFullScreen
//            popupvc.activeDataType = .company
//            popupvc.companyArray = self.userDetails?.companylists ?? []
//            popupvc.completion = { passedAns, passedId in
//                self.companyTxtField.text = passedAns
//                self.companyId = passedId
//            }
//            self.navigationController?.present(popupvc, animated: true)
            let vc = CompanyListPopupVC.instantiate()
            vc.activeDataType = .company
            vc.modalPresentationStyle = .overFullScreen
            vc.completion = { name, id in
                self.companyTxtField.text = name
                self.companyId = id
            }
            self.navigationController?.present(vc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onCategoryDropBtnTp(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
//            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
//            popupvc.modalPresentationStyle = .overFullScreen
//            popupvc.activeDataType = .category
//            popupvc.categoryArray = self.userDetails?.categoryLists ?? []
//            popupvc.completion = { passedAns, passedId in
//                self.categoryTxtField.text = passedAns
//                self.categoryId = passedId
//            }
//            self.navigationController?.present(popupvc, animated: true)
            let vc = CompanyListPopupVC.instantiate()
            vc.activeDataType = .category
            vc.modalPresentationStyle = .overFullScreen
            vc.completion = { name, id in
                self.categoryTxtField.text = name
                self.categoryId = id
            }
            self.navigationController?.present(vc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onCountrySelectBtnTap(_ sender: UIButton) {
        if self.isContactInfoEdit {
            if  self.countries.count == 0 {
                self.presentAlert("Country data not available")
            } else {
                let popupvc = CountryListVC(nibName: "CountryListVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                popupvc.countries = self.countries
                popupvc.completion = { country in
                    self.countryFlagLbl.text = country.flag
                    self.countryPhnCodeTxtField.text = country.dialCode
                }
                self.navigationController?.present(popupvc, animated: true)
            }
        } else { print("Not Editable.") }
    }
    
    @IBAction func onBusinessSectorDropBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
//            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
//            popupvc.modalPresentationStyle = .overFullScreen
//            popupvc.activeDataType = .sector
//            popupvc.sectorsArray = self.userDetails?.sectorLists ?? []
//            popupvc.completion = { passedAns, passedId in
//                self.businessSectorTxtField.text = passedAns
//                self.businessSectorId = passedId
//            }
//            self.navigationController?.present(popupvc, animated: true)
            let vc = CompanyListPopupVC.instantiate()
            vc.activeDataType = .sector
            vc.modalPresentationStyle = .overFullScreen
            vc.completion = { name, id in
                self.businessSectorTxtField.text = name
                self.businessSectorId = id
            }
            self.navigationController?.present(vc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onRegionDropBtnTap(_ sender: UIButton) {
        if self.isRegionLanguageEdit {
            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
            popupvc.modalPresentationStyle = .overFullScreen
            popupvc.activeDataType = .string
            popupvc.stringArray = self.regionList
            popupvc.completion = { passedAns, passedId in
                self.regionTxtField.text = passedAns
            }
            self.navigationController?.present(popupvc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onLanguageDropBtnTap(_ sender: UIButton) {
        if self.isRegionLanguageEdit {
            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
            popupvc.modalPresentationStyle = .overFullScreen
            popupvc.activeDataType = .string
            popupvc.stringArray = self.languageList
            popupvc.completion = { passedAns, passedId in
                self.languageTxtField.text = passedAns
            }
            self.navigationController?.present(popupvc, animated: true)
        } else { print("Not Editable.") }
    }
    
    @IBAction func onArrivalDateBtnTap(_ sender: UIButton) {
        if self.isOtherTransferEdit {
            self.openDatePicker()
        } else { print("Not Editable.") }
    }
    
    @IBAction func onArrivalTimeBtnTap(_ sender: UIButton) {
        if self.isOtherTransferEdit {
            self.openTimePicker()
            self.arrivalTimeTxtField.becomeFirstResponder()
        } else { print("Not Editable.") }
    }
    
    @IBAction func onPersionalInfoEditBtnTap(_ sender: UIButton) {
        if self.isPersionalDetailsEdit {
            self.updateInfo()
            self.isPersionalDetailsEdit = false
        } else {
            self.isPersionalDetailsEdit = true
        }
        self.isContactInfoEdit = false
        self.isRegionLanguageEdit = false
        self.isPAinfoEdit = false
        self.isOtherTransferEdit = false
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
    }
    
    @IBAction func onContactInfoEditBtnTap(_ sender: UIButton) {
        if self.isContactInfoEdit {
            self.updateInfo()
            self.isContactInfoEdit = false
        } else {
            self.isContactInfoEdit = true
        }
        self.isPersionalDetailsEdit = false
        self.isRegionLanguageEdit = false
        self.isPAinfoEdit = false
        self.isOtherTransferEdit = false
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
    }
    
    @IBAction func onRegionLanguageEditBtnTap(_ sender: UIButton) {
        if self.isRegionLanguageEdit {
            self.updateInfo()
            self.isRegionLanguageEdit = false
        } else {
            self.isRegionLanguageEdit = true
        }
        self.isPersionalDetailsEdit = false
        self.isContactInfoEdit = false
        self.isPAinfoEdit = false
        self.isOtherTransferEdit = false
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
    }
    
    @IBAction func onPAinfoEditBtnTap(_ sender: UIButton) {
        if self.isPAinfoEdit {
            self.updateInfo()
            self.isPAinfoEdit = false
        } else {
            self.isPAinfoEdit = true
        }
        self.isPersionalDetailsEdit = false
        self.isContactInfoEdit = false
        self.isRegionLanguageEdit = false
        self.isOtherTransferEdit = false
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
    }
    
    @IBAction func onOtherTransferEditBtnTap(_ sender: UIButton) {
        if self.isOtherTransferEdit {
            self.storeAirportTransferInfo()
            self.isOtherTransferEdit = false
        } else {
            self.isOtherTransferEdit = true
        }
        self.isPersionalDetailsEdit = false
        self.isContactInfoEdit = false
        self.isRegionLanguageEdit = false
        self.isPAinfoEdit = false
        self.persionalDetailsTextFieldUpdate()
        self.contactInformationTextFieldUpdate()
        self.regionLanguageTextFieldUpdate()
        self.paInfoTextFieldUpdate()
        self.otherTransferTextFieldUpdate()
    }
}

//MARK: ImagePicker Delegate Method...
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: TextView Delegate Method...
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = textView.font!.lineHeight * 7
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
            if textView == descriptionTxtVw {
                descTxtVwHeight.constant = estimatedSize.height
            } else {
                otherTransferTxtVwHeight.constant = estimatedSize.height
            }
        } else {
            textView.isScrollEnabled = true
            if textView == descriptionTxtVw {
                descTxtVwHeight.constant = maxHeight
            } else {
                otherTransferTxtVwHeight.constant = maxHeight
            }
        }
    }
}

//MARK: Datepicker...
extension EditProfileViewController {
    func openDatePicker() {
        let pickerVC = DatePickerSheetViewController()
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.pickerMode = .date
        
        if #available(iOS 15.0, *) {
            pickerVC.modalPresentationStyle = .pageSheet
            if let sheet = pickerVC.sheetPresentationController {
                sheet.detents = [.medium()] // or [.medium(), .large()]
            }
        } else {
            pickerVC.modalPresentationStyle = .formSheet // Fallback for iOS 14 and earlier
        }
        
        // Set max date to today for DOB...
        if self.isPersionalDetailsEdit {
            pickerVC.maximumDate = Date()
        }
        
        pickerVC.onDateSelected = { [weak self] date in
            let selectedDate = date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            if self?.isPersionalDetailsEdit == true {
                self?.dobTxtField.text = formatter.string(from: selectedDate)
            } else if self?.isOtherTransferEdit == true {
                self?.arrivalDateTxtField.text = formatter.string(from: selectedDate)
            }
        }
        present(pickerVC, animated: true)
    }
        
    func openTimePicker() {
        // Setup picker
        arrivalTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            arrivalTimePicker.preferredDatePickerStyle = .wheels
        }
        arrivalTimePicker.locale = Locale(identifier: "en_GB") // force 24-hour mode
        
        // Default selected time
        let now = Date()
        arrivalTimePicker.date = now
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        toolbar.tintColor = .black
        
        // Attach picker to textfield
        self.arrivalTimeTxtField.inputView = arrivalTimePicker
        self.arrivalTimeTxtField.inputAccessoryView = toolbar
        
//        // Set initial value
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.locale = Locale(identifier: "en_GB")
//        self.arrivalTimeTxtField.text = formatter.string(from: now)
    }
    
    @objc func doneStartTimePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // 24-hour format
        formatter.locale = Locale(identifier: "en_GB")
        self.arrivalTimeTxtField.text = formatter.string(from: arrivalTimePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}

//MARK: API Call...
extension EditProfileViewController {
    func updateInfo() {
        showActivity()
        var params: [String:Any] = [:]
        
        if self.isPersionalDetailsEdit {
            
            var cat_ID = ""
            if self.categoryId == 0 {
                cat_ID = ""
            } else {
                cat_ID = "\(self.categoryId)"
            }
            
            var sector_ID = ""
            if self.businessSectorId == 0 {
                sector_ID = ""
            } else {
                sector_ID = "\(self.businessSectorId)"
            }
            
            
            if let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.50) {
                let base64ImageString = imageData.base64EncodedString(options: [])
                base64String = "data:image/png;base64,\(base64ImageString)"
            } else { print("No need to update Image") }
            
            params = ["first_name": self.nameTxtField.text ?? "",
                      "dob": self.dobTxtField.text ?? "",
                      "company_id": self.companyId,
                      "designation": self.jobTitleTxtField.text ?? "",
                      "category_id": cat_ID,
                      "sector_id": sector_ID,
                      "bio_data": self.descriptionTxtVw.text ?? "",
                      "user_image": base64String,
                      "is_public": "\(self.userDetails?.isPublic ?? 0)"] as [String: Any]
        }
        else if self.isContactInfoEdit {
            params = ["country_phonecode": self.countryPhnCodeTxtField.text ?? "",
                      "phone_number": self.mobileTxtField.text ?? "",
                      "company_url": self.websiteTxtField.text ?? "",
                      "linkedin_image_url": self.linkedinTxtField.text ?? ""] as [String: Any]
        }
        else if self.isRegionLanguageEdit {
            params = ["region": self.regionTxtField.text ?? "",
                      "language": self.languageTxtField.text ?? ""] as [String: Any]
        }
        else if self.isPAinfoEdit {
            params = ["delegate_pa_name": self.paNameTxtField.text ?? "",
                      "delegate_pa_email": self.paEmailTxtfield.text ?? ""] as [String: Any]
        }
        
        let url = "\(EndPoints.userDetail)"
        NetworkManagerr.request(url, method: .patch, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !(root.error) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                } else {
                    self.presentAlert("Failure", root.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func storeAirportTransferInfo() {
        let parameters = [
            "arriaval_date": self.arrivalDateTxtField.text ?? "",
            "arrival_time": self.arrivalTimeTxtField.text ?? "",
            "airport_location": self.airportLocationTxtField.text ?? "",
            "flight_number": self.flightNumberTxtField.text ?? "",
            "otherdetails": self.otherTransferTxtVw.text ?? ""] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.userStoreAirportDetail,method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !(root.error) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                } else {
                    self.presentAlert("Failure", root.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
     }
}

//MARK: TextField Update...
extension EditProfileViewController {
    func persionalDetailsTextFieldUpdate() {
        self.dobTxtField.isUserInteractionEnabled = false
        self.categoryTxtField.isUserInteractionEnabled = false
        self.businessSectorTxtField.isUserInteractionEnabled = false
        
        if self.isPersionalDetailsEdit {
            self.persionalDetailEditBtn.backgroundColor = UIColor(hex: "#4D76CD")
            self.persionalDetailEditBtn.setTitle("Save", for: .normal)
            self.persionalDetailEditBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)

            self.nameTxtField.textColor = UIColor(hex: "#000000")
            self.nameTxtField.isUserInteractionEnabled = true
            self.dobTxtField.textColor = UIColor(hex: "#000000")
            self.companyTxtField.textColor = UIColor(hex: "#000000")
            self.companyTxtField.isUserInteractionEnabled = true
            self.jobTitleTxtField.textColor = UIColor(hex: "#000000")
            self.jobTitleTxtField.isUserInteractionEnabled = true
            self.categoryTxtField.textColor = UIColor(hex: "#000000")
            self.businessSectorTxtField.textColor = UIColor(hex: "#000000")
            self.descriptionTxtVw.textColor = UIColor(hex: "#000000")
            self.descriptionTxtVw.isUserInteractionEnabled = true
        } else {
            self.persionalDetailEditBtn.backgroundColor = UIColor.clear
            self.persionalDetailEditBtn.setTitle("Edit", for: .normal)
            self.persionalDetailEditBtn.setTitleColor(UIColor(hex: "#000000"), for: .normal)
            
            self.nameTxtField.textColor = UIColor(hex: "#707070")
            self.nameTxtField.isUserInteractionEnabled = false
            self.dobTxtField.textColor = UIColor(hex: "#707070")
            self.companyTxtField.textColor = UIColor(hex: "#707070")
            self.companyTxtField.isUserInteractionEnabled = false
            self.jobTitleTxtField.textColor = UIColor(hex: "#707070")
            self.jobTitleTxtField.isUserInteractionEnabled = false
            self.categoryTxtField.textColor = UIColor(hex: "#707070")
            self.businessSectorTxtField.textColor = UIColor(hex: "#707070")
            self.descriptionTxtVw.textColor = UIColor(hex: "#707070")
            self.descriptionTxtVw.isUserInteractionEnabled = false
        }
    }
    
    func contactInformationTextFieldUpdate() {
        if self.isContactInfoEdit {
            self.contactInfoEditBtn.backgroundColor = UIColor(hex: "#4D76CD")
            self.contactInfoEditBtn.setTitle("Save", for: .normal)
            self.contactInfoEditBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)

            self.countryPhnCodeTxtField.textColor = UIColor(hex: "#000000")
            self.countryPhnCodeTxtField.isUserInteractionEnabled = true
            self.mobileTxtField.textColor = UIColor(hex: "#000000")
            self.mobileTxtField.isUserInteractionEnabled = true
            self.emailTxtField.textColor = UIColor(hex: "#000000")
            self.emailTxtField.isUserInteractionEnabled = true
            self.websiteTxtField.textColor = UIColor(hex: "#000000")
            self.websiteTxtField.isUserInteractionEnabled = true
            self.linkedinTxtField.textColor = UIColor(hex: "#000000")
            self.linkedinTxtField.isUserInteractionEnabled = true
        } else {
            self.contactInfoEditBtn.backgroundColor = UIColor.clear
            self.contactInfoEditBtn.setTitle("Edit", for: .normal)
            self.contactInfoEditBtn.setTitleColor(UIColor(hex: "#000000"), for: .normal)
            
            self.countryPhnCodeTxtField.textColor = UIColor(hex: "#707070")
            self.countryPhnCodeTxtField.isUserInteractionEnabled = false
            self.mobileTxtField.textColor = UIColor(hex: "#707070")
            self.mobileTxtField.isUserInteractionEnabled = false
            self.emailTxtField.textColor = UIColor(hex: "#707070")
            self.emailTxtField.isUserInteractionEnabled = false
            self.websiteTxtField.textColor = UIColor(hex: "#707070")
            self.websiteTxtField.isUserInteractionEnabled = false
            self.linkedinTxtField.textColor = UIColor(hex: "#707070")
            self.linkedinTxtField.isUserInteractionEnabled = false
        }
    }
    
    func regionLanguageTextFieldUpdate() {
        self.regionTxtField.isUserInteractionEnabled = false
        self.languageTxtField.isUserInteractionEnabled = false
        
        if self.isRegionLanguageEdit {
            self.regionLanguageEditBtn.backgroundColor = UIColor(hex: "#4D76CD")
            self.regionLanguageEditBtn.setTitle("Save", for: .normal)
            self.regionLanguageEditBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)

            self.regionTxtField.textColor = UIColor(hex: "#000000")
            self.languageTxtField.textColor = UIColor(hex: "#000000")
        } else {
            self.regionLanguageEditBtn.backgroundColor = UIColor.clear
            self.regionLanguageEditBtn.setTitle("Edit", for: .normal)
            self.regionLanguageEditBtn.setTitleColor(UIColor(hex: "#000000"), for: .normal)
            
            self.regionTxtField.textColor = UIColor(hex: "#707070")
            self.languageTxtField.textColor = UIColor(hex: "#707070")
        }
    }
    
    func paInfoTextFieldUpdate() {
        if self.isPAinfoEdit {
            self.paEditBtn.backgroundColor = UIColor(hex: "#4D76CD")
            self.paEditBtn.setTitle("Save", for: .normal)
            self.paEditBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)

            self.paNameTxtField.textColor = UIColor(hex: "#000000")
            self.paNameTxtField.isUserInteractionEnabled = true
            self.paEmailTxtfield.textColor = UIColor(hex: "#000000")
            self.paEmailTxtfield.isUserInteractionEnabled = true
        } else {
            self.paEditBtn.backgroundColor = UIColor.clear
            self.paEditBtn.setTitle("Edit", for: .normal)
            self.paEditBtn.setTitleColor(UIColor(hex: "#000000"), for: .normal)
            
            self.paNameTxtField.textColor = UIColor(hex: "#707070")
            self.paNameTxtField.isUserInteractionEnabled = false
            self.paEmailTxtfield.textColor = UIColor(hex: "#707070")
            self.paEmailTxtfield.isUserInteractionEnabled = false
        }
    }
    
    func otherTransferTextFieldUpdate() {
        if self.isOtherTransferEdit {
            self.otherTransferEditBtn.backgroundColor = UIColor(hex: "#4D76CD")
            self.otherTransferEditBtn.setTitle("Save", for: .normal)
            self.otherTransferEditBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
            
            self.arrivalDateTxtField.isUserInteractionEnabled = true
            self.arrivalDateTxtField.textColor = UIColor(hex: "#000000")
            self.arrivalTimeTxtField.isUserInteractionEnabled = true
            self.arrivalTimeTxtField.textColor = UIColor(hex: "#000000")
            self.airportLocationTxtField.isUserInteractionEnabled = true
            self.airportLocationTxtField.textColor = UIColor(hex: "#000000")
            self.airportLocationTxtField.isUserInteractionEnabled = true
            self.flightNumberTxtField.textColor = UIColor(hex: "#000000")
            self.flightNumberTxtField.isUserInteractionEnabled = true
            self.otherTransferTxtVw.textColor = UIColor(hex: "#000000")
            self.otherTransferTxtVw.isUserInteractionEnabled = true
        } else {
            self.otherTransferEditBtn.backgroundColor = UIColor.clear
            self.otherTransferEditBtn.setTitle("Edit", for: .normal)
            self.otherTransferEditBtn.setTitleColor(UIColor(hex: "#000000"), for: .normal)
            
            self.arrivalDateTxtField.isUserInteractionEnabled = false
            self.arrivalDateTxtField.textColor = UIColor(hex: "#707070")
            self.arrivalTimeTxtField.isUserInteractionEnabled = false
            self.arrivalTimeTxtField.textColor = UIColor(hex: "#707070")
            self.airportLocationTxtField.isUserInteractionEnabled = false
            self.airportLocationTxtField.textColor = UIColor(hex: "#707070")
            self.airportLocationTxtField.isUserInteractionEnabled = false
            self.flightNumberTxtField.textColor = UIColor(hex: "#707070")
            self.flightNumberTxtField.isUserInteractionEnabled = false
            self.otherTransferTxtVw.textColor = UIColor(hex: "#707070")
            self.otherTransferTxtVw.isUserInteractionEnabled = false
        }
    }
}
