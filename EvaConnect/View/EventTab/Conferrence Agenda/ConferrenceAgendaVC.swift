//
//  ConferrenceAgendaVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferrenceAgendaVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
            let sessionLblHeight = self.heightForView(text: agenda.name ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            let sponsersNameHeight = self.heightForView(text: agenda.sponsorname ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            
            let totalHeight = sessionLblHeight + sponsersNameHeight + 115.0 //Full Cell Height...
            let collapseHeight = totalHeight - sponsersNameHeight - 35.0 //Collapse Cell Height...
            
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
    
    @objc func viewAllTapped() {
        print("View All tapped")
        let vc = ConferenceDetailsVC.instantiate(eventId: self.eventId)
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
}

extension ConferrenceAgendaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conferenceAgendaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = agendaListTable.dequeueReusableCell(withIdentifier: ConferrenceAgendaCell.id(), for: indexPath) as! ConferrenceAgendaCell
        
        let agenda = self.conferenceAgendaList[indexPath.row]
        cell.setUpData(data: agenda)
        
        cell.isExpanded = (indexPath.row == selectedIndex)
        cell.drpDwnButton.tag = indexPath.row
        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let agenda = self.conferenceAgendaList[indexPath.row]
        let sessionName = ((agenda.name?.isEmpty ?? true) ? "--" : agenda.name) ?? ""
        let sponsorName = ((agenda.sponsorname?.isEmpty ?? true) ? "--" : agenda.sponsorname) ?? ""
        
        let sessionLblHeight = self.heightForView(text: sessionName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
        let sponsersNameHeight = self.heightForView(text: sponsorName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
        
        let totalHeight = sessionLblHeight + sponsersNameHeight + 115.0
        
        if indexPath.row == selectedIndex {
            return totalHeight //157
        } else {
            //return 101
            let sponserheight = sponsersNameHeight + 35.0
            let collapseHeight = totalHeight - sponserheight
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
