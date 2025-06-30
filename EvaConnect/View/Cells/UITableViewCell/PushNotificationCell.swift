//
//  PushNotificationCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/30/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class PushNotificationCell: UITableViewCell {
    
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var pushTitleLbl: UILabel!
    
    var indexPath: IndexPath!
    var notification: (item: UserNotificationSetting, selected: Bool)! {
        didSet {
            pushTitleLbl.text = notification.item.rawValue
            pushSwitch.setOn(notification.selected, animated: false)
        }
    }
    
    var pushChanged: ((IndexPath, Bool) -> Void)?
    
    @IBAction func pushSwitchChanged(_ sender: UISwitch) {
        if let pushChanged = pushChanged { pushChanged(indexPath, sender.isOn) }
    }
    
}
