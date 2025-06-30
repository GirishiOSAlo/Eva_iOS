//
//  EventCell.swift
//  EvaConnect
//
//  Created by Metis on 04/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class EventCell: BaseCellClass {
    
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventContentLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var dateUIView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dateHeaderLbl: UILabel!
    @IBOutlet weak var openCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateUIView.applyBorderWithRadius(color: UIColor(hex: "455BBE"), value: 1, radius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(data: CalenderEventsdata) {
        eventContentLbl.text = data.title
        eventType.text = data.type
        startTimeLbl.text = data.startTime
        dateLbl.text = data.createdDate
//        dateHeaderLbl.text = BaseVC.shared.dateString(type == .note ? data.objectDetails?.occurrenceDate ?? "" : data.objectDetails?.startDate ?? "")
//        eventType.textColor = type == .event ? AppColors.appRed : type == .note ? AppColors.appBlue : AppColors.appGreen
//        eventType.text = type.rawValue.capitalized
//        eventContentLbl.text = type == .note ? data.objectDetails?.title : data.objectDetails?.name
//
//        monthLbl.text = showMonthOnly(getString: type == .note ? data.objectDetails?.occurrenceDate ?? "" : data.objectDetails?.startDate ?? "")
//        dateLbl.text = showDateOnly(getString: type == .note ? data.objectDetails?.occurrenceDate ?? "" : data.objectDetails?.startDate ?? "")
//        startTimeLbl.text = type == .note ? calenderTimeOnly(getString: data.objectDetails?.occurrenceTime ?? "") : ("\(calenderTimeOnly(getString: data.objectDetails?.startTime ?? "")) - \(calenderTimeOnly(getString: data.objectDetails?.endTime ?? ""))")
//        dateLbl.textColor = .black
//        dateHeaderLbl.textColor = .black
//        monthLbl.textColor = UIColor(named: "BackColor")!
    }
    
    

}

extension EventCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
            // Set the desired output format
            dateFormatter.dateFormat = "dd MMM"

            // Format the date to "30 Oct"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            print("Invalid date format")
            return ""
        }
    }
}
