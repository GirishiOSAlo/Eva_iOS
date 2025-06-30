//
//  DocAudioTVCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 14/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class DocAudioTVCell: UITableViewCell
{

    @IBOutlet weak var mainBaseViewLeading: NSLayoutConstraint!
    @IBOutlet weak var mainBaseViewTralling: NSLayoutConstraint!
    @IBOutlet weak var mainBaseView: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var documentStackVw: UIStackView!
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var docSizeLbl: UILabel!
    
    @IBOutlet weak var dowmloadBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var audioMainView: UIView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioDurationLbl: UILabel!
    @IBOutlet weak var audioTitleLbl: UILabel!
    @IBOutlet weak var showDeatilsBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initUI()
    }
    
    func initUI() {
        self.mainBaseView.layer.cornerRadius = 13.0
        
        //Slider Thumb Image custom set.....
        let circleImage = makeCircleWith(size: CGSize(width: 10, height: 10),
                       backgroundColor: UIColor(hex: "#4D76CD"))
        audioSlider.setThumbImage(circleImage, for: .normal)
        audioSlider.setThumbImage(circleImage, for: .highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension DocAudioTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

