//
//  NetworkingEventsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class NetworkingEventsVC: UIViewController, XIBed {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var networkinEventListTable: UITableView!
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var infoUiView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var networkingEventList: [EventNetworking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        networkinEventListTable.dataSource = self
        networkinEventListTable.delegate = self
        networkinEventListTable.registerCell(withType: NetworkingEventsCell.self)
        let text = "View all"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        viewAllLabel.attributedText = attributedString
        
        viewAllLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllTapped))
        viewAllLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func viewAllTapped() {
        print("View All tapped")
    }
    
    @objc func drpDwnBtnTapped(sender: UIButton) {
        let index = sender.tag
//        let obj =
    }

}

extension NetworkingEventsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = networkinEventListTable.dequeueReusableCell(withIdentifier: NetworkingEventsCell.id(), for: indexPath) as! NetworkingEventsCell
//        cell.conferenceDetailsTimeLabel.isHidden = true
//        cell.drpDwnButton.tag = indexPath.row
//        cell.drpDwnButton.addTarget(self, action: #selector(self.drpDwnBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NetworkingEventsListVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
}
