//
//  InviteConnectionVC.swift
//  EvaConnect
//
//  Created by usama on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol ConnectionsProvidable {
    func updateConnections(connections: [User])
}

enum InvitationType {
      case attendees, postShare, message
  }

class InviteConnectionVC: TableViewBase {

    @IBOutlet weak var titleLbl: HeadingLabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inviteButton: UIButton!
    
    var inSearchMode = false
    var connectionUsers: [User] = []
    var filteredUsers: [User] = []
    var navigationType: EventNavigationType = .notifications
    var invitationType: InvitationType = .attendees
    var delegate: ConnectionsProvidable?
    var objectID: Int!
    var type: TypePostEnum!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = invitationType == .postShare ? "Share with connection" : "Invite Connections"
        inviteButton.setTitle(invitationType == .postShare ? "Share" : "Invite", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
        getConnection()
    }
}

extension InviteConnectionVC {
    
    func initUI() {
        headerView.backgroundColor = AppColors.lightGrayBG
        searchBar.delegate = self
        tableView.dataSource = self
        inviteButton.setBackgroundImage(UIImage(named: "ic_logout_btn"), for: .normal)

        tableView.registerCell(withType: InviteConnectionCell.self)
    }
    
    func getConnection() {
        
        if let user = LoggedUserDetails.shared.user {
            
            let parameters = ["user_id":  user.id,
                              "connection_status": "active"] as [String : Any]
            
            showActivity()
            NetworkManagerr.request(EndPoints.getFilterConnection, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                if response.result.isSuccess {
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let connection = try jsonDecoder.decode(ConnectionRoot.self, from:response.data!)
                        
                        if connection.data.count > 0 {
                            
                            self.connectionUsers = connection.data
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func shareConnection() {
        
        if let user = LoggedUserDetails.shared.user {
            let ids = connectionUsers.filter({ $0.isSelected }).compactMap { $0.id }

            var parameters = [ "object_id": objectID!,
                               "object_type": type.rawValue,
                               "user_id":  user.id,
                               "share_user_id": ids] as [String : Any]
            
            if type == .post {
                parameters["post_id"] = objectID!
            } else if type == .event {
                parameters["event_id"] = objectID!
            } else if type == .news {
                parameters["news_id"] = objectID!
            }
            
            showActivity()
            NetworkManagerr.request(EndPoints.dashboardSharePost, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                if response.result.isSuccess {
                    
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                    
                    if !genericResponse.error, genericResponse.message == "success" {
                        self.presentAlertWithAction(title: "Success", message: "Shared with connections") {
                            self.navigationController?.dismiss(animated: true)
                        }
                    } else {
                        self.presentAlert("Failure", genericResponse.message, nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func backButton_touchUpInside(_ sender: UIButton) {
        
        if navigationType == .dialog {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func invite_touchUpInside(_ sender: UIButton) {
        
        if connectionUsers.compactMap({ $0.isSelected }).count > 0 || filteredUsers.compactMap({ $0.isSelected }).count > 0 {
    
            var connection = connectionUsers.filter { $0.isSelected }
            connection.mergeElements(newElements: filteredUsers.filter{ $0.isSelected })
  
            switch invitationType {
              case .attendees:
                              
                  self.delegate?.updateConnections(connections: connection)
                  if navigationType == .dialog {
                      dismiss(animated: true, completion: nil)
                  } else {
                      navigationController?.popViewController(animated: true)
                  }
              default:
                  shareConnection()
              }
        } else {
            self.presentAlert("Alert", "Please invite connections", nil)
        }
    }
}

extension InviteConnectionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inSearchMode ? filteredUsers.count : connectionUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InviteConnectionCell.id(), for: indexPath) as? InviteConnectionCell {
            
            cell.invitationType = invitationType
            cell.inviteButton.tag = indexPath.row
            cell.delegate = self
            
            cell.connection = inSearchMode ? filteredUsers[indexPath.row] : connectionUsers[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

extension InviteConnectionVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let lower = searchBar.text!.lowercased()
        searchAlgorithm(searchText: lower)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let lower = searchBar.text!.lowercased()
        searchAlgorithm(searchText: lower)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchAlgorithm()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    fileprivate func searchAlgorithm(searchText: String? = nil) {
        //
        guard let searchText = searchText, searchText.length > 0 else {
            
            inSearchMode = false
            tableView.reloadData()
            return
        }
        
        inSearchMode = true
        filteredUsers = connectionUsers.filter({ $0.firstName.lowercased().range(of: searchText) != nil })
        if filteredUsers.count > 0 {
            tableView.reloadData()
        } else {
            self.presentAlert("Alert", "Connection not found", nil)
        }
    }
}

extension InviteConnectionVC: SelectionCellActionable {
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        
     inSearchMode ? filteredUsers[sender.tag].isSelected.toggle() :
            connectionUsers[sender.tag].isSelected.toggle()
    
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
}

