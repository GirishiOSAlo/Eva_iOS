//
//  SignUpJobSectorVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 21/12/2021.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class SignUpJobSectorVC: BaseForAuthentication {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var headerTitleLbl: NameLabel!
    
    @IBOutlet weak var businessSectorView: UIView!
    @IBOutlet weak var baseview1: UIView!
    @IBOutlet weak var sectorTextField: UITextField!
    @IBOutlet weak var chooseSectorBtn: UIButton!
    
    @IBOutlet weak var businessSubSectorView: UIView!
    @IBOutlet weak var baseview2: UIView!
    @IBOutlet weak var subSectorTextField: UITextField!
    @IBOutlet weak var chooseSubSectorBtn: UIButton!
    
    private var contentPickerView: ContentPickerView!
    var signUpDetails: SignUpDetails?
    
    var jobSectorList: [Sectors] = []
    var jobSubSectorList: [Sectors] = []
    
    var passedId:Int = 0
    var passedSubId:Int = 0
    var params = [:] as [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getSectors()
        setLayoutStyle()
        setContentPickerView()
        if signUpDetails?.userType == .company { hideInputs() }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
    
    @IBAction func chooseSectorBtnTapped(_ sender: Any) {
        showActivity()
        getSectors()
//        contentPickerView.title = "Pick sector"
//        contentPickerView.contentHeight = 250
//        contentPickerView.showDatePicker = false
//        contentPickerView.isShowing = true
//        getSectors()
        
    }
    
    @IBAction func chooseSubSectorBtnTapped(_ sender: UIButton) {
        if self.sectorTextField.text!.elementsEqual("") {
            makeAlert(titleMsg: "Warning", messageData: "Please first select Job Sector.")
        } else {
            showActivity()
            getSubSectors()
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
            
        if nextValidation() {
//        if chooseSectorBtn.title(for: .normal)?.trim ?? "" == "Choose" {
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please choose sector")
//        } else if companyTxt.text?.trim.isEmpty ?? false && signUpDetails?.userType == .user {
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please enter company name")
//        } else if jobTitleTxt.text?.trim.isEmpty ?? false && signUpDetails?.userType == .user {
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please enter job title")
//        } else {
//            signUpDetails?.sector = chooseSectorBtn.title(for: .normal)?.trim ?? ""
//            signUpDetails?.jobTitle = jobTitleTxt.text?.trim
//            signUpDetails?.company = companyTxt.text?.trim
//        }
//
            signUpDetails?.sector = self.passedId
            myUserDefaults.sector = "\(self.passedId)"
            signUpDetails?.subSector = subSectorTextField.text?.trim
            myUserDefaults.subSector = subSectorTextField.text?.trim ?? ""
            
            if myUserDefaults.user == "user" {
                goToJobDesriptionVC()
            } else {
                goToPasswordVC()
            }
        }
    }
    
    func nextValidation() -> Bool {
        if self.sectorTextField.text!.elementsEqual("") {
            makeAlert(titleMsg: "Warning", messageData: "Please select Job Sector.")
            return false
        }
        else if self.subSectorTextField.text!.elementsEqual("") {
            if myUserDefaults.isIndivisualUser {
                makeAlert(titleMsg: "Warning", messageData: "Please select Sub Sector.")
                return false
            } else {
                return true
            }
        }
        else {
            return true
        }
    }
}

// MARK: getSector
extension SignUpJobSectorVC {
    
    private func getSectors() {
        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: params) { [weak self] (response) in
//            guard let self = self, let sectors = try? JSONDecoder().decode(AllSectorModel.self, from: response.data!) else {
//                return }
            do {
                let jsonDecoder = JSONDecoder()
                let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
//                self.sectors.append(contentsOf: sectors.data)
                
                self?.jobSectorList = sectors.data
                let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                self?.hideActivity()
                popupvc.activeDataType = .sector
                popupvc.sectorsArray = self?.jobSectorList ?? []
                popupvc.completion = { passedAns, passedId in
                    self?.sectorTextField.text = passedAns
                    self?.passedId = passedId
                }
                self?.navigationController?.present(popupvc, animated: true)
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
            
            //self.contentPickerView.setPicker(values: sectors.data)
            
        }
    }
    
    
//    private func getSectors() {
//
//            let parameters = [:] as [String: Any]
//            NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: parameters) { (response) in
//
//                if response.result.isSuccess {
//                    do {
//                        let jsonDecoder = JSONDecoder()
//                        let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
//                        self.sectors.append(contentsOf: sectors.data)
//                        self.sectorTF.text = self.sectors.first ?? ""
//                    } catch {
//                        self.presentAlert("Failure", nil, response.result.error)
//                    }
//                }
//            }
//        }
    
    private func getSubSectors() {
        params = ["sector_id": passedId]
        NetworkManagerr.request(EndPoints.getSubSectors, method: .post, parameters: params) { [weak self] (response) in
            guard let self = self, let sectors = try? JSONDecoder().decode(AllSectorModel.self, from: response.data!) else {
                return }
            //self.contentPickerView.setPicker(values: sectors.data)
            jobSubSectorList = sectors.data
            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
            popupvc.modalPresentationStyle = .overFullScreen
            self.hideActivity()
            popupvc.activeDataType = .sector
            popupvc.sectorsArray = self.jobSubSectorList
            popupvc.completion = { passedAns, passedId in
                self.subSectorTextField.text = passedAns
                self.passedSubId = passedId
            }
            self.navigationController?.present(popupvc, animated: true)
            
        }
    }
    
}


extension SignUpJobSectorVC {
    
    private func setLayoutStyle() {
//        headerTitleLbl.text = signUpDetails?.userType == .user ? "Business Sector / Job Title" : "Company & Job Title"
        
        if myUserDefaults.isIndivisualUser {
            self.businessSubSectorView.isHidden = false
        } else {
            self.businessSubSectorView.isHidden = true
        }
        
        baseview1.applyBorderWithRadius()
        baseview2.applyBorderWithRadius()
        self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height/2
    }
    
    private func hideInputs() {
//        companyLbl.isHidden = true
//        jobTitleLbl.isHidden = true
    }
    
    private func goToPasswordVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpPasswordVC.storyboardIdentifier) as? SignUpPasswordVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToJobDesriptionVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpJobDescriptionVC.storyboardIdentifier) as? SignUpJobDescriptionVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpJobSectorVC  {
    
    private func setContentPickerView() {
        contentPickerView = ContentPickerView(contentView: view, pickerValues: [])
        contentPickerView.contentHeight = 0
        contentPickerView.doneBtn.addTarget(self, action: #selector(contentDoneBtnTapped), for: .touchUpInside)
    }
    
    @objc private func contentDoneBtnTapped() {
        contentPickerView.isShowing = false
        chooseSectorBtn.setTitle("   \(contentPickerView.getValue())", for: .normal)
    }
    
}
