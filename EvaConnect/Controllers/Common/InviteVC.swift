//
//  InviteVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class InviteVC: UIViewController {

    @IBOutlet weak var mainUiView: UIView!
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var copyLinkBtn: UIButton!
    @IBOutlet weak var whatsAppBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    
//    var completion: (([Int?], [UserConnection]) -> ())? = nil
    var completion: (([Int?], [AttendeesList]) -> ())? = nil
    
    
    var inSearchMode = false
    var offSet = 0
    var pageSize = 50
    var selectedIndex = 0
    //var passedConnections: [UserConnection] = []
    var attendeesList: [AttendeesList] = []
    
//    var connectionUsers: [UserConnection] = [] {
//        didSet {
//            shareTableView.reloadData()
//        }
//    }
    var connectionUsers: [AttendeesList] = [] {
        didSet {
            shareTableView.reloadData()
        }
    }
    
    var rescheduleUsers: [UserConnection] = [] {
        didSet {
            shareTableView.reloadData()
        }
    }
    
//    var filteredUsers: [UserConnection] = []
    var filteredUsers: [AttendeesList] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getAllConnection()
    }
    
    func initUI() {
        self.connectionUsers = self.attendeesList
        popupView(uiView: mainUiView)
        shareTableView.delegate = self
        shareTableView.dataSource = self
        self.shareTableView.separatorColor = UIColor.clear
        
    }

    @IBAction func DoneBtnTapped(_ sender: UIButton) {
        let selectedUsers = connectionUsers.filter { $0.isSelected }
        let selectedUserIds = selectedUsers.map { $0.id }
        
//        var parameters = [ "user_id":  user.id ?? 0,
//                           "share_user_id": selectedUserIds] as [String : Any]
        self.completion?(selectedUserIds, selectedUsers)
        self.dismiss(animated: true)
    }
}

extension InviteVC {
    @objc func textFieldDidChange(_ textField: UITextField) {
        let lower = searchTF.text!.lowercased()
        searchAlgorithm(searchText: lower)
    }
    
    func synchronizeSelection() {
        for attendees in attendeesList {
            if let index = connectionUsers.firstIndex(where: { $0.id == attendees.id }) {
                // Update isSelected in connectionUsers based on passedConnections
                connectionUsers[index].isSelected = attendees.isSelected
            }
        }
    }
}

//private extension InviteVC {
//    
//    func getAllConnection() {
//        let endPoint = String(format: "?limit=%d&offset=%d", pageSize, offSet)
//        getConnections(pagination: endPoint) { (userConnections, error) in
//            
//            if let connections = userConnections {
//                if connections.count > 0 {
//                    self.connectionUsers.append(contentsOf: connections)
//                    if self.passedConnections.count > 0 {
//                        self.synchronizeSelection()
//                    }
//                } else {
//                    //                    self.stopAPICall = true
//                }
//            }
//            
//            if let error = error {
//                self.presentAlert("Failure", nil, error)
//            }
//        }
//    }
//    
//    func getConnections(pagination: String? = nil,
//                        parameters: AFParameters? = nil,
//                        completion: @escaping ([UserConnection]? , Error?) -> ()) {
//        
//        var parameterss: AFParameters  = ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "connection_status": "active"]
//        
//        if let parameters = parameters {
//            parameterss = parameters
//        }
//        
//        var endPoint = EndPoints.getFilterConnection
//        
//        if let pagination = pagination {
//            endPoint += pagination
//        }
//        
//        NetworkManagerr.request(endPoint, method: .post, parameters: parameterss) { (response) in
//            
//            self.shareTableView.refreshControl?.endRefreshing()
//            
//            if response.result.isSuccess {
//                
//                let jsonDecoder = JSONDecoder()
//                
//                do {
//                    let connectionRoot = try jsonDecoder.decode(ConnectionFilterModel.self, from: response.data!)
//                    print("json -> \(String(data: response.data!, encoding: .utf8) ?? "invalid json")")
//                    if !connectionRoot.error  {
//                        
//                        completion(connectionRoot.data, nil)
//                    }
//                    
//                } catch {
//                    
//                    completion(nil, error)
//                }
//            }
//        }
//    }
//}

extension InviteVC : SelectionCellActionable {
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        inSearchMode ? filteredUsers[sender.tag].isSelected.toggle() :
               connectionUsers[sender.tag].isSelected.toggle()
       
        shareTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
    
    fileprivate func searchAlgorithm(searchText: String? = nil) {
        //
        guard let searchText = searchText, searchText.length > 0 else {
            
            inSearchMode = false
            shareTableView.reloadData()
            return
        }
        
        inSearchMode = true
        filteredUsers = connectionUsers.filter({ $0.name?.lowercased().range(of: searchText) != nil })
        if filteredUsers.count > 0 {
            shareTableView.reloadData()
        } else {
            self.presentAlert("Alert", "Connection not found", nil)
        }
    }
}


extension InviteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionUsers.count  //rescheduleUsers.count > 0 ? rescheduleUsers.count : connectionUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: InviteTVC = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
//        if rescheduleUsers.count > 0 {
//            cell.connection = rescheduleUsers[indexPath.row]
//            //        cell.connection.isSelected ? cell.inviteBtn.setImage(UIImage(named: "fillRadioBtn"), for: .normal) : cell.inviteBtn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
//            if cell.connection.isSelected {
//                cell.inviteBtn.setTitle("Invited", for: .normal)
//                cell.inviteBtn.setTitleColor(.white, for: .normal)
//                cell.inviteBtn.layer.borderWidth = 1
//                cell.inviteBtn.layer.borderColor = AppColors.appBlue.cgColor
//                cell.inviteBtn.layer.cornerRadius = 15
//                cell.inviteBtn.backgroundColor = AppColors.appBlue
//            } else {
//                cell.inviteBtn.setTitle("Invite", for: .normal)
//                cell.inviteBtn.setTitleColor(AppColors.appBlue, for: .normal)
//                cell.inviteBtn.layer.borderWidth = 1
//                cell.inviteBtn.layer.borderColor = AppColors.appBlue.cgColor
//                cell.inviteBtn.layer.cornerRadius = 15
//                cell.inviteBtn.backgroundColor = .white
//            }
//            cell.inviteBtn.tag = indexPath.row
//            return cell
//        } else {
//            cell.connection = inSearchMode ? filteredUsers[indexPath.row] : connectionUsers[indexPath.row]
            cell.Attendees = inSearchMode ? filteredUsers[indexPath.row] : connectionUsers[indexPath.row]
            //        cell.connection.isSelected ? cell.inviteBtn.setImage(UIImage(named: "fillRadioBtn"), for: .normal) : cell.inviteBtn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
        if cell.Attendees.isSelected {
                cell.inviteBtn.setTitle("Invited", for: .normal)
                cell.inviteBtn.setTitleColor(.white, for: .normal)
                cell.inviteBtn.layer.borderWidth = 1
                cell.inviteBtn.layer.borderColor = AppColors.appBlue.cgColor
                cell.inviteBtn.layer.cornerRadius = 15
                cell.inviteBtn.backgroundColor = AppColors.appBlue
            } else {
                cell.inviteBtn.setTitle("Invite", for: .normal)
                cell.inviteBtn.setTitleColor(AppColors.appBlue, for: .normal)
                cell.inviteBtn.layer.borderWidth = 1
                cell.inviteBtn.layer.borderColor = AppColors.appBlue.cgColor
                cell.inviteBtn.layer.cornerRadius = 15
                cell.inviteBtn.backgroundColor = .white
            }
            cell.inviteBtn.tag = indexPath.row
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if rescheduleUsers.count > 0 {
//            if rescheduleUsers.compactMap({ $0.isSelected }).count > 0 {
//
//                var connection = rescheduleUsers.filter { $0.isSelected }
////                connection.mergeElements(newElements: filteredUsers.filter{ $0.isSelected })
//
//            } else {
//                self.presentAlert("Alert", "Please invite connections", nil)
//            }
//        } else {
            if connectionUsers.compactMap({ $0.isSelected }).count > 0 || filteredUsers.compactMap({ $0.isSelected }).count > 0 {
        
                var connection = connectionUsers.filter { $0.isSelected }
                connection.mergeElements(newElements: filteredUsers.filter{ $0.isSelected })
      
            } else {
                self.presentAlert("Alert", "Please invite connections", nil)
            }
//        }
        
    }
}
