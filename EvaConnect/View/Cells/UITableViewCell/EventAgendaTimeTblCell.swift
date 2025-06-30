//
//  EventAgendaTimeTblCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class EventAgendaTimeTblCell: UITableViewCell {
    
    
    @IBOutlet weak var mainDayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sheduleTableView: UITableView!
    
    var dayData: [DayRelatedDatum] = [] {
        didSet {
            sheduleTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.sheduleTableView.delegate = self
        self.sheduleTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension EventAgendaTimeTblCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventAgendaSheduleTblCell", for: indexPath) as! EventAgendaSheduleTblCell
        let obj = dayData[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.1)
        } else {
            cell.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.1)
        }
        
        cell.sheduleTimeLbl.text = "\(obj.startTime ?? "") - \(obj.endTime ?? "")" //"09:00 - 09:30 pm"
        cell.sheduleLbl.text = "\(obj.title ?? "")" //"Session \(indexPath.row)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

