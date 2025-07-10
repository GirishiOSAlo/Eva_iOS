//
//  ExhibitorsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 16/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ExhibitorsVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var exhibitorsTableView: UITableView!
    var exhibitorsList: [CommonEventMetaData] = []
    var eventId = 0
    var currentPage = 1
    var lastPage = 1
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        exhibitorsTableView.dataSource = self
        exhibitorsTableView.delegate = self
        exhibitorsTableView.registerCell(withType: ExhibitorsCell.self)
        exhibitorsTableView.layer.cornerRadius = 20
        fetchExhibitorsList(page: currentPage)
    }
    
    @objc func drpDwnBtnTapped(sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = nil
        } else {
            selectedIndex = sender.tag
        }
        exhibitorsTableView.reloadData()
        updateTableHeigth()
    }
    
    func updateTableHeigth() {
        var finalHeight = 0.0
        for (i,exhibitor) in self.exhibitorsList.enumerated() {
            if i == selectedIndex {
                finalHeight = finalHeight + 201.0
            } else {
                finalHeight = finalHeight + 142.0
            }
        }
        self.viewHeight.constant = finalHeight + 20.0
    }
}

extension ExhibitorsVC {
    func fetchExhibitorsList(page: Int) {
        let parameters: AFParameters = [ "event_id": eventId,
                                         "page": page,
                                         "user_type": 1] //user_type == 1: exhibitors
        showActivity()
        NetworkManagerr.request(EndPoints.eventDropDwnList , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let exhibitorsDetail = try decoder.decode(CommonEventModel.self, from: response.data!)
                    
                    if !(exhibitorsDetail.error ?? false) {
                        self.exhibitorsList = exhibitorsDetail.data?.data ?? []
                        self.exhibitorsTableView.reloadData()
                        self.lastPage = exhibitorsDetail.data?.lastPage ?? 1
                        self.updateTableHeigth()
                    } else {
                        self.presentAlert("Error","\(exhibitorsDetail.message ?? "")")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension ExhibitorsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exhibitorsTableView.dequeueReusableCell(withIdentifier: ExhibitorsCell.id(), for: indexPath) as! ExhibitorsCell
        let exhibitorData = exhibitorsList[indexPath.row]
        cell.setUpData(data: exhibitorData)
        cell.isExpanded = (indexPath.row == selectedIndex)
        cell.DrpDwnBtn.tag = indexPath.row
        cell.DrpDwnBtn.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
           return 201
        } else {
            return 142
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == exhibitorsList.count - 1 {
            print("👉 Last tableview cell is visible")
            // Load next page if not already fetching and not at the last page
            if currentPage < lastPage {
                currentPage += 1
                fetchExhibitorsList(page: currentPage)
            } else {
                print("Page completed. No Api call")
            }
        }
    }
}
