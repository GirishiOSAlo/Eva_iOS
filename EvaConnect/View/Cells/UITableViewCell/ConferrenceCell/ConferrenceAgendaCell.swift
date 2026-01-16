//
//  ConferrenceAgendaCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferrenceAgendaCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionNameLabel: UILabel!
    
    @IBOutlet weak var sponsersLabel: UILabel!
    @IBOutlet weak var sponsersNameLabel: UILabel!
    
    @IBOutlet weak var speakersLabel: UILabel!
    @IBOutlet weak var speakersNameLabel: UILabel!
    
    @IBOutlet weak var drpDwnButton: UIButton!
    
    @IBOutlet weak var btnStackVw: UIStackView!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var eventAttendeesStatus = ""
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            drpDwnButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        DateLabel.font = UIFont(name: Myfonts.medium, size: 14)
        timeLabel.font = UIFont(name: Myfonts.medium, size: 14)
        descriptionLbl.font = UIFont(name: Myfonts.medium, size: 14)
        sessionLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        sessionNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        sponsersLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        sponsersNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        speakersLabel.font = UIFont(name: Myfonts.semiBold, size: 14)
        speakersNameLabel.font = UIFont(name: Myfonts.medium, size: 14)
        
        joinBtn.layer.cornerRadius = 10
        cancelBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 10)
    }
    
    func setUpData(data: ConferenceAgenda) {
        self.DateLabel.text = data.date ?? "--"
        self.timeLabel.text = "\(data.timeFrom ?? "--" ) - \(data.timeTo ?? "--" )"
        
        let content = data.description ?? "--"
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.descriptionLbl.attributedText = attributed
        } else { self.descriptionLbl.text = content }
        
        let sessionName = (data.name?.isEmpty ?? true) ? "--" : data.name
        self.sessionNameLabel.text = sessionName
        let sponsorName = (data.sponsorname?.isEmpty ?? true) ? "--" : data.sponsorname
        self.sponsersNameLabel.text = sponsorName
        let speakerName = ((data.speakerNames?.isEmpty ?? true) ? "--" : data.speakerNames) ?? ""
        self.speakersNameLabel.text = speakerName        
        
        self.joinBtn.isHidden = false
        self.cancelBtn.isHidden = true
        
        let mapping = data.evaUserNetworkingMappings ?? []
        if mapping.count == 0 {
            self.joinBtn.isHidden = false
        } else {
            if mapping[0].status == 1 {
                self.cancelBtn.isHidden = false
            } else {
                self.joinBtn.isHidden = false
            }
        }
        if eventAttendeesStatus.lowercased() == "approved" {
            self.btnStackVw.isHidden = false
            let mappings = data.evaUserNetworkingMappings ?? []
            if mappings.isEmpty {
                // No mapping yet → show "Join"
                self.joinBtn.isHidden = false
                self.cancelBtn.isHidden = true
            } else {
                // There is at least one mapping
                let mapping = mappings[0]
                
                if mapping.status == 1 && mapping.userID == myUserDefaults.userId {
                    // User already joined → show "Cancel"
                    self.cancelBtn.isHidden = false
                    self.joinBtn.isHidden = true
                } else {
                    // Different user or not active → show "Join"
                    self.joinBtn.isHidden = false
                    self.cancelBtn.isHidden = true
                }
            }
        } else {
            // Not approved → show nothing
            self.btnStackVw.isHidden = true
            self.joinBtn.isHidden = true
            self.cancelBtn.isHidden = true
        }
    }
    
    func setDetailsData(data: ConferenceProgram?) {
        DateLabel.text = "\(data?.timeFrom ?? "") - \(data?.timeTo ?? "")"
        self.timeLabel.text = ""
        
        let content = ((data?.description?.isEmpty ?? true) ? "--" : data?.description) ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.descriptionLbl.attributedText = attributed
        } else { self.descriptionLbl.text = content }
        
        let sessionName = (data?.name?.isEmpty ?? true) ? "--" : data?.name
        self.sessionNameLabel.text = sessionName
        let sponsorName = (data?.sponsorname?.isEmpty ?? true) ? "--" : data?.sponsorname
        self.sponsersNameLabel.text = sponsorName
        
        var speakerList = ""
        let speakers = data?.speakers ?? []
        for obj in speakers {
            let name = obj.name ?? ""
            speakerList.append(name)
        }
        let speakerName = ((speakerList.isEmpty) ? "--" : speakerList)
        self.speakersNameLabel.text = speakerName
        
        self.joinBtn.isHidden = true
        self.cancelBtn.isHidden = true
        
        let mapping = data?.evaUserNetworkingMappings ?? []
        if mapping.count == 0 {
            self.joinBtn.isHidden = false
        } else {
            if mapping[0].status == 1 {
                self.cancelBtn.isHidden = false
            } else {
                self.joinBtn.isHidden = false
            }
        }
        if eventAttendeesStatus.lowercased() == "approved" {
            self.btnStackVw.isHidden = false
            let mappings = data?.evaUserNetworkingMappings ?? []
            if mappings.isEmpty {
                // No mapping yet → show "Join"
                self.joinBtn.isHidden = false
                self.cancelBtn.isHidden = true
            } else {
                // There is at least one mapping
                let mapping = mappings[0]
                
                if mapping.status == 1 && mapping.userID == myUserDefaults.userId {
                    // User already joined → show "Cancel"
                    self.cancelBtn.isHidden = false
                    self.joinBtn.isHidden = true
                } else {
                    // Different user or not active → show "Join"
                    self.joinBtn.isHidden = false
                    self.cancelBtn.isHidden = true
                }
            }
        } else {
            // Not approved → show nothing
            self.btnStackVw.isHidden = true
            self.joinBtn.isHidden = true
            self.cancelBtn.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ConferrenceAgendaCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
