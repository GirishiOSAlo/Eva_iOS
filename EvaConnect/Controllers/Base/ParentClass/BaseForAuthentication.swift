//
//  BaseForAuthentication.swift
//  EvaConnect
//
//  Created by Metis on 11/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class BaseForAuthentication: UIViewController {
    
    var window: UIWindow?
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(self is LoginVC) { self.navigationController?.interactivePopGestureRecognizer?.delegate = nil }
    }
    
    func setButton(view: UIButton, ConnerByHeight: Bool = false, setBoader: Bool = false) {
        
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width:5,height:5);
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
        if ConnerByHeight {
            view.layer.cornerRadius = (view.frame.height)/2
        } else {
            view.layer.cornerRadius = (view.frame.width)/2
        }
    }
    
    //MARK: AlertMsg
    func makeAlert(titleMsg: String = "Error",messageData: String) {
        
        let alert = UIAlertController(title: titleMsg, message: messageData, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
     
    @objc func goBackByViewController(){
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: BackAction
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openGallery() {
        //pickImageCallback = callback;
        //self.viewController = viewController;
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.present(self.picker, animated: true, completion: nil)
            } else {
                let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
                alertWarning.show()
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    //MARK: SetCornerSmallRadius
    func giveButtonCorner(actionBtn:UIButton?=nil,setClipsBound:Bool?=true,backColor:UIColor? = .white, giveShadow:Bool?=false,boderColor:UIColor?=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)){
        if giveShadow==true{
            actionBtn?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            actionBtn?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            actionBtn?.layer.shadowOpacity = 1.0
            actionBtn?.layer.shadowRadius = 5.0
            actionBtn?.layer.masksToBounds = false
            actionBtn?.layer.cornerRadius = 4.0
            if setClipsBound == false{
                actionBtn?.clipsToBounds=setClipsBound!
            }
            else{
                actionBtn?.clipsToBounds=setClipsBound!
            }
            
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
            actionBtn?.layer.borderColor = boderColor?.cgColor
            actionBtn?.layer.borderWidth = 1
        } else{
            actionBtn?.clipsToBounds=true
            actionBtn?.clipsToBounds=true
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
        }
    }
}

extension BaseForAuthentication {
    @objc func GOTOFunctionLoginVCObj() {
        let vc = UIStoryboard.init(name: "AuthenticationVC", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    //DashBoard Screen
    func gotoDashboard() {
        
        let vc = DashboardTabbarVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let tabbar = StoryboardRouter.tabbar()
////        tabbar.setupTabBar()
//        self.window?.rootViewController = tabbar
//        self.window?.makeKeyAndVisible()
//        tabbar.modalPresentationStyle = .fullScreen
//        present(tabbar, animated: false, completion: nil)
    }
    
    //EventDtailsScreen
    func gotoEventDetails() {
        let vc = EventTabbarVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToRootViewController() { navigationController?.popToRootViewController(animated: true) }
}
