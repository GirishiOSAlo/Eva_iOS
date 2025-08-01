//
//  ScheduleMeetingCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 01/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ScheduleMeetingCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        self.baseView.cornerRadius = 20.0
        self.titleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.timeLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
    }
    
    func setData(obj: scheduleMeeting) {
        self.titleLbl.text = obj.title ?? "--"
        
        let startTime = obj.startTime ?? "--"
        let endTime = obj.endTime ?? "--"
        self.timeLbl.text = "\(startTime) - \(endTime)"
    }
}
