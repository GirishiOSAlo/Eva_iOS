//
//  LoginVC.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import ValidationTextField
//import IHProgressHUD
//import FacebookLogin
//import FBSDKCoreKit
//import FBSDKLoginKit

//protocol FBInjectable {
//    func inject(fbData: FBData)
//}

class LoginVC: BaseForAuthentication {
    
    //MARK:- OUTLETS
    @IBOutlet weak var rememberMeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordTextBaseView: UIView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTextBaseView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var loginByLinkedin: UIButton!
    @IBOutlet weak var loginByFaceBook: UIButton!
    @IBOutlet weak var signup_Lbl: UILabel!
    @IBOutlet weak var showPassBtn: UIButton!
    
    //MARK:- Variables
    var emailVaild = false
    var passwordVaild = false
    var gotoNext = false
    var validDic = ["name": false, "email":false, "pw":false, "pwc": false]
    var isFaceBook = false
    var rememberMe = false
    var isPassShown = false
    var isRegistrationEnable = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setLayOut()
        
        //        #if DEBUG
        //        emailTxt.text = "company.sol@gmail.com"
        //        passwordTxt.text = "Aa123456@"
        //        emailVaild = true
        //        passwordVaild = true
        //        #endif
        
        //        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
        //
        //            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        //        }
        //
        //
        //        let deletepermission = GraphRequest(graphPath: "/me/permissions", parameters: [:]
        //            , httpMethod: .delete)
        //
        //        deletepermission.start { (connection,result,error) -> Void in
        //            print("the delete permission is \(result)")
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.getSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SignUpVC_Step1, let signUpDetails = sender as? SignUpDetails {
            destination.signUpDetails = signUpDetails
        }
    }
    
    func setupSignUpLbl() {
        self.signup_Lbl.text = "Don't have an account ? Sign up"
        
        let labelAttriString = NSMutableAttributedString(string: signup_Lbl.text!)
        
        let range1 = (signup_Lbl.text! as NSString).range(of: "Sign up")
        labelAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SFProText-Regular", size: 14.0)!, range: range1)
        labelAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#326FE9") as UIColor, range: range1)

        signup_Lbl.attributedText = labelAttriString
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.signup_Lbl.addGestureRecognizer(tap)
        self.signup_Lbl.isUserInteractionEnabled = true
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        if isRegistrationEnable {
            let signupRange = (signup_Lbl.text! as NSString).range(of: "Sign up")
            
            if tap.didTapAttributedTextInLabel(label: self.signup_Lbl, inRange: signupRange) {
                navigationController?.pushViewController(StoryboardRouter.signUpVC(), animated: true)
            }
            else {
                print("Tapped None")
            }
        } else {
            presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }

    }
    
    func setLayOut(){
        self.setupSignUpLbl()
        self.emailTextBaseView.applyBorderWithRadius()
        self.passwordTextBaseView.applyBorderWithRadius()
        
        self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2
        
//        emailTxt.validCondition = { $0.isValidEmail}
//        passwordTxt.validCondition = { $0.isValidPassword }
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        let savedRememberMe = KeychainService.getRememberMe()
        let savedEmail = KeychainService.getEmail()
        let savedPassword = KeychainService.getPassword()
        
        rememberMeBtn.setImage(UIImage(named: savedRememberMe ? "ic_check" : "ic_uncheck"), for: .normal)
        self.rememberMe = savedRememberMe
        emailTxt.text = savedRememberMe ? savedEmail : ""
        passwordTxt.text = savedRememberMe ? savedPassword : ""
        
//        giveButtonCorner(actionBtn: signUpBtn,backColor: Constants.AppColorLiteral.signUpNew)
//        giveButtonCorner(actionBtn: loginBtn,backColor: Constants.AppColorLiteral.loginColor)
//        giveButtonCorner(actionBtn: loginByLinkedin,backColor: Constants.AppColorLiteral.loginByNew)
//        giveButtonCorner(actionBtn: loginByFaceBook,backColor: Constants.AppColorLiteral.loginByFacebook)
        emailTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    private func getSettings() {
        NetworkManagerr.request(EndPoints.settingsOptions) { [weak self] (response) in
            self?.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SettingsOptionsDataModel.self, from: response.data!)
                self?.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self?.isRegistrationEnable = data[0].registrations ?? true
                    }
                } else {
                    self?.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
            
        }
    }
    
    @IBAction func rememberMeBtnTapped(_ sender: Any) {
        rememberMe.toggle()
        rememberMeBtn.tintColor = UIColor(named: rememberMe ? "AppColor" : "BackColor")!
        
        rememberMeBtn.setImage(UIImage(named: rememberMe ? "ic_check" : "ic_uncheck"), for: .normal)
        
        print("RememberMe after Value", rememberMe)
        
    }
    
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
}

//MARK: TextField Delegate
extension LoginVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
//        let tf = textfield as! ValidationTextField
//
//        switch tf {
//
//        case emailTxt:
//
//            validDic["email"] = tf.isValid
//            if emailTxt.text?.count != 0 || !emailTxt.text!.isEmpty{
//                emailTxt.isValid = emailTxt.text!.isValidEmail
//            } else {
//                emailTxt.isValid = emailTxt.text!.isValidEmail
//            }
//            break
//
//        case passwordTxt:
//            validDic["pw"] = tf.isValid
//
//            if passwordTxt.text?.count != 0 || !passwordTxt.text!.isEmpty{
//                passwordTxt.isValid = passwordTxt.text!.isValidPassword
//            }
//            else{
//                passwordTxt.isValid = passwordTxt.text!.isValidPassword
//            }
//            passwordTxt.clearsOnBeginEditing = false
//            break
//        default:
//            break
//        }
//        tf.successImage = UIImage(named: "success")
//        tf.errorImage = UIImage(named: "error")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginVC {
    
    @IBAction func signUp(_ sender: Any) {
//        navigationController?.pushViewController(StoryboardRouter.signUpVC(), animated: true)
        //self.performSegue(withIdentifier: Constants.Segues.signUp1, sender: nil)
        
        checkIfUserExists(email: emailTxt.text!) { emailExists in

            if !emailExists.isNil {
                self.presentAlert("Failure", "This account is already registered", nil)
                self.emailTxt.text = ""
                self.passwordTxt.text = ""
            } else {
//                        self.performSegue(withIdentifier: Constants.Segues.signUp1, sender: self.signUpData())
                self.navigationController?.pushViewController(StoryboardRouter.signUpVC(), animated: true)
            }
        }
    }
    
    @IBAction func forgotPasswordVC(_ sender: Any) {
        goToForgotPasswordVC()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    @IBAction func login(_ sender: Any) {
//        self.gotoDashboard()
        if emailTxt.text!.isValidEmail {

            LoginManagerr.login(email: emailTxt.text!, password: passwordTxt.text!, socialMedia: nil) { (loginUser, errorMessage) in

                if let user = loginUser {
                    KeychainService.saveRememberMe(rememberMe: self.rememberMe)
                    KeychainService.saveEmail(email: self.emailTxt.text!)
                    KeychainService.savePassword(password: self.passwordTxt.text!)
                    myUserDefaults.userId = user.id ?? 0
                    myUserDefaults.fullName = user.firstName ?? ""
                    myUserDefaults.companyName = user.companyName ?? ""
                    myUserDefaults.userImage = user.userImage ?? ""
                    myUserDefaults.token = user.token ?? ""
                    
                    if user.isPublic == 0 {
                        myUserDefaults.isPrivate = true
                    } else {
                        myUserDefaults.isPrivate = false
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FCMToken"), object: nil)
                    self.gotoDashboard()
                }

                if let errorMessage = errorMessage {
                    if errorMessage == "pending" {
                        self.presentAlertWithAction(title: "Warning", message: "Please verify yourself", positiveTitle: "Verify", negativeTitle: "Cancel") {
                            self.sendPendingVerification(email: self.emailTxt.text!)
                        }
                    } else {
                        self.makeAlert(messageData: errorMessage)
                    }
                }
            }
        } else if !emailTxt.text!.isValidEmail {
            if passwordTxt.text.isNilOrEmpty || emailTxt.text.isNilOrEmpty {
                self.makeAlert(titleMsg: "Empty Fields", messageData: "Please Provide Input to Proceed ")
            } else {
                self.makeAlert(titleMsg: "Invaild Password", messageData: "Please Provide correct Input to Proceed ")
            }
        } else {
            self.makeAlert(titleMsg: "Invaild Email", messageData: "Please Provide correct Input to Proceed ")
        }
    }
    
    @IBAction func logInByLinkedin(_ sender: Any) {
        let vc = StoryboardRouter.loginByLinkedin()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true)
        //        performSegue(withIdentifier: Constants.Segues.linkedIn, sender: self)
    }
    
//    @IBAction func fb_touchUpInside(_ sender: UIButton) {
//        showActivity()
//        LoginManager().logOut()
//        let fbLoginManager: LoginManager = LoginManager()
//        fbLoginManager.logIn(permissions: ["email", "publicProfile"], from: self) { (result,error) in
//
//            if error != nil {
//                self.presentAlert("Error", "\(error?.localizedDescription ?? "")", nil)
//                return
//            }
//
//
//            let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
//            let graphRequest = GraphRequest(graphPath: "/me", parameters: params)
//            let connection = GraphRequestConnection()
//            connection.add(graphRequest) { (connection, result, error) in
//                let info = result as! [String : AnyObject]
//
//                self.checkIfUserExists(email: info["email"] as! String) { (isFacebook) in
//
//                    if let isFacebook = isFacebook, isFacebook {
//                        LoginManagerr.login(email: info["email"] as! String, password: nil, socialMedia: .facebook) { (loginUser, errorMessage) in
//
//                            if let _ = loginUser {
//                                self.gotoDashboard()
//                            }
//
//                            if let errorMessage = errorMessage {
//                                self.makeAlert(messageData: errorMessage)
//                            }
//                        }
//                    } else {
//                        let vc = StoryboardRouter.signUpVC()
//                        vc.signUpDetails = self.convertDictToFbData(sender: info)
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            }
//            connection.start()
//
//        }
//    }
    
    func checkIfUserExists(email: String, completion:@escaping (Bool?) -> Void) {
        
        let parameters: Parameters = ["email": email]
        NetworkManagerr.request(EndPoints.checkUserEmail, method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            
            let jsonDecoder = JSONDecoder()
            let userCheck = try! jsonDecoder.decode(UserCheckRoot.self, from: response.data!)
            
            if userCheck.error,  userCheck.error, userCheck.message ==  "record not found" {
                completion(nil)
                
            } else if !userCheck.error, userCheck.data[0].is_facebook == 1 {
                completion(true)
            } else {
                
                self.presentAlert("Error", userCheck.message, nil)
                completion(false)
            }
        }
    }
    
    func goToForgotPasswordVC() {
        let vc = StoryboardRouter.forgotPasswordVC()
        vc.isfromEditEmail = false
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LoginVC {
    
    func convertDictToFbData(sender: [String : AnyObject]) -> SignUpDetails? {
        
        if let firstName = sender["first_name"] as? String,
           let lastName = sender["last_name"] as? String,
           let pictureUrl = sender["picture"] as? NSDictionary,
           let email = sender["email"] as? String {
            let pictureDictionary = sender["picture"] as? Dictionary<String, Any>
            guard let imageUrl = pictureDictionary?["url"] as? String else {
                
                return SignUpDetails(firstName: firstName, lastName: lastName, email: email, password: nil, userType: nil, sector: nil, workAviationType: nil, city: nil, country: nil, userImage: nil, socialMedia: .facebook)
            }
            
            return SignUpDetails(firstName: firstName, lastName: lastName, email: email, password: nil, userType: nil, sector: nil, workAviationType: nil, city: nil, country: nil, userImageURI: imageUrl, socialMedia: .facebook)
        }
        return nil
    }
}

extension LoginVC {
    
    private func sendPendingVerification(email: String) {
        showActivity()
        NetworkManagerr.request(EndPoints.pendingVerificationEmail, method: .post, parameters: ["email": email]) { [weak self] (result: Result<GenericResponse>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let value):
                self.presentAlert(value.error ? "Error" : "Success", value.message) {
                    if !value.error {
                        let vc = StoryboardRouter.verifyCode()
                        vc.email = email
                        vc.pendingVerification = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(let error):
                self.presentAlert("Error", error.localizedDescription)
            }
        }
    }
    
}

extension LoginVC: LoginByLinkedinDelegate {
    
    func redirectLinkedinInfoToCreateAccount(_ details: SignUpDetails?) {
        let vc = StoryboardRouter.signUpVC()
        vc.signUpDetails = details
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
