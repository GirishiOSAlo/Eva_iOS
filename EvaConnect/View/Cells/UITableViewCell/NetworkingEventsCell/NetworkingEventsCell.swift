//
//  NetworkingEventsCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsCell: UITableViewCell {

    @IBOutlet weak var eventNameHeadingLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sponsorsHeadingLabel: UILabel!
    @IBOutlet weak var sponsorsHedingLblHeight: NSLayoutConstraint!
    @IBOutlet weak var sponsorsLabel: UILabel!
    @IBOutlet weak var locationHeadingLable: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var drpDwnBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            drpDwnBtn.setImage(UIImage(named: imageName), for: .normal)
            
            self.locationHeadingLable.isHidden = !isExpanded
            self.locationLabel.isHidden = !isExpanded
            self.joinBtn.isHidden = !isExpanded
            self.cancelBtn.isHidden = !isExpanded
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        eventNameHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        eventNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        eventDescLable.font = UIFont(name: Myfonts.regular, size: 14)
        dateLabel.font = UIFont(name: Myfonts.medium, size: 14)
        timeLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
        sponsorsHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        sponsorsLabel.font = UIFont(name: Myfonts.medium, size: 14)
        locationHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        locationLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
        
        drpDwnBtn.layer.cornerRadius = drpDwnBtn.layer.frame.height/2
        joinBtn.layer.cornerRadius = 10
        cancelBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 10)
        
    }
    
    func setData(obj: EventNetworking) {
        let name = (obj.networkingeventName?.isEmpty ?? true) ? "--" : obj.networkingeventName
        self.eventNameLabel.text = name
        
//        self.eventDescLable.text = obj.description ?? ""
        let content = obj.description ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.eventDescLable.attributedText = attributed
        } else { self.eventDescLable.text = content }
        
        self.dateLabel.text = obj.date ?? ""
        self.timeLabel.text = "\(obj.startTime ?? "") - \(obj.endTime ?? "")"
        //Sponsors Data not available in Backend...
        self.sponsorsHedingLblHeight.constant = 0.0 //17.0 & bottom = 6
        self.sponsorsLabel.text = ""
        let location = (obj.location?.isEmpty ?? true) ? "--" : obj.location
        self.locationLabel.text = location
        
        self.joinBtn.isHidden = true
        self.cancelBtn.isHidden = true
        
        let mapping = obj.evaUserNetworkingMappings ?? []
        if mapping.count == 0 {
            self.joinBtn.isHidden = false
        } else {
            if mapping[0].status == 1 {
                self.cancelBtn.isHidden = false
            } else {
                self.joinBtn.isHidden = false
            }
        }
        
    }

    func setListData(obj: NetworkEventList) {
        self.eventNameLabel.text = obj.networkingeventName ?? ""
        
//        self.eventDescLable.text = obj.description ?? ""
        let content = obj.description ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.eventDescLable.attributedText = attributed
        } else { self.eventDescLable.text = content }
        
        self.dateLabel.text = obj.date ?? ""
        self.timeLabel.text = "\(obj.startTime ?? "") - \(obj.endTime ?? "")"
        //Sponsors Data not available in Backend...
        self.sponsorsHedingLblHeight.constant = 0.0 //17.0 & bottom = 6
        self.sponsorsLabel.text = ""
        self.locationLabel.text = obj.location ?? ""
        
        self.joinBtn.isHidden = true
        self.cancelBtn.isHidden = true
        
        let mapping = obj.evaUserNetworkingMappings ?? []
        if mapping.count == 0 {
            self.joinBtn.isHidden = false
        } else {
            if mapping[0].status == 1 {
                self.cancelBtn.isHidden = false
            } else {
                self.joinBtn.isHidden = false
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NetworkingEventsCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
