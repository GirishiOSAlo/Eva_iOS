//
//  ReceiverCell.swift
//  EvaConnect
//
//  Created by usama on 20/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    
    @IBOutlet weak var defaultBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var zeroBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            
            messageTextView.layer.borderColor = AppColors.evaBackground.cgColor
            messageTextView.layer.borderWidth = 1.0
            messageTextView.textColor = UIColor(hex: "595757")
            messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
          
        }
    }

    @IBOutlet weak var timeLabel: UILabel!
    
//    var message: Message! {
//        didSet {
//            messageTextView.text = message.text
////            timeLabel.text = setTimeStamp(epochTime: "\(message.timeStamp)")
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
//            layoutIfNeeded()
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.white
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        addGradient()
        
//        [messageTextView].updateLayerWidth(messageTextView.frame.width)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.isHidden = false
        messageTextView.text = ""
        messageTextView.backgroundColor = .clear
    }
    
    func addGradient() {
        
        
        
        if let topLayer = messageTextView.layer.sublayers?.first, topLayer is CAGradientLayer {
            [messageTextView].updateLayerWidth(messageTextView.frame.width)
            
        } else {
            messageTextView.setGradientBackground(colors: [AppColors.blueHigherGradient.cgColor,
                                                           AppColors.lowerGradient.cgColor,
                                                           AppColors.higherGradient.cgColor,
                                                           AppColors.lowestGradient.cgColor])
        }
    }
    
    func addGradientIfNeeded() {
                
         
         messageTextView.setGradientBackground(colors: [AppColors.blueHigherGradient.cgColor,
                                                        AppColors.lowerGradient.cgColor,
                                                        AppColors.higherGradient.cgColor,
                                                        AppColors.lowestGradient.cgColor])
     }
    
    func updateGradientLayerFrame() {
        
        messageTextView.layer.frame = messageTextView.bounds
    }
}

extension SenderCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

protocol TimeStampProvider {
    func setTimeStamp(epochTime: String) -> String
    func getLocalDate(timeStamp: Double) -> String
}

extension TimeStampProvider {
    
    func setTimeStamp(epochTime: String) -> String {
        let currentDate = Date()
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime)!)

        let calendar = Calendar.current

        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)

        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)

        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }

                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }


    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    func getLocalDate(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium //Set time style
        dateFormatter.dateStyle = .short //Set date style
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

extension ReceiverCell: TimeStampProvider { }
extension SenderCell: TimeStampProvider { }

