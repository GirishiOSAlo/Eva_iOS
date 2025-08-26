//
//  NotificationCell.swift
//  EvaConnect
//
//  Created by usama on 11/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher


protocol NotificationCellDelegate: NSObject {
    func didSelect(notification: EvaNotification)
}

class NotificationCell: UITableViewCell {

    @IBOutlet weak var baseview: UIView!
    @IBOutlet weak var stackViewTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var unreadMsgCount: UILabel!
    
    var isMyActivity = false
    var delegate: SelectionCellActionable?
    weak var notificationDelegate: NotificationCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        unreadView.isHidden = true
        
        baseview.layer.cornerRadius = 8.0
        contentView.backgroundColor = AppColors.lightGrayBG
        imageContainer.layer.borderColor = AppColors.evaBlue.cgColor
        imageContainer.layer.borderWidth = 2.0
        imageContainer.roundOnly()
        userAvatar.roundOnly()
        actionButton.isHidden = true
        actionButton.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 12.0)
        actionButton.makeRoundView(backGroundColor: .clear, boderColor: AppColors.evaBlue, boderValue: 1.0)
    }
    
    var notification: EvaNotification! {
        
        didSet {
            dateTime.text = notification.notificationTime
            content.text = notification.content
            unreadView.backgroundColor = notification.isRead == 0 ? AppColors.solidBlue : .clear
            
            if (notification.content?.contains("commented") ?? false) || (notification.content?.contains("connect") ?? false) {
                actionButton.isHidden = false
                actionButton.setTitleColor(AppColors.evaBlue, for: .normal)
                actionButton.setTitle("View", for: .normal)
//                stackViewTrailingConst.constant = 100
            } else {
                actionButton.isHidden = true
//                stackViewTrailingConst.constant = 30
            }
            
            if let image = notification.user.userImage, let url = URL(string: image) {
                userAvatar.kf.setImage(with: url)
            } else if let image = LoggedUserDetails.shared.user?.userImage, let url = URL(string: image), isMyActivity {
                userAvatar.kf.setImage(with: url)
            }
        }
    }
    
    
    func configure(item: FirebaseNotification) {
        content.text = item.body ?? "--"
        dateTime.text = DateUtils.formatTo24Hour(timestamp: item.created_at ?? 0.0)
        
        userAvatar.kf.setImage(with: URL(string: item.image ?? ""), placeholder: UIImage(named: "profile"))
    }
    
    @IBAction func action_touchUpInside(_ sender: UIButton) {
        notificationDelegate?.didSelect(notification: notification)
    }
}

extension NotificationCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    static func hasNib() -> Bool {
        return true
    }
}
