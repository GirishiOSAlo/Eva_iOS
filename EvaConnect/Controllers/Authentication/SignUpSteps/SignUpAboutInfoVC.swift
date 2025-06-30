//
//  SignUpAboutInfoVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/20/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpAboutInfoVC: BaseForAuthentication {

    @IBOutlet weak var haveAnAccountBtn: UIButton!
    @IBOutlet weak var titleLbl: NameLabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var TVheightConst: NSLayoutConstraint!
    
    private var inputTextColor: UIColor!
    var signUpDetails: SignUpDetails?
    var delegate: EditUserProfileDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) { IQKeyboardManager.shared.isEnabled = false }
    override func viewWillDisappear(_ animated: Bool) { IQKeyboardManager.shared.isEnabled = true }
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func alreadyAccountBtnTapped(_ sender: Any) { goToRootViewController() }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if delegate != nil {
            if inputTextView.text.stringValue.isEmpty {
                ErrorView(contentView: navigationController?.view ?? view).show(message: "Please tell us about yourself")
            } else {
                updateBio()
            }
            return
        }
        
        signUpDetails?.about = inputTextView.text ?? ""
        myUserDefaults.bio = inputTextView.text ?? ""
        goToVerificationScreen()
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpLocationDOBVC.storyboardIdentifier) as? SignUpLocationDOBVC else { return }
//        vc.signUpDetails = signUpDetails
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpAboutInfoVC {
    
    private func setLayout() {
        
        // Set UITextView properties
        inputTextView.isScrollEnabled = false // Disable scrolling
        inputTextView.delegate = self // Set the delegate to self for handling resizing
//        inputTextView.font = UIFont.systemFont(ofSize: 16)
        
        //giveButtonCorner(actionBtn: nextBtn, backColor: Constants.AppColorLiteral.nextButtonColor)
        self.nextBtn.layer.cornerRadius = 14//self.nextBtn.frame.size.height/2
        inputContainerView.applyBorderWithRadius()
        inputTextColor = inputTextView.textColor
        inputTextView.delegate = self
        
        inputTextView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.25, radius: 10)
        
        let isCompany = signUpDetails?.userType == .company
//        titleLbl.text = isCompany ? "About your Company" : "About yourself"
        aboutLbl.text = isCompany ? "Tell us a bit about the company" : "Tell us a bit about yourself"
        
        if let bioData = LoggedUserDetails.shared.user?.bioData, !bioData.isEmpty {
            inputTextView.text = bioData
            inputTextView.textColor = .black
        }
        
        if delegate != nil {
            nextBtn.setTitle("Submit", for: .normal)
            haveAnAccountBtn.isHidden = true
        }
    }
}

extension SignUpAboutInfoVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == inputTextColor {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        resizeTextView()
    }
    
    func resizeTextView() {
        let fixedWidth = inputTextView.frame.size.width
        let newSize = inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        inputTextView.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        TVheightConst.constant = newSize.height
        
        if inputTextView.text != "" {
            nextBtn.setTitle("Done", for: .normal)
        } else {
            nextBtn.setTitle("Skip", for: .normal)
        }
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//
//        // Calculate the new height based on the content size
//        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//
//        // Update the height constraint of the UITextView (assuming you have a height constraint)
//        // If you don't have a height constraint, you can directly update the frame of the UITextView
//        textView.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
//
//
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            inputTextView.text = "Bio"
            inputTextView.textColor = inputTextColor
        }
    }
    
}

extension SignUpAboutInfoVC {
    
    private func updateBio() {
        nextBtn.isUserInteractionEnabled.toggle()
        ProfileManager.shared.updateProfile(params: ["bio_data": inputTextView.text.stringValue]) { [weak self] (error, message) in
            self?.nextBtn.isUserInteractionEnabled.toggle()
            if error { self?.presentAlert("Error", message, nil) }
            else { self?.navigationController?.popViewController(animated: true)  }
        }
    }
    
    private func goToVerificationScreen() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpSendVerificationEmailVC.storyboardIdentifier) as? SignUpSendVerificationEmailVC else { return }
        vc.userEmail = myUserDefaults.emailAdd
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
