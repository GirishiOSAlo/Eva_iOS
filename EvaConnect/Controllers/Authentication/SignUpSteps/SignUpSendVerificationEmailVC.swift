//
//  SignUpSendVerificationEmailVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/22/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class SignUpSendVerificationEmailVC: BaseForAuthentication {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var verifyEmailHeadingLbl: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var userEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutStyle()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpVerifyEmailVC.storyboardIdentifier) else { return }
        sendOTPCall()
    }
}

extension SignUpSendVerificationEmailVC {
    
    private func setLayoutStyle() {
        
        let fullText = "In order to start using your Aviation Connect account, you need to verify your email address: \(userEmail)"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: "\(userEmail)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#4D76CD"), range: NSRange(range, in: fullText))
        }

        infoLabel.attributedText = attributedString
//        giveButtonCorner(actionBtn: nextBtn, backColor: AppColors.appBlue)
        nextBtn.layer.cornerRadius = 14
    }
    
}

extension SignUpSendVerificationEmailVC {
    
    private func sendOTPCall() {
        
        let param: AFParameters = [
            "email" : userEmail
        ]
        
        NetworkManagerr.request(EndPoints.sendOTP, method: .post, parameters: param) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let OTPRoot = try jsonDecoder.decode(OTPModel.self, from: response.data!)
                
                if !(OTPRoot.error ?? false) {
                    let vc = StoryboardRouter.verifyCode()
                    vc.email = self?.userEmail
                    vc.otp = String(OTPRoot.data?.otp ?? 0)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
    
}
