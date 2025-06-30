//
//  EditJobTitleVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/29/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class EditJobTitleVC: BaseForAuthentication {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var jobTitleLbl: UITextField!
    
    private let user = LoggedUserDetails.shared.user!
    var delegate: EditUserProfileDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let jobTitle = jobTitleLbl.text?.trim ?? ""
        if jobTitle.isEmpty {
            ErrorView(contentView: navigationController?.view ?? view).show(title: "Field is missing", message: "Please enter job title")
        } else if user.designation == jobTitle {
            goBack()
        } else {
            submitBtn.isUserInteractionEnabled.toggle()
            ProfileManager.shared.updateProfile(params: ["designation": jobTitle]) { [weak self] (error, message) in
                self?.submitBtn.isUserInteractionEnabled.toggle()
                if error { self?.presentAlert("Error", message, nil) }
                else { self?.navigationController?.popViewController(animated: true)  }
            }
        }
    }
}

extension EditJobTitleVC {
    
    func setLayout() {
        giveButtonCorner(actionBtn: submitBtn, backColor: Constants.AppColorLiteral.nextButtonColor)
        jobTitleLbl.text = LoggedUserDetails.shared.user?.designation ?? ""
    }
    
}
