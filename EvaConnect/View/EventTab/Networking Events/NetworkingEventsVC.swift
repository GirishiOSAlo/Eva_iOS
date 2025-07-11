//
//  NetworkingEventsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var networkinEventListTable: UITableView!
    @IBOutlet weak var networkinEventTableHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var infoUiView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableBgVw: UIView!
    
    var networkingEventList: [EventNetworking] = []
    var selectedIndex: Int?
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        tableBgVw.layer.cornerRadius = 20.0
        
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
        networkinEventListTable.dataSource = self
        networkinEventListTable.delegate = self
        networkinEventListTable.registerCell(withType: NetworkingEventsCell.self)
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
    
    func updateTableHeigth() {
        var finalHeight = 0.0
        
        for (i,network) in self.networkingEventList.enumerated() {
            let eventNameLblHeight = self.heightForView(text: network.networkingeventName ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            let descLblHeight = self.heightForView(text: network.description ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            let sponsorLblHeight = self.heightForView(text: "--", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            let locationLblHeight = self.heightForView(text: "--", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            
            let totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0
            let collapseHeight = totalHeight - sponserheight
            
            if i == selectedIndex {
                finalHeight = finalHeight + totalHeight
            } else {
                finalHeight = finalHeight + collapseHeight
            }
        }
        self.networkinEventTableHeight.constant = finalHeight
    }
    
    @objc func viewAllTapped() {
        print("View All tapped")
        let vc = NetworkingEventsListVC.instantiate(eventId: self.eventId)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func drpDwnBtnTapped(sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = nil
        } else {
            selectedIndex = sender.tag
        }
        networkinEventListTable.reloadData()
        self.updateTableHeigth()
    }

}

extension NetworkingEventsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkingEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = networkinEventListTable.dequeueReusableCell(withIdentifier: NetworkingEventsCell.id(), for: indexPath) as! NetworkingEventsCell
        
        let networkEvent = self.networkingEventList[indexPath.row]
        cell.setData(obj: networkEvent)
        
        cell.isExpanded = (indexPath.row == selectedIndex)
        cell.drpDwnBtn.tag = indexPath.row
        cell.drpDwnBtn.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 320
        let networkEvent = self.networkingEventList[indexPath.row]
        let eventNameLblHeight = self.heightForView(text: networkEvent.networkingeventName ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        let descLblHeight = self.heightForView(text: networkEvent.description ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        let sponsorLblHeight = self.heightForView(text: "--", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        let locationLblHeight = self.heightForView(text: "--", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        
        let totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
        
        if indexPath.row == selectedIndex {
            return totalHeight //157
        } else {
            //return 101
            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0
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
