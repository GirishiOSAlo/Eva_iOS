//
//  ForgotPasswordVC.swift
//  EvaConnect
//
//  Created by Metis on 09/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import ValidationTextField
//import IHProgressHUD
import SVProgressHUD
import Alamofire
class ForgotPasswordVC: BaseForAuthentication,UITextFieldDelegate {
    //MARK:- OUTLETS
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    
    //MARK:- Variables
    var validDic = ["name": false, "email":false, "pw":false, "pwc": false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    func setLayOut(){
        emailTxt.delegate = self
//        emailTxt.validCondition = {$0.isValidEmail}
        self.giveButtonCorner(actionBtn: resetBtn,backColor:Constants.AppColorLiteral.loginColor)
        //emailTxt.delegate = self
        backBtn.addTarget(self, action: #selector(goBackByViewController), for: .touchUpInside)
        emailTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    @IBAction func reset(_ sender: Any) {
        self.resetBtn.isUserInteractionEnabled = false
        if emailTxt.text?.isValidEmail == true{
            self.forgotPassword(email: emailTxt.text!)
        }
        else{
            self.resetBtn.isUserInteractionEnabled = true
            self.makeAlert(titleMsg: "Invail Input", messageData: "Please Provide correct Input to Proceed ")
        }

    }
    //API Call
    func forgotPassword(email:String){
        let param:Parameters = [
            "username" : email
        ]
        SVProgressHUD.show()
        ApiCallerClass.forgotPasswordServiceFunc(para: param, success: { (dataRespose) in
            print(dataRespose)
            
            //self.getlogin=dataRespose as! Login
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            DispatchQueue.global(qos: .default).async(execute: {
                SVProgressHUD.dismiss()
            })
            self.resetBtn.isUserInteractionEnabled = true
           if error == 0{
            self.makeAlert_Navigate(titleMsg:"",messageData:"An email has been sent to your email address. Follow the instruction in the email to reset your password" )
            
            }
            else{
            self.makeAlert(messageData:data?["message"] as! String)
            }
       })
        { (error) in
            DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
                SVProgressHUD.dismiss()
            })
            self.resetBtn.isUserInteractionEnabled = true
            //self.gotoNext = false
            print(error.localizedDescription)
            //self.makeAlert(messageData: "credentials you have provider are wrong.")
        }
    }
    //MARK:-TextField Delegate
    @objc func textFieldDidChange(_ textfield: UITextField) {
//        let tf = textfield as! ValidationTextField
        
//        switch tf {
//
//        case emailTxt:
//            validDic["email"] = tf.isValid
//
//            if emailTxt.text?.count != 0 || !emailTxt.text!.isEmpty{
//                emailLbl.isHidden = true
//                emailTxt.isValid = emailTxt.text!.isValidEmail
//            }
//            else{
//                emailTxt.isValid = emailTxt.text!.isValidEmail
//                emailLbl.isHidden = false
//            }
//
//        default:
//            break
//        }
        
        //tf.isValid = validDic.reduce(true){ $0 && $1.value}
//        tf.successImage = UIImage(named: "success")
//        tf.errorImage = UIImage(named: "error")
    }
    func makeAlert_Navigate(titleMsg:String? = "Success", messageData:String){
           let alert = UIAlertController(title: titleMsg, message: messageData, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
               self.GOTOFunctionLoginVCObj()
            
                //implement login redirection
           }))
           self.present(alert, animated: true, completion: nil)
           
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
}
