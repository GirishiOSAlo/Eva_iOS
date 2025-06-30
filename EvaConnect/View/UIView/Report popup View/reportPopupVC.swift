//
//  reportPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 31/05/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class reportPopupVC: UIViewController, XIBed {

    @IBOutlet weak var mainUiView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reportTableView: UITableView!
    
    var completion: (() -> ())? = nil
    
    var reasons = ["Spam or Scam","Hate Speech or Harassment", "Violence or Threats", "Nudity or Sexual Content", "Graphic Violence or Disturbing Content","Impersonation", "Intellectual Property Violation", "False Information or Misleading Content", "Self-Harm or Suicide Content", "Bullying or Cyberbullying", "Privacy Violation", "Other"]
    var postId = 0
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        Constants.setUpperCornerRadius(uiView: mainUiView, radius: 35)
    }
    
    func registerCell(){
        reportTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        reportTableView.delegate = self
        reportTableView.dataSource = self
    }
    
    
    func sendReport(selectedIndex: Int) {
        showActivity()
        var parameterss: AFParameters  = [:]
        parameterss = [ "reason" : reasons[selectedIndex]]
                     /*   "tag_name": reasons[selectedIndex],
                       "user_id": self.userId,
                       "post_id": self.postId] */

        NetworkManagerr.request(EndPoints.createReport, method: .post, parameters: parameterss) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error) {
                    if newsRoot.error {
                        self.presentAlert("Failure", newsRoot.message, nil)
                    } else {
                        self.presentAlert("Success", "Report Sent") {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

}


extension reportPopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = reasons[indexPath.row]
        cell.backgroundColor = .clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if reasons.count-1 == indexPath.row {
            self.dismiss(animated: true)
            self.completion?()
        }
        sendReport(selectedIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
