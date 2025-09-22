//
//  SurveyNotificationTVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 22/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SurveyNotificationTVC: UITableViewCell {

    @IBOutlet weak var checkmarkImgVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        titleLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SurveyNotificationTVC: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
