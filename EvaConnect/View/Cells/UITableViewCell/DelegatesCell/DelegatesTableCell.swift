//
//  DelegatesTableCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class DelegatesTableCell: UITableViewCell {

    @IBOutlet weak var mainUiView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var viewProfileBtn: ConnectButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainUiView.layer.cornerRadius = 12
        mainUiView.layer.masksToBounds = true
        viewProfileBtn.layer.cornerRadius = 12
        nameLabel.font = UIFont(name: Myfonts.bold, size: 16)
        designationLabel.font = UIFont(name: Myfonts.regular, size: 14)
        companyLabel.font = UIFont(name: Myfonts.regular, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DelegatesTableCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
