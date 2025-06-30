//
//  InterestedListVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 29/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class InterestedListVC: UIViewController {
    
    @IBOutlet weak var navBarTitle: HeadingLabel!
    @IBOutlet weak var backBtn: UIButton!


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchBaseVw: UIView!
    
    var isSearch:Bool = false
    var interestedList: [UserConnection] = []
    var employees : [Employees] = []
    var filteredUsers: [Employees] = []
    var companyId = 0
    private var searchTimer: Timer? = nil
    var inSearchMode = false
    var isFromEvent = false
    var isChatEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getSettings()
        if !isFromEvent {
            self.fetchEmpList()
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setLayout() {
        
        self.navBarTitle.text = isFromEvent ? "Interested" : "Employees"
        self.searchBtn.isHidden = isFromEvent
        self.tableView.registerCell(withType: ConnectionCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchMainView.isHidden = true
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        if self.isSearch {
            self.isSearch = false
            self.searchMainView.isHidden = true
        } else {
            print("Back Btn Tapped...")
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        self.isSearch = true
        self.searchMainView.isHidden = false
    }
    
    @objc func sendMsgTapped(_ sender: UIButton){
        let obj = interestedList[sender.tag]
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = obj.id ?? 0
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
    @objc func sendMsgTapped2(_ sender: UIButton){
        let obj = employees[sender.tag]
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = obj.id ?? 0
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
    fileprivate func searchAlgorithm(searchText: String? = nil) {
        //
        guard let searchText = searchText, searchText.length > 0 else {
            
            inSearchMode = false
            tableView.reloadData()
            return
        }
        
        inSearchMode = true
        filteredUsers = employees.filter({ $0.firstName?.lowercased().range(of: searchText) != nil })
        if filteredUsers.count > 0 {
            tableView.reloadData()
        } else {
            self.presentAlert("Alert", "No such employee", nil)
        }
    }

}

// MARK: API Calls

extension InterestedListVC {
    func fetchEmpList() {

        let param: AFParameters = [
            "company_id" : LoggedUserDetails.shared.user?.id ?? 0
        ]
        
        let endPoint = EndPoints.EmpList
        NetworkManagerr.request(endPoint, method: .post, parameters: param) { (response) in
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let resResult = try jsonDecoder.decode(EmployeeListDataModel.self, from: response.data!)
                    if resResult.error == false {
                        self.tableView.isHidden = false
                        self.employees = resResult.data ?? []
                        self.tableView.reloadData()
                    } else {
                        self.presentAlert("Error", resResult.message){
                        }
                    }
                } catch {
                    self.presentAlert("Error", nil, error) {
                        
                    }
                }
            } else {
                self.presentAlert("Error", nil, response.result.error){
                    
                }
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

extension InterestedListVC: UITextFieldDelegate {
    
    //MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        let lower = searchField.text!.lowercased()
        searchAlgorithm(searchText: lower)
    }
}

extension InterestedListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFromEvent ? interestedList.count : inSearchMode ? filteredUsers.count : employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
        cell.connectionType = .followers
        if isFromEvent {
            cell.sendButton.tag = indexPath.row
            cell.connection = interestedList[indexPath.row]
            cell.sendButton.addTarget(self, action: #selector(sendMsgTapped(_:)), for: .touchUpInside)
        } else {
            cell.sendButton.tag = indexPath.row
            cell.emps = inSearchMode ? filteredUsers[indexPath.row] : employees[indexPath.row]
            cell.sendButton.addTarget(self, action: #selector(sendMsgTapped2(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = isFromEvent ? interestedList[indexPath.row].id ?? 0 : inSearchMode ? filteredUsers[indexPath.row].id ?? 0 : employees[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

