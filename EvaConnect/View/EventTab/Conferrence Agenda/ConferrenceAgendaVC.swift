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
        self.updateTableHeigth()
    }
    
    func registerCell() {
        agendaListTable.dataSource = self
        agendaListTable.delegate = self
        agendaListTable.registerCell(withType: ConferrenceAgendaCell.self)
    }
    
    func updateTableHeigth() {
        if selectedIndex == nil {
            let height = conferenceAgendaList.count * 101
            self.agendaTableHeight.constant = CGFloat(height)
        } else {
            let collapseCellHeight = (conferenceAgendaList.count - 1) * 101
            let expandCellHeight = 157
            let height = Int(collapseCellHeight + expandCellHeight)
            self.agendaTableHeight.constant = CGFloat(height)
        }
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
        
//        let agenda = self.conferenceAgendaList[indexPath.row]
//        cell.setUpData(data: agenda)
        cell.DateLabel.text = "14-10-2023"
        cell.timeLabel.text = "9:00 AM - 10:00 AM"
        cell.sessionNameLabel.text = "Next-Gen Aerospace Technologies"
        cell.sponsersNameLabel.text = "Aroora Gaur"
        
        cell.isExpanded = (indexPath.row == selectedIndex)
        cell.conferenceDetailsTimeLabel.isHidden = true
        cell.drpDwnButton.tag = indexPath.row
        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 157
        } else {
            return 101
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
