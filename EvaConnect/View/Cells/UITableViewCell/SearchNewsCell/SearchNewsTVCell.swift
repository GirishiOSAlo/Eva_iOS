//
//  SearchNewsTVCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 15/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class SearchNewsTVCell: UITableViewCell {

    @IBOutlet weak var baseMainView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var subImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var visitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI() {
        self.baseMainView.layer.cornerRadius = 13.0
        self.baseMainView.dropShadow()
        self.titleImageView.layer.cornerRadius = 13.0
        self.subImageView.layer.cornerRadius = self.subImageView.layer.frame.size.height/2
        self.visitButton.layer.cornerRadius = self.visitButton.layer.frame.size.height/2
    }
}

extension SearchNewsTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
