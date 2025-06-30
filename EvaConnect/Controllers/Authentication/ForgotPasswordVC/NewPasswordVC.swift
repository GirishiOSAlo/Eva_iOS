//
//  NewPasswordVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/24/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class NewPasswordVC: BaseForAuthentication {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutStyle()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
}

extension NewPasswordVC {
    
    private func setLayoutStyle() {
        giveButtonCorner(actionBtn: submitBtn, backColor: AppColors.appColor)
        confirmPasswordTextField.addTarget(self, action: #selector(textFeildChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFeildChanged(_ textField: UITextField) {
        let isEqual = passwordTextField.text == textField.text && (textField.text ?? "").count > 7
        submitBtn.isEnabled = isEqual
        submitBtn.alpha = isEqual ? 1 : 0.5
    }
    
}
