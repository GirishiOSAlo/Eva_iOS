//
//  LoginManager.swift
//  EvaConnect
//
//  Created by usama on 31/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Alamofire
//import IHProgressHUD
import SVProgressHUD

let userDefaults = UserDefaults.standard

class LoginManagerr {
    
    class func login(email: String, password: String? = nil, socialMedia: SocialMedia?, status: String = "active",
                     completionHandler: @escaping (EvaUser?, String?) -> Void) {
        
        var parameters: Parameters = [
            "username" : email,
        ]
        
        if let socialMedia = socialMedia {
            parameters["login_type"] = socialMedia.rawValue
        } else {
            parameters["password"] = password
        }
        
        SVProgressHUD.show()

        NetworkManagerr.request(EndPoints.loginUrl, method: .post, parameters: parameters) { (response) in
            
            SVProgressHUD.dismiss()

            if  response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let loginData = try! jsonDecoder.decode(LoginStruct.self, from:response.data!)
                
                //if let userData = loginData.data, !loginData.error , userData.first?.status == status {
                if let userData = loginData.data, !loginData.error {
                    var user = userData[0]
                    userDefaults.setValue(user.token, forKeyPath: "UserToken")
                    userDefaults.setValue(user.id, forKey:"id")
                    userDefaults.setValue(user.companyName, forKey: "companyName")
                    userDefaults.setValue(user.bioData, forKey: "bioData")
                    user.socialMedia = socialMedia
                    BaseVC.saveUser(user: user)
//                    if user.type == "company" {
//                        !isIndivisualUser
//                    } else {
//
//                    }
                    (user.type == "user") ? (isIndivisualUser = true ): (isIndivisualUser = false)
                    myUserDefaults.user = user.type ?? ""
                    if user.type == "user" {
                        isIndivisualUser = true
                    } else {
                        isIndivisualUser = false
                    }
                    
                    
                    LoggedUserDetails.shared.updateUser(userModel: user)
                    LoggedUserDetails.shared.updateToken(tokenString: user.token!)
                    
//                    FirebaseHandler.handler.createUserIfNotExist(with: user)
//                    LoggedUserDetails.shared.syncFCMToken()
                    
                    userDefaults.set(true, forKey: "isLogin")
//                    OneSignalUtility.shared.subscribe(user.email!)
                    completionHandler(user, nil)
                } else {
                    completionHandler(nil, loginData.data?.first?.status == "pending" ? "pending" : loginData.message)
                }
            }
        }
    }
}
