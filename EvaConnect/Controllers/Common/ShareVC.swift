//
//  ShareVC.swift
//  EvaConnect
//
//  Created by usama on 18/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ShareVC: UIViewController {

    var shareView: ShareView!
    var dismissGesture: UITapGestureRecognizer!
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var mainUiView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var copyLinkBtn: UIButton!
    @IBOutlet weak var whatsAppBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    
    var objectId: Int = 0
    var type: TypePostEnum = .post
    var inSearchMode = false
    var offSet = 0
    var pageSize = 50
    var selectedIndex = 0
    
    var stopAPICall = false
    var completion: (() -> ())? = nil
    
    var sharedLinks = ""
    var copiedLink = ""
    var whatsappLink = ""
    var facebookLink = ""
        
    let application = UIApplication.shared
    var subIndexPathCustom: IndexPath? = nil
    var connectionUsers: [UserConnection] = [] {
        didSet {
            shareTableView.reloadData()
        }
    }
    
    var filteredUsers: [UserConnection] = []
    
    
    override func viewDidLoad() {
        initUI()
        super.viewDidLoad()
//        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initUI()
        getAllConnection()
//        createShareView()
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        shareConnection()
    }
    
    @IBAction func copyLinkTapped(_ sender: UIButton) {
        //sharedLinks = "https://aviationconnect.com/\(type)/\(objectId)"
        if self.copiedLink == "" {
            self.presentAlert("Alert","data is not available.")
            return
        }
        UIPasteboard.general.string = self.copiedLink
        showToastWithLogo(message: "Link Copied")
    }
    
    @IBAction func whatsAppTapped(_ sender: UIButton) {
        //sharedLinks = "https://aviationconnect.com/\(type)/\(objectId)"
        if self.whatsappLink == "" {
            self.presentAlert("Alert","data is not available.")
            return
        }
        let urlString = "https://api.whatsapp.com/send?text=Hey check this out \(self.whatsappLink)"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let URL = NSURL(string: urlStringEncoded!)
        if UIApplication.shared.canOpenURL(URL! as URL){
            print("Opening whatsapp")
            UIApplication.shared.open(URL! as URL, options: [:]){ status in
                print("Opened a Whatsapp chat")
            }
        } else {
            let webURL = NSURL(string: "https://facebook.com")!
            application.open(webURL as URL)
        }
        
        //MARK: Code for openning particular chat in whatsapp
        
//        let phoneNumber =  "+917359836183" // you need to change this number
//            let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=hi")!
//            if UIApplication.shared.canOpenURL(appURL) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
//                }
//                else {
//                    UIApplication.shared.openURL(appURL)
//                }
//            }
    }
    
    @IBAction func facebookTapped(_ sender: UIButton) {
        //sharedLinks = "https://aviationconnect.com/\(type)/\(objectId)"
        
        if self.facebookLink == "" {
            self.presentAlert("Alert","data is not available.")
            return
        }
        
        let urlStr = String(format: "fb-messenger://share/?link=%@", facebookLink)
        let url  = NSURL(string: urlStr)

        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                if success {
                    print("Messenger accessed successfully")
                } else {
                    print("Error accessing Messenger")
                }
            }
        } else {
            let webURL = URL(string: "https://facebook.com")!
            application.open(webURL)
        }
    }
    
    @IBAction func smsTapped(_ sender: UIButton) {
        sharedLinks = "https://aviationconnect.com/\(type)/\(objectId)"
        let sms = "sms:&body=Hey check this out \(sharedLinks)"
        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let inviteConnections = segue.destination as? InviteConnectionVC, let (id, type) = sender as? (Int, TypePostEnum) {
//            inviteConnections.objectID = id
//            inviteConnections.type = type
//        }
//    }
    
    func initUI() {
        popupView(uiView: mainUiView)
        shareTableView.delegate = self
        shareTableView.dataSource = self
        self.shareTableView.separatorColor = UIColor.clear
//        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
//        dismissGesture.delegate = self
//        view.addGestureRecognizer(dismissGesture)
    }
    
//    func createShareView() {
//
//        shareView = .fromNib()
//        view.addSubview(shareView)
//        shareView.layer.borderColor = AppColors.border.cgColor
//        shareView.layer.borderWidth = 1.0
//        shareView.withConstraints { (sView) -> [NSLayoutConstraint] in
//            return [ sView.alignTop(view.layoutMarginsGuide, constant: 72.0),
//                     sView.alignLeft(view.layoutMarginsGuide, constant: 25.0),
//                     sView.alignTrailing(view.layoutMarginsGuide, constant: -25)
//            ]
//        }
//
//        shareView.actionBlock = { (selectedButton: ShareViewAction) in
//            self.shareViewAction(shareAction: selectedButton)
//        }
//    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

private extension ShareVC {
    
    func getAllConnection() {
        self.connectionUsers = []
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
        
        var parameterss: AFParameters  = ["user_id": myUserDefaults.userId, "connection_status": "active"]
        
        if let parameters = parameters {
            parameterss = parameters
        }
        
        var endPoint = EndPoints.getFilterConnection
        
        if let pagination = pagination {
            endPoint += pagination
        }
        
        NetworkManagerr.request(endPoint, method: .post, parameters: parameterss) { (response) in
            
            self.shareTableView.refreshControl?.endRefreshing()
            
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
    
    
        
    func shareConnection() {
        
//        if let user = LoggedUserDetails.shared.user {
//            let selectedUsers = connectionUsers.filter { $0.isSelected }
//            let selectedUserIds = selectedUsers.map { $0.id }
        var selectedUserIds: [Int] = []
        for user in connectionUsers {
            if user.isSelected {
                if let id = user.id {
                    selectedUserIds.append(id)
                }
            } else {
                print("Not Selected")
            }
        }
        
        if selectedUserIds.count == 0 {
            self.presentAlert("Alert","Please choose at least one user")
            return
        }
        
            var parameters = [ "user_id":  myUserDefaults.userId,
                               "share_user_id": selectedUserIds] as [String : Any]
            var endPoint = ""
            if type == .post {
                parameters["post_id"] = objectId
                endPoint = EndPoints.dashboardSharePost
            } else if type == .event {
                parameters["id"] = objectId
                endPoint = EndPoints.eventShare
            } else if type == .news {
                parameters["rss_news_id"] = objectId
                endPoint = EndPoints.dashboardShareNews
            } else if type == .job {
                parameters["job_id"] = objectId
                endPoint = EndPoints.shareJob
            } else if type == .meet {
                parameters["id"] = objectId
                endPoint = EndPoints.shareMeet
            }
            
            showActivity()
            NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                if response.result.isSuccess {
                    
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try! jsonDecoder.decode(ShareDataModel.self, from:response.data!)
                    
                    if !(genericResponse.error ?? false) {
                        
                        self.copiedLink = genericResponse.data?.copyLink ?? ""
                        self.whatsappLink = genericResponse.data?.whatsappLink ?? ""
                        self.facebookLink = genericResponse.data?.facebookLink ?? ""
                        
                        self.connectionUsers.enumerated().forEach { index, user in
                            self.connectionUsers[index].isSelected = false
                            if selectedUserIds.count == 0 {
                                print("Fetch Share Link....")
                            } else {
                                self.presentAlert("Alert", "Successfully shared with desired connection"){
                                    self.dismiss(animated: true)
                                    self.completion?()
                                }
                            }
                        }
                    }
                }
                
            }
//        }
        
    }
    
//    func shareViewAction(shareAction: ShareViewAction) {
//
//        switch shareAction {
//        case .connection:
//
//            let inviteConnections = StoryboardRouter.inviteConnections()
//            inviteConnections.objectID = self.objectId
//            inviteConnections.type = self.type
//
//            self.presentingViewController?.show(inviteConnections, sender: nil)
//            dismiss(animated: true, completion: nil)
//
//        default:
//            break
//            //            handleWhatsup(shareValue: "eva://\(type!)/\(objectId!)")
//        }
//    }
}

extension ShareVC : SelectionCellActionable {
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
        filteredUsers = connectionUsers.filter({ $0.firstName?.lowercased().range(of: searchText) != nil })
        if filteredUsers.count > 0 {
            shareTableView.reloadData()
        } else {
            self.presentAlert("Alert", "Connection not found", nil)
        }
    }
}

extension ShareVC {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let lower = searchTF.text!.lowercased()
        searchAlgorithm(searchText: lower)
    }
    
}

extension ShareVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: shareView) == true {
            return false
        }
        return true
    }
}

extension ShareVC: UITableViewDataSource, UITableViewDelegate {
    
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if inSearchMode {
//            if indexPath.row + 1 == filteredConnections.count {
//
//                if !stopAPICall {
//                    offSet = filteredConnections.count
//                    searchConnections()
//                }
//            }
//        } else {
//            if indexPath.row + 1 == connections.count {
//
//                if !stopAPICall {
//                    offSet = connections.count
//                    getAllConnection()
//                }
//            }
//        }
//
//    }

    
}
