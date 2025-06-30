//
//  BlockListVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 31/05/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class BlockListVC: UIViewController, XIBed {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    
    
    var isSearch:Bool = false
    var inSearchMode = false
    private var dataType: DataType = .normal
    private var searchTimer: Timer? = nil
    
    var connections: [UserConnection] = [] {
        didSet {
            let count = connections.count
            tableView.reloadData()
            self.noRecordLbl.isHidden = count > 0
        }
    }
    
    var filteredConnections: [UserConnection] = [] {
        didSet {
            let count = filteredConnections.count
//            print("Connections Count :: \(count)")
//            self.tableBaseVwHeight.constant = (CGFloat(count) * 80.0) + 20.0
//            print("tableHeight :: \(self.tableBaseVwHeight.constant)")
            tableView.reloadData()
            self.noRecordLbl.isHidden = count > 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        getPendingBlockConnection()
        setupUI()
    }
    
    func setupUI(){
        self.noRecordLbl.isHidden = true
        //self.searchMainView.isHidden = true
        self.searchMainView.layer.cornerRadius = 8.0
        self.searchMainView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(withType: ConnectionCell.self)
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func reloadData() {
//        inSearchMode = false
        dataType = .normal
        connections.removeAll()
        getPendingBlockConnection()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if self.isSearch {
            self.isSearch = false
            self.searchMainView.isHidden = true
        } else {
            print("Back Btn Tapped...")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        self.isSearch = true
        self.searchMainView.isHidden = false
    }
    
    private func getPendingBlockConnection() {
        ProfileManager.shared.getConnection(type: .blocked) { [weak self] connections, error, allData  in
            guard let self = self else { return }
            if let error = error {
                self.noRecordLbl.isHidden = false
            } else {
                self.connections = connections ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func searchConnections() {
                
        guard let searchText = searchField.text, searchText.count > 0 else {
            dataType = .normal
            inSearchMode = false
            isSearch = false
            tableView.reloadData()
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.connections.removeAll()
            self.tableView.reloadData()
            self.SearchBlockConnection()
        })
    }
    
    func SearchBlockConnection() {
        showActivity()
        
        let endpoint = EndPoints.blockConnection + "?first_name=\(searchField.text!)"
        
        NetworkManagerr.request(endpoint) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(PendingBlockFilterModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error) {
                    if newsRoot.error {
                        
                    } else if newsRoot.data.isEmpty {
                        
                    } else {
                        var users : [UserConnection] = []
                        newsRoot.data.forEach({ userData in
                            
                            var receiver = userData.receiver
                            receiver?.connectionID = userData.id
                            users.append(receiver!)
                        
                        })

                        self.filteredConnections = users
//                        self.stopAPICall = true
                    }
                    
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
//    func SearchPendingConnection() {
//        showActivity()
//        var parameterss: AFParameters  = [:]
//        
//             parameterss = ["first_name": searchField.text!]
//        
//        NetworkManagerr.request(EndPoints.pendingConnections, method: .post, parameters: parameterss) { (response) in
//            self.hideActivity()
//            do {
//                let jsonDecoder = JSONDecoder()
//                let newsRoot = try jsonDecoder.decode(PendingBlockFilterModel.self, from: response.data!)
//                self.hideActivity()
//                if !(newsRoot.error) {
//                    if newsRoot.error {
//                        
//                    } else if newsRoot.data.isEmpty {
//                        
//                    } else {
//                        var users : [UserConnection] = []
//                        newsRoot.data.forEach({ userData in
//                            var sender = userData.sender
//                            sender?.connectionID = userData.id
//                            users.append(sender!)
//
//                        })
//
//                        self.filteredConnections = users
//                    }
//                    
//                } else {
//                    self.presentAlert("Failure", newsRoot.message, nil)
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//        }
//    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        if textfield.text!.count > 0 {
            dataType = .search
            inSearchMode = true
            searchConnections()
        } else {
            inSearchMode = false
            noRecordLbl.isHidden = true
            reloadData()
        }
    }
}

extension BlockListVC: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return isSearch ? filteredConnections.count : connections.count
//        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
            cell.connectionType = .blocked
            cell.connect.tag = indexPath.row
            cell.accept.tag = indexPath.row
            cell.decline.tag = indexPath.row
            cell.delegate = self
            cell.connectionDelegate = self
        if isSearch {
            cell.connection = filteredConnections[indexPath.row]
        } else {
            cell.connection = connections[indexPath.row]
        }
//            cell.connection = dataType == .normal ? connections[indexPath.row] : filteredConnections[indexPath.row]
            return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension BlockListVC : SelectionCellActionable, ConnectionCellDelegate {
    func sendBtn(connection: UserConnection) {
        print("Do nothing")
    }
    
    func didViewProfile(connection: UserConnection) {
        ProfileManager.shared.blockConnection(id: connection.id ?? 0, isBlock: false) { [weak self] (title, message) in
            guard let self = self else { return }
            self.presentAlert(title, message, nil)
            self.reloadData()
        }
    }
    
    func acceptUser(connection: UserConnection) {
        print("Do nothing")
    }
    
    func declineUser(connection: UserConnection) {
        print("Do nothing")
    }
    
    func cancelRequest(connection: UserConnection) {
        print("Do nothing")
    }
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        print("Do nothing")
    }
}
