//
//  PreviousCVCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 07/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class PreviousCVCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var viewCVBtn: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var downloadCVBtn: UIButton!
    @IBOutlet weak var deleteCVBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpView()
    }
    
    func setUpView(){
        outerView.layer.cornerRadius = 15.5
        outerView.layer.borderWidth = 1
        fileNameLbl.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        dateTimeLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
    }

    func uiData(dataMaper: ResumeData){
        self.fileNameLbl.text = dataMaper.title ?? ""
        let createdDate = dataMaper.createdAt ?? ""
        if let formattedDate = formatDateString(createdDate) {
            self.dateTimeLbl.text = formattedDate // Output: "30th May 2025"
        }
    }
    
    func formatDateString(_ isoDate: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoDate) else {
            return nil
        }

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let daySuffix: String
        switch day {
        case 11, 12, 13:
            daySuffix = "th"
        default:
            switch day % 10 {
            case 1: daySuffix = "st"
            case 2: daySuffix = "nd"
            case 3: daySuffix = "rd"
            default: daySuffix = "th"
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let restOfDate = formatter.string(from: date)

        return "\(day)\(daySuffix) \(restOfDate)"
    }
}
