//
//  PushNotificationSettingsVC.swift
//  EvaConnect
//
//  Created by usama on 03/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class PushNotificationSettingsVC: BaseVC {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var userAvatarView: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
}

extension PushNotificationSettingsVC {
    
    func initUI() {
        
        view.backgroundColor = AppColors.lightGrayBG
        userAvatarView.layer.borderColor = AppColors.evaBlue.cgColor
        userAvatarView.layer.borderWidth = 2.0
        userAvatarView.roundOnly()
        userAvatar.roundOnly()
        
        save.backgroundColor = AppColors.dullRed
        save.setTitleColor(.white, for: .normal)
        
        notificationSwitch.onTintColor = AppColors.lightBlue
        
        notificationSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        if let user = LoggedUserDetails.shared.user {
            name.text = (user.firstName ?? "") +  " " + user.lastName.stringValue
            location.text = user.address.stringValue
            notificationSwitch.isOn = user.is_notifications == 1
            userAvatar.kf.setImage(with: URL(string: user.userImage!)!)
        }
    }
}

extension PushNotificationSettingsVC {
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switch_valueChanged(_ sender: UISwitch) {

        var parameters: AFParameters = ["modified_by_id" :myUserDefaults.userId]// LoggedUserDetails.shared.user!.id]
        
        parameters["is_notifications"] = sender.isOn ? 1 : 0
        showActivity()
        let endPoint = EndPoints.userDetail + "\(myUserDefaults.userId)/"  //LoggedUserDetails.shared.user!.id)/"
        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let pushNotificationRoot = try decoder.decode(PushNotificationRoot.self, from: response.data!)
                    
                    if !pushNotificationRoot.error {
                        
                        let user = pushNotificationRoot.data[0]
                        LoggedUserDetails.shared.updateUser(userModel: user)
                        
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
