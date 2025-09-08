//
//  ApplicantListVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 12/10/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

class ApplicantListVC: UIViewController {
    
    @IBOutlet weak var navBarTitle: HeadingLabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var jobCardView: UIView!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var positionNameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var industryView: UIView!
    @IBOutlet weak var industryJobDescLbl: UILabel!
    @IBOutlet weak var activeForLbl: UILabel!
    @IBOutlet weak var applicantBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var jobId = 0
    var jobDetails: ApplicantListData?
    var applicantsList: [UserConnection] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isChatEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
//        fetchApplicantsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getSettings()
        tableView.registerCell(withType: ConnectionCell.self)
        fetchApplicantsList()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setLayout() {
        navBarTitle.text = "Applicants"
        jobCardView.layer.cornerRadius = 15
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}

extension ApplicantListVC {
    func setupUI(details: ApplicantListData) {
        jobImageView.sd_setImage(with: URL(string: details.image ?? ""), placeholderImage: UIImage(named: "profile")!)
        positionNameLbl.text = details.jobTitle
        companyNameLbl.text = details.position
        locationLbl.text = details.location
        industryJobDescLbl.text = details.description
        activeForLbl.text = details.value
        applicantBtn.setTitle("\(details.applicationsCount ?? "") Applicants", for: .normal)
        applicantsList = details.application ?? []
        tableView.reloadData()
    }
    
    @objc func sendTapped(_ sender: UIButton) {
        let obj = applicantsList[sender.tag]
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = obj.id ?? 0
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
}

// MARK: API Calls

extension ApplicantListVC {
    
    func fetchApplicantsList() {
        
        showActivity()
        
        //let url = EndPoints.getAllJobApplicant
        let url = "http://18.168.230.15:2300/Jobs/14/applicantlist"
        
        let parameters: AFParameters = ["job_id": self.jobId]
        
        NetworkManagerr.request(url, method: .post, parameters: parameters) { [weak self] (response) in
            self?.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(ApplicantListModel.self, from: response.data!)
                
                if !(root.error ?? false) {
                    if let details = root.data?[0] {
                        self?.setupUI(details: details)
                        
                    }
                } else {
                    self?.presentAlert("Error: ", root.message)
                }
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func getSettings() {
        NetworkManagerr.request(EndPoints.settingsOptions) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SettingsOptionsDataModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self.isChatEnable = data[0].privateMessaging ?? true
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

extension ApplicantListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        applicantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
        cell.connectionType = .followers
//        cell.requestType = requestType
        cell.connect.tag = indexPath.row
        cell.accept.tag = indexPath.row
        cell.decline.tag = indexPath.row
        cell.sendButton.tag = indexPath.row
        cell.connection = applicantsList[indexPath.row]
        cell.sendButton.addTarget(self, action: #selector(sendTapped(_:)), for: .touchUpInside)
//        cell.delegate = self
//        cell.connectionDelegate = self
//        cell.connection = dataType == .normal ? connections[indexPath.row] : filteredConnections[indexPath.row]
//        cell.accept.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
//        cell.decline.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = applicantsList[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

