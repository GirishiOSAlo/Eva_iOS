//
//  ConferrenceAgendaVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferrenceAgendaVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int, eventAttendeesStatus: String) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        vc.eventAttendeesStatus = eventAttendeesStatus
        return vc
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var agendaListTable: UITableView!
    @IBOutlet weak var tableBgVw: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var agendaTableHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var infoUiView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var conferenceAgendaList: [ConferenceAgenda] = []
    var selectedIndex: Int?
    var eventId = 0
    var eventAttendeesStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        if myUserDefaults.isEventFlow {
            self.eventId = myUserDefaults.isEventFlowEventID
        } else {
           print("Social FLow")
        }
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        tableBgVw.layer.cornerRadius = 20.0
        infoUiView.layer.cornerRadius = 20.0
        noDataLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        noDataLbl.isHidden = true
        
        let text = "View all"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#4D76CD", alpha: 1.0),
            .font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        viewAllLabel.attributedText = attributedString
        
        viewAllLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllTapped))
        viewAllLabel.addGestureRecognizer(tapGesture)
        
        self.registerCell()
        
        if self.conferenceAgendaList.count == 0 {
            self.tableBgVw.isHidden = true
            self.noDataLbl.isHidden = false
            self.agendaTableHeight.constant = 50.0
        } else {
            self.tableBgVw.isHidden = false
            self.noDataLbl.isHidden = true
            self.updateTableHeigth()
        }
    }
    
    func registerCell() {
        agendaListTable.dataSource = self
        agendaListTable.delegate = self
        agendaListTable.registerCell(withType: ConferrenceAgendaCell.self)
    }
    
    func updateTableHeigth() {
        var finalHeight = 0.0
        
        for (i,agenda) in self.conferenceAgendaList.enumerated() {
            
            let content = agenda.description ?? ""
            let font = UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14)
            let color = UIColor(hex: "#848397")
            let labelWidth = self.view.frame.width - 96.0
            
            var descLblHeight = 0.0
            if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
                descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
            } else {
                descLblHeight = heightForView(text: content, font: font, width: labelWidth)
            }
            
            let sessionName = ((agenda.name?.isEmpty ?? true) ? "--" : agenda.name) ?? ""
            let sponsorName = ((agenda.sponsorname?.isEmpty ?? true) ? "--" : agenda.sponsorname) ?? ""
            let speakerName = ((agenda.speakerNames?.isEmpty ?? true) ? "--" : agenda.speakerNames) ?? ""
            
            let sessionLblHeight = self.heightForView(text: sessionName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            let sponsersNameHeight = self.heightForView(text: sponsorName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            let speakersNameHeight = self.heightForView(text: speakerName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            
            let totalHeight = descLblHeight + sessionLblHeight + sponsersNameHeight + speakersNameHeight + 214.0 //Full Cell Height...
            let collapseHeight = descLblHeight + sessionLblHeight + 92.0 //Collapse Cell Height...
            
            if i == selectedIndex {
                finalHeight = finalHeight + totalHeight
            } else {
                finalHeight = finalHeight + collapseHeight
            }
        }
        // Animate reload
        UIView.animate(withDuration: 0.3) {
            self.agendaListTable.beginUpdates()
            self.agendaListTable.endUpdates()
            self.agendaTableHeight.constant = finalHeight
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    func calculateAttributedLblHeight(attributedText: NSAttributedString, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let boundingRect = attributedText.boundingRect(with: size, options: options, context: nil)
        return ceil(boundingRect.height)
    }
    
    @objc func viewAllTapped() {
        print("View All tapped")
        let vc = ConferenceDetailsVC.instantiate(eventId: self.eventId, eventAttendeesStatus: self.eventAttendeesStatus)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func drpDwnBtnTapped(sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = nil
        } else {
            selectedIndex = sender.tag
        }
        agendaListTable.reloadData()
        self.updateTableHeigth()
    }
    
    @objc func joinBtnTapped(sender: UIButton) {
        print("Join Btn Tapped.")
//        let networkId = self.networkingEventList[sender.tag].id ?? 0
//        self.networkJoinApiCall(networkingID: networkId, status: "join")
    }
    
    @objc func cancelBtnTapped(sender: UIButton) {
        print("Cancel Btn Tapped.")
//        let networkId = self.networkingEventList[sender.tag].id ?? 0
//        self.networkJoinApiCall(networkingID: networkId, status: "cancel")
    }
}

extension ConferrenceAgendaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conferenceAgendaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = agendaListTable.dequeueReusableCell(withIdentifier: ConferrenceAgendaCell.id(), for: indexPath) as! ConferrenceAgendaCell
        
        let agenda = self.conferenceAgendaList[indexPath.row]
        cell.setUpData(data: agenda)
        cell.eventAttendeesStatus = self.eventAttendeesStatus
        cell.isExpanded = (indexPath.row == selectedIndex)
        
        let speakers = agenda.speakers ?? []        
        cell.configure(text: agenda.speakerNames ?? "")
        if speakers.count > 0 {
            cell.onSpeakerTapped = { [weak self] name, index in
                guard let self = self else { return }
                print("Tapped Speaker:\(name), Index: \(index), Row:\(indexPath.row)")
                // 🔥 Go Speaker Profile...
                let speaker = speakers[index]
                let vc = StoryboardRouter.othersProfileVC()
                vc.profileID = speaker.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.drpDwnButton.tag = indexPath.row
        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.joinBtn.tag = indexPath.row
        cell.joinBtn.addTarget(self, action: #selector(self.joinBtnTapped(sender:)), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(self.cancelBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let agenda = self.conferenceAgendaList[indexPath.row]
        
        let content = agenda.description ?? "--"
        let font = UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14)
        let color = UIColor(hex: "#848397")
        let labelWidth = self.view.frame.width - 96.0
        
        var descLblHeight = 0.0
        if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
            descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
        } else {
            descLblHeight = heightForView(text: content, font: font, width: labelWidth)
        }
        
        let sessionName = ((agenda.name?.isEmpty ?? true) ? "--" : agenda.name) ?? ""
        let sponsorName = ((agenda.sponsorname?.isEmpty ?? true) ? "--" : agenda.sponsorname) ?? ""
        let speakerName = ((agenda.speakerNames?.isEmpty ?? true) ? "--" : agenda.speakerNames) ?? ""
        
        let sessionLblHeight = self.heightForView(text: sessionName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
        let sponsersNameHeight = self.heightForView(text: sponsorName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
        let speakersNameHeight = self.heightForView(text: speakerName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
        
        let totalHeight = descLblHeight + sessionLblHeight + sponsersNameHeight + speakersNameHeight + 214.0
        let collapseHeight = descLblHeight + sessionLblHeight + 92.0
        
        if indexPath.row == selectedIndex {
            return totalHeight
        } else {
            return collapseHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // Last cell: hide separator
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        } else {
            // Other cells: reset to default
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
}

