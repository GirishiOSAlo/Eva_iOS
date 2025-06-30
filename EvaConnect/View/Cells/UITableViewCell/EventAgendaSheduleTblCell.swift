//
//  EventAgendaSheduleTblCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class EventAgendaSheduleTblCell: UITableViewCell {

    @IBOutlet weak var sheduleTimeLbl: UILabel!
    @IBOutlet weak var sheduleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
