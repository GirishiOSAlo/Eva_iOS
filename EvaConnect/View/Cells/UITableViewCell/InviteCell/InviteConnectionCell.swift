//
//  InviteConnectionCell.swift
//  EvaConnect
//
//  Created by usama on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class InviteConnectionCell: UITableViewCell {

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var onlineStatus: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    weak var delegate: SelectionCellActionable?
    var invitationType: InvitationType = .attendees

    var connection: User! {
        didSet {
            
            name.text = connection.fullName
            occupation.text = connection.designation.stringValue
            
            if let imageUrl = connection.userImage, let url = URL(string: imageUrl) {
                userAvatar.kf.setImage(with: url)
            }
            
            inviteButton.layer.borderWidth = 1.0

            if connection.isSelected {
                inviteButton.setTitle("", for: .normal)
                inviteButton.setImage(UIImage(named: "sent_tickmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
                inviteButton.layer.borderColor = AppColors.dullRed.cgColor
            } else {
                
                switch invitationType {
                case .attendees:
                    inviteButton.setTitle("Invite", for: .normal)
                case .message:
                    inviteButton.setTitle("Message", for: .normal)
                    onlineStatus.isHidden = false

                    if !connection.isOnline! {
                        
                        if let time = connection.lastOnlineDateTime?.date(formatter: .standardDateWithTime)?.toString(formatter: .standardDate) {
                            (onlineStatus as? HeadingThreeLabel)?.textColor = AppColors.lightBg
                            onlineStatus.text = "Last Online \(time)"
                        }
                        

                    } else {
                        
                        (onlineStatus as? HeadingThreeLabel)?.textColor = AppColors.evaBlue
                        onlineStatus.text = "Online"
                    }
                    
                default:
                    inviteButton.setTitle("Share", for: .normal)
                }
                
                inviteButton.setImage(UIImage(), for: .normal)
                inviteButton.layer.borderColor = AppColors.evaBlue.cgColor
            }

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func initUI() {
        contentView.backgroundColor =  AppColors.lightGrayBG
        (name as? HeadingLabel)?.textColor = .black
        (occupation as? HeadingTwoLabel)?.textColor = .black
        (onlineStatus as? HeadingThreeLabel)?.textColor = AppColors.lightBg

        inviteButton.layer.cornerRadius = 10.0

        imageViewContainer.roundOnly()
        userAvatar.roundOnly()
        imageViewContainer.layer.borderWidth = 2.0
        imageViewContainer.layer.borderColor =  AppColors.evaBlue.cgColor
        
    }
    
    @IBAction func invite_touchUpInside(_ sender: UIButton) {
        delegate?.selectedButton(sender: sender, completion: {
        
        })
    }
}

extension InviteConnectionCell: Dequeueable {
    static func id() -> String {
        String(describing: self)
    }
    
    static func hasNib() -> Bool {
        true
    }
}
