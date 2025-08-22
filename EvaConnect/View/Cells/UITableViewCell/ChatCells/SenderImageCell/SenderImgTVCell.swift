//
//  SenderImgTVCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class SenderImgTVCell: UITableViewCell {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var singleImgUIView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var singleTimeLabel: UILabel!
    @IBOutlet weak var timeBaseVw: UIView!
    
    @IBOutlet weak var multiImgView: UIView!
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image4: UIImageView!
    @IBOutlet weak var multiTimeLabel: UILabel!
    @IBOutlet weak var showDetailsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        singleImgUIView.layer.cornerRadius = 15
        mainImageView.layer.cornerRadius = 15
        timeBaseVw.layer.cornerRadius = 15
        
        multiImgView.layer.cornerRadius = 15
        Image1.layer.cornerRadius = 15
        Image2.layer.cornerRadius = 15
        Image3.layer.cornerRadius = 15
        Image4.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SenderImgTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
