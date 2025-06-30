//
//  SenderCell.swift
//  EvaConnect
//
//  Created by usama on 20/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var defaultBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var zeroBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.layer.borderColor = AppColors.evaBackground.cgColor
            messageTextView.layer.borderWidth = 1.0
            messageTextView.textColor = UIColor(hex: "666666")
            messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
//    var message: Message! {
//        didSet {
//            
//            if message.sameSender {
//                timeLabel.isHidden = true
//                zeroBottomConstraint.priority = UILayoutPriority(rawValue: 999)
//                defaultBottomConstraint.priority = .defaultLow
//            } else {
//                defaultBottomConstraint.priority = UILayoutPriority(rawValue: 999)
//                zeroBottomConstraint.priority = .defaultLow
//                timeLabel.text = message.timeString
//            }
//
//            messageTextView.text = message.text
////            timeLabel.text = setTimeStamp(epochTime: "\(message.timeStamp)")
//        }
//    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppColors.appBlueWith10Alpha
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          timeLabel.isHidden = false
          messageTextView.text = ""
      }
    
}

extension ReceiverCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
