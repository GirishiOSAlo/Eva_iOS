//
//  NewChatVC.swift
//  EvaConnect
//
//  Created by usama on 09/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class NewChatVC: TableViewBase {

    @IBOutlet weak var yourConnections: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Properties
    let pageSize = 200
    let pageNumber = 0
    
    var inSearchMode = false
    var filteredUsers: [User] = []
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? ChatVC, let user = sender as? User {
//            destination.user = user
//        }
//    }
}

extension NewChatVC {
    
    func initUI() {
        
        (yourConnections as? HeadingTwoBold)?.textColor = .black
        headerView.backgroundColor = AppColors.lightGrayBG
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.registerCell(withType: InviteConnectionCell.self)
        updateUsers()
    }
    
    private func updateUsers() {
        
        showActivity()
        UserDataHandler.getUsers(pageNumber: pageNumber, pageSize: pageSize) { (users, error) in
            
            self.hideActivity()
            if let users = users {
                self.users.append(contentsOf: users.filter({ $0.isConnected == "active" }))
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension NewChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InviteConnectionCell.id(), for: indexPath) as? InviteConnectionCell {
            
            cell.invitationType = .message
            cell.inviteButton.tag = indexPath.row
            cell.delegate = self
            cell.connection = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}


extension NewChatVC: UISearchBarDelegate {
    
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
        filteredUsers = users.filter({ $0.firstName.lowercased().range(of: searchText) != nil })
        tableView.reloadData()
    }
}


extension NewChatVC: SelectionCellActionable {
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        let user = inSearchMode ? filteredUsers[sender.tag] : users[sender.tag]
        print("user", user)
        performSegue(withIdentifier: Constants.Segues.chat, sender: user)

    }
}
