////
////  RecommededVC.swift
////  EvaConnect
////
////  Created by Metis on 12/06/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import UIKit
//
//class RecommededVC: BaseVC {
//    
//    // MARK: IB Outlets
//    @IBOutlet weak var recommendedTable: UITableView!
//    @IBOutlet weak var searchField: UITextField!
//    @IBOutlet weak var noRecordLbl: UILabel!
//    @IBOutlet weak var viewingAllRecommended: UILabel!
//    
//    // MARK: Variables
//    var isSearching = false
//    var stopAPICall  = false
//    var dataType: DataType = .normal
//    var offSet = 0
//    var pageSize = 50
//    
//    var connections: [UserConnection] = [] {
//        didSet {
//            recommendedTable.reloadData()
//        }
//    }
//    var filterConnection: [UserConnection] = [] {
//        didSet {
//            recommendedTable.reloadData()
//        }
//    }
//    
//    // MARK: Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setLayOut()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        searchField.text = ""
//        getAllRecommendation()
//        recommendedTable.tableFooterView = UIView()
//    }
//    
//    @IBAction func back_touchUpInside(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//extension RecommededVC {
//    
//        func setLayOut() {
//        recommendedTable.delegate = self
//        recommendedTable.dataSource = self
//        (viewingAllRecommended as? HeadingTwoBold)?.textColor = .black
//        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        let refreshControl = UIRefreshControl()
//        recommendedTable.refreshControl = refreshControl
//        recommendedTable.refreshControl?.beginRefreshing()
//        recommendedTable.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
//        recommendedTable.tableFooterView = UIView()
//        recommendedTable.registerCell(withType: ConnectionCell.self)
//        
//    }
//}
//
//extension RecommededVC: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataType == .normal ? connections.count : filterConnection.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
//        cell.connect.tag = indexPath.row
//        cell.accept.tag = indexPath.row
//        cell.decline.tag = indexPath.row
//        cell.delegate = self
////        cell.connection  = dataType == .normal ? connections[indexPath.row] : filterConnection[indexPath.row]
//        cell.accept.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
//        cell.decline.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if isSearching {
//            if indexPath.row + 1 == filterConnection.count && !stopAPICall {
//                offSet = filterConnection.count
//                searchRecommedation()
//            }
//        } else {
//            if indexPath.row + 1 == connections.count && !stopAPICall {
//                offSet = connections.count
//                getAllRecommendation()
//            }
//        }
//    }
//}
//extension RecommededVC: UITextFieldDelegate {
//    
//    //MARK: TextField Delegates
//    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool {
//        self.view.isUserInteractionEnabled = true
//        return true
//    }
//    
//    @objc func textFieldDidChange(_ textfield: UITextField) {
//        if textfield.text!.count > 0 {
//            dataType = .search
//            isSearching = true
//            searchRecommedation()
//        } else {
//            dataType = .normal
//            isSearching = false
//            noRecordLbl.isHidden = true
//            recommendedTable.isHidden = false
//            getAllRecommendation()
//        }
//    }
//}
//
//extension RecommededVC {
//    
//    private func addConnection(receiverId: Int , index: Int) {
//        
//        let parameters: AFParameters = [ "receiver_id": receiverId,
//                                         "sender_id": LoggedUserDetails.shared.user?.id ?? 0,
//                                         "status": "pending" ]
//        
//        showActivity()
//        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { (response) in
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                
//                let jsonDecoder = JSONDecoder()
//                
//                do {
//                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
//                    if !genericRoot.error {
//
//                        self.makeAlert2(messageData: "Connection Request Send")
//                        print(genericRoot.message)
//                    }
//                } catch {
//                    self.presentAlert("Error", nil, response.error)
//                }
//            }
//        }
//    }
//    
//    private func updateConnection(id: Int, declined: Bool = false) {
//        
//        showActivity()
//        updateConnection(id: id, declined: declined) { (updated, error) in
//            
//            self.hideActivity()
//            if let _ = updated {
//                
//                self.presentAlertWithAction(title: "Success", message: "Connection Updated") {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                
//                if let error = error {
//                    self.presentAlert("Failure", nil, error)
//
//                }
//            }
//        }
//    }
//
//    func getAllRecommendation() {
//        let endPoint = String(format: "?limit=%d&offset=%d", pageSize, offSet)
//        getRecommendedConnections(pagination: endPoint) { (userConnection, error) in
//            self.recommendedTable.refreshControl?.endRefreshing()
//            if let recommended = userConnection {
//                if recommended.count > 0 {
//                    self.connections.removeAll()
//                    self.connections.append(contentsOf: recommended)
//                }
//                else {
//                    self.stopAPICall = true
//                }
//            }
//            if let errors = error {
//                self.presentAlert("Failure", nil, errors)
//            }
//        }
//    }
//    
//    func searchRecommedation() {
//        guard let searchText = searchField.text, searchText.count > 0 else {
//            dataType = .normal
//            isSearching = false
//            recommendedTable.reloadData()
//            return
//        }
//        
//        let parameters: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id ?? 0,
//                                        "first_name": searchText]
//        
//        getRecommendedConnections(parameter: parameters) { (recommendedConnection, error) in
//            self.recommendedTable.refreshControl?.endRefreshing()
//            if let recommended = recommendedConnection {
//                if  recommended.count > 0 {
//                    self.noRecordLbl.isHidden = true
//                    self.recommendedTable.isHidden = false
//                    self.filterConnection = recommended
//                } else {
//                    self.noRecordLbl.isHidden = false
//                    self.recommendedTable.isHidden = true
//                    self.noRecordLbl.text = "No Record Found"
//                }
//            }
//            if let errors = error {
//                self.presentAlert("Failure", nil, errors)
//            }
//        }
//    }
//    
//    func getRecommendedConnections(pagination: String? = nil,
//                           parameter: AFParameters? = nil,
//                           completional: @escaping ([UserConnection]?, Error?) ->()) {
//        
//        var endPoints = EndPoints.getRecommendedConnections
//        var parameters: AFParameters = ["user_id": LoggedUserDetails.shared.user!.id ?? 0]
//        if let param = parameter {
//            parameters = param
//        }
//        if let page = pagination {
//            endPoints += page
//        }
//        
//        NetworkManagerr.request(endPoints, method: .post, parameters: parameters) { (response) in
//            self.recommendedTable.refreshControl?.endRefreshing()
//            if response.result.isSuccess {
//                let decode = JSONDecoder()
//                do {
//                    let recommendedRoot = try decode.decode(ConnectionFilterModel.self, from: response.data!)
//                    if !recommendedRoot.error && recommendedRoot.data.count > 0 {
//                        completional(recommendedRoot.data, nil)
//                    }
//                    else if recommendedRoot.data.count == 0{
//                        completional(recommendedRoot.data, nil)
//                    }
//                }
//                catch {
//                    completional(nil, error)
//                }
//            }
//        }
//    }
//}
//
//extension RecommededVC: SelectionCellActionable {
//    
//    @objc func reloadData() {
//        connections.removeAll()
//        offSet = 0
//        getAllRecommendation()
//    }
//    
//    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
//        if isSearching {
//            if filterConnection[sender.tag].isConnected == .notConnected {
//                addConnection(receiverId: filterConnection[sender.tag].id ?? 0, index: sender.tag)
//            }
//        } else {
//            if connections[sender.tag].isConnected == .notConnected {
//                addConnection(receiverId: connections[sender.tag].id ?? 0, index: sender.tag)
//            }
//        }
//    }
//    
//    @objc func updateConnectionFunction(sender: UIButton) {
//
//        let decline: Bool!
//        if isSearching {
//            if filterConnection[sender.tag].isConnected == .pending && filterConnection[sender.tag].isReceiver == "true" {
//                decline = sender.titleLabel!.text == "Accept" ? false : true
//                updateConnection(id: filterConnection[sender.tag].connectionID!, declined: decline)
//            }
//        } else {
//            if connections[sender.tag].isConnected == .pending && connections[sender.tag].isReceiver == "true" {
//                decline = sender.titleLabel!.text == "Accept" ? false : true
//                updateConnection(id:  connections[sender.tag].connectionID!, declined: decline)
//            }
//        }
//        
//        sender.isUserInteractionEnabled = true
//    }
//    
//    @objc func openProfileVC(gesture: UIGestureRecognizer) {
//        let tapImageView = gesture.view as! UIImageView
//        if connections.count != 0 {
//            let bindModelData =  connections[tapImageView.tag]
//            let profile = StoryboardRouter.profile()
//            profile.userId = bindModelData.id
//            self.navigationController?.pushViewController(profile, animated: true)
//        }
//    }
//}
