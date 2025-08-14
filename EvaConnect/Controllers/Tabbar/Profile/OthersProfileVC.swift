//
//  OthersProfileVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 14/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
import AVKit

class OthersProfileVC: UIViewController {

    @IBOutlet weak var profileLoadingView: UIView!
//    @IBOutlet weak var tableViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollViewTopConst: NSLayoutConstraint!
//    @IBOutlet weak var followerCountLbl: UILabel!
//    @IBOutlet weak var followerTitleLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var professionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var followerTextLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingTextLabel: UILabel!
    //    @IBOutlet weak var connectedView: UIView!
    @IBOutlet weak var followBtnView: UIView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var unfollowBtnView: UIView!
    @IBOutlet weak var unfollowBtn: UIButton!
    @IBOutlet weak var unblockBtnView: UIView!
    @IBOutlet weak var unblockBtn: UIButton!
    @IBOutlet weak var aacceptDeclineBtnView: UIView!
    //    @IBOutlet weak var sendMsgCnct: UIButton!
//    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var scheduleMeetingBtnView: UIView!
    @IBOutlet weak var scheduleMeetingBtn: UIButton!
    @IBOutlet weak var scheduleMeetingBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var sendRequestBtnView: UIView!
    @IBOutlet weak var sendRequestBtn: UIButton!
    @IBOutlet weak var sentRequestBtnView: UIView!
    @IBOutlet weak var sentRequestBtn: UIButton!
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var downloadResumeBtn: UIButton!
    
    @IBOutlet weak var sendMsgPend: UIButton!
//    @IBOutlet weak var moreOptionBtn: UIButton!
    @IBOutlet weak var aboutLabelTextlabel: UILabel!
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteToFollowBtn: UIButton!
    @IBOutlet weak var inviteMsgBtn: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
//    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileMainVw: UIView!
    @IBOutlet weak var bioMainView: UIView!
//    @IBOutlet weak var bioViewHeight: NSLayoutConstraint!
    
//    @IBOutlet weak var onlineStatusDotView: UIView!
//    @IBOutlet weak var onlineStatusLbl: UILabel!
    
    @IBOutlet weak var ViewPostLbl: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var privateAccView: UIView!
    @IBOutlet weak var postTVHeight: NSLayoutConstraint!
    @IBOutlet weak var bioViewHeight: NSLayoutConstraint!
    
//    var isConnected = true
    var Is_Reaction: Bool = false
    var isFrom = 0
    var profileID = 0
    let pageSize = 10
    var isFollowed = false
    var status = ""
    var isChatEnable = true
    var eventID = 0
    var userDetails: UserDetailsData?
    var isComeFromDelegate = false
    var otherUserID = 0
    var eventDetail: NewEventDetailsData?
    
    var posts: [DashboardItem] = [] {
        didSet {
            self.postTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        

//        getPosts(offSet: 1)
//        fetchUserDetail(userId: profileID) { (user, error) in
//            if let user = user {
//                self.setUI(for: user)
//            }
//            
//            if let error = error {
//                self.presentAlert("Failure", nil, error)
//            }
//        }
//        postTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        getSettings()
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if(keyPath == "contentSize"){
//            self.postTVHeight.constant = self.postTableView.contentSize.height
//        }
//    }
    
    func setupUI(){
        
//        switch isFrom {
//        case 0: //Connected
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            inviteView.isHidden = true
//        case 1: //pending
//            pendingView.isHidden = false
//            connectedView.isHidden = true
//            inviteView.isHidden = true
//        case 2: //invite to follow
//            inviteView.isHidden = false
//            connectedView.isHidden = true
//            pendingView.isHidden = true
//        default:
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            inviteView.isHidden = true
//        }
        self.postTVHeight.constant = 0.0
        
        fetchUserDetailsData()
        getPosts(offSet: 1)
        privateAccView.isHidden = true
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        
        self.profileMainVw.layer.cornerRadius = 13
        self.bioMainView.layer.cornerRadius = 13
        
        self.followBtn.layer.cornerRadius = 13
        self.unfollowBtn.layer.cornerRadius = 13
        self.unblockBtn.layer.cornerRadius = 13
        self.acceptBtn.layer.cornerRadius = 13
        self.declineBtn.layer.cornerRadius = 13
        self.scheduleMeetingBtn.layer.cornerRadius = 13
        self.sendRequestBtn.layer.cornerRadius = 13
        self.sentRequestBtn.layer.cornerRadius = 13
        
        
        self.inviteToFollowBtn.layer.cornerRadius = 13
//        self.sendMsgCnct.layer.cornerRadius = sendMsgCnct.layer.bounds.width/2
//        self.sendMsgPend.layer.cornerRadius = sendMsgPend.layer.bounds.width/2
        self.inviteMsgBtn.layer.cornerRadius = inviteMsgBtn.layer.bounds.width/2
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        
        self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2
        self.profileView.layer.borderWidth = 1
        self.profileView.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        
//        self.onlineStatusDotView.layer.cornerRadius = self.onlineStatusDotView.frame.size.height/2
//        self.onlineStatusDotView.backgroundColor = UIColor(hex: "#30BF04")
//        self.onlineStatusLbl.text = "Online"
//        self.onlineStatusLbl.textColor = UIColor(hex: "#30BF04")

//        self.postTableView.registerCells(withTypes: [ReactionTableViewCell.self])
        self.postTableView.registerCells(withTypes: [HomeText.self, HomeImage.self, HomeVideo.self, HomeNewz.self, ReactionTableViewCell.self, HomeUrl.self])
    }
    
    
    func setUI(for user: OtherUserData?) {
        self.profileImageView.sd_setImage(with: URL(string: user?.userImage ?? ""))
        self.nameLbl.text = user?.firstName
        self.professionLbl.text = "\(user?.designation ?? "") | \(user?.companyName ?? "")"
//        self.onlineStatusDotView.isHidden = user?.loginStatus == "Online" ? false : true
//        self.onlineStatusLbl.text = user?.loginStatus
//        self.onlineStatusLbl.textColor = user?.loginStatus == "Online" ? UIColor(hex: "#30BF04") : UIColor.lightGray
//        self.onlineStatusDotView.backgroundColor = user?.loginStatus == "Online" ? UIColor(hex: "#30BF04") : UIColor.lightGray
//        self.connectionCountLbl.text = "\(user?.totalConnection ?? 0)"
        self.aboutLbl.text = user?.bioData
        
        status = user?.connectionStatus ?? ""
//        switch status {
//        case "Connected": //Connected
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            inviteView.isHidden = true
//            sendMsgCnct.isHidden = false
//            moreOptionBtn.isHidden = false
//            followBtn.setTitle("Unfollow", for: .normal)
////            self.isFollowed = true
//            self.ViewPostLbl.isHidden = false
//            self.bottomStackView.isHidden = false
//        case "sent request":
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            inviteView.isHidden = true
//            sendMsgCnct.isHidden = false
//            moreOptionBtn.isHidden = false
//            followBtn.setTitle("Cancel Request", for: .normal)
//            self.ViewPostLbl.isHidden = false
//            self.bottomStackView.isHidden = false
//            break
//        case "received request":
//            pendingView.isHidden = false
//            connectedView.isHidden = true
//            inviteView.isHidden = true
//            sendMsgCnct.isHidden = false
//            moreOptionBtn.isHidden = false
//            self.ViewPostLbl.isHidden = false
//            self.bottomStackView.isHidden = false
//        case "Pending": //pending
//            break
//        case "Company": //invite to follow
//            inviteView.isHidden = false
//            connectedView.isHidden = true
//            pendingView.isHidden = true
//            sendMsgCnct.isHidden = false
//            moreOptionBtn.isHidden = false
//            self.ViewPostLbl.isHidden = false
//            self.bottomStackView.isHidden = false
//        case "Blocked":
//            inviteView.isHidden = true
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            sendMsgCnct.isHidden = true
//            moreOptionBtn.isHidden = true
//            followBtn.setTitle("Unblock", for: .normal)
//            self.ViewPostLbl.isHidden = true
//            self.bottomStackView.isHidden = true
//            
//        case "NotConnected":
//            inviteView.isHidden = true
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            sendMsgCnct.isHidden = false
//            moreOptionBtn.isHidden = false
//            self.isFollowed = false
//            followBtn.setTitle("Follow", for: .normal)
//            self.ViewPostLbl.isHidden = false
//            self.bottomStackView.isHidden = false
//        default:
//            connectedView.isHidden = false
//            pendingView.isHidden = true
//            inviteView.isHidden = true
//        }
    }
    
    func setData(user: UserDetailsData) {
        self.otherUserID = user.id ?? 0
        if let imageUrl = user.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.profileImageView.image = UIImage(named: "profile")
        }
        
        nameLbl.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        
        if user.type!.elementsEqual("user") {
            professionLbl.text = "\(user.designation ?? "No Designation")"
            //self.followingLabel.text = "\(user.pendingConnection ?? "")"
            self.followingLabel.text = "\(user.following ?? 0)"
            self.downloadResumeBtn.isHidden = true
        }
        else {
            professionLbl.text = "\(user.companyName ?? "")"
            self.followingLabel.text = ""
            
            if self.eventID == 0 {
                self.downloadResumeBtn.isHidden = true
            } else {
                self.downloadResumeBtn.isHidden = false
            }
        }
        self.companyNameLbl.text = user.companyName ?? ""

        //aboutLbl.text = user.bioData ?? ""
        let content = user.bioData ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 12) ?? UIFont.systemFont(ofSize: 12.0), color: UIColor(hex: "#565656")) {
            aboutLbl.attributedText = attributed
        } else { aboutLbl.text = content }
        
        //Set bio view Height.....
        let lblHeight = self.heightForView(text: self.aboutLbl.text ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: self.view.frame.width - 72.0)
        self.bioViewHeight.constant = lblHeight + 64.0
        
        self.followerLabel.text = "\(user.followers ?? 0)"
//        self.companyId = user.companyID ?? 0
        
//        self.connectionLbl.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Followers" : "Connections"
//        self.pendingReqLabel.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Employees" : "Pending Request"
        
        
        
        
        self.followBtnView.isHidden = true
        self.unfollowBtnView.isHidden = true
        self.unblockBtnView.isHidden = true
        self.aacceptDeclineBtnView.isHidden = true
        self.sendRequestBtnView.isHidden = true
        self.sentRequestBtnView.isHidden = true
        
        if self.isComeFromDelegate {
            self.scheduleMeetingBtnWidth.constant = 110.0 //schedule meeting button show...
        } else {
            self.scheduleMeetingBtnWidth.constant = 0 //schedule meeting button hide...
        }
        
        let connectionStatus = user.connectionStatus ?? ""
        if connectionStatus == "Connected" {
            //unfollow button show...
            self.unfollowBtnView.isHidden = false
        }
        else if connectionStatus == "Request Sent" { //sent request
            //Friend request send...
            self.sentRequestBtnView.isHidden = false
        }
        else if connectionStatus == "received request" {
            //accept reject btn show...
            self.aacceptDeclineBtnView.isHidden = false
        }
        else if connectionStatus == "Block" {
            //unblock btn show...
            self.unblockBtnView.isHidden = false
        }
        else {
            if user.isPublic == 0 {
                //Send Request btn show...
                self.sendRequestBtnView.isHidden = false
            } else {
                //Follow btn show...
                self.followBtnView.isHidden = false
            }
        }
    }
    
    func setPostTableHeight() {
        var totalHeight = 0.0
        for homePost in self.posts {
            if homePost.postVideo != "" && homePost.postVideo != nil {//Video
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 356.0
                totalHeight = totalHeight + height
            } else if homePost.postDocuments?.count ?? 0 > 0 {//Document
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 231.0
                totalHeight = totalHeight + height
            } else if homePost.datumPostImage!.count > 0 {//Image
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 430.0
                totalHeight = totalHeight + height
            } else {//Text
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 195.0
                totalHeight = totalHeight + height
            }
//            if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // text cell
//                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
//                let height = lblHeight + 195.0
//                totalHeight = totalHeight + height
//            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] { //Video Cell
//                totalHeight = totalHeight + 450
//            } else if homePost.postDocument != "" && homePost.postImage == [] { //document Cell
//                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
//                let height = lblHeight + 231.0
//                totalHeight = totalHeight + height
//                
//            } else if homePost.postImage!.count > 0 { //Image Cell
//                totalHeight = totalHeight + 450
//            }
        }
        self.postTVHeight.constant = totalHeight
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreOptionTapped(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender, with: ["Block"], done: { (selectedIndex) -> () in
            
            switch selectedIndex {
            case 0:
                print("Edit")
                self.blockUser(userId: self.profileID)
                break
            default:
                break
            }
        })

    }
    

    @IBAction func followBtnTapped(_ sender: UIButton) {
        let receiverID = userDetails?.id ?? 0
        self.connectionFollowUnfollow(receiverID: receiverID, status: 2) //2= follow
    }
    
    @IBAction func unfollowBtnTapped(_ sender: UIButton) {
        let receiverID = userDetails?.id ?? 0
        self.connectionFollowUnfollow(receiverID: receiverID, status: 6) //6= unfollow
    }
    
    @IBAction func unblockBtnTapped(_ sender: UIButton) {
        self.blockUser(userId: self.profileID)
    }
    
    @IBAction func sendRequestBtnTapped(_ sender: UIButton) {
        let receiverID = userDetails?.id ?? 0
        self.connectionSendRequest(receiverID: receiverID, status: 1) //1= pending
    }
    
    @IBAction func sendMsgTapped(_ sender: UIButton) {
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = profileID
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
//    @IBAction func sendMsgPendTapped(_ sender: UIButton) {
//        if isChatEnable {
//            let chatVC = StoryboardRouter.chat()
//            chatVC.userId = profileID
//            navigationController?.pushViewController(chatVC, animated: true)
//        } else {
//            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
//        }
//    }
    
//    @IBAction func inviteToFollowTapped(_ sender: UIButton) {
//        
//    }
    
//    @IBAction func inviteMsgTapped(_ sender: UIButton) {
//        if isChatEnable {
//            let chatVC = StoryboardRouter.chat()
//            chatVC.userId = profileID
//            navigationController?.pushViewController(chatVC, animated: true)
//        } else {
//            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
//        }
//    }
    
    @IBAction func acceptBtnTapped(_ sender: UIButton) {
//        ProfileManager.shared.updateConnection(id: profileID) { [weak self] title, message in
//            guard let self = self else { return }
//            self.presentAlert(title, message, nil){
//                self.fetchUserDetail(userId: self.profileID) { (user, error) in
//                    if let user = user {
//                        self.setUI(for: user)
//                    }
//                    
//                    if let error = error {
//                        self.presentAlert("Failure", nil, error)
//                    }
//                }
//            }
//        }
        let connectionId = self.userDetails?.id ?? 0
        self.connectionAcceptReject(conectionID: connectionId, action: "accept")
    }
    
    @IBAction func declineBtnTapped(_ sender: UIButton) {
//        ProfileManager.shared.deleteConnection(id: profileID) { [weak self] title, message in
//            guard let self = self else { return }
//            self.presentAlert(title, message, nil) {
//                self.fetchUserDetail(userId: self.profileID) { (user, error) in
//                    if let user = user {
//                        self.setUI(for: user)
//                    }
//                    
//                    if let error = error {
//                        self.presentAlert("Failure", nil, error)
//                    }
//                }
//            }
//        }
        let connectionId = self.userDetails?.id ?? 0
        self.connectionAcceptReject(conectionID: connectionId, action: "reject")
    }
    
    @IBAction func onScheduleMeetingBtntapped(_ sender: UIButton) {
        let vc = MyScheduleVC.instantiate()
        vc.eventID = self.eventID
        vc.otherUserID = self.otherUserID
        vc.eventDetail = self.eventDetail
        vc.isComeFromDelegate = self.isComeFromDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Network calls
extension OthersProfileVC {
//    func fetchUserDetail(userId: Int, completion: @escaping (OtherUserData?, Error?) -> Void) {
//        
//        let url = "\(EndPoints.userDetail)/\(userId)"
//        NetworkManagerr.request(url, encoding: JSONEncoding.default) { (response) in
//            self.hideActivity(isUserInteractionEnabled: true)
//            
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let userData = try jsonDecoder.decode(OtherUserDataModel.self, from: response.data!)
//                    if !(userData.error ?? false), userData.data?.count ?? 0 > 0 {
//                        
//                        completion(userData.data?[0], nil)
//                    }
//                    
//                } catch {
//                    completion(nil, response.result.error)
//                }
//            } else {
//                completion(nil, response.result.error)
//            }
//            
//        }
//            
//    }
    
    func fetchUserDetailsData() {
        showActivity()
        let url = "\(EndPoints.userDetail)/\(self.profileID)"
        
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                self.presentAlert("Error", nil, response.error?.localizedDescription as? Error)
                return
            }

            guard let data = response.data else {
                self.presentAlert("Error", nil, "No data received." as? Error)
                return
            }

            do {
                let response = try JSONDecoder().decode(UserDetailsDataModel.self, from: data)
                if let user = response.data?.first {
                    self.userDetails = user
                    if let user = self.userDetails {
                        self.setData(user: user)
                    }
                } else {
                    self.presentAlert("Error", nil, response.message as? Error)
                }
            } catch {
                self.presentAlert("Error", nil, error)
            }
        }
    }
    
    func getPosts(offSet: Int) {
//        if stopAPICall { return }
        
        let url = "\(EndPoints.getAllHomePost)?limit=\(pageSize)&offset=\(offSet)"
        print(url)
        let param: AFParameters = ["user_id": profileID, "filter": "all_posts"] //

        NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<DashboardItemRoot>) in
            guard let self = self else { return }
//            self.stopAPICall = false
            switch result {
            case .success(let post):

                if post.error == true, post.message == "Account is Private" {
                    postTableView.isHidden = true
                    privateAccView.isHidden = false
                }
                
                if post.error == false, post.data?.count ?? 0 > 0 {
                    postTableView.isHidden = false
                    privateAccView.isHidden = true
                    self.posts = post.data ?? []
                    self.setPostTableHeight()
                }
                    
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            default:
                break
            }
        }
    }
    
    func likePost(postId: Int, status: String, action: String, at: Int) {
        
        let param:Parameters = [
            "post_id" : postId,
            "created_by_id" : myUserDefaults.userId, // LoggedUserDetails.shared.user!.id ?? 0,
            "status":status,
            "action":action
        ]
        
        self.view.isUserInteractionEnabled = false
        ApiCallerClass.likePostServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                if self.Is_Reaction {
//                    self.fetchRections()
                } else {
                    self.getPosts(offSet: 1)
                }
//                let indexPath = IndexPath(item: at, section: 0)
//                self.reactionTblVw.reloadRows(at: [indexPath], with: .none)
//                self.view.isUserInteractionEnabled = true
            }
            else {
                self.getPosts(offSet: 1)
//                let indexPath = IndexPath(item: at, section: 0)
//                self.reactionTblVw.reloadRows(at: [indexPath], with: .none)
//                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            self.hideActivity()
            print(action)
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
        }
    }

    
    func blockUser(userId: Int) {
        
        let url = "\(EndPoints.blockUser)"
        print(url)
        
        let param: AFParameters = ["target_user_key": userId]

        NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<GenericResponse>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.error == true {
                    self.presentAlert("Error", response.message)
                }
                
                if response.error == false {
                    showToast(message: "User Blocked Successfully")
                    self.backBtnTapped(backBtn!)
                }
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            default:
                break
            }
        }
    }
    
    func addConnection(receiverId: Int, completion: @escaping () -> Void) {
        
        let id = myUserDefaults.userId
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
    
//    func callCancelrequest(id: Int) {
//        let params: AFParameters  = ["user_id": id]
//        showActivity()
//        NetworkManagerr.request(EndPoints.cancelRequest, method: .post, parameters: params) { (response) in
//            self.hideActivity()
//            do {
//                let jsonDecoder = JSONDecoder()
//                let Root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
//                self.hideActivity()
//                if !(Root.error) {
//                    self.presentAlert("Success", Root.message, nil)
//                    self.fetchUserDetail(userId: self.profileID) { (user, error) in
//                        if let user = user {
//                            self.setUI(for: user)
//                        }
//                        
//                        if let error = error {
//                            self.presentAlert("Failure", nil, error)
//                        }
//                    }
//                } else {
//                    self.presentAlert("Failure", Root.message, nil)
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//        }
//    }
    
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
    
    func connectionFollowUnfollow(receiverID: Int, status: Int) {
        let url = EndPoints.connectionFollowUnfollow
        let parameters = [
            "receiverId": receiverID,
            "status": status] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let networkEventRoot = try jsonDecoder.decode(DataStringResponse.self, from: response.data!)
                if !(networkEventRoot.error ?? false) {
                    self.presentAlert(networkEventRoot.message ?? "Success", networkEventRoot.data ?? "")
                    self.fetchUserDetailsData()
                } else {
                    self.presentAlert(networkEventRoot.message ?? "")
                    print("Error :: \(networkEventRoot.message ?? "Default Message")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func connectionSendRequest(receiverID: Int, status: Int) {
        let url = EndPoints.delegateSendRequest
        let parameters = [
            "receiver_id": receiverID,
            "status": status] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let networkEventRoot = try jsonDecoder.decode(SendRequestDataModel.self, from: response.data!)
                if !(networkEventRoot.error ?? false) {
                    self.presentAlert(networkEventRoot.message ?? "Success")
                    self.fetchUserDetailsData()
                } else {
                    self.presentAlert(networkEventRoot.message ?? "")
                    print("Error :: \(networkEventRoot.message ?? "Default Message")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func connectionAcceptReject(conectionID: Int, action: String) {
        let url = EndPoints.delegateAcceptReject
        let parameters = [
            "connection_id": conectionID,
            "action": action] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let networkEventRoot = try jsonDecoder.decode(DataStringResponse.self, from: response.data!)
                if !(networkEventRoot.error ?? false) {
                    self.presentAlert(networkEventRoot.message ?? "Success", networkEventRoot.data ?? "")
                    self.fetchUserDetailsData()
                } else {
                    self.presentAlert(networkEventRoot.message ?? "")
                    print("Error :: \(networkEventRoot.message ?? "Default Message")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

// MARK: Custom Methods
extension OthersProfileVC {
    
    @objc func handleShare(_ sender: UIButton) {
        let post = posts[sender.tag]
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = post.id ?? 0
        vc.type = post.type ?? .post
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @objc func handleLike(_ sender: UIButton) {
        let post = posts[sender.tag]
        likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike" , at: sender.tag)
    }
    
//    @objc func openDoc(_ sender: UIButton) {
//        let obj = reactions[sender.tag]
//        articleContent = obj.postDocument
//        openArticle()
//    }
    
    @objc func addCommentOnPost(_ sender: UIButton) {
        let index = sender.tag
        let obj = posts[index]
        
        if obj.postVideo != "" {//Video
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else if obj.postDocuments?.count ?? 0 > 0 {//Document
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else if obj.datumPostImage!.count > 0 {//Image
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else {//Text
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = obj.id ?? 0
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        if  obj.postImage == [] && obj.postVideo == "" && obj.postDocument == "" { // && post.postDocument == nil
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .simpleText
//            vc.postId = obj.id
//            navigationController?.pushViewController(vc, animated: true)
//        } else if obj.postVideo != "" && obj.postDocument == "" && obj.postImage == [] {
//            //==> Video Cell...
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .video
//            vc.postId = obj.id
//            navigationController?.pushViewController(vc, animated: true)
//        } else if obj.postDocument != "" && obj.postImage == [] { //document Cell
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .article
//            vc.postId = obj.id
//            navigationController?.pushViewController(vc, animated: true)
//        }  else if obj.postImage!.count > 0 {
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .image
//            vc.postId = obj.id
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @objc func showVideoView(sender: UIButton) {
        if Is_Reaction {
//            let bindModelData = reactions[sender.tag]
//            configureVideoView(getUrl: bindModelData.postVideo)
        } else {
            let bindModelData = posts[sender.tag]
            configureVideoView(getUrl: bindModelData.postVideo)
        }
    }
    
    func configureVideoView(getUrl: String?) {
        if getUrl != nil {
            let videoURL = URL(string: getUrl!)
            if videoURL != nil {
                let player = AVPlayer(url: videoURL!)
                let playerLayer = AVPlayerViewController()
                playerLayer.player = player
                self.present(playerLayer, animated: true, completion: {
                    player.play()
                })
            }
        }
    }
    
    @objc func openDoc(_ sender: UIButton) {        
        let articleContent = posts[sender.tag].postDocuments?[0] ?? ""
        self.openSafari(strURL: articleContent)
        //self.openArticle(strURL: articleContent)
    }
    
    func openSafari(strURL: String) {
        let deocURl = URL(string: strURL)
        if let url = deocURl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func openArticle(strURL: String) {
//        if let urlString = strURL, let url = URL(string: urlString) {
//            let webVC = WebVC(url: url)
//            present(webVC, animated: true, completion: nil)
//        }
        let docVC = DocumentVC.instantiate()
        docVC.documentURL = URL(string: strURL)
        navigationController?.pushViewController(docVC, animated: true)
    }
    
    @objc func reportBtnTapped(_ sender: UIButton) {
        let index = sender.tag
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Report"],
                                    popOverPosition: .automatic,
                                    config: Constants.configWithMenuStyle(),
                                    done: { (selectedIndex) in
            switch selectedIndex {
            case 0:
                let vc = reportPopupVC.instantiate()
                vc.postId = self.posts[index].id ?? 0
                vc.userId = self.posts[index].user?.id ?? 0
                vc.completion = {
                    let vc = otherReasonPopupVC.instantiate()
                    vc.postId = self.posts[index].id ?? 0
                    vc.userId = self.posts[index].user?.id ?? 0
                    self.navigationController?.present(vc, animated: true)
                }
                self.navigationController?.present(vc, animated: true)
            default:
                break
            }
        })
    }
}

extension OthersProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Is_Reaction {
            let cell: ReactionTableViewCell = postTableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
        else {
            let homePost = posts[indexPath.row]
            let Row = indexPath.row

            if homePost.postVideo != "" && homePost.postVideo != nil {//Video
                let cell: HomeVideo = postTableView.dequeueReusableCell(forIndexPath: indexPath)
                
                cell.uiData(dataMaper: homePost)
                
                //for other user profile...
                if homePost.isConnected == "connected" || homePost.isConnected == "active" {
                    cell.followBtn.isHidden = true
                } else {
                    cell.followBtn.isHidden = false
                }
                
                cell.likeBtn.tag = Row
                cell.commentBtn.tag = Row
                cell.sharedBtn.tag = Row
                cell.openVideoBtn.tag = Row
                cell.reportBtn.tag = Row
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resize)
                cell.videoView.stop()
                
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                return cell
            }
            else if homePost.postDocuments?.count ?? 0 > 0 {//Document
                let cell: HomeUrl = postTableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.backgroundColor = UIColor(hex: "#F8F6F8")
                //            cell.delegate = self
                cell.uiData(homePost: homePost)
                
                //for other user profile...
                if homePost.isConnected == "connected" || homePost.isConnected == "active" {
                    cell.followBtn.isHidden = true
                } else {
                    cell.followBtn.isHidden = false
                }
                
                cell.likeBtn.tag = Row
                cell.commentBtn.tag = Row
                cell.sharedBtn.tag = Row
                cell.openArticleBtn.tag = Row
                cell.reportBtn.tag = Row

                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
                cell.openArticleBtn.addTarget(self, action: #selector(openDoc(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                return cell
            }
            else if homePost.datumPostImage!.count > 0 {//Image
                let cell: HomeImage = postTableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.backgroundColor = UIColor(hex: "#F8F6F8")
                cell.uiData(dataMaper: homePost)

                //for other user profile...
                if homePost.isConnected == "connected" || homePost.isConnected == "active" {
                    cell.followBtn.isHidden = true
                } else {
                    cell.followBtn.isHidden = false
                }
                
                cell.likeButton.tag = indexPath.row
                cell.commentButton.tag = indexPath.row
                cell.shareButton.tag = indexPath.row
                cell.reportBtn.tag = Row

                cell.likeButton.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.commentButton.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                return cell
            }
            else {//Text
                let cell: HomeText = postTableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.detailsView.layer.cornerRadius = 13
                //            cell.delegate = self
                cell.uiData(dataMaper: homePost)
                
                //for other user profile...
                if homePost.isConnected == "connected" || homePost.isConnected == "active" {
                    cell.followBtn.isHidden = true
                } else {
                    cell.followBtn.isHidden = false
                }
                
                cell.likeBtn.tag = Row
                cell.commentBtn.tag = Row
                cell.shareBtn.tag = Row
                cell.reportBtn.tag = Row
                
                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                
                return cell
            }

            
//            if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" {
//                let cell: HomeText = postTableView.dequeueReusableCell(forIndexPath: indexPath)
//                cell.detailsView.layer.cornerRadius = 13
//                //            cell.delegate = self
//                cell.uiData(dataMaper: homePost)
//                
//                cell.likeBtn.tag = Row
//                cell.commentBtn.tag = Row
//                cell.shareBtn.tag = Row
//                cell.reportBtn.tag = Row
//                
//                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
//                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                
//                return cell
//                
//            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] { //Video Cell
//                let cell: HomeVideo = postTableView.dequeueReusableCell(forIndexPath: indexPath)
//                
//                cell.uiData(dataMaper: homePost)
//                
//                cell.likeBtn.tag = Row
//                cell.commentBtn.tag = Row
//                cell.sharedBtn.tag = Row
//                cell.openVideoBtn.tag = Row
//                cell.reportBtn.tag = Row
//                cell.videoView.backgroundColor = .black
//                cell.videoView.configure(url: homePost.postVideo!,ratio: .resize)
//                cell.videoView.stop()
//                
//                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                return cell
//                
//            } else if homePost.postDocument != "" && homePost.postImage == [] { //document Cell
//                let cell: HomeUrl = postTableView.dequeueReusableCell(forIndexPath: indexPath)
//                //            cell.delegate = self
//                cell.uiData(homePost: homePost)
//                cell.likeBtn.tag = Row
//                cell.commentBtn.tag = Row
//                cell.sharedBtn.tag = Row
//                cell.openArticleBtn.tag = Row
//                cell.reportBtn.tag = Row
//
//                cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
//                cell.openArticleBtn.addTarget(self, action: #selector(openDoc(_:)), for: .touchUpInside)
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                //                cell.isConnectedBtn.tag = indexPath.row
//                //
//                //                cell.likeBtn.tag = indexPath.row
//                //                cell.commentBtn.tag = indexPath.row
//                //                cell.sharedBtn.tag = indexPath.row
//                //            cell.openArticleBtn.tag = indexPath.row
//                //                cell.moreOption.tag = indexPath.row
//                //                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                //                cell.openProfile.tag = indexPath.row
//                //                cell.didTapURL = { [weak self] url in
//                //                    self?.present(SFSafariViewController(url: url), animated: true, completion: nil)
//                //                }
//                //
//                //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//                //                cell.openProfile.addGestureRecognizer(tapGesture)
//                //                cell.openProfile.isUserInteractionEnabled = true
//                
//                return cell
//            } else if homePost.postImage!.count > 0 { //Image Cell
//                //
//                let cell: HomeImage = postTableView.dequeueReusableCell(forIndexPath: indexPath)
//                cell.uiData(dataMaper: homePost)
//
//                cell.likeButton.tag = indexPath.row
//                cell.commentButton.tag = indexPath.row
//                cell.shareButton.tag = indexPath.row
//                cell.reportBtn.tag = Row
//
//                cell.likeButton.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
//                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.commentButton.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                return cell
//            } else {
//                let cell: HomeText = postTableView.dequeueReusableCell(forIndexPath: indexPath)
//                return cell
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let homePost = self.posts[indexPath.row]
        if homePost.postVideo != "" && homePost.postVideo != nil {
            let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            let height = lblHeight + 356.0
            return height
        } else if homePost.postDocuments?.count ?? 0 > 0 {
            let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            let height = lblHeight + 231.0
            return height
        } else if homePost.datumPostImage!.count > 0 {
            let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            let height = lblHeight + 430.0
            return height
        } else {
            let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            let height = lblHeight + 195.0
            return height
        }
    }

}
