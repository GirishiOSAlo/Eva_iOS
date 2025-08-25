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
        conversationImageView.kf.setImage(with: URL(string: item.user?.avatar ?? ""), placeholder: UIImage(named: "profile"))
        nameLabel.text = item.user?.name
        
        let lastMessage = item.lastMessage
        if lastMessage?.image != "" {
            latestMessageLabel.text = "📷 Photo" //"🎥 Video"
        }
        else if lastMessage?.document != "" {
            latestMessageLabel.text = "📄 Document"
        }
        else if lastMessage?.audio_file != "" {
            latestMessageLabel.text = "🎵 Audio"
        }
        else if lastMessage?.message != "" {
            latestMessageLabel.text = lastMessage?.message
        }
        
        timeLabel.text = DateUtils.formatTo24Hour(timestamp: item.lastMessage?.timestamp ?? 0.0)
        onlineStatusView.isHidden = item.user?.status?.lowercased() == "online" ? false : true
        
        if item.lastMessage?.read == true {
            unreadCount.isHidden = true
        } else {
            unreadCount.isHidden = false
            unreadCount.text = "\(1)"
        }
    }
}



