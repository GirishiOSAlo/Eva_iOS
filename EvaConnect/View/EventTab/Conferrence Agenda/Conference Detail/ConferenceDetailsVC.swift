//
//  ConferenceDetailsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 15/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferenceDetailsVC: UIViewController, XIBed {

    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet weak var agendaTblVw: UITableView!
    
    var eventId = 0
    var eventAgendaData: [EventAgendaData] = []
    var expandedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if myUserDefaults.isEventFlow {
            self.eventId = myUserDefaults.isEventFlowEventID
        } else { print("Social FLow") }
        setupUI()
        registerCell()
        fetchEventConferanceAgenda()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        headingLabel.font = UIFont(name: Myfonts.semiBold, size: 16)
        noDataLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        noDataLbl.isHidden = true
    }
    
    func registerCell() {
        agendaTblVw.dataSource = self
        agendaTblVw.delegate = self
        agendaTblVw.registerCell(withType: ConferrenceAgendaCell.self)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
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
}

extension ConferenceDetailsVC {
    func fetchEventConferanceAgenda() {
        showActivity()
        let url = "\(EndPoints.eventConferenceAgenda)"
        let parameters = ["eventid" : eventId] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let agendaRoot = try jsonDecoder.decode(EventAgendaListDataModel.self, from: response.data!)
                
                if !(agendaRoot.error!) {
                    if (agendaRoot.data?.count ?? 0) > 0 {
                        self.noDataLbl.isHidden = true
                        if let data = agendaRoot.data {
                            self.eventAgendaData = data
                        }
                    } else {
                        print("Agenda List is Empty...")
                        self.eventAgendaData = []
                        self.noDataLbl.isHidden = false
                    }
                    self.agendaTblVw.reloadData()
                } else {
                    print("Error :: \(agendaRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

// MARK: - TableView Delegate & DataSource
extension ConferenceDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventAgendaData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventAgendaData[section].conferencePrograms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = agendaTblVw.dequeueReusableCell(withIdentifier: ConferrenceAgendaCell.id(),
                                                   for: indexPath) as! ConferrenceAgendaCell
        
        let agenda = eventAgendaData[indexPath.section].conferencePrograms?[indexPath.row]
        cell.setDetailsData(data: agenda)
        
        // Expansion logic
        cell.isExpanded = (expandedIndexPath == indexPath)
        
        // Button setup
        cell.drpDwnButton.tag = indexPath.row
        cell.drpDwnButton.accessibilityIdentifier = "\(indexPath.section)"
        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    // Custom Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.clipsToBounds = true
        
        // Background view (fills header)
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#F8F6F8")
        bgView.clipsToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        // Base card view (rounded top corners)
        let baseView = UIView()
        baseView.backgroundColor = UIColor(hex: "#FFFFFF")
        baseView.layer.cornerRadius = 20.0
        baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // top-right + top-left
        baseView.clipsToBounds = true
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Label
        let label = UILabel()
        label.text = self.eventAgendaData[section].date
        label.textColor = UIColor(hex: "#030229")
        label.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Underline
        let underline = UIView()
        underline.backgroundColor = UIColor(hex: "#B8C4CE")
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        // Hierarchy
        headerView.addSubview(bgView)
        headerView.addSubview(baseView)
        baseView.addSubview(label)
        baseView.addSubview(underline)
        
        NSLayoutConstraint.activate([
            // bgView fills header
            bgView.topAnchor.constraint(equalTo: headerView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            // baseView inside header (10pt from top)
            baseView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            baseView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            baseView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0),
            baseView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // label inside baseView
            label.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            
            // underline inside baseView
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
        ])
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    // Dynamic row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let programs = self.eventAgendaData[indexPath.section].conferencePrograms?[indexPath.row]
        let sessionName = ((programs?.name?.isEmpty ?? true) ? "--" : programs?.name) ?? ""
        let sponsorName = ((programs?.sponsorname?.isEmpty ?? true) ? "--" : programs?.sponsorname) ?? ""
        
        let sessionLblHeight = self.heightForView(text: sessionName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 68.0)
        let sponsersNameHeight = self.heightForView(text: sponsorName, font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 68.0)
        let totalHeight = sessionLblHeight + sponsersNameHeight + 115.0
        
        if indexPath == expandedIndexPath {
            return totalHeight
        } else {
            let sponserheight = sponsersNameHeight + 35.0
            let collapseHeight = totalHeight - sponserheight
            return collapseHeight
        }
        //return (indexPath == expandedIndexPath) ? 150 : 50
    }
}

// MARK: - Drop Down Button Action
extension ConferenceDetailsVC {
    @objc func drpDwnBtnTapped(sender: UIButton) {
        guard let sectionStr = sender.accessibilityIdentifier,
              let section = Int(sectionStr) else { return }
        
        let indexPath = IndexPath(row: sender.tag, section: section)
        
        if expandedIndexPath == indexPath {
            // Collapse
            expandedIndexPath = nil
        } else {
            // Expand new
            expandedIndexPath = indexPath
        }
        
        // Animate reload
        UIView.animate(withDuration: 0.3) {
            self.agendaTblVw.beginUpdates()
            self.agendaTblVw.endUpdates()
        }
    }
}

