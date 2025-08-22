//
//  TextMsgTVCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 14/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class TextMsgTVCell: UITableViewCell {

//    @IBOutlet weak var mainBaseViewLeading: NSLayoutConstraint!
//    @IBOutlet weak var mainBaseViewTralling: NSLayoutConstraint!
//
//    @IBOutlet weak var recvrMainBaseView: UIView!
//    @IBOutlet weak var recvrMsgLbl: UILabel!
//    @IBOutlet weak var recvrTimelable: UILabel!
//    @IBOutlet weak var recvrBaseViewWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var mainBaseView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainBaseViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainBaseView.layer.cornerRadius = 13.0
        self.messageLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.timeLabel.font = UIFont(name: Myfonts.regular, size: 8.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        mainBaseViewWidth.constant = 0
    }
    
    func setData(obj: Message, screenWidth: CGFloat) {
        messageLbl.text = obj.message
        timeLabel.text = DateUtils.formatTo24Hour(timestamp: obj.timestamp ?? 0.0)
        
        let label = UILabel()
        label.text = obj.message ?? ""
        label.font = UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)

        if let text = label.text {
            let lblWidth = (text as NSString).size(withAttributes: [.font: label.font!]).width
            let finalLblWidth = lblWidth + 44.0
            
            if finalLblWidth < 30.0 {
                mainBaseViewWidth.constant = 30.0
            } else {
                if finalLblWidth > screenWidth {
                    mainBaseViewWidth.constant = screenWidth
                } else {
                    mainBaseViewWidth.constant = finalLblWidth
                }
            }
        }
    }
    
//    func configure(with message: String) {
//        // Configure cell UI elements
//        messageLbl.text = message
//        
//        var rect: CGRect = messageLbl.frame //get frame of label
//        rect.size = (messageLbl.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: messageLbl.font.fontName , size: messageLbl.font.pointSize)!]))! //Calculate as per label font
//        var width = rect.width // set width to Constraint outlet
//        print("Width of", width, message)
//        mainBaseViewWidth.constant = width + 20 + 32
//        
//        print("ContentWidth", (contentView.frame.size.width))
//        let totalWidth = ((contentView.frame.size.width) - 90)
//        if width >= totalWidth {
//            width = contentView.frame.size.width
//            mainBaseViewWidth.constant = totalWidth - 25
//            print("case 1")
//        }
//        else if width <= 54.0 {
//            width = width + 54.0
//            mainBaseViewWidth.constant = width + 35.0
//            print("case 2")
//        }
//        else {
//            mainBaseViewWidth.constant = width + 35.0
//            print("case 3")
//        }
//        
//    }
    
}

extension TextMsgTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

