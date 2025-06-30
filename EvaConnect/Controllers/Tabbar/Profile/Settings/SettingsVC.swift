//
//  SettingsVC.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class SettingsVC: BaseVC {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var userAvatarView: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UIButton!
    @IBOutlet weak var pushNotification: UIButton!
    @IBOutlet weak var passwordStack: UIView!
    @IBOutlet weak var save: UIButton!

    var passwordTap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
}

extension SettingsVC {
    
    func initUI() {

        view.backgroundColor = AppColors.lightGrayBG
        userAvatarView.layer.borderColor = AppColors.evaBlue.cgColor
        userAvatarView.layer.borderWidth = 2.0
        userAvatarView.roundOnly()
        userAvatar.roundOnly()
        pushNotification.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 12.0)
        password.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 12.0)
        save.backgroundColor = AppColors.dullRed
        save.setTitleColor(.white, for: .normal)
//        view.roundCorners(view: save, corners: .allCorners, radius: 15.0)
        
        if let user = LoggedUserDetails.shared.user {
            name.text = user.fullName
            location.text = user.address.stringValue
            email.text = user.email
            userAvatar.kf.setImage(with: URL(string: user.userImage!)!)
            
            if !user.socialMedia.isNil {
                passwordStack.isHidden = true
            }
        }
    }
}

extension SettingsVC {
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        isSeparatorHidden = true
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func save_touchUpInside(_ sender: UIButton) {
        
    }
}


