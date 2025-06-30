//
//  JobCell.swift
//  EvaConnect
//
//  Created by Metis on 04/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class JobCell: BaseCellClass {
    
    @IBOutlet weak var jobContentLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dateHeaderLbl: UILabel!
    @IBOutlet weak var openCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(calenderModel: CalendarModelList) {
        if calenderModel.objectType == .job {
            
            
        }
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension JobCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
