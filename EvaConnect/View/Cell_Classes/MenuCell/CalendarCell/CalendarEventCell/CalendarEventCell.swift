//
//  CalendarEventCell.swift
//  EvaConnect
//
//  Created by Metis on 01/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class CalendarEventCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var eventCity: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
