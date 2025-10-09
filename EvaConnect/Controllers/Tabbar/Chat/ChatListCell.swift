//
//  ConversationTableViewCell.swift
//  EvaConnect
//
//  Created by Pranay on 14/12/2024.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

class ChatListCell: UITableViewCell {

    @IBOutlet weak var conversationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onlineStatusView: UIView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var unreadIndicator: UIView!
    @IBOutlet weak var unreadCount: UILabel!

    
    var didTapProfile: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conversationImageView.roundOnly()
        unreadCount.roundOnly()
        nameLabel.textColor = .black
        onlineStatusView.roundOnly()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unreadCount.text = ""
        nameLabel.text = ""
    }
    
    var conversation: MessageList? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let conversation = conversation {
            if conversation.blockedStatus == "blocked" {
                nameLabel.text = "User"
                conversationImageView.image = UIImage(named: "profile")
                onlineStatusView.isHidden = true
                unreadCount.isHidden = true
            } else {
                nameLabel.text = "\(conversation.userName ?? "")"
                conversationImageView.kf.setImage(with: URL(string: conversation.userAvatar ?? ""), placeholder: UIImage(named: "profile"))
                onlineStatusView.isHidden = conversation.loginStatus == "Online" ? false : true
                unreadCount.isHidden = conversation.unreadCount == "0"
            }
            
            latestMessageLabel.text = "\(conversation.lastMessage ?? "")"
            unreadCount.text = conversation.unreadCount ?? ""
            timeLabel.text = conversation.lastMsgtime
        }
    }
    

    func configure(item: Conversation) {
        let url = EndPoints.shareBaseURL + (item.user?.avatar ?? "")
        conversationImageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "profile"))
        print(url)
        
        nameLabel.text = item.user?.name
        
        let lastMessage = item.lastMessage
        if let imageString = lastMessage?.image, !imageString.isEmpty {
            latestMessageLabel.text = "📷 Photo" //"🎥 Video"
        }
        else if let documentString = lastMessage?.document, !documentString.isEmpty {
            latestMessageLabel.text = "📄 Document"
        }
        else if let audioString = lastMessage?.audio_file, !audioString.isEmpty {
            latestMessageLabel.text = "🎵 Audio"
        }
        else if let messageString = lastMessage?.message, !messageString.isEmpty {
            latestMessageLabel.text = lastMessage?.message
        }
        
        timeLabel.text = DateUtils.formatTo24Hour(timestamp: item.lastMessage?.timestamp ?? 0.0)
        onlineStatusView.isHidden = item.user?.status?.lowercased() == "online" ? false : true
        
        
        if lastMessage?.sender_id == myUserDefaults.userId {
            unreadCount.isHidden = true
        } else {
            if item.lastMessage?.read == true {
                unreadCount.isHidden = true
            } else {
                unreadCount.isHidden = false
                unreadCount.text = "\(item.unreadCount ?? 0)"
            }
        }
    }
}



