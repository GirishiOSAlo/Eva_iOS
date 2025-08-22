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
        conversationImageView.kf.setImage(with: URL(string: item.user?.profileImage ?? ""), placeholder: UIImage(named: "profile"))
        nameLabel.text = item.user?.name
        latestMessageLabel.text = item.lastMessage?.text
        timeLabel.text = formatLastSeen(item.lastMessage?.timestamp)
        
//        if item.unreadCount > 0 {
//            unreadCount.isHidden = false
//            unreadCount.text = "\(item.unreadCount)"
//        } else {
//            unreadCount.isHidden = true
//        }
    }
    
    
    func formatLastSeen(_ timestamp: TimeInterval?) -> String {
        guard let timestamp = timestamp else { return "Unknown" }
        
        // Firebase gives ms → convert to seconds
        let seconds = timestamp / 1000
        let date = Date(timeIntervalSince1970: seconds)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"   // 24-hour format
        return formatter.string(from: date)
    }
}



