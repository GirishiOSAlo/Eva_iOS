//
//  NetworkingEventsListVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsListVC: UIViewController,XIBed {
    
    static func instantiate(eventId: Int, eventAttendeesStatus: String) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        vc.eventAttendeesStatus = eventAttendeesStatus
        return vc
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var networkingEventListTable: UITableView!
    @IBOutlet weak var networkinEventTableHeight: NSLayoutConstraint!
    @IBOutlet weak var EventListTitleLabel: UILabel!
    @IBOutlet weak var tableBgVw: UIView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var networkingEventList: [NetworkEventList] = []
    var selectedIndex: Int?
    var eventId = 0
    var eventAttendeesStatus = ""
    var currentPage = 1
    var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.navigationController?.isNavigationBarHidden = true
        tableBgVw.layer.cornerRadius = 20.0
        noDataLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        noDataLbl.isHidden = true
        registerCell()
        pageTitleLabel.font = UIFont(name: Myfonts.medium, size: 14)
        EventListTitleLabel.font = UIFont(name: Myfonts.medium, size: 14)
        EventListTitleLabel.text = "Event List"
        self.fetchNetworkEventListData(page: currentPage)
    }
    
    func registerCell() {
        networkingEventListTable.dataSource = self
        networkingEventListTable.delegate = self
        networkingEventListTable.registerCell(withType: NetworkingEventsCell.self)
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
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func updateTableHeigth() {
        var finalHeight = 0.0
        
        for (i,network) in self.networkingEventList.enumerated() {
            let name = (network.networkingeventName?.isEmpty ?? true) ? "--" : network.networkingeventName
            let eventNameLblHeight = self.heightForView(text: name ?? "", font: UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)

            let content = network.description ?? ""
            let font = UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14)
            let color = UIColor(hex: "#848397")

            var descLblHeight = 0.0
            if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
                let labelWidth = self.view.frame.width - 96.0
                descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
            } else {
                descLblHeight = self.heightForView(text: content, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            }
            
            
            let sponsorLblHeight = self.heightForView(text: "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            let location = (network.location?.isEmpty ?? true) ? "--" : network.location
            let locationLblHeight = self.heightForView(text: location ?? "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            
            let totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0 - 17.0 //-17 is sponsor header hide.....
            let collapseHeight = totalHeight - sponserheight
            
            if i == selectedIndex {
                finalHeight = finalHeight + totalHeight
            } else {
                finalHeight = finalHeight + collapseHeight
            }
        }
        self.networkinEventTableHeight.constant = finalHeight
    }
    
    @objc func drpDwnBtnTapped(sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = nil
        } else {
            selectedIndex = sender.tag
        }
        networkingEventListTable.reloadData()
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

extension NetworkingEventsListVC {
    func fetchNetworkEventListData(page: Int) {
        let url = EndPoints.eventNetworkList
        let parameters: [String: Any] = [
            "eventid": self.eventId,
            "page": page
        ]
        
        showActivity()
        
        NetworkManagerr.request(url, method: .post, parameters: parameters) { response in
            self.hideActivity()
            do {
                let decoder = JSONDecoder()
                let networkEventRoot = try decoder.decode(NetworkEventListDataModel.self, from: response.data!)
                
                if networkEventRoot.error == false {
                    let list = networkEventRoot.data?.networkingList?.data ?? []
                    self.lastPage = networkEventRoot.data?.networkingList?.lastPage ?? 1
                    
                    if !list.isEmpty {
                        self.networkingEventList = list
                        self.noDataLbl.isHidden = true
                        self.updateTableHeigth()
                    } else {
                        print("No networking events found.")
                        self.networkingEventList = []
                        self.noDataLbl.isHidden = false
                        self.networkinEventTableHeight.constant = 0.0
                    }
                    self.networkingEventListTable.reloadData()
                } else {
                    print("Error: \(networkEventRoot.message ?? "Unknown error")")
                }
            } catch {
                print("Decoding error:", error)
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
                    self.fetchNetworkEventListData(page: self.currentPage)
                } else {
                    print("Error :: \(networkEventRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}


extension NetworkingEventsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkingEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = networkingEventListTable.dequeueReusableCell(withIdentifier: NetworkingEventsCell.id(), for: indexPath) as! NetworkingEventsCell
        
        let networkEvent = self.networkingEventList[indexPath.row]
        cell.setListData(obj: networkEvent)
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

        var descLblHeight = 0.0
        if let attributed = content.htmlToAttributedString(withFont: font, color: color) {
            let labelWidth = self.view.frame.width - 96.0
            descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: labelWidth)
        } else {
            descLblHeight = self.heightForView(text: content, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        }
        
        let sponsorLblHeight = self.heightForView(text: "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        let location = (networkEvent.location?.isEmpty ?? true) ? "--" : networkEvent.location
        let locationLblHeight = self.heightForView(text: location ?? "", font:  UIFont(name: Myfonts.medium, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        
        var totalHeight = eventNameLblHeight + descLblHeight + sponsorLblHeight + locationLblHeight + 220.0
        totalHeight = totalHeight - 17.0 //-17 is sponsor header hide.....
        
        if indexPath.row == selectedIndex {
            if self.eventAttendeesStatus.lowercased() == "approved" {
                let finalHeight = totalHeight
                return finalHeight
            } else {
                let finalHeight = totalHeight - 40.0 //-40.0 is Btn Hidden....
                return finalHeight
            }
        } else {
            let sponserheight = sponsorLblHeight + locationLblHeight + 126.0
            let collapseHeight = totalHeight - sponserheight
            return collapseHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == networkingEventList.count - 1 {
            print("👉 Last tableview cell is visible")
            // Load next page if not already fetching and not at the last page
            if currentPage < lastPage {
                currentPage += 1
                fetchNetworkEventListData(page: currentPage)
            } else {
                print("Page completed. No Api call")
            }
        }
    }
}
