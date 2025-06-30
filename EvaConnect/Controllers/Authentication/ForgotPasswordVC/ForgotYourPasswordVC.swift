//
//  ForgotYourPasswordVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/24/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class ForgotYourPasswordVC: BaseForAuthentication {

    @IBOutlet weak var navBarTitle: NameLabel!
    @IBOutlet weak var sendOTPBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var isfromEditEmail = false
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutStyle()
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    
    @IBAction func sendOTPBtnTapped(_ sender: Any) {
        if validation() {
            if !isfromEditEmail {
                sendVerificationCode()
            } else {
                guard emailTextField.text != "" else {
                    presentAlert("Alert", "Please write your Email")
                    return
                }
                callEditEmail()
            }
        }
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: NewPasswordVC.storyboardIdentifier) else { return }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func validation() -> Bool {
        if self.emailTextField.text!.elementsEqual("") {
            makeAlert(titleMsg: "Warning", messageData: "Please enter email address")
            return false
        }else {
            return true
        }
    }
}

extension ForgotYourPasswordVC {
    
    private func setLayoutStyle() {
        
        if isfromEditEmail {
            navBarTitle.text = "Edit Email Address"
            sendOTPBtn.setTitle("Verify", for: .normal)
        } else {
            navBarTitle.text = "Forgot Password"
            sendOTPBtn.setTitle("Send Link", for: .normal)
        }
        
        sendOTPBtn.isEnabled = true
        giveButtonCorner(actionBtn: sendOTPBtn, backColor: AppColors.appBlue)
//        emailTextField.addTarget(self, action: #selector(textFeildChanged(_:)), for: .editingChanged)
    }
    
//    @objc private func textFeildChanged(_ textField: UITextField) {
//        let isEmpty = textField.text?.isEmpty ?? false
//        sendLinkBtn.isEnabled = !isEmpty
//        sendLinkBtn.alpha = isEmpty ? 0.5 : 1
//    }
    
}

extension ForgotYourPasswordVC {
    
    // content can be email or username
    private func sendVerificationCode() {
        
//        let vc = StoryboardRouter.verifyCode()
//        vc.email = "pranay@appic.me"//content
//        self.navigationController?.pushViewController(vc, animated: true)
        
        guard ((emailTextField.text?.isEmpty) != nil) else {
            presentAlert("Please add email")
            return
        }
        
        let content = emailTextField.text ?? ""
        let params: Parameters = ["email": content]
        sendOTPBtn.isUserInteractionEnabled.toggle()
        showActivity()

        NetworkManagerr.request(EndPoints.sendForgotEmail, method: .post, parameters: params) { [weak self] (result: Result<forgotPasswordModel>) in
            guard let self = self else { return }
            self.sendOTPBtn.isUserInteractionEnabled.toggle()
            self.hideActivity()
            switch result {
            case .success(let success):
                if success.error ?? false { self.presentAlert("Error", success.message?.capitalized) }
                else {
                    let vc = StoryboardRouter.verifyCode()
                    vc.email = content
                    vc.isFromForgotVC = true
//                    vc.otp = "\(result.value?.data?.otp ?? 0)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            default:
                break
            }
        }
    }
    
    func callEditEmail() {
        let params: Parameters = ["old_email": self.email,
                                  "new_email": emailTextField.text!]
        showActivity()
        NetworkManagerr.request(EndPoints.editEmail, method: .post, parameters: params) { [self] (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error) {
                    let vc = StoryboardRouter.verifyCode()
                    vc.email = emailTextField.text ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
