//
//  CompaniesListTableViewCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class CompaniesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseVw: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI() {
        baseVw.layer.cornerRadius = 12.0
        nameLbl.font = UIFont(name: Myfonts.medium, size: 14)
    }
    
}

extension CompaniesListTableViewCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
