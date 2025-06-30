//
//  CalendarMeetingCell.swift
//  EvaConnect
//
//  Created by Metis on 01/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class CalendarMeetingCell: UITableViewCell {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var meetingLbl: UILabel!
    @IBOutlet weak var meetingCity: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
