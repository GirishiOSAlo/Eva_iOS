//
//  ConferrenceAgendaCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferrenceAgendaCell: UITableViewCell {
    
    private var speakers: [String] = []
    var onSpeakerTapped: ((_ name: String, _ index: Int) -> Void)?

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionNameLabel: UILabel!
    
    @IBOutlet weak var sponsersLabel: UILabel!
    @IBOutlet weak var sponsersNameLabel: UILabel!
    
    @IBOutlet weak var speakersLabel: UILabel!
    @IBOutlet weak var speakersNameLabel: UILabel!
    @IBOutlet weak var speakersNameTxtVw: UITextView!
    
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
        setupTextView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onSpeakerTapped = nil
        speakers.removeAll()
        speakersNameTxtVw.attributedText = nil
    }
    
    private func setupTextView() {
        speakersNameTxtVw.delegate = self
        speakersNameTxtVw.isEditable = false
        speakersNameTxtVw.isScrollEnabled = false
        speakersNameTxtVw.isSelectable = true   // 🔥 REQUIRED
        speakersNameTxtVw.isUserInteractionEnabled = true
        speakersNameTxtVw.backgroundColor = .clear
        speakersNameTxtVw.textContainerInset = .zero
        speakersNameTxtVw.textContainer.lineFragmentPadding = 0
        speakersNameTxtVw.dataDetectorTypes = []
    }
    
    /// Configure with SINGLE STRING
    func configure(text: String) {
        speakers = text.components(separatedBy: ", ")
        
        let attributed = NSMutableAttributedString(string: text)
        var startIndex = 0
        
        for (index, name) in speakers.enumerated() {
            let range = NSRange(location: startIndex, length: name.count)
            
            attributed.addAttributes([
                .link: URL(string: "speaker://\(index)")!,
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14)
            ], range: range)
            
            startIndex += name.count + 2 // ", "
        }
        
        speakersNameTxtVw.attributedText = attributed
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
        speakersNameTxtVw.font = UIFont(name: Myfonts.medium, size: 14)
        
        joinBtn.layer.cornerRadius = 10
        cancelBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 10)
    }
    
    func setUpData(data: ConferenceAgenda) {
        self.DateLabel.text = data.date ?? "--"
        self.timeLabel.text = "\(data.timeFrom ?? "--" ) - \(data.timeTo ?? "--" )"
        
        let content = data.description ?? "--"
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.sessionNameLabel.attributedText = attributed
        } else { self.sessionNameLabel.text = content }
        
        let sessionName = (data.name?.isEmpty ?? true) ? "--" : data.name
        self.descriptionLbl.text = sessionName
        
        
        let sponsorName = (data.sponsorname?.isEmpty ?? true) ? "--" : data.sponsorname
        self.sponsersNameLabel.text = sponsorName
        let speakerName = ((data.speakerNames?.isEmpty ?? true) ? "--" : data.speakerNames) ?? ""
        self.speakersNameLabel.text = speakerName
        self.speakersNameTxtVw.text = speakerName
        if speakerName == "--" {
            self.speakersNameLabel.isHidden = false
        } else {
            self.speakersNameLabel.isHidden = true
        }
        
        let mappings = data.evaUserNetworkingMappings ?? []

        // Default state (hide all)
        btnStackVw.isHidden = true
        joinBtn.isHidden = true
        cancelBtn.isHidden = true

        // Only proceed if approved
        guard eventAttendeesStatus.lowercased() == "approved" else {
            return
        }
        btnStackVw.isHidden = false

        // No mapping → show Join
        guard let mapping = mappings.first else {
            joinBtn.isHidden = false
            return
        }

        // Mapping exists
        if mapping.status == 1 && mapping.userID == myUserDefaults.userId {
            // User already joined
            cancelBtn.isHidden = false
        } else {
            // Not joined / different user
            joinBtn.isHidden = false
        }
    }
    
    func setDetailsData(data: ConferenceProgram?) {
        DateLabel.text = "\(data?.timeFrom ?? "") - \(data?.timeTo ?? "")"
        self.timeLabel.text = ""
        
        let content = ((data?.description?.isEmpty ?? true) ? "--" : data?.description) ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            self.sessionNameLabel.attributedText = attributed
        } else { self.sessionNameLabel.text = content }
        
        let sessionName = (data?.name?.isEmpty ?? true) ? "--" : data?.name
        self.descriptionLbl.text = sessionName
        
        
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
        self.speakersNameTxtVw.text = speakerName
        if speakerName == "--" {
            self.speakersNameLabel.isHidden = false
        } else {
            self.speakersNameLabel.isHidden = true
        }
        
        let mappings = data?.evaUserNetworkingMappings ?? []

        // Default state (hide all)
        btnStackVw.isHidden = true
        joinBtn.isHidden = true
        cancelBtn.isHidden = true

        // Only proceed if approved
        guard eventAttendeesStatus.lowercased() == "approved" else {
            return
        }
        btnStackVw.isHidden = false

        // No mapping → show Join
        guard let mapping = mappings.first else {
            joinBtn.isHidden = false
            return
        }

        // Mapping exists
        if mapping.status == 1 && mapping.userID == myUserDefaults.userId {
            // User already joined
            cancelBtn.isHidden = false
        } else {
            // Not joined / different user
            joinBtn.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - UITextViewDelegate
extension ConferrenceAgendaCell: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "speaker",
           let index = Int(URL.host ?? ""),
           index < speakers.count {
            
            let name = speakers[index]
            onSpeakerTapped?(name, index)
            return false // prevent system action
        }
        return true
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
