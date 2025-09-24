//
//  EditPasswordVC.swift
//  EvaConnect
//
//  Created by usama on 06/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class EditPasswordVC: BaseForAuthentication {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var oldPassWholeView: UIView!
    @IBOutlet weak var oldPassView: UIView!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var oldPassPrivacyBtn: UIButton!
    
    @IBOutlet weak var newPassWholeView: UIView!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var newPassPrivacyBtn: UIButton!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmPassWholeView: UIView!
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var confirmPassPrivacyBtn: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var send: UIButton!

    @IBOutlet weak var changePasswordHeadingLbl: HeadingLabel!
    @IBOutlet weak var createAccHeadingLabel: HeadingLabel!
    var dismissGesture: UITapGestureRecognizer!
    var isFromForgotVC = false
    var email = ""
    var code = ""
    
    var isOldPassShown = false
    var isNewPassShown = false
    var isConfPassShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        initUI()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
//        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send_touchUpInside(_ sender: UIButton) {
        
        if isFromForgotVC {
            resetValidation()
        } else {
            changeValidation()
        }
    }
    
    @IBAction func oldPassTapped(_ sender: UIButton) {
        
        isOldPassShown.toggle()
        if isOldPassShown {
            oldPassPrivacyBtn.setImage(UIImage(named: "ic_showEye"), for: .normal)
            oldPassword.isSecureTextEntry = false
        } else {
            oldPassPrivacyBtn.setImage(UIImage(named: "ic_hideEye"), for: .normal)
            oldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func newPassTapped(_ sender: UIButton) {
        
        isNewPassShown.toggle()
        if isNewPassShown {
            newPassPrivacyBtn.setImage(UIImage(named: "ic_showEye"), for: .normal)
            newPassword.isSecureTextEntry = false
        } else {
            newPassPrivacyBtn.setImage(UIImage(named: "ic_hideEye"), for: .normal)
            newPassword.isSecureTextEntry = true
        }
        
    }
    
    @IBAction func confirmPassTapped(_ sender: UIButton) {
        
        isConfPassShown.toggle()
        if isConfPassShown {
            confirmPassPrivacyBtn.setImage(UIImage(named: "ic_showEye"), for: .normal)
            confirmPassword.isSecureTextEntry = false
        } else {
            confirmPassPrivacyBtn.setImage(UIImage(named: "ic_hideEye"), for: .normal)
            confirmPassword.isSecureTextEntry = true
        }
    }
}

extension EditPasswordVC {
    
    func initUI() {
        
        oldPassWholeView.isHidden = isFromForgotVC
        changePasswordHeadingLbl.isHidden = isFromForgotVC
        createAccHeadingLabel.isHidden = !isFromForgotVC
        
        send.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 14.0)
        send.backgroundColor = AppColors.dullRed
        send.setTitleColor(.white, for: .normal)
        
        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        dismissGesture.delegate = self
        view.addGestureRecognizer(dismissGesture)
        
        oldPassView.cornerRadius = 10
        oldPassView.borderColor = UIColor(hex: "#837A88")
        oldPassView.borderWidth = 0.25
        oldPassView.backgroundColor = .white
        
        newPassView.cornerRadius = 10
        newPassView.borderColor = UIColor(hex: "#837A88")
        newPassView.borderWidth = 0.25
        newPassView.backgroundColor = .white
        
        confirmPassView.cornerRadius = 10
        confirmPassView.borderColor = UIColor(hex: "#837A88")
        confirmPassView.borderWidth = 0.25
        confirmPassView.backgroundColor = .white
        
        if isFromForgotVC {
            send.backgroundColor = AppColors.appBlue
            send.setTitle("Done", for: .normal)
        }else{
            send.backgroundColor = AppColors.appBlue
            send.setTitle("Submit", for: .normal)
        }
        send.cornerRadius = 20
        
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeValidation(){
        if oldPassword.text!.isEmpty {
            self.presentAlert("Alert", "Please enter your current password", nil)
        } else if newPassword.text!.isEmpty {
            self.presentAlert("Alert", "Please enter your new password", nil)
        }else if (newPassword.text?.length ?? 0) < 8 {
            self.presentAlert("Alert","Password is short, must be greater than 8 characters")
        } else if !(newPassword.text ?? "").isValidPassword {
            self.presentAlert("Alert","Must contain Special characters,Letters,Numbers")
        } else if confirmPassword.text!.isEmpty {
            self.presentAlert("Alert", "Please enter new password again", nil)
        } else if newPassword.text != confirmPassword.text {
            self.presentAlert("Alert", "Passwords do not match", nil)
        } else {
            changeCall()
        }
    }
    
    func resetValidation(){
        if newPassword.text!.isEmpty {
            self.presentAlert("Alert", "Please enter your new password", nil)
        } else if confirmPassword.text!.isEmpty {
            self.presentAlert("Alert", "Please enter new password again", nil)
        } else if (newPassword.text?.length ?? 0) < 8 {
            self.presentAlert("Alert","Password is short, must be greater than 8 characters")
        } else if !(newPassword.text ?? "").isValidPassword {
            self.presentAlert("Alert","Must contain Special characters,Letters,Numbers")
        } else if newPassword.text != confirmPassword.text {
            self.presentAlert("Alert", "Passwords do not match", nil)
        } else {
            resetPasswordCall()
        }
    }
    
    func resetPasswordCall() {
        
//        if let user = LoggedUserDetails.shared.user {
            let parameters: Parameters = ["email": self.email,
                                          "verification_code": self.code,
                                          "new_password": newPassword.text!,
                                          "new_password_confirmation": confirmPassword.text!] as [String : Any]
            
            NetworkManagerr.request(EndPoints.resetPassword, method: .post, parameters: parameters) { (response) in
                
                let jsonDecoder = JSONDecoder()
                let genericResponse = try! jsonDecoder.decode(forgotPasswordModel.self, from:response.data!)
                
                if !(genericResponse.error ?? false) {
                    self.presentAlertWithAction(title: "Success", message: "Password changed successfully") {
//                        if self.isFromForgotVC {
//                            self.gotoDashboard()
                        self.goToRootViewController()
//                        } else {
//                            self.dismiss(animated: true, completion: nil)
//                        }
                    }
                } else {
                    self.presentAlert("Failure", genericResponse.message, nil)
                }
            }
//        }
    }
    
    
    func changeCall() {
        
//        if let user = LoggedUserDetails.shared.user {
            let parameters: Parameters = ["user_id": myUserDefaults.userId,
                                          "old_password": oldPassword.text!,
                                          "new_password": newPassword.text!] as [String : Any]
            
            NetworkManagerr.request(EndPoints.changePassword, method: .post, parameters: parameters) { (response) in
                
                let jsonDecoder = JSONDecoder()
                let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                
                if !genericResponse.error {
                    self.presentAlertWithAction(title: "Success", message: "Password changed successfully") {
                        if self.isFromForgotVC {
                            self.gotoDashboard()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    self.presentAlert("Failure", genericResponse.message, nil)
                }
            }
//        }
    }
    
    
    
}

extension EditPasswordVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: passwordView) == true {
            return false
        }
        return true
    }
}
