//
//  NetworkingEventsListVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsListVC: UIViewController,XIBed {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pageTitleLabel: HeadingLabel!
    @IBOutlet weak var networkingEventListTable: UITableView!
    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var EventListTitleLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.navigationController?.isNavigationBarHidden = true
        networkingEventListTable.dataSource = self
        networkingEventListTable.delegate = self
        networkingEventListTable.registerCell(withType: NetworkingEventsCell.self)
        contentUIView.layer.cornerRadius = 20
        contentUIView.clipsToBounds = true
        pageTitleLabel.font = UIFont(name: Myfonts.medium, size: 14)
        EventListTitleLabel.font = UIFont(name: Myfonts.medium, size: 14)
        EventListTitleLabel.text = "Event List"
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension NetworkingEventsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = networkingEventListTable.dequeueReusableCell(withIdentifier: NetworkingEventsCell.id(), for: indexPath) as! NetworkingEventsCell
//        cell.conferenceDetailsTimeLabel.isHidden = true
//        cell.drpDwnButton.tag = indexPath.row
//        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
}
