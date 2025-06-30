//
//  SignUpVC_Step1.swift
//  EvaConnect
//
//  Created by Metis on 23/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import MobileCoreServices
//import ValidationTextField
import Alamofire

class SignUpVC_Step1: BaseForAuthentication {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var surNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var websiteNameLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var goNext: UIButton!
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var individualBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var WebsiteName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var backBtnTop: UIButton!
    @IBOutlet weak var alreadyRegisterBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet var boderView: UIView!
    
    @IBOutlet weak var baseView_1: UIView!
    @IBOutlet weak var baseView_2: UIView!
    @IBOutlet weak var baseView_3: UIView!
    @IBOutlet weak var baseView_4: UIView!
    @IBOutlet weak var mapIconImgVw: UIImageView!
    @IBOutlet weak var dropDownImgVw: UIImageView!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var baseView_5: UIView!
    @IBOutlet weak var linkedInTextField: UITextField!
    
    //MARK: Variables
    var signUpDetails: SignUpDetails?
    var userType: UserType = .user
    var sizeCheck = false
    var emailValid = false
    var validURL = false
    var mobileNoValid = false
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SignUpVC_Location, let signUpDetails = sender as? SignUpDetails? {
            destination.signUpDetails = signUpDetails
        }
    }
}

extension SignUpVC_Step1 {
    func saveImage(userImage: UIImage?) {
        guard let image = userImage else { return }

        // Create a unique filename
        let fileName = UUID().uuidString
        if let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path {
            do {
                // Convert image to data
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    // Save data to file
                    try imageData.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                    
                    // Store file path in UserDefaults
                    UserDefaults.standard.set(filePath, forKey: "userImageFilePath")
                }
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
    }
    
    // Get the Documents directory URL
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

extension SignUpVC_Step1 {
    
    func setLayOut() {
        
        //==> By Default User Tab Selected.....
        userType = .user
        myUserDefaults.user = "user"
        individualBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        individualBtn.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.1)
        companyBtn.borderColor = UIColor(hex: "#707070",alpha: 0.20)
        companyBtn.backgroundColor = UIColor.clear
        self.baseView_2.isHidden = true


        
        self.baseView_1.applyBorderWithRadius()
        self.baseView_2.applyBorderWithRadius()
        self.baseView_3.applyBorderWithRadius()
        self.baseView_4.applyBorderWithRadius()
        self.baseView_5.applyBorderWithRadius()
        
        //Selecetd Individual Button...
        self.individualBtn.layer.cornerRadius = self.individualBtn.frame.size.height/2
        self.individualBtn.borderWidth = 1.0
        individualBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        individualBtn.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.1)
        //Unselecetd Individual Button...
        self.companyBtn.layer.cornerRadius = self.companyBtn.frame.size.height/2
        self.companyBtn.borderWidth = 1.0
        companyBtn.borderColor = UIColor(hex: "#707070",alpha: 0.20)
        companyBtn.backgroundColor = UIColor.clear

        
        self.goNext.layer.cornerRadius = 14
        
        
        self.picker.delegate = self
        backBtnTop.addTarget(self, action: #selector(back_touchUpInside(_:)), for: .touchUpInside)
        alreadyRegisterBtn.addTarget(self, action: #selector(back_touchUpInside(_:)), for: .touchUpInside)
//        self.giveButtonCorner(actionBtn: individualBtn,backColor:Constants.AppColorLiteral.newUnSelectedBackColor,giveShadow:true)
//        self.giveButtonCorner(actionBtn: companyBtn, backColor: Constants.AppColorLiteral.newUnSelectedBackColor,giveShadow: false)
//        self.giveButtonCorner(actionBtn: goNext,backColor: Constants.AppColorLiteral.nextButtonColor)
//        individualBtn.setTitleColor(.darkGray, for: .normal)
//        companyBtn.setTitleColor(.white, for: .normal)
//        self.giveButtonCorner(actionBtn: uploadBtn,backColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), giveShadow: true)
        imageOutlet.roundOnly()
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        WebsiteName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mobileNoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.loginByNew)
        imageOutlet.makeRoundView(backGroundColor: .white, boderColor: .white, boderValue: 2)
        if let signUpDetails = signUpDetails {
            
            if let socialMedia = signUpDetails.socialMedia {
                
                firstName.text = signUpDetails.firstName.stringValue
                WebsiteName.text = signUpDetails.lastName.stringValue
                email.text = signUpDetails.email
                email.isUserInteractionEnabled.toggle()
                let btn = UIButton(type: .system)
                btn.tag = 2
                ChangeUser(btn)
                textFieldDidChange(email)
                switch socialMedia {
                case .linkedin:
                    imageOutlet.kf.setImage(with: URL(string: signUpDetails.userImageURI!))
                    
                default:
                    // handle image update from fb
                    guard let image = signUpDetails.userImage else {
                        
                        return imageOutlet.image = UIImage(named: "profile")
                    }
                    imageOutlet.kf.setImage(with: URL(string: signUpDetails.userImageURI!))
                    break
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == email {
            if email.text?.count != 0 || !email.text!.isEmpty {
                if email.text!.isValidEmail == true {
                    emailValid = true
                } else {
                    emailValid = false
                }
            } else {
                emailValid = false
            }
        }
        
        if textfield == mobileNoTextField {
            if mobileNoTextField.text?.count != 0 || !mobileNoTextField.text!.isEmpty {
                if mobileNoTextField.text!.count == 10 {
                    mobileNoValid = true
                } else {
                    mobileNoValid = false
                }
            } else {
                mobileNoValid = false
            }
        }
        
        if textfield == WebsiteName {
            if WebsiteName.text?.count != 0 || !WebsiteName.text!.isEmpty {
                if Constants.isValidUrl(url: WebsiteName.text!)  {
                    validURL = true
                } else {
                    validURL = false
                }
            } else {
                validURL = false
            }
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) { goBack() }
    
    //MARK: Outlet Action
    
    @IBAction func next(_ sender: Any) {
        
        if !firstName.text.isNilOrEmpty //&& !surName.text.isNilOrEmpty
        {
            if isIndivisualUser {
                if emailValid && email.text != "" {
                    if mobileNoValid {
                        checkIfUserExists(email: email.text!, phoneNo: mobileNoTextField.text!) { reason in
                            if reason != "" {
                                self.presentAlert("Failure", "\(reason ?? "")", nil)
                                self.email.text = ""
                                self.mobileNoTextField.text = ""
                            } else {
//                                print("i am called bro")
//                                self.signUpDetails?.userType = self.userType
                                
                                self.goToServiceDetails()
                            }
                        }
                        //                    if signUpDetails.isNil {
                        //                        signUpDetails = SignUpDetails(email: "some@co.co")
                        //                    }
                    } else {
                        presentAlert("Invalid Mobile No", "Please Enter Valid Mobile No.", nil)
                    }
                } else {
                    presentAlert("Invalid Email", "Please Enter Valid Email Address", nil)
                }
            } else {
                if validURL {
                    if emailValid {
                        checkIfUserExists(email: email.text!, phoneNo: mobileNoTextField.text!) { reason in
                            if reason != "" {
                                self.presentAlert("Failure", "\(reason ?? "")", nil)
                                self.email.text = ""
                                self.mobileNoTextField.text = ""
                            } else {
//                                print("i am called bro")
//                                self.signUpDetails?.userType = self.userType
                                
                                self.goToServiceDetails()
                            }
                        }
//                        self.goToServiceDetails()
                    } else {
                        presentAlert("Invalid Email", "Please Enter Valid Email Address", nil)
                    }
                } else {
                    makeAlert(messageData: "Please Enter valid Website")
                }
            }

        } else {
            if isIndivisualUser {
                makeAlert(messageData: "Please Enter Full Name")
            } else {
                makeAlert(messageData: "Please Enter Company Name")
            }
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        
        openGallery()
    }
    
    @IBAction func ChangeUser(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            isIndivisualUser = false
            userType = .company
            myUserDefaults.user = "company"
            companyBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
            companyBtn.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.1)
            individualBtn.borderColor = UIColor(hex: "#707070",alpha: 0.20)
            individualBtn.backgroundColor = UIColor.clear
            
            self.baseView_2.isHidden = false
            self.baseView_4.isHidden = true
            
            firstName.placeholder = "Company Name"
            email.placeholder = "Email Address"
            WebsiteName.placeholder = "Website Name"
            linkedInTextField.placeholder = "LinkedIn Id"
            

        case 2:
            isIndivisualUser = true
            userType = .user
            myUserDefaults.user = "user"
            individualBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
            individualBtn.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.1)
            companyBtn.borderColor = UIColor(hex: "#707070",alpha: 0.20)
            companyBtn.backgroundColor = UIColor.clear
            
            self.baseView_2.isHidden = true
            self.baseView_4.isHidden = false
            
            firstName.placeholder = "Full Name"
            email.placeholder = "Email Address"
            linkedInTextField.placeholder = "LinkedIn Id"

        default:
            break
            
        }
        
        /// 1 is company and 2 is individual user
        changeInfo(sender.tag == 1)
    }
    
    /// change info to label and text input according to selected option
    private func changeInfo(_ isCompany: Bool) {
        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            isIndivisualUser = !isCompany
//            self.firstNameLbl.text = isCompany ? "Company Name" : "What is your name?"
//            self.surNameLbl.text = isCompany ? "Website" : ""
            self.firstName.placeholder = isCompany ? "Company Name" : "Full Name"
            self.WebsiteName.placeholder = isCompany ? "Website URL" : ""
            self.email.placeholder = "Email Address"
//            self.surNameLbl.alpha = isCompany ? 1 : 0
//            self.surNameTopConstraint?.constant = isCompany ? 20 : -40
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
}

extension SignUpVC_Step1: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        print("picked mediatype = \(mediaType)")
        
        if mediaType == kUTTypeImage as String {
          
            let editImage = info[.editedImage] as? UIImage
            var orignalImage = info[.originalImage] as? UIImage
            if editImage != orignalImage {
                orignalImage = editImage
            }
            let imgData = NSData(data: (orignalImage!).jpegData(compressionQuality: 0.8)!)
//
            let imageSize: Int = imgData.count
            
            
            //chekcing size if its 4mb
            if  imageSize <= 4194304 {
                self.imageOutlet.contentMode = .scaleAspectFill
                self.sizeCheck = true
                self.imageOutlet.image = orignalImage
                print("Image\(orignalImage!)")
            } else {
                sizeCheck = false
            }
            dismiss(animated: true, completion: nil)
            
            if !sizeCheck {
                makeAlert(messageData: "Image File must be less than equal to 4 MB")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
extension SignUpVC_Step1{
    func checkIfUserExists(email: String, phoneNo: String, completion:@escaping (String?) -> Void) {
      
        let parameters: Parameters = ["email": email,
                                      "mobile": phoneNo]
        
        showActivity()
        NetworkManagerr.request(EndPoints.checkUserEmail, method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            
            if let errorMessage = response.error?.localizedDescription {
                self.presentAlert("Error", errorMessage, nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let userCheck = try jsonDecoder.decode(UserCheckRoot.self, from: response.data!)

                if !userCheck.error, userCheck.message == "record not found" {
                    completion("")
                } else if !userCheck.error { //userCheck.data[0].is_facebook == 1 {
                    completion("\(userCheck.message ?? "Already registered!!")")
                } else {
                    self.presentAlert("Error", userCheck.message, nil)
                    completion("")
                }
            } catch let error {
                self.presentAlert("Error", error.localizedDescription, nil)
            }
        }
    }
    
//    private func goToAboutSection() {
//        print("hello goToAboutSection")
//        saveImage(userImage: imageOutlet.image)
//        myUserDefaults.fullName = firstName.text ?? ""
//        myUserDefaults.emailAdd = email.text ?? ""
//        myUserDefaults.websiteUrl = surName.text ?? ""
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpAboutInfoVC.storyboardIdentifier) as? SignUpAboutInfoVC else { return }
//        vc.signUpDetails = signUpDetails
//        navigationController?.pushViewController(vc, animated: true)
//    }
    private func goToServiceDetails() {
        print("hello goToServiceDetails")
        saveImage(userImage: imageOutlet.image)
        self.signUpDetails?.firstName = firstName.text ?? ""
        self.signUpDetails?.email = email.text ?? ""
        self.signUpDetails?.phoneNo = mobileNoTextField.text ?? ""
        self.signUpDetails?.linkedIn = linkedInTextField.text ?? ""
        myUserDefaults.fullName = firstName.text ?? ""
        myUserDefaults.emailAdd = email.text ?? ""
        myUserDefaults.websiteUrl = WebsiteName.text ?? ""
        myUserDefaults.mobileNo = mobileNoTextField.text ?? ""
        myUserDefaults.linkedIn = linkedInTextField.text ?? ""
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpLocationDOBVC.storyboardIdentifier) as? SignUpLocationDOBVC else { return }
        vc.signUpDetails = signUpDetails
        navigationController?.pushViewController(vc, animated: true)
    }
}
