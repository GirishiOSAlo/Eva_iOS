//
//  CalendarNoteCell.swift
//  EvaConnect
//
//  Created by Metis on 01/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class CalendarNoteCell: UITableViewCell {
    @IBOutlet weak var circleView: UIView!
       @IBOutlet weak var noteLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
