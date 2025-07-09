//
//  ConferrenceAgendaCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferrenceAgendaCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionNameLabel: UILabel!
    
    @IBOutlet weak var sponsersLabel: UILabel!
    @IBOutlet weak var sponsersNameLabel: UILabel!
    
    @IBOutlet weak var drpDwnButton: UIButton!
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            drpDwnButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        DateLabel.font = UIFont(name: Myfonts.medium, size: 14)
        timeLabel.font = UIFont(name: Myfonts.medium, size: 14)
        sessionLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        sessionNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        sponsersLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        sponsersNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
    }
    
    func setUpData(data: ConferenceAgenda) {
        DateLabel.text = data.date ?? "--"
        timeLabel.text = "\(data.timeFrom ?? "--" ) - \(data.timeTo ?? "--" )"
        sessionNameLabel.text = data.name ?? "--"
        sponsersNameLabel.text = data.sponsorname ?? "--"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ConferrenceAgendaCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
