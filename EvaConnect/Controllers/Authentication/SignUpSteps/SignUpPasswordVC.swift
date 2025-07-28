//
//  SignUpPasswordVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 21/12/2021.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import ValidationTextField

class SignUpPasswordVC: BaseForAuthentication {
    
    @IBOutlet weak var haveAnAccountBtn: UIButton!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var enterPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var showConfirmPassBtn: UIButton!
    
    
    var getUserImage: UIImage?
    var signUpDetails: SignUpDetails!
    var delegate: EditUserProfileDelegate? = nil
    var data: (email: String, code: String)? = nil
    
    var isPassShown = false
    var isConfPassShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayoutStyle()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
        
    @IBAction func showPassTapped(_ sender: UIButton) {
        isPassShown.toggle()
        if isPassShown {
            showPassBtn.setImage(UIImage(named: "shown_IC"), for: .normal)
            passwordTxt.isSecureTextEntry = false
        } else {
            showPassBtn.setImage(UIImage(named: "HiddenIC"), for: .normal)
            passwordTxt.isSecureTextEntry = true
        }
    }
    
    @IBAction func showConfirmPassTapped(_ sender: UIButton) {
        isConfPassShown.toggle()
        if isConfPassShown {
            showConfirmPassBtn.setImage(UIImage(named: "shown_IC"), for: .normal)
            confirmPasswordTxt.isSecureTextEntry = false
        } else {
            showConfirmPassBtn.setImage(UIImage(named: "HiddenIC"), for: .normal)
            confirmPasswordTxt.isSecureTextEntry = true
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
//        self.goToVerificationScreen()
        if delegate != nil {
            if let error = changeValidateField() {
                validationLabel.isHidden = false
                validationLabel.text = error
//                makeAlert(messageData: error)
                return
            }
        } else {
            if let error = validateField() {
                validationLabel.isHidden = false
                validationLabel.text = error
//                makeAlert(messageData: error)
                return
            }
        }
        
        myUserDefaults.password = confirmPasswordTxt.text ?? ""
        if let data = data {
            resetPasswod(email: data.email, code: data.code)
        } else if delegate != nil {
            validationLabel.isHidden = true
            changePassword()
        } else {
            validationLabel.isHidden = true
            createAccount()
            
        }
    }
    
}

extension SignUpPasswordVC {
    
    private func validateField() -> String? {
        if passwordTxt.text?.isEmpty ?? true {
            return "Please enter password"
        } else if (passwordTxt.text?.length ?? 0) < 8 {
            return "Password is short, must be greater than 8 characters"
        } else if !(passwordTxt.text ?? "").isValidPassword {
            return "Must contain Special characters,Letters,Numbers"
        } else if confirmPasswordTxt.text?.isEmpty ?? false {
            return "Please enter password again"
        } else if passwordTxt.text != confirmPasswordTxt.text {
            return "Passwords doesn't match"
        }
        return nil
    }
    
    private func changeValidateField() -> String? {
        if passwordTxt.text?.isEmpty ?? true {
            return "Please enter password"
        } else if (passwordTxt.text?.length ?? 0) < 8 {
            return "Password is short, must be greater than 8 characters"
        } else if !(passwordTxt.text ?? "").isValidPassword {
            return "Must contain Special characters,Letters,Numbers"
        } else if confirmPasswordTxt.text?.isEmpty ?? false {
            return "Please enter password again"
        } else if (confirmPasswordTxt.text?.length ?? 0) < 8 {
            return "Password is short, must be greater than 8 characters"
        } else if !(confirmPasswordTxt.text ?? "").isValidPassword {
            return "Please enter correct password"
        }
        
        return nil
    }
    
    private func setLayoutStyle() {
//        giveButtonCorner(actionBtn: nextBtn, backColor: Constants.AppColorLiteral.nextButtonColor)
        nextBtn.layer.cornerRadius = 14
        passwordTxt.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        if delegate != nil {
            haveAnAccountBtn.isHidden = true
            enterPasswordLbl.text = "Old Password"
            confirmPasswordLbl.text = "New Password"
            nextBtn.setTitle("Submit", for: .normal)
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if delegate != nil {
            if let error = changeValidateField() {
                validationLabel.isHidden = false
                validationLabel.text = error
                return
            } else {
                validationLabel.isHidden = true
                validationLabel.text = ""
            }
        } else {
            if let error = validateField() {
                validationLabel.isHidden = false
                validationLabel.text = error
                return
            } else {
                validationLabel.isHidden = true
                validationLabel.text = ""
            }
        }
    }
}

extension SignUpPasswordVC {
    
    func loadImage() -> UIImage? {
        if let filePath = UserDefaults.standard.string(forKey: "userImageFilePath") {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    func deleteImage() {
        if let filePath = UserDefaults.standard.string(forKey: "userImageFilePath") {
            do {
                try FileManager.default.removeItem(atPath: filePath)
                UserDefaults.standard.removeObject(forKey: "userImageFilePath")
            } catch {
                print("Error deleting image: \(error.localizedDescription)")
            }
        }
    }
}

extension SignUpPasswordVC {
    
    private func createAccount() {
        var parameters: Parameters = [:]
        if isIndivisualUser {
            parameters = [
                "fullname": myUserDefaults.fullName,
                "email": myUserDefaults.emailAdd,
                "mobile": myUserDefaults.mobileNo,
                "country_code": "91",
                "is_linkedin": 0,
                "linkedin_url": myUserDefaults.linkedIn,
                "password": passwordTxt.text!,
                "type": myUserDefaults.user,
                "sector_id": "",
                "category_id": myUserDefaults.Cat_id,
                "company_id": "\(myUserDefaults.companyId)",
                "designation": myUserDefaults.jobTitle,
                "region": myUserDefaults.region,
                "language": "English",
                "is_facebook": 0,
                "status": "active",
                "bio_data": myUserDefaults.bio
            ]
        } else {
            parameters = [
                "company_name": myUserDefaults.fullName,
                "linkedin_url": myUserDefaults.linkedIn,
                "mobile": myUserDefaults.mobileNo,
                "email": myUserDefaults.emailAdd,
                "type": myUserDefaults.user,
                "password": passwordTxt.text!,
                "status": "active",
                "language": "English",
                "company_url": myUserDefaults.websiteUrl,
                "sector_id": myUserDefaults.sector,
                "region": myUserDefaults.region,
                "bio_data": myUserDefaults.bio,
                "category_id": myUserDefaults.Cat_id,
                "is_facebook": 0,
                "is_linkedin": 0
            ]
        }
        
//        let email = (parameters["email"] as? String) ?? ""
//        let password = (parameters["password"] as? String) ?? ""
        if isIndivisualUser {
            if let loadedImage = loadImage() {
                //            if let userImage = loadedImage {
                if let imageData = loadedImage.jpegData(compressionQuality: 0.5) {
                    let base64ImageString = imageData.base64EncodedString(options: [])
                    parameters["user_image"] = "data:image/png;base64,\(base64ImageString)"
                    
                }
                //            }
            }
        } else{
            if let loadedImage = loadImage() {
                //            if let userImage = loadedImage {
                if let imageData = loadedImage.jpegData(compressionQuality: 0.5) {
                    let base64ImageString = imageData.base64EncodedString(options: [])
                    parameters["logo"] = "data:image/png;base64,\(base64ImageString)"
                    
                }
                //            }
            }
            }
        showActivity()
        NetworkManagerr.request(EndPoints.signUp, method: .post, parameters: parameters) { (response) in

            if response.result.isSuccess {

                do {
                    let genericRoot = try JSONDecoder().decode(SignUpModel.self, from: response.data!)
                    if (genericRoot.error ?? false ){
                        self.hideActivity()
                        self.makeAlert(messageData: genericRoot.message ?? "")
                    } else {
                        let response = genericRoot.data
                        myUserDefaults.userId = response?.id ?? 0
                        myUserDefaults.fullName = response?.firstName ?? ""
                        myUserDefaults.companyName = response?.companyName ?? ""
                        myUserDefaults.userImage = response?.userImage ?? ""
                        myUserDefaults.token = response?.token ?? ""
                        myUserDefaults.isPrivate = false
                        userDefaults.setValue(response?.token, forKeyPath: "UserToken")
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: NewsSourceVC.storyboardIdentifier) else { return }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } catch let error {
                    self.hideActivity()
                    self.makeAlert(messageData: "\(error)")
//                    self.nextBtn.isUserInteractionEnabled.toggle()
                }
                
            } else {
                self.hideActivity()
//                completion(nil, response.result.error)
            }
        }
        
        
//        showActivity()
//        uploadMultiformData(parameters) { [weak self] in
//            guard let self = self else { return }
//            LoginManagerr.login(email: email, password: password, socialMedia: self.signUpDetails.socialMedia, status: "pending") { [weak self] (_, error) in
//                guard let self = self else {
//                    self?.hideActivity()
//                    return
//                }
//                self.hideActivity()
//                if let error = error, error != "pending" {
//                    self.nextBtn.isUserInteractionEnabled.toggle()
//                    self.makeAlert(messageData: error)
//                } else {
//                    self.goToVerificationScreen()
//                }
//            }
//        }
    }
    
//    private func uploadMultiformData(_ parameters: Parameters, completion: @escaping () -> Void) {
//
//        var defaultHeaders = [
//            "Content-Type": "multipart/form-data"
//        ]
//
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//
//            if let userImage = self.signUpDetails.userImage {
//                let imageData = userImage.jpegData(compressionQuality: 0.80)
//                if let data = imageData {
//                    multipartFormData.append(data, withName: "user_image", fileName: "image.png", mimeType: "image/png")
//                }
//            }
//
//        }, to: EndPoints.signUp, method: .post, headers: defaultHeaders) { [weak self] result in
//            guard let self = self else { return }
//            // self.hideActivity()
//            switch result {
//                case .success(let upload, _, _):
//
//                    upload.uploadProgress(closure: { (progress) in
//                        //Print progress
//                        print(progress)
//                    })
//
//                    //To check and verify server error
//                    upload.responseString(completionHandler: { (response) in
//                        print(response)
//                        print (response.result)
//                    })
//
//                    upload.responseJSON { response in
//
//                        if let error = response.error {
//                            self.makeAlert(messageData: error.localizedDescription)
//                            self.hideActivity()
//                            self.nextBtn.isUserInteractionEnabled.toggle()
//                            return
//                        }
//
//                        if response.result.isFailure {
//                            self.makeAlert(messageData: "Something went wrong")
//                            return
//                        }
//
//                        do {
//                            let genericRoot = try JSONDecoder().decode(GenericResponse.self, from: response.data!)
//                            if genericRoot.error {
//                                self.makeAlert(messageData: genericRoot.message)
//                            } else {
//                                completion()
//                            }
//                        } catch let error {
//                            self.hideActivity()
//                            self.makeAlert(messageData: error.localizedDescription)
//                            self.nextBtn.isUserInteractionEnabled.toggle()
//                        }
//
//                    }
//
//                case .failure(let error):
//                    self.hideActivity()
//                    self.makeAlert(messageData: error.localizedDescription)
//                    self.nextBtn.isUserInteractionEnabled.toggle()
//            }
//
//        }
//
//    }
    
    private func goToVerificationScreen() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpSendVerificationEmailVC.storyboardIdentifier) as? SignUpSendVerificationEmailVC else { return }
        vc.userEmail = myUserDefaults.emailAdd
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension SignUpPasswordVC {
    
    private func resetPasswod(email: String, code: String) {
        let password = passwordTxt.text ?? ""
        nextBtn.isUserInteractionEnabled.toggle()
        ProfileManager.shared.resetPassword(email: email, code: code, password: password) { error, message in
            self.nextBtn.isUserInteractionEnabled.toggle()
            self.presentAlertWithAction(title: error ? "Error" : "Success", message: message.capitalized) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func changePassword() {
        let params: Parameters = ["password": confirmPasswordTxt.text ?? ""]
        self.nextBtn.isUserInteractionEnabled.toggle()
        ProfileManager.shared.updateProfile(params: params) { [weak self] (error, message) in
            self?.nextBtn.isUserInteractionEnabled.toggle()
            if error { self?.presentAlert("Error", message, nil) }
            else { self?.navigationController?.popViewController(animated: true)  }
        }
    }
}
