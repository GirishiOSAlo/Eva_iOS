//
//  SignUpVerifyEmailVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/22/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import SVProgressHUD
import Alamofire

class SignUpVerifyEmailVC: BaseForAuthentication {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var passcodeTxt: UITextField!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var resendOtp: UIButton!
    @IBOutlet weak var editEmail: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    var timer:Timer? = nil
    var totalSecond: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    let user = LoggedUserDetails.shared.user
    var email: String? = nil
    var pendingVerification = false
    var isFromForgotVC = false
    var otp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayoutStyle()
        self.startTimer()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.stopTimer()
        goBack()
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        verifyAccount()
    }
    
    @IBAction func resendOtpTapped(_ sender: UIButton) {
        resendVerificationCode()
    }
    
    @IBAction func editEmailTapped(_ sender: UIButton) {
        self.stopTimer()
        let vc = StoryboardRouter.forgotPasswordVC()
        vc.isfromEditEmail = true
        vc.email = self.email ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startTimer() {
        timerLbl.isHidden = true
        timerLbl.text = ""
        totalSecond = 120
        
        //Resend Button Disable...
        self.resendOtp.isUserInteractionEnabled = false
        self.resendOtp.setTitle("Resend OTP in", for: .normal)
        //self.resendOtp.setTitleColor(UIColor(hex: "#4D76CD", alpha: 0.5), for: .normal)
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timerLbl.isHidden = true
        self.timerLbl.text = ""
        timer?.invalidate()
        timer = nil
    }
    
    @objc func countdown() {
        //print("Time- ",totalSecond)
        if totalSecond == 0 {
            timer?.invalidate()
            timer = nil
            self.timerLbl.isHidden = true
            self.timerLbl.text = ""
            
            //Resend Button Enable...
            self.resendOtp.isUserInteractionEnabled = true
            self.resendOtp.setTitle("Resend verification code", for: .normal)
            //self.resendOtp.setTitleColor(UIColor(hex: "#4D76CD", alpha: 1.0), for: .normal)
        }
        else {
            minutes = (totalSecond / 60)
            seconds = (totalSecond % 3600) % 60
            self.timerLbl.isHidden = false
            self.timerLbl.text = String(format: "%02d:%02d", minutes, seconds) //00:10
            totalSecond = totalSecond - 1
        }
    }
}

extension SignUpVerifyEmailVC {
    
    private func setLayoutStyle() {
//        let isUser = email != nil ? true : UserType.user.rawValue == user?.type
//        giveButtonCorner(actionBtn: nextBtn, backColor: isUser ? Constants.AppColorLiteral.nextButtonColor : Constants.AppColorLiteral.nextButtonColor)
        nextBtn.layer.cornerRadius = 14
    
        let fullText = "Please enter the 6- digit email verification code that we have shared to \(email ?? "example.com")"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: "\(email ?? "example.com")") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#4D76CD"), range: NSRange(range, in: fullText))
        }

        descLabel.attributedText = attributedString

        let fullTitle = "Wrong Email address? Edit"
            
        // Create an attributed string with different colors for "Wrong Email address?" and "Edit"
        let attributedString2 = NSMutableAttributedString(string: fullTitle)
        attributedString2.addAttribute(.foregroundColor, value: UIColor.init(hex: "#707070"), range: NSRange(location: 0, length: fullTitle.count - 5))
        attributedString2.addAttribute(.foregroundColor, value: UIColor.init(hex: "#326FE9"), range: NSRange(location: fullTitle.count - 4, length: 4))
        
        editEmail.setAttributedTitle(attributedString2, for: .normal)
        
        editEmail.isHidden = isFromForgotVC
        
//        // Create an attributed string
//        let attributedString = NSMutableAttributedString(string: "Wrong Email address? Edit")
//
//        // Set the color attribute for the "Edit" portion of the string to blue
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.appBlue, range: NSRange(location: 22, length: 4))
//
//        // Set the attributed string as the button's title
//        editEmailBtn.setAttributedTitle(attributedString, for: .normal)
        
//        nextBtn.setTitle(isUser ? "Next" : "Finish", for: .normal)
//        if pendingVerification { nextBtn.setTitle("Verify", for: .normal) }
//        passcodeTxt.addTarget(self, action: #selector(textFeildChanged(_:)), for: .editingChanged)
    }
    
    private func goToNextScreen() {
        if isFromForgotVC {
            let vc = StoryboardRouter.editPasswordVC()
            vc.isFromForgotVC = true
            vc.email = email ?? ""
            vc.code = self.otpView.text ?? ""
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if UserType.user.rawValue == user?.type {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: NewsSourceVC.storyboardIdentifier) else { return }
                navigationController?.pushViewController(vc, animated: true)
            } else {
                gotoDashboard()
            }
        }
    }
    
    
    private func verifyAccount() {
        
        
        guard self.otpView.validate() else {
            self.presentAlert("Error", "Please enter OTP")
            return
        }
        self.callVerifyOtp()
//        if isFromForgotVC || pendingVerification {
//            verifyOTP()
//        } else {
//            self.goToNextScreen()
//        }
    }
    
    
    
    private func goToPasswordVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpPasswordVC.storyboardIdentifier) as? SignUpPasswordVC else { return }
//        vc.signUpDetails = signUpDetails
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SignUpVerifyEmailVC {
    
    func verifyOTP(){
//        if otp == self.otpView.text ?? "" {
//            self.stopTimer()
            if isFromForgotVC {
                let vc = StoryboardRouter.editPasswordVC()
                vc.isFromForgotVC = true
                vc.email = email ?? ""
                vc.code = self.otpView.text ?? ""
                navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpPasswordVC.storyboardIdentifier) as? SignUpPasswordVC else { return }
                navigationController?.pushViewController(vc, animated: true)
            }
//        } else {
//            self.presentAlert("Error", "Invalid OTP")
//        }
    }
    
    private func resendVerificationCode() {
        let content = email ?? ""
        let params: Parameters = ["email": content]
        showActivity()
        NetworkManagerr.request(EndPoints.resendOTP, method: .post, parameters: params) { [weak self] (result: Result<GenericResponse>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let success):
                if success.error { self.presentAlert("Error", success.message.capitalized) }
                else {
                    startTimer()
                    showToast(message: "OTP Sent")
                }
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
                
            @unknown default:
                break
            }
        }
    }
    
    func callVerifyOtp() {
        self.stopTimer()
        let parameters: AFParameters = [ "email" : self.email ?? "",
                                         "verification_code": otpView.text!]
        showActivity()
        NetworkManagerr.request(EndPoints.userVerification , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let verificationDetails = try decoder.decode(forgotPasswordModel.self, from: response.data!)
                    
                    if !(verificationDetails.error ?? false) {
                        self.verifyOTP()
                    } else {
                        self.presentAlert("Error", verificationDetails.message, nil)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
    }
}
