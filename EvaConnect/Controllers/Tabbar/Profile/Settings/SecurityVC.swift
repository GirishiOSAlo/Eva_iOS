//
//  SecurityVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/31/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class SecurityVC: BaseVC {

    @IBOutlet weak var deleteAccountView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
}

extension SecurityVC {
    
    private func setLayout() {
        changePasswordView.applyShadow()
        changePasswordView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped)))
        deleteAccountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountTapped)))
    }
    
    
    @objc private func changePasswordTapped() {
        let vc = StoryboardRouter.signUpPassword()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func deleteAccountTapped() {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteAccount()
        }))
        present(alert, animated: true)
    }
    
    private func deleteAccount() {
        let url = "\(EndPoints.deleteAccount)\(LoggedUserDetails.shared.user?.id ?? -1)/"
        showActivity()
        NetworkManagerr.request(url, method: .delete) { (result: Result<GenericResponse>) in
            self.hideActivity()
            switch result {
            case .success(let data):
                if data.error {
                    self.presentAlert("Error", data.message, nil)
                } else {
                    self.logOut()
                }
            case .failure(let error):
                self.presentAlert("Error", nil, error)
            }
        }
    }
}

extension SecurityVC: EditUserProfileDelegate {
    
    func didProfileUpdated(item: EditProfile, value: String) {
        if item != .password { return }
        print("updated password")
    }
    
}
