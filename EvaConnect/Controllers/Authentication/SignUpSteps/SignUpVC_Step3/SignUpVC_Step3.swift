//
//  SignUpVC_Step2.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
@IBDesignable
class SignUpVC_Step3: BaseForAuthentication {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var alreadyRegisterBtn: UIButton!
    @IBOutlet weak var jobTitleView: UIView!

    //MARK: Variables
    
    var signUpDetails: SignUpDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? SignUpVC_Step4, let signUpDetails = sender as? SignUpDetails {
//            destination.signUpDetails = signUpDetails
//        }
    }
    
    func setLayOut() {
        
        alreadyRegisterBtn.addTarget(self, action: #selector(GOTOFunctionLoginVCObj), for: .touchUpInside)
        
        self.giveButtonCorner(actionBtn: signUpBtn, backColor: Constants.AppColorLiteral.signUpNew)
        backBtn.addTarget(self, action: #selector(goBackByViewController), for: .touchUpInside)
        
        if signUpDetails.userType == .company {
            jobTitleView.isHidden = true
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if signUpDetails.userType == .user {
            if !company.text.isNilOrEmpty && !jobTitle.text.isNilOrEmpty {
                signUpBtn.isUserInteractionEnabled = true
                signUpDetails.jobTitle = jobTitle.text!
                signUpDetails.company = company.text!
                performSegue(withIdentifier: Constants.Segues.signUp4, sender: signUpDetails)
                
            } else {
                signUpBtn.isUserInteractionEnabled = true
                self.makeAlert(titleMsg: "Missing", messageData: "All Field are required")
            }
        }
        else {
            if !company.text.isNilOrEmpty {
                signUpBtn.isUserInteractionEnabled = true
                signUpDetails.jobTitle = ""
                signUpDetails.company = company.text!
                performSegue(withIdentifier: Constants.Segues.signUp4, sender: signUpDetails)
            }
            else {
                signUpBtn.isUserInteractionEnabled = true
                self.makeAlert(titleMsg: "Missing", messageData: "All Field are required")
            }
        }
       
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        openGallery()
    }
}
