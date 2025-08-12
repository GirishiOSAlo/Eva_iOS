//
//  ConnectionVC.swift
//  EvaConnect
//
//  Created by Metis on 16/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum DataType {
    case normal, search
}

class ConnectionVC: BaseVC {
    
    //MARK: Outlets
    @IBOutlet weak var navBarTitle: HeadingLabel!
    @IBOutlet weak var searchFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var speratorView: UIStackView!
    @IBOutlet weak var buttonBaseView: UIView!
    @IBOutlet weak var buttonBaseViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var searchFieldView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBaseVwHeight: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var recommended: UILabel!
    @IBOutlet weak var seeALL: UIButton!
//    @IBOutlet weak var requestStackView: UIStackView!
    @IBOutlet weak var requestViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var receiveReqBtn: UIButton!
    @IBOutlet weak var sentReqBtn: UIButton!
    
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchBaseVw: UIView!
    var isSearch:Bool = false
    
    @IBOutlet weak var suggestedConnectionBaseVw: UIView!
    @IBOutlet weak var suggestedBaseVwHeight: NSLayoutConstraint!
    @IBOutlet weak var suggestedTblVw: UITableView!
    
    //MARK: Variables
    var inSearchMode = false
    var offSet = 0
    var pageSize = 50
    var selectedIndex = 0
    var selectedSubIndex = 0
    var isChatEnable = true
        
    var subIndexPathCustom: IndexPath? = nil
    var connections: [UserConnection] = [] {
        didSet {
            let count = connections.count
            print("Connections Count :: \(count)")
            self.tableBaseVwHeight.constant = (CGFloat(count) * 80.0) + 20.0
            print("tableHeight :: \(self.tableBaseVwHeight.constant)")
            tableView.reloadData()
            self.noRecordLbl.isHidden = count == 0
        }
    }
    
    var recommandedConnection: [UserConnection] = []
    var filteredConnections: [UserConnection] = [] {
        didSet {
            let count = filteredConnections.count
            print("Connections Count :: \(count)")
            self.tableBaseVwHeight.constant = (CGFloat(count) * 80.0) + 20.0
            print("tableHeight :: \(self.tableBaseVwHeight.constant)")
            tableView.reloadData()
        }
    }
    
    var suggestedConnectionList: [SuggestedConnection] = [] {
        didSet {
            suggestedTblVw.reloadData()
        }
    }

    
    private var dataType: DataType = .normal
    private var connectionType: EvaConnectionType = .followers
    private var requestType: EvaRequestType = .received
    var stopAPICall = false
    
    var isGlobalSearch: Bool = false {
        didSet {
            if isGlobalSearch {
                searchFieldHeight.constant = 0
                searchFieldView.isHidden = true
                speratorView.isHidden = true
                buttonBaseView.isHidden = true
//                buttonBaseViewHeight.constant = 0
            }
        }
    }
    
    var globalSearchQuery = (query: "", filter: "") {
        didSet {
            performGlobalSearch()
        }
    }
    
    private var searchTimer: Timer? = nil
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConnectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getSettings()
        searchField.text = ""
//        noRecordLbl.text = ""
        didSelectedFilter(at: 0)
        connectionType = .followers
        isGlobalSearch ? performGlobalSearch() : reloadData()
        tableView.tableFooterView = UIView()
    }
    
    func setupUI() {
        self.noRecordLbl.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.isSeparatorHidden = true
        self.navBarTitle.text = isIndivisualUser ? "My Connections" : "My Followers"
        self.buttonBaseView.layer.cornerRadius = 8
        self.searchMainView.isHidden = true
//        self.requestStackView.isHidden = true
        self.requestViewHeightConst.constant = 0
        
        self.suggestedBaseVwHeight.constant = 0.0

        self.searchBaseVw.layer.cornerRadius = 8
        self.searchBaseVw.layer.borderColor = UIColor(hex: "#837A88").cgColor
        self.searchBaseVw.layer.borderWidth = 1
    }
    
//    @IBAction func seeAll_touchUpInside(_ sender: UIButton) {
//        
//        let recommendedVC = StoryboardRouter.recommendedVC()
//        self.navigationController?.pushViewController(recommendedVC, animated: true)
//    }
    
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        didSelectedFilter(at: sender.tag)
        connections.removeAll()
//        tableView.refreshControl?.beginRefreshing()
        connectionType =  EvaConnectionType(rawValue: sender.tag)!
//        noRecordLbl.text = ""
        
        tableView.isHidden = false
        inSearchMode = false
        dataType = .normal
        searchField.text = ""
        filteredConnections.removeAll()
        connections.removeAll()
        tableView.reloadData()
        
        self.suggestedBaseVwHeight.constant = 0.0
                
        switch connectionType {
        case .followers:
            getAllConnection(offSet: 1)
        case .pending:
            requestBtnTapped(receiveReqBtn)
        case .blocked:
//            getPendingBlockConnection()
            break
        }
        
        if LoggedUserDetails.shared.user?.type == userType.company.rawValue {
            searchField.placeholder = " Search \(sender.title(for: .normal) ?? "")\(connectionType == .blocked ? " User" : "")"
        } else {
            searchField.placeholder = "Search for a Connection"
        }
    }
    
    @IBAction func requestBtnTapped(_ sender: UIButton) {
        self.noRecordLbl.isHidden = true
        connections.removeAll()
        selectedSubIndex = sender.tag
        if selectedSubIndex == 0 {
            requestType = .received
            fetchPendingSentRequests()
            
            suggestedBaseVwHeight.constant = 0.0
            selectedTab(for: receiveReqBtn)
            unSelectedTab(for: sentReqBtn)
        } else {
            requestType = .sent
            fetchPendingSentRequests()
            fetchSuggestedConnectionData()
            self.suggestedBaseVwHeight.constant = (CGFloat(suggestedConnectionList.count) * 80.0) + 50.0
            selectedTab(for: sentReqBtn)
            unSelectedTab(for: receiveReqBtn)
        }
//        tableView.reloadData()
    }

    
    
    
    private func didSelectedFilter(at index: Int) {
        for i in 0...1 {
            let selectedFilter = index == i
//            filterButtons[i].tintColor = selectedFilter ? Constants.AppColorLiteral.selectedColor : Constants.AppColorLiteral.unSelectedColor
//            filterButtons[i].isUserInteractionEnabled = !selectedFilter

            let selectedBGColor = UIColor(hex: "#4D76CD", alpha: 0.2)
            let selectedColor = UIColor(hex: "#4D76CD")
            let unSelectedBGColor = UIColor.clear
            let unSelectedColor = UIColor(hex: "#707070")

            filterButtons[i].layer.cornerRadius = 8
            filterButtons[i].backgroundColor = selectedFilter ? selectedBGColor : unSelectedBGColor
            filterButtons[i].setTitleColor(selectedFilter ? selectedColor : unSelectedColor, for: .normal)
            filterButtons[i].isUserInteractionEnabled = !selectedFilter

//            self.requestStackView.isHidden = index == 1 ? false : true
            
        }
        if index == 1 {
            selectedTab(for: receiveReqBtn)
            unSelectedTab(for: sentReqBtn)
        }
        self.requestViewHeightConst.constant = index == 1 ? 24 : 0
        self.selectedIndex = index
    }
    
    func selectedTab(for button: UIButton){
        button.layer.cornerRadius = 12
        button.layer.borderColor = AppColors.appBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(AppColors.appBlue, for: .normal)
    }
    
    func unSelectedTab(for button: UIButton){
        button.layer.cornerRadius = 12
        button.layer.borderColor = AppColors.border.withAlphaComponent(0.2).cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(AppColors.border, for: .normal)
    }
    
    @IBAction func onBackBtnTapped(_ sender: UIButton) {
        if self.isSearch {
            self.isSearch = false
            self.searchMainView.isHidden = true
        } else {
            print("Back Btn Tapped...")
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    @IBAction func onSearchBtnTapped(_ sender: UIButton) {
        self.isSearch = true
        self.searchMainView.isHidden = false
    }
}
extension ConnectionVC {
    
    func setConnectionLayout() {
        
        tableView.delegate = self
        tableView.dataSource = self
        suggestedTblVw.delegate = self
        suggestedTblVw.dataSource = self
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        (recommended as? HeadingTwoBold)?.textColor = .black
        seeALL.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 10)
        seeALL.titleLabel?.textColor = AppColors.lightBg
//        let refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
//        tableView.refreshControl?.beginRefreshing()
//        tableView.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        collectionView.registerNib(cellNib: RecommandConnection.self)
        tableView.registerCell(withType: ConnectionCell.self)
        suggestedTblVw.registerCell(withType: ConnectionCell.self)
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        searchFieldView.applyShadow()
        
        if LoggedUserDetails.shared.user?.type == userType.company.rawValue {
            filterButtons[0].setTitle("Followers", for: .normal)
//            filterButtons[1].isHidden = true
            searchField.placeholder = "Search Followers"
        }
        
        // getRecommendedConnnections()
        
    }
    
    @objc func addFriend(_ Sender: UIButton) {
        let obj = suggestedConnectionList[Sender.tag]
        let id = obj.id ?? 0
        addConnection(receiverId: id) {
            self.showToast(message: "Request Sent!!")
        }
    }
}

extension ConnectionVC: UICollectionViewDataSource {
    
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recommandedConnection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandConnection.ReuseId, for: indexPath) as? RecommandConnection {
            //DataBinding
            let bindData = recommandedConnection[indexPath.row]
            cell.nameLbl.text = "\(bindData.firstName ?? "") \(bindData.lastName ?? "")"
            if bindData.isLinkedin == 0 {
                if  bindData.userImage != nil {
                    cell.userAvatar.sd_setImage(with: URL(string: bindData.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
                } else {
                    cell.userAvatar.image = #imageLiteral(resourceName: "noImage")
                }
            } else {
                if bindData.linkedinImageURL != nil {
                    cell.userAvatar.sd_setImage(with: URL(string: bindData.linkedinImageURL!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
                }
                    
                else {
                    cell.userAvatar.image = #imageLiteral(resourceName: "noImage")
                }
            }
            cell.occupationLbl.text = "\(bindData.designation ?? "No Designation")"
            cell.companyLbl.text = "at \(bindData.companyName ?? "No Company")"
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ConnectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset: CGFloat = 3
        let width = collectionView.frame.width * 0.32
        let height = collectionView.frame.height - 5
        return CGSize(width: width - inset, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ConnectionVC: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataType == .normal ? connections.count : filteredConnections.count
////        return 10
        
        if tableView == self.suggestedTblVw {
            return suggestedConnectionList.count
        } else {
            if dataType == .normal {
                return connections.count
            } else {
                return filteredConnections.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.suggestedTblVw {
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
            
            let obj = suggestedConnectionList[indexPath.row]
            cell.userName.text = obj.firstName

            cell.userDesignation.text = obj.companyName

            if !obj.userImage.isNil {
                cell.userImage.sd_setImage(with: URL(string: obj.userImage!), placeholderImage: #imageLiteral(resourceName: "default_profile"), options: .continueInBackground, completed: .none)
            }
            cell.addFriendBtn.tag = indexPath.row
            cell.addFriendBtn.addTarget(self, action: #selector(addFriend(_:)), for: .touchUpInside)
            cell.blockedView.isHidden = true
            cell.connectedView.isHidden = true
            cell.pendingView.isHidden = true
            cell.sentReqView.isHidden = true
            cell.addFriendView.isHidden = false
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
            cell.connectionType = connectionType
            cell.requestType = requestType
            cell.connect.tag = indexPath.row
            cell.accept.tag = indexPath.row
            cell.decline.tag = indexPath.row
            cell.delegate = self
            cell.connectionDelegate = self
            cell.connection = dataType == .normal ? connections[indexPath.row] : filteredConnections[indexPath.row]
            //        cell.accept.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
            //        cell.decline.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if inSearchMode {
            if indexPath.row + 1 == filteredConnections.count {
                
                if !stopAPICall {
                    offSet = filteredConnections.count
                    searchConnections()
                }
            }
        } else {
            let count = connections.count
            if indexPath.row + 1 == count && !stopAPICall && !inSearchMode && count > 9 {
                getAllConnection(offSet: indexPath.row + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = connections[indexPath.row].id
        switch connectionType {
        case .pending:
            if requestType == .received {
                let vc = StoryboardRouter.othersProfileVC()
                vc.isFrom = 1
                vc.profileID = id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = StoryboardRouter.othersProfileVC()
                vc.isFrom = 1
                vc.profileID = id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .followers:
            let vc = StoryboardRouter.othersProfileVC()
            vc.profileID = id ?? 0
            vc.isFrom = 0
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        if connectionType != .pending { return }
        
        print("i am called")
    }
}

extension ConnectionVC: UITextFieldDelegate {
    
    //MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        if textfield.text!.count > 0 {
            //filteredConnections.removeAll()
            dataType = .search
            inSearchMode = true
            searchConnections()
        } else {
            //connections.removeAll()
            dataType = .normal
            inSearchMode = false
            noRecordLbl.isHidden = true
            tableView.isHidden = false
            reloadData()
        }
    }
}

// MARK: API Calls

private extension ConnectionVC {
    
    func addConnection(receiverId: Int, completion: @escaping () -> Void) {
        
        let id = LoggedUserDetails.shared.user?.id ?? 0
        let parameters: AFParameters = [ "receiver_id": receiverId,
                                         "sender_id": id,
                                         "status": "pending",
                                         "modified_by_id": id]
        showActivity()
        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        completion()
                    } else {
                        self.presentAlert("Error", genericRoot.message)
                    }
                } catch {
                    self.presentAlert("Error", "\(error)")
                }
            }
        }
    }
    
    private func getPendingBlockConnection() {
        offSet = 0
        ProfileManager.shared.getConnection(type: connectionType) { [weak self] connections, error, allData  in
            guard let self = self else { return }
            //            self.tableView.refreshControl?.endRefreshing()
            if let error = error {
                //                self.noRecordLbl.text = error.capitalized
                self.noRecordLbl.isHidden = false
            } else {
                self.connections = connections ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func updateConnection(id: Int, index: Int, declined: Bool) {
        
        
        showActivity()
        updateConnection(id: id, declined: declined) { (updated, error) in
            
            self.hideActivity()
            if let _ = updated {
                if self.inSearchMode {
                    self.filteredConnections[index].isConnected = declined ? "deleted" : "active"
                } else {
                    self.connections[index].isConnected = declined ? "deleted" : "active"
                }
                
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
                
            }
        }
    }
    
    func getAllConnection(offSet: Int) {
        showActivity()
        self.noRecordLbl.isHidden = true
        let endPoint = String(format: "?limit=%d&offset=\(offSet)", pageSize, offSet)
        getConnections(pagination: endPoint) { (userConnections, error) in
            self.hideActivity()
            if let connections = userConnections {
                if connections.count > 0 {
                    self.connections.append(contentsOf: connections)
                    self.noRecordLbl.isHidden = true
                } else {
                    self.noRecordLbl.isHidden = false
                    self.stopAPICall = true
                }
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    func performGlobalSearch() {
        if globalSearchQuery.query.isEmpty { return }
        //        tableView.refreshControl?.beginRefreshing()
        ProfileManager.shared.performGlobalSearch(search: globalSearchQuery.query, filter: globalSearchQuery.filter) { [weak self] connectionData, error, allData  in
            self?.applySearchData(connectionData ?? [], error, allData)
        }
    }
    
    func searchConnections() {
        
        guard let searchText = searchField.text, searchText.count > 0 else {
            dataType = .normal
            inSearchMode = false
            tableView.reloadData()
            getAllConnection(offSet: 0)
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
            self.connections.removeAll()
            self.tableView.reloadData()
            //            self.tableView.refreshControl?.beginRefreshing()
            switch self.connectionType {
            case .followers:
                ProfileManager.shared.performSearch(query: searchText, status: self.connectionType.filterStatus) { [weak self] connections, error, allData  in
                    guard let self = self else { return }
                    self.applySearchData(connections ?? [], error, [])
                }
            case .pending:
                self.SearchPendingConnection()
                break
            case .blocked:
                //                self.SearchPendingConnection()
                break
            }
            
        })
    }
    
    func applySearchData(_ connections: [UserConnection], _ error: String?, _ allData: [PendingBlockResponse]) {
        //        self.tableView.refreshControl?.endRefreshing()
        if connections.count > 0 {
            self.noRecordLbl.isHidden = true
            self.tableView.isHidden = false
            self.dataType = globalSearchQuery.query.isEmpty ? .search : .normal
            self.inSearchMode = true
            if globalSearchQuery.query.isEmpty { self.filteredConnections = connections }
            else { self.connections = connections }
        } else {
            self.noRecordLbl.isHidden = false
            self.tableView.isHidden = true
            self.noRecordLbl.text = "No Record Found"
        }
        self.tableView.reloadData()
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
            
            //            self.tableView.refreshControl?.endRefreshing()
            self.hideActivity()
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let connectionRoot = try jsonDecoder.decode(ConnectionFilterModel.self, from: response.data!)
                    print("json -> \(String(data: response.data!, encoding: .utf8) ?? "invalid json")")
                    if !connectionRoot.error  {
                        
                        completion(connectionRoot.data, nil)
                    } else {
                        self.noRecordLbl.isHidden = false
                    }
                    
                } catch {
                    print("Error:: ",error)
                    completion(nil, error)
                }
            }
        }
    }
    
    //    func getRecommendedConnnections() {
    //
    //        let pagination = String(format: "?limit=6&offset=0")
    //        let endPoints = EndPoints.getRecommendedConnections + pagination
    //        let parameters: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id]
    //
    //        NetworkManagerr.request(endPoints, method: .post, parameters: parameters) { (response) in
    //            if response.result.isSuccess {
    //                let decode = JSONDecoder()
    //                do {
    //                    let recommendedRoot = try decode.decode(ConnectionFilterModel.self, from: response.data!)
    //                    if !recommendedRoot.error && recommendedRoot.data.count > 0 {
    //
    //                        self.recommandedConnection = recommendedRoot.data
    //                        self.collectionView.reloadData()
    //
    //                    }
    //                }
    //                catch {
    //                    self.presentAlert("Failure", nil, response.error)
    //                }
    //            } else {
    //                self.presentAlert("Failure", nil, response.error)
    //            }
    //        }
    //    }
    
    func searchPending() {
        
        showActivity()
        NetworkManagerr.request(EndPoints.getSuggestedConnections) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SuggetedConnectionDataModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self.suggestedConnectionList = data
                    }
                    
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchPendingSentRequests() {
        showActivity()
        var parameterss: AFParameters  = [:]
        if requestType == .received {
            parameterss = ["filter": "received_requests"]
        } else {
            parameterss = ["filter": "sent_requests"]
        }
        
        NetworkManagerr.request(EndPoints.pendingConnections, method: .post, parameters: parameterss) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(PendingBlockFilterModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error) {
                    if newsRoot.error {
                        self.presentAlert("Error", newsRoot.message, nil)
                    } else if newsRoot.data.isEmpty {
                        self.connections = []
                        self.noRecordLbl.isHidden = false
                    } else {
                        var users : [UserConnection] = []
                        newsRoot.data.forEach({ userData in
                            if self.requestType == .received {
                                var sender = userData.sender
                                sender?.connectionID = userData.id
                                users.append(sender!)
                            } else {
                                var receiver = userData.receiver
                                receiver?.connectionID = userData.id
                                users.append(receiver!)
                            }
                        })
                        
                        self.connections = users
                        self.noRecordLbl.isHidden = true
                        if self.requestType == .sent {
                            
                        }
                        self.stopAPICall = true
                    }
                    
                } else {
                    self.presentAlert("Error", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    
    func fetchSuggestedConnectionData() {
        
        showActivity()
        NetworkManagerr.request(EndPoints.getSuggestedConnections) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SuggetedConnectionDataModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self.suggestedConnectionList = data
                        self.suggestedConnectionBaseVw.isHidden = !(self.suggestedConnectionList.count > 0)
                    }
                    
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func SearchPendingConnection() {
        showActivity()
        var parameterss: AFParameters  = [:]
        if requestType == .received {
            parameterss = ["filter": "received_requests",
                           "first_name": searchField.text!]
        } else {
            parameterss = ["filter": "sent_requests",
                           "first_name": searchField.text!]
        }
        
        NetworkManagerr.request(EndPoints.pendingConnections, method: .post, parameters: parameterss) { (response) in
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
                            if self.requestType == .received {
                                var sender = userData.sender
                                sender?.connectionID = userData.id
                                users.append(sender!)
                                
                            }else {
                                var receiver = userData.receiver
                                receiver?.connectionID = userData.id
                                users.append(receiver!)
                            }
                        })
                        
                        self.filteredConnections = users
                    }
                    
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
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
                            if self.requestType == .received {
                                var sender = userData.sender
                                sender?.connectionID = userData.id
                                users.append(sender!)
                                
                            }else {
                                var receiver = userData.receiver
                                receiver?.connectionID = userData.id
                                users.append(receiver!)
                            }
                        })
                        
                        self.filteredConnections = users
                        self.stopAPICall = true
                    }
                    
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    
    func callCancelrequest(id: Int) {
        let params: AFParameters  = ["user_id": id]
        showActivity()
        NetworkManagerr.request(EndPoints.cancelRequest, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let Root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                self.hideActivity()
                if !(Root.error) {
                    self.presentAlert("Success", Root.message, nil)
                    
                } else {
                    self.presentAlert("Failure", Root.message, nil)
                }
            } catch {
                print("Error: \(error)")
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

extension ConnectionVC: SelectionCellActionable {
    
    //MARK: Custom Methods
    @objc func reloadData() {
        tableView.isHidden = false
        inSearchMode = false
        dataType = .normal
        connections.removeAll()
        getAllConnection(offSet: 0)
//        connectionType == .followers ? getAllConnection(offSet: 0) : getPendingBlockConnection()
    }
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        
        if inSearchMode {
//            if filteredConnections[sender.tag].isConnected == .notConnected {
//                addConnection(receiverId: filteredConnections[sender.tag].id, index: sender.tag) {
//                    completion()
//                }
//            }
        } else {
//            if connections[sender.tag].isConnected == .notConnected {
//                addConnection(receiverId: connections[sender.tag].id, index: sender.tag) {
//                    completion()
//                }
//            }
        }
    }
    
    private func openProfileVC(connection: UserConnection) {
        let profile = StoryboardRouter.newProfile()
        profile.userId = connection.connectionID ?? connection.id
        profile.isConnected = true
        navigationController?.pushViewController(profile, animated: true)
    }
}

extension ConnectionVC: ConnectionCellDelegate {

    func sendBtn(connection: UserConnection) {
        //send btn from connection cell btn action...
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.user = connection
            //        chatVC.conversation = conversation
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
    func didViewProfile(connection: UserConnection) {
        if connectionType == .followers {
            let profile = StoryboardRouter.newProfile()
            profile.userId = connection.id
            profile.isConnected = true
            navigationController?.pushViewController(profile, animated: true)
        } 
//        else if connectionType == .blocked {
//            ProfileManager.shared.blockConnection(id: connection.id ?? 0, isBlock: false) { [weak self] (title, message) in
//                guard let self = self else { return }
//                self.presentAlert(title, message, nil)
//                self.reloadData()
//            }
//        }
    }
    
    func acceptUser(connection: UserConnection) {
        guard let connectionId = connection.id else { return }
//        ProfileManager.shared.updateConnection(id: connectionId) { [weak self] title, message in
//            guard let self = self else { return }
//            self.presentAlert(title, message, nil)
//            self.reloadData()
//        }
        ProfileManager.shared.updateConnection(id: connectionId) { [weak self] title, message in
            guard let self = self else { return }
            self.presentAlert(title, message, nil) {
                self.fetchPendingSentRequests()
            }
        }
    }
    
    func declineUser(connection: UserConnection) {
        guard let connectionId = connection.id else { return }
//        ProfileManager.shared.deleteConnection(id: connectionId) { [weak self] title, message in
//            guard let self = self else { return }
//            self.presentAlert(title, message, nil)
//            self.reloadData()
//        }
        ProfileManager.shared.deleteConnection(id: connectionId) { [weak self] title, message in
            guard let self = self else { return }
            self.presentAlert(title, message, nil) {
                self.fetchPendingSentRequests()
            }
        }
    }
    
    func cancelRequest(connection: UserConnection) {
        let connectionId = connection.id ?? 0
        callCancelrequest(id: connectionId)
    }
    
}
