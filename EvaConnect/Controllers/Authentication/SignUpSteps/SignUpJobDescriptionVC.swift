//
//  SignUpJobDescriptionVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 08/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class SignUpJobDescriptionVC: BaseForAuthentication {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var headerTitleLbl: NameLabel!
    @IBOutlet weak var baseview1: UIView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var baseview2: UIView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    
    @IBOutlet weak var showCompanyListBtn: UIButton!
    
    var signUpDetails: SignUpDetails?
    var companyId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutStyle()
    }
    
    private func setLayoutStyle() {

//        companyNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        companyNameTextField.isUserInteractionEnabled = false
//        companyNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        baseview1.applyBorderWithRadius()
        baseview2.applyBorderWithRadius()
        self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height/2
    }
    
    private func goToPasswordVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpPasswordVC.storyboardIdentifier) as? SignUpPasswordVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if nextValidation() {
//            signUpDetails?.company = companyNameTextField.text?.trim
            myUserDefaults.companyName = companyNameTextField.text?.trim ?? ""
//            signUpDetails?.jobTitle = jobTitleTextField.text?.trim
            myUserDefaults.jobTitle = jobTitleTextField.text?.trim ?? ""
//            signUpDetails?.companyId = self.companyId
            myUserDefaults.companyId = self.companyId
            self.goToPasswordVC()
        }
    }
    
    func nextValidation() -> Bool {
        if self.companyNameTextField.text!.elementsEqual("") {
            makeAlert(titleMsg: "Warning", messageData: "Please select Company name")
            return false
        }
        else if self.jobTitleTextField.text!.elementsEqual("") {
            makeAlert(titleMsg: "Warning", messageData: "Please select Job title")
            return false
        }
        else {
            return true
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) { goBack() }

    @IBAction func showComListBtnTapped(_ sender: UIButton) {
        let vc = CompanyListPopupVC.instantiate()
        vc.activeDataType = .company
        vc.modalPresentationStyle = .overFullScreen
        vc.completion = { name, id in
            self.companyNameTextField.text = name
            self.companyId = id
        }
        self.navigationController?.present(vc, animated: true)
    }
    
}

//extension SignUpJobDescriptionVC : UITextFieldDelegate {
//    //MARK: TextField Delegates
//    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
//        self.view.isUserInteractionEnabled = true
//        return false
//    }
//    
//    @objc func textFieldDidChange(_ textfield: UITextField) {
//        
////        if textfield == companyNameTextField && textfield.text == "" {
////            textfield.resignFirstResponder()
////            let vc = CompanyListPopupVC.instantiate()
////            vc.modalPresentationStyle = .overFullScreen
////            vc.completion = { name, id in
////                textfield.text = name
////                self.companyId = id
////            }
////            self.navigationController?.present(vc, animated: true)
////        }
//    }
//}


