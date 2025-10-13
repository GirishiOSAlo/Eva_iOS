//
//  NetworkingEventsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int, eventAttendeesStatus: String) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        vc.eventAttendeesStatus = eventAttendeesStatus
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
    var eventAttendeesStatus = ""
    
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
            let name = (network.networkingeventName?.isEmpty ?? true) ? "--" : network.networkingeventName
            let eventNameLblHeight = self.heightForView(text: name ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            
            let content = network.description ?? ""
            let font = UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14)
            let color = UIColor(hex: "#848397")
            let labelWidth = self.view.frame.width - 96.0
            
            var descLblHeight = 0.0
            if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
                descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
            } else {
                descLblHeight = heightForView(text: content, font: font, width: labelWidth)
            }
            
            let sponsorLblHeight = self.heightForView(text: "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            let location = (network.location?.isEmpty ?? true) ? "--" : network.location
            let locationLblHeight = self.heightForView(text: location ?? "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            
            
            var totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
            if descLblHeight == 0 {
                totalHeight = totalHeight - 11.0 // -11.0 top bottom margin desc lbl.
            }
            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0 - 17.0 - 6.0 //-17 is sponsor header hide & -6 id Bottom space.....
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
        let vc = NetworkingEventsListVC.instantiate(eventId: self.eventId, eventAttendeesStatus: self.eventAttendeesStatus)
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
    
    @objc func joinBtnTapped(sender: UIButton) {
        print("Join Btn Tapped.")
        let networkId = self.networkingEventList[sender.tag].id ?? 0
        self.networkJoinApiCall(networkingID: networkId, status: "join")
    }
    
    @objc func cancelBtnTapped(sender: UIButton) {
        print("Cancel Btn Tapped.")
        let networkId = self.networkingEventList[sender.tag].id ?? 0
        self.networkJoinApiCall(networkingID: networkId, status: "cancel")
    }
    
    
    func calculateAttributedLblHeight(attributedText: NSAttributedString, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let boundingRect = attributedText.boundingRect(with: size, options: options, context: nil)
        return ceil(boundingRect.height)
    }
}

extension NetworkingEventsVC {
    func fetchEventDetail() {
        let parameters: AFParameters = [ "id": eventId]
        showActivity()
        NetworkManagerr.request(EndPoints.eventDetail , method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let decoder = JSONDecoder()
                    let eventDetail = try decoder.decode(NewEventDetailsModel.self, from: response.data!)
                    
                    if !(eventDetail.error ?? false), ((eventDetail.data?.count ?? 0) > 0) {
                        let eventDetail = eventDetail.data?[0]
                        self.networkingEventList = eventDetail?.eventNetworking ?? []
                        self.networkinEventListTable.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
        
    func networkJoinApiCall(networkingID: Int, status: String) {
        let url = EndPoints.eventNetworkingStatus
        let parameters = [
            "event_id": self.eventId,
            "networking_id": networkingID,
            "status": status,
            "user_id": myUserDefaults.userId] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let networkEventRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(networkEventRoot.error) {
                    print("Success")
                    self.fetchEventDetail()
                } else {
                    print("Error :: \(networkEventRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
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
        cell.eventAttendeesStatus = self.eventAttendeesStatus
        cell.isExpanded = (indexPath.row == selectedIndex)
        cell.drpDwnBtn.tag = indexPath.row
        cell.drpDwnBtn.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.joinBtn.tag = indexPath.row
        cell.joinBtn.addTarget(self, action: #selector(self.joinBtnTapped(sender:)), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(self.cancelBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 320
        let networkEvent = self.networkingEventList[indexPath.row]
        let name = (networkEvent.networkingeventName?.isEmpty ?? true) ? "--" : networkEvent.networkingeventName
        let eventNameLblHeight = self.heightForView(text: name ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        
        let content = networkEvent.description ?? ""
        let font = UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14)
        let color = UIColor(hex: "#848397")
        let labelWidth = self.view.frame.width - 96.0

        var descLblHeight = 0.0
        if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
            descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
        } else {
            descLblHeight = heightForView(text: content, font: font, width: labelWidth)
        }
        
        let sponsorLblHeight = self.heightForView(text: "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        let location = (networkEvent.location?.isEmpty ?? true) ? "--" : networkEvent.location
        let locationLblHeight = self.heightForView(text: location ?? "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        
        var totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
        if descLblHeight == 0 {
            totalHeight = totalHeight - 11.0 // -11.0 top bottom margin desc lbl.
        }
        let sponserheight = sponsorLblHeight + locationLblHeight + 126.0 - 17.0 - 6.0 //-17 is sponsor header hide & -6 id Bottom space.....
        let collapseHeight = totalHeight - sponserheight
        
//        if indexPath.row == selectedIndex {
//            return totalHeight //157
//        } else {
//            //return 101
//            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0
//            let collapseHeight = totalHeight - sponserheight
//            return collapseHeight
//        }
        
        if indexPath.row == selectedIndex {
            if self.eventAttendeesStatus.lowercased() == "approved" {
                let finalHeight = totalHeight
                return finalHeight
            } else {
                let finalHeight = totalHeight - 40.0 //-40.0 is Btn Hidden....
                return finalHeight
            }
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
