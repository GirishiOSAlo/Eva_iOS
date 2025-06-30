//
//  MeetingCell.swift
//  EvaConnect
//
//  Created by Metis on 04/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class MeetingCell: BaseCellClass {

    @IBOutlet weak var meetingLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dateHeaderLbl: UILabel!
    @IBOutlet weak var openCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(data: CalendarModelList) {
        meetingLbl.text = data.objectDetails?.name ?? "No Title"
        monthLbl.text = ("\(showMonthOnly(getString: data.objectDetails?.startDate ?? ""))")
        dateLbl.text = ("\(showDateOnly(getString: data.objectDetails?.startDate ?? ""))")
        startTimeLbl.text = ("\(data.objectDetails?.startTime?.in12HourFormat() ?? "") - \(data.objectDetails?.endTime!.in12HourFormat() ?? "")")
        dateHeaderLbl.text = BaseVC.shared.dateString(data.objectDetails?.startDate ?? "")
      }
}

extension MeetingCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
