//
//  ForwardChatVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class ForwardChatVC: UIViewController {
    

    @IBOutlet weak var NavBarView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navBarTitle: HeadingLabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var FWtableView: UITableView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    var inSearchMode = false
    var offSet = 0
    var pageSize = 50
    var stopAPICall = false
    var msgIdArr: [Int] = []
    
    var connectionUsers: [UserConnection] = [] {
        didSet {
            FWtableView.reloadData()
        }
    }
    
    var filteredUsers: [UserConnection] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllConnection()
    }
    
    func setupUI() {
        shareBtn.layer.cornerRadius = 24
        FWtableView.delegate = self
        FWtableView.dataSource = self
        self.FWtableView.separatorColor = UIColor.clear
        searchTextfield.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        ForwardMSG()
    }
}

extension ForwardChatVC {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let lower = searchTextfield.text!.lowercased()
        searchAlgorithm(searchText: lower)
    }
    
    fileprivate func searchAlgorithm(searchText: String? = nil) {
        //
        guard let searchText = searchText, searchText.length > 0 else {
            
            inSearchMode = false
            FWtableView.reloadData()
            return
        }
        
        inSearchMode = true
        filteredUsers = connectionUsers.filter({ $0.firstName?.lowercased().range(of: searchText) != nil })
        if filteredUsers.count > 0 {
            FWtableView.reloadData()
        } else {
            self.presentAlert("Alert", "Connection not found", nil)
        }
    }
    
}

private extension ForwardChatVC {
    
    func getAllConnection() {
        let endPoint = String(format: "?limit=%d&offset=%d", pageSize, offSet)
        getConnections(pagination: endPoint) { (userConnections, error) in
            
            if let connections = userConnections {
                if connections.count > 0 {
                    self.connectionUsers.append(contentsOf: connections)
                } else {
                    self.stopAPICall = true
                }
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    
    func getConnections(pagination: String? = nil,
                                parameters: AFParameters? = nil,
                                completion: @escaping ([UserConnection]? , Error?) -> ()) {
        
        var parameterss: AFParameters  = ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "connection_status": "active"]
        
        if let parameters = parameters {
            parameterss = parameters
        }
        
        var endPoint = EndPoints.getFilterConnection
        
        if let pagination = pagination {
            endPoint += pagination
        }
        
        NetworkManagerr.request(endPoint, method: .post, parameters: parameterss) { (response) in
            
            self.FWtableView.refreshControl?.endRefreshing()
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let connectionRoot = try jsonDecoder.decode(ConnectionFilterModel.self, from: response.data!)
                    print("json -> \(String(data: response.data!, encoding: .utf8) ?? "invalid json")")
                    if !connectionRoot.error  {
        
                        completion(connectionRoot.data, nil)
                    }
                    
                } catch {
                    
                    completion(nil, error)
                }
            }
        }
    }
    
    
    func ForwardMSG() {
        
        if let user = LoggedUserDetails.shared.user {
            let selectedUsers = connectionUsers.filter { $0.isSelected }
            let selectedUserIds = selectedUsers.map { $0.id }
            
            var parameters = [ "message_id":  self.msgIdArr,
                               "receiver_id": selectedUserIds] as [String : Any]

            showActivity()
            NetworkManagerr.request(EndPoints.forwardMessage, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                if response.result.isSuccess {
                    
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                    
                    if !genericResponse.error {
                        
//                        self.showToast(message: "Shared successfully")
                        self.presentAlert("Success", genericResponse.message, nil) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.presentAlert("Failure", genericResponse.message, nil) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
            self.navigationController?.dismiss(animated: true)
        }
        
    }
    
}

extension ForwardChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : connectionUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShareTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        //        cell.connection = connections[indexPath.row]
                cell.delegate = self
        cell.connection = inSearchMode ? filteredUsers[indexPath.row] : connectionUsers[indexPath.row]
        cell.connection.isSelected ? cell.selectButton.setImage(UIImage(named: "fillRadioBtn"), for: .normal) : cell.selectButton.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
        cell.selectButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if connectionUsers.compactMap({ $0.isSelected }).count > 0 || filteredUsers.compactMap({ $0.isSelected }).count > 0 {
            
            var connection = connectionUsers.filter { $0.isSelected }
            connection.mergeElements(newElements: filteredUsers.filter{ $0.isSelected })
            
        } else {
            self.presentAlert("Alert", "Please invite connections", nil)
        }
        
    }
}

extension ForwardChatVC : SelectionCellActionable {
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        inSearchMode ? filteredUsers[sender.tag].isSelected.toggle() :
               connectionUsers[sender.tag].isSelected.toggle()
       
        FWtableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
}
    
