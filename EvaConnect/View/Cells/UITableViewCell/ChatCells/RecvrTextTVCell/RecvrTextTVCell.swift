//
//  RecvrTextTVCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/02/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class RecvrTextTVCell: UITableViewCell {

    @IBOutlet weak var mainUiView: UIView!
    @IBOutlet weak var recvrMsgLbl: UILabel!
    @IBOutlet weak var recvrTimeLbl: UILabel!
    @IBOutlet weak var recvrMsgWidthConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainUiView.layer.cornerRadius = 13.0
        self.recvrMsgLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.recvrTimeLbl.font = UIFont(name: Myfonts.regular, size: 8.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        recvrMsgWidthConst.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj: Message, screenWidth: CGFloat) {
        recvrMsgLbl.text = obj.message
        recvrTimeLbl.text = DateUtils.formatTo24Hour(timestamp: obj.timestamp ?? 0.0)
        
        let label = UILabel()
        label.text = obj.message ?? ""
        label.font = UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)

        if let text = label.text {
            let lblWidth = (text as NSString).size(withAttributes: [.font: label.font!]).width
            let finalLblWidth = lblWidth + 44.0
            
            if finalLblWidth < 30.0 {
                recvrMsgWidthConst.constant = 30.0
            } else {
                if finalLblWidth > screenWidth {
                    recvrMsgWidthConst.constant = screenWidth
                } else {
                    recvrMsgWidthConst.constant = finalLblWidth
                }
            }
        }
    }
    
//    func configure(with message: String) {
//        // Configure cell UI elements
//        recvrMsgLbl.text = message
//        
//        var rect: CGRect = recvrMsgLbl.frame //get frame of label
//        rect.size = (recvrMsgLbl.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: recvrMsgLbl.font.fontName , size: recvrMsgLbl.font.pointSize)!]))! //Calculate as per label font
//        var width = rect.width // set width to Constraint outlet
//        print("Width of", width, message)
//        print("ContentWidth", (contentView.frame.size.width))
//        let totalWidth = ((contentView.frame.size.width) - 90)
//        if width >= totalWidth {
//            width = contentView.frame.size.width
//            recvrMsgWidthConst.constant = width - 50
//        }
//        else if width <= 54.0 {
//            width = width + 54.0
//            recvrMsgWidthConst.constant = width + 35.0
//        }
//        else {
//            recvrMsgWidthConst.constant = width + 35.0
//        }
//    }
    
}

extension RecvrTextTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
