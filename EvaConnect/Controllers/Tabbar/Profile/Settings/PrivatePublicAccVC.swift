//
//  PrivatePublicAccVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 01/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation
import UIKit

class PrivatePublicAccVC: BaseVC {

    @IBOutlet weak var headerTitleLabel: HeadingLabel!
    @IBOutlet weak var privateAccountLabel: HeadingLabel!
    @IBOutlet weak var accSwitch: UISwitch!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    var section: HelpSection!
//    var isPrivate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserDetail()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func donebtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        myUserDefaults.isPrivate.toggle()
        updateProfile(isPrivate: myUserDefaults.isPrivate) { success, error in
            if success ?? false {
                print("Done!!")
                self.goBack()
            }
            if let error = error {
                print(error)
                print(error.localizedDescription)
            }
        }
    }

}

extension PrivatePublicAccVC {
    
    func setLayout() {
        myUserDefaults.isPrivate = LoggedUserDetails.shared.user?.isPublic != 0 ? false : true
        accSwitch.isOn = myUserDefaults.isPrivate
        doneBtn.layer.cornerRadius = 24.0
//        let isHelp = section == .help
//        headerTitleLbl.text = section.rawValue
//        emailBtn.setTitle(isHelp ? Constants.Label.email : section.rawValue, for: .normal)
//        emailBtn.isUserInteractionEnabled = isHelp
//        titleLbl.isHidden = !isHelp
    }
    
}

// MARK: API Calss
extension PrivatePublicAccVC {
    
    private func fetchUserDetail() {
        showActivity()
        ProfileManager.shared.fetchUserDetail(userId: LoggedUserDetails.shared.user?.id ?? 0, showLoader: false) { user, error in
            self.hideActivity()
            if let error = error {
                self.presentAlert("Error", error)
            } else if let user = user {
                LoggedUserDetails.shared.updateUser(userModel: user)
                self.setLayout()
            } else {
                self.presentAlert("Error", "Unable to fetch user details")
            }
        }
    }
    
    func updateProfile(isPrivate: Bool , completion: @escaping (Bool?, Error?) -> Void) {

        let parameters: AFParameters = ["is_public": (isPrivate ? 0 : 1)]
        
        let endPoint = EndPoints.userDetail
        
        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        self.presentAlert(genericRoot.error ? "Error" : "Success", "Profile Updated.", nil) {
                            if !genericRoot.error { self.goBack() }
                        }
                        completion(true, nil)
                    }
                } catch {
                    
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}
