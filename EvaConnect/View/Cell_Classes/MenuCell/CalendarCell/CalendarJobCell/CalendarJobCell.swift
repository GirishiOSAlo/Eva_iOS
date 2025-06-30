//
//  CalendarJobCell.swift
//  EvaConnect
//
//  Created by Metis on 01/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class CalendarJobCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var jobCity: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(calenderModel: CalendarModelList) {
        if calenderModel.objectType == .job {
            jobLbl.text = calenderModel.objectDetails?.name
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
