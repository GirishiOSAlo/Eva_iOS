//
//  NetworkingEventsCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsCell: UITableViewCell {

    @IBOutlet weak var eventNameHeadingLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sponsorsHeadingLabel: UILabel!
    @IBOutlet weak var sponsorsLabel: UILabel!
    @IBOutlet weak var locationHeadingLable: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var drpDwnBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        eventNameHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        eventNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        eventDescLable.font = UIFont(name: Myfonts.medium, size: 14)
        sponsorsHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        sponsorsLabel.font = UIFont(name: Myfonts.medium, size: 14)
        locationHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        locationLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
        dateLabel.font = UIFont(name: Myfonts.medium, size: 14)
        timeLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
        drpDwnBtn.layer.cornerRadius = drpDwnBtn.layer.frame.height/2
        joinBtn.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NetworkingEventsCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
