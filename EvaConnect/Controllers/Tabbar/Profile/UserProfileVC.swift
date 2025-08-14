//
//  UserProfileVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/27/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage
import Network
import Alamofire
import AVKit
import SVProgressHUD
import IQKeyboardManagerSwift

enum ProfileSettingData {
    case profile(ProfileData)
    case posts(DashboardItem)
    case custom(String)
}

class UserProfileVC: BaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileLoadingView: UIView!
    @IBOutlet weak var connectionCountView: UIView!
    @IBOutlet weak var connectedBtn: UIButton!
    //@IBOutlet weak var tableViewTopConst: NSLayoutConstraint!
    @IBOutlet var profileViews: [UIView]!
    //@IBOutlet weak var scrollViewTopConst: NSLayoutConstraint!
    //@IBOutlet weak var tableView: DynamicSizeTableView!
    @IBOutlet var profileButtons: [UIButton]!
    @IBOutlet weak var connectionLbl: UILabel!
    @IBOutlet weak var connectionCountLbl: UILabel!
    
    @IBOutlet weak var bioTitleLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var professionLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileMainVw: UIView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var bioMainView: UIView!
    @IBOutlet weak var bioViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBaseView: UIView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var reactionButton: UIButton!
    
    @IBOutlet weak var reactionTblVw: UITableView!
    @IBOutlet weak var reactionTblViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var pendingReqLabel: UILabel!
    @IBOutlet weak var pendingCountLbl: UILabel!
    @IBOutlet weak var pendingEmpView: UIView!
    
    @IBOutlet weak var noRecordLbl: UILabel!
    
    var Is_Reaction: Bool = false
    var stopAPICall  = false
    let pageSize = 10
    var companyId = 0
    var isChatEnable = true
    
    let likeManager = LikeManager()
    var selectedTab: HomeTabs = .posts
    
    var posts: [DashboardItem] = [] {
        didSet {
            let count = posts.count
            if count > 0 {
                self.noRecordLbl.isHidden = true
                self.viewAllButton.isHidden = false
            } else {
                self.noRecordLbl.isHidden = false
                self.viewAllButton.isHidden = true
            }
            self.reactionTblVw.reloadData()
            
        }
    }
    
    var reactions: [ReactionData] = [] {
        didSet {
            let count = reactions.count
            if count > 0 {
                self.noRecordLbl.isHidden = true
                self.viewAllButton.isHidden = false
            } else {
                self.noRecordLbl.isHidden = false
                self.viewAllButton.isHidden = true
            }
            self.reactionTblVw.reloadData()
            
        }
    }
    
    //MARK: VARIABLES
    private var homeVC: HomeVC!
    var connectionDetail: DashboardItem?
    var userId: Int!
    var profileSettings: [ProfileSettingData] = []
    var homePostType: HomePosts?
    var userDetail: EvaUser?
    var isConnected: Bool = false
    var userDetails: UserDetailsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        reactionTblVw.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getSettings()
//        fetchUserInfo()
        fetchUserDetailsData()
        getPosts(offSet: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            self.reactionTblViewHeight.constant = self.reactionTblVw.contentSize.height == 0 ? 120 : self.reactionTblVw.contentSize.height
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setPostTableHeight() {
        var totalHeight = 0.0
        for homePost in self.posts {
            if homePost.postVideo != "" && homePost.postVideo != nil {
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 356.0
                totalHeight = totalHeight + height
            } else if homePost.postDocuments?.count ?? 0 > 0 {
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 231.0
                totalHeight = totalHeight + height
            } else if homePost.datumPostImage!.count > 0 {
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 430.0
                totalHeight = totalHeight + height
            } else {
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 195.0
                totalHeight = totalHeight + height
            }
        }
        self.reactionTblViewHeight.constant = totalHeight
    }
    
    @IBAction func messageBtnTapped(_ sender: Any) {
        guard let userDetail = userDetail else { return }
        if userDetail.isConnected == "active" {
            if isChatEnable {
                let chatVC = StoryboardRouter.chat()
                navigationController?.pushViewController(chatVC, animated: true)
            } else {
                self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
            }
            let chatVC = StoryboardRouter.chat()
//            chatVC.user = convertEvaUserToUser(userDetail)
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            ErrorView(contentView: navigationController?.view ?? view).show(message: "Only connected user can send message")
        }
    }
    
    @IBAction func connectBtnTapped(_ sender: Any) {
        if userDetail?.isConnected == "active" { return }
        guard let userId = connectionDetail?.userID ?? userDetail?.id else { return }
        if userDetail?.isConnected == "pending" && userDetail?.isReceiver == false {
            updateConnection()
        } else if userDetail?.isConnected != "pending" {
            addConnection(id: userId)
        }
    }
    
    @IBAction func blockBtnTapped(_ sender: Any) {
        self.profileButtons[2].isUserInteractionEnabled.toggle()
        guard let id = connectionDetail?.userID ?? userDetail?.id else { return }
        ProfileManager.shared.blockConnection(id: id) { [weak self] (title, message) in
            guard let self = self else { return }
            self.profileButtons[2].isUserInteractionEnabled.toggle()
            if title == "Failure" || title == "Error" {
                self.presentAlert(title, message, nil)
            } else {
                self.presentAlertWithAction(title: title, message: message) { self.navigationController?.popViewController(animated: true) }
            }
        }
    }
    
    
    @IBAction func onEditProfilrBtnTapped(_ sender: UIButton) {
        print("Tapped Edit Profile")
//        let editProfile = StoryboardRouter.editUserProfile()
//        editProfile.userDetail = userDetail
//        navigationController?.pushViewController(editProfile, animated: true)
        let vc = EditProfileViewController.instantiate()
        vc.userDetails = self.userDetails
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func onPostBtnTapped(_ sender: UIButton) {
        getPosts(offSet: 1)
        self.postButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
        self.postButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.reactionButton.backgroundColor = UIColor.clear
        self.reactionButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.Is_Reaction = false
        self.viewAllButton.setTitle("View all Post", for: .normal)
//        self.reactionTblViewHeight.constant = (240.0 * 2)
        self.reactionTblVw.reloadData()
        
    }
    
    @IBAction func onReactionBtnTapped(_ sender: UIButton) {
        self.fetchRections()
        self.reactionButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
        self.reactionButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.postButton.backgroundColor = UIColor.clear
        self.postButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.Is_Reaction = true
        self.viewAllButton.setTitle("View all Reaction", for: .normal)
//        self.reactionTblViewHeight.constant = (451.0 * 2)
        self.reactionTblVw.reloadData()
        
    }
    
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        if self.Is_Reaction {
            print("Tapped View all Reaction.")
            vc.Is_Reaction = true
        } else {
            vc.Is_Reaction = false
            print("Tapped View all Post.")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onFollowersBtnTap(_ sender: UIButton) {
        //connectionTapped()
        let vc = ConnectionViewController.instantiate()
        vc.type = .Followers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func connectionTapped() {
        let vc = StoryboardRouter.connectionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFollowingBtnTap(_ sender: UIButton) {
        //TapOnView()
        let vc = ConnectionViewController.instantiate()
        vc.type = .Following
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func TapOnView() {
        if isIndivisualUser {
            
        } else {
            let vc = StoryboardRouter.interestedList()
            vc.companyId = self.companyId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func goToReactionProfileTapped(_ sender: UIButton) {
        let reaction = reactions[sender.tag]
        let id = reaction.user?.id
        if id == LoggedUserDetails.shared.user?.id ?? 0 {
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = StoryboardRouter.othersProfileVC()
            vc.profileID = id ?? 0
            vc.isFrom = 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UserProfileVC {
    
    func setupTapGestures(){
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(TapOnView))
        self.pendingEmpView.isUserInteractionEnabled = true
        self.pendingEmpView.addGestureRecognizer(TapGesture)
        
        let TapGesture2 = UITapGestureRecognizer(target: self, action: #selector(connectionTapped))
        self.connectionCountView.isUserInteractionEnabled = true
        self.connectionCountView.addGestureRecognizer(TapGesture2)
    }
    
    func setLayout() {
        isSeparatorHidden = true
        self.noRecordLbl.isHidden = true
        //setupTapGestures()
        self.profileMainVw.layer.cornerRadius = 19.0
        self.bioMainView.layer.cornerRadius = 19.0
        
        self.editProfileBtn.layer.cornerRadius = 12.0
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        
        self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2
        self.profileView.layer.borderWidth = 2
        self.profileView.layer.borderColor = UIColor(hex: "#5894DD").cgColor
        
        self.nameLbl.font = UIFont(name: Myfonts.bold, size: 20.0)
        self.professionLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.detailsLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        
        self.connectionCountLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.connectionLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        self.pendingCountLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.pendingReqLabel.font = UIFont(name: Myfonts.regular, size: 12.0)
        
        self.bioTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.aboutLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        
        self.buttonBaseView.layer.cornerRadius = 8
        self.postButton.layer.cornerRadius = 8
        self.reactionButton.layer.cornerRadius = 8
        
        self.Is_Reaction = false
        self.reactionTblViewHeight.constant = 0.0
//        self.reactionTblViewHeight.constant = (240.0 * 2)
        
        self.viewAllButton.layer.cornerRadius = self.viewAllButton.frame.size.height/2
        self.viewAllButton.setTitle("View all Post", for: .normal)
        
        self.postButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
        self.postButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.reactionButton.backgroundColor = UIColor.clear
        self.reactionButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)

        self.reactionTblVw.registerCells(withTypes: [ReactionTableViewCell.self])
        self.reactionTblVw.registerCells(withTypes: [TextViewCell.self,
                                            PostImageViewCell.self,
                                            PostDocumentCell.self])
        reactionTblVw.registerCells(withTypes: [HomeText.self, HomeImage.self, HomeVideo.self, HomeNewz.self, HomeUrl.self])

        if userId.isNil {
            userId = myUserDefaults.userId
            backView.isHidden = true
        }
        
//        profileView.applyBorderWithRadius(color: Constants.AppColorLiteral.selectedColor, radius: profileView.bounds.width / 2)
        profileButtons[0].applyBorderWithRadius(color: Constants.AppColorLiteral.loginByNew, radius: 20)
        profileButtons[1].applyBorderWithRadius(color: Constants.AppColorLiteral.loginColor, radius: 20)
        profileButtons[2].applyBorderWithRadius(color: .black, radius: 20)
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        if userId == LoggedUserDetails.shared.user?.id ?? 0 {
            hideUserDetails()
//            updateUI(user: LoggedUserDetails.shared.user!)
            if profileSettings.isEmpty {
                profileSettings.append(contentsOf: [
                    .profile(ProfileData(userImage: #imageLiteral(resourceName: "profile"), title: "Notification")), .profile(ProfileData(userImage: #imageLiteral(resourceName: "profile"), title: "Edit Profile")),
                    .profile(ProfileData(userImage: #imageLiteral(resourceName: "profile"), title: "Settings"))
                ])
            }
        } else if let user = connectionDetail?.user ?? userDetail {
            updateUI(user: user)
            //applyConditionalLayout()
            userId = connectionDetail?.userID ?? LoggedUserDetails.shared.user?.id
        }
        
        self.onPostBtnTapped(postButton)
      
    }
    
    func hideUserDetails() {
        //scrollViewTopConst.constant = -40
        profileViews.forEach({ $0.isHidden = true })
//        tableViewTopConst.constant = -50
    }
    
    
}

extension UserProfileVC {
    
    func applyConditionalLayout() {
        let status = connectionDetail?.isConnected ?? userDetail?.isConnected ?? .none
        if status == "active" {
            //
        }
        else if status == "pending" {
            setLayoutForPending()
//            tableView.tableFooterView = UIView()
        }
        else {
            setLayoutForPrivate()
//            tableView.tableFooterView = UIView()
        }
//        switch status {
//        case "active":
////            getPosts()
//            break
//        case "pending":
//            setLayoutForPending()
//            tableView.tableFooterView = UIView()
//        default:
//            setLayoutForPrivate()
//            tableView.tableFooterView = UIView()
//        }
    }
    
    func setLayoutForPending() {
        let title = userDetail?.isReceiver == false ? Constants.Label.accept : Constants.Label.pending
        for i in 2..<6 { profileViews[i].isHidden = true }
//        tableView.isHidden = true
        connectedBtn.setTitle(title, for: .normal)
    }
    
    func setLayoutForPrivate() {
        for i in 2..<6 { profileViews[i].isHidden = true }
        connectionCountView.isHidden = true
        connectedBtn.setTitle(Constants.Label.connect, for: .normal)
//        tableViewTopConst.constant = -70
        
        profileSettings.append(.custom("PrivateProfileCell"))
//        tableView.separatorColor = .clear
//        tableView.reloadData()
//        tableView.invalidateIntrinsicContentSize()
    }
    
}

extension UserProfileVC {
    
    func updateUI(user: EvaUser) {
        userDetail = user
        
        if user.userImage != nil {
            profileImageView.sd_setImage(with: URL(string: user.isLinkedin == 0 ? user.userImage ?? "" : user.linkedinImageURL ?? ""),
                                         placeholderImage: UIImage(named: "profile"))
        }
        
        nameLbl.text = user.fullName
        professionLbl.text = user.isCompany ? user.workAviation ?? "" : "\(user.companyName ?? "") | \(user.designation ?? "No Designation")"
        
        
        //aboutLbl.text = user.bioData ?? ""
        let content = user.bioData ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), color: UIColor(hex: "#030229")) {
            aboutLbl.attributedText = attributed
        }
        
        //Set bio view Height.....
        let lblHeight = self.heightForView(text: self.aboutLbl.text ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: self.view.frame.width - 72.0)
        self.bioViewHeight.constant = lblHeight + 64.0
        
        self.connectionCountLbl.text = "\(user.connectionCount ?? 0)"
//        self.pendingCountLbl.text = "\(user.)"
        self.companyId = user.companyID ?? 0
        
        self.connectionLbl.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Followers" : "Connections"
        self.pendingReqLabel.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Employees" : "Pending Request"
        
        self.pendingCountLbl.text = isIndivisualUser ? "\(user.pendingConnection ?? "")" : "\(user.employeesCount ?? 0)"
        
        
//        self.connectionTitleLbl.text = connectionTitle
        
//        let connection = "\(user.connectionCount ?? 0)  \(connectionTitle)"
//        let attributedText = NSMutableAttributedString(string: connection)
//
//        attributedText.setAttributes([
//            .font: UIFont(defaultFontStyle: .bold, size: 26), .foregroundColor: UIColor(hex: "#000000")
//        ], range: (connection as NSString).range(of: "\(user.connectionCount ?? 0)"))
//        attributedText.setAttributes([
//            .font: UIFont(defaultFontStyle: .bold, size: 17), .foregroundColor: UIColor(hex: "#B4B4B4")
//        ], range: (connection as NSString).range(of: connectionTitle))
//
//        connectionLbl.attributedText = attributedText
        
        
//        let isActive = connectionDetail?.isConnected == .active || userDetail?.isConnected == .active
//        if isConnected || isActive { getPosts() }
        updateButtons()
        
//        if user.type == userType.company.rawValue {
//            profileViews[1].isHidden = true
//            profileViews[2].isHidden = true
//            connectedBtn.setTitle("Website", for: .normal)
//        }
    }
    
    func updateButtons() {
        guard let bindData = userDetail else {
//            tableView.tableFooterView = UIView()
            profileViews[5].isHidden.toggle()
            return
        }
        
        let isCompanyUser = LoggedUserDetails.shared.user?.type == userType.company.rawValue && userDetail?.type == userType.user.rawValue
        if bindData.id != myUserDefaults.userId {
            connectedBtn.isHidden = false
//            if bindData.isConnected == .deleted || bindData.isConnected == .notConnected {
//                //connectedBtn.isHidden = true
//                setLayoutForPrivate()
//                tableView.tableFooterView = UIView()
//            }
            
            if bindData.isConnected == "not_connected" {
                connectedBtn.isUserInteractionEnabled = true
                connectedBtn.setTitle(isCompanyUser ? Constants.Label.inviteToFollow : Constants.Label.connect, for: .normal)
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == true {
                connectedBtn.setTitle(isCompanyUser ? "  \(Constants.Label.invited)" : Constants.Label.pending, for: .normal)
                connectedBtn.backgroundColor = isCompanyUser ? Constants.AppColorLiteral.nextButtonColor : .clear
                connectedBtn.setTitleColor(isCompanyUser ? .white : Constants.AppColorLiteral.nextButtonColor, for: .normal)
                connectedBtn.setImage(isCompanyUser ? UIImage(named: "ic_intersted") : nil, for: .normal)
                connectedBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == true {
                connectedBtn.setTitle(Constants.Label.pending, for: .normal)
                connectedBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == false {
                connectedBtn.setTitle(Constants.Label.accept, for: .normal)
                connectedBtn.isUserInteractionEnabled = true
            }
            else if bindData.isConnected == "active" {
                connectedBtn.setTitle(Constants.Label.connected, for: .normal)
                connectedBtn.isUserInteractionEnabled = false
                profileViews[2].isHidden = false
            }
        } else {
            connectedBtn.isHidden = true
        }
        
    }
    
    
    func fetchUserInfo() {
        fetchUserDetail()
//        tableView.reloadData()
//        tableView.invalidateIntrinsicContentSize()
    }
    
    func fetchUserDetailsData() {
        showActivity()
        let url = "\(EndPoints.userDetail)"
        
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
                print(response)
                if let user = response.data?.first {
                    self.userDetails = user
                    if let user = self.userDetails {
                        self.setData(user: user)
                    }
                } else {
                    self.presentAlert("Error", nil, response.message as? Error)
                }
            } catch {
                print(error)
                self.presentAlert("Error", nil, error.localizedDescription as? Error)
            }
        }
    }


    func setData(user: UserDetailsData) {
        if user.isPublic == 0 {
            myUserDefaults.isPrivate = true
        } else {
            myUserDefaults.isPrivate = false
        }
        
        if let imageUrl = user.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.profileImageView.image = UIImage(named: "profile")
        }
        
        nameLbl.text = isIndivisualUser ? "\(user.firstName ?? "") \(user.lastName ?? "")" : "\(user.companyName ?? "")"
        
        if user.type!.elementsEqual("user") {
            professionLbl.text = "\(user.designation ?? "No Designation")"
            self.pendingCountLbl.text = "\(user.pendingConnection ?? "")"
        }
        else {
            professionLbl.text = isIndivisualUser ? "\(user.companyName ?? "")" : "--"
            self.pendingCountLbl.text = "--"
        }

        //aboutLbl.text = user.bioData ?? ""
        let content = user.bioData ?? ""
        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), color: UIColor(hex: "#030229")) {
            aboutLbl.attributedText = attributed
        }
        
        //Set bio view Height.....
        let lblHeight = self.heightForView(text: self.aboutLbl.text ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: self.view.frame.width - 72.0)
        self.bioViewHeight.constant = lblHeight + 64.0
        
        self.connectionCountLbl.text = "\(user.connectionCount ?? 0)"
        self.companyId = Int(user.companyID ?? 0)
//        self.connectionLbl.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Followers" : "Connections"
//        self.pendingReqLabel.text = LoggedUserDetails.shared.user?.type == userType.company.rawValue ? "Employees" : "Pending Request"
        self.connectionCountLbl.text = "\(user.followers ?? 0)"
        self.connectionLbl.text = "Followers"
        self.pendingCountLbl.text = "\(user.following ?? 0)"
        self.pendingReqLabel.text = "Following"
        
    }
    
    func fetchUserDetail() {
        showActivity()
        ProfileManager.shared.fetchUserDetail(userId: userId ?? 0, showPush: true) { user, error in
            if let error = error {
                self.presentAlert("Error", error)
            } else if let user = user {
                self.updateUI(user: user)
                self.profileLoadingView.isHidden = true
                if myUserDefaults.userId != user.id { self.applyConditionalLayout() }
            } else {
                self.presentAlert("Error", "Unable to fetch user details")
            }
        }
    }
    
    func getPosts(offSet: Int) {
        showActivity()
        let url = "\(EndPoints.getAllHomePost)?limit=\(pageSize)&offset=\(offSet)"
        print(url)

        let param: AFParameters = ["filter": "my_posts"] //

        NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<DashboardItemRoot>) in
            guard let self = self else { return }
            hideActivity()
//            self.stopAPICall = false
            switch result {
            case .success(let post):
                
                if post.message == "Account is Private" {
                    noRecordLbl.isHidden = true
                }

                if post.error == false {
                    if post.data?.count ?? 0 > 0 {
                        self.posts = post.data ?? []
                        noRecordLbl.isHidden = true
                        self.viewAllButton.isHidden = false
                    } else {
                        noRecordLbl.isHidden = false
                        self.viewAllButton.isHidden = true
                    }
                } else {
                    if post.data?.count ?? 0 > 0 {
                        self.posts = post.data ?? []
                        noRecordLbl.isHidden = true
                        self.viewAllButton.isHidden = false
                    } else {
                        noRecordLbl.isHidden = false
                        self.viewAllButton.isHidden = true
                    }
                }
                self.setPostTableHeight()

            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            default:
                break
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
    
    func fetchRections(){
        showActivity()
        let params = ["limit": 10] as [String: Any]
        let url = EndPoints.reactions
        NetworkManagerr.request(url, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingRoot = try jsonDecoder.decode(ReactionsDataModel.self, from: response.data!)
                
                if !(meetingRoot.error!) {
                    if let data = meetingRoot.data {
                        self.reactions = data
                    }
                } else {
                    self.presentAlert("Failure", meetingRoot.message, nil)
                }
            } catch {
                print("Error: ",error)
            }
        }
    }

    
//    func fetchSinglePost(user: EvaUser) {
//        ProfileManager.shared.fetchPosts(uid: user.id) { posts, error in
//            if let error = error {
//                self.presentAlert("Error", error)
//            } else {
//                self.connectionDetail = posts.first
//                self.updateUI(user: user)
//            }
//        }
//    }
    
}

//extension UserProfileVC {
//
//    func getPosts() {
//        profileViews[3].isHidden.toggle()
//        profileViews[4].isHidden.toggle()
//        let userId = connectionDetail?.userID ?? userDetail?.id
//        let isActive = connectionDetail?.isConnected == .active || userDetail?.isConnected == .active
//        if userId != LoggedUserDetails.shared.user?.id && isActive { setTableFooterView(posts: []) }
//        else { tableView.tableFooterView = UIView() }
//    }
//
//    private func setTableFooterView(posts: [DashboardItem]) {
//        homeVC = StoryboardRouter.homeVC()
//        homeVC.hideSperator = true
//        homeVC.specificUserPost = userId
//        tableFooterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
//        homeVC.view.frame = CGRect(x: 0, y: 0, width: tableFooterView.frame.width, height: tableFooterView.frame.height)
//        tableFooterView.addSubview(homeVC.view)
//        addChild(homeVC)
//    }
//
//}

extension UserProfileVC {
    
//    func getPosts(offSet: Int) {
//        if stopAPICall { return }
////        if searchEnabled {
////            tabCollectionViewHeight.constant = 0
////            indicatorView.stopAnimating()
////            return
////        }
//        
//        var url = "\(EndPoints.getAllHomePost)?limit=\(pageSize)&offset=\(offSet)&filter=my_posts"
//        print(url)
////        var param: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "filter": "my_posts"]
//        
////        if let uid = specificUserPost {
////            param["user_key"] = uid
////            param["filter"] = "my_posts"
////            url = "\(EndPoints.homeFilterPosts)?limit=\(pageSize)&offset=\(offSet)"
////            tabCollectionViewHeight.constant = 0
////        } else if let searchFilterKey = searchFilterKey {
////            url = "\(EndPoints.searhDashboard)?limit=\(pageSize)&offset=\(offSet)"
////            param["filter"] = searchFilterKey.key
////            param["search_key"] = searchFilterKey.query
////        }
//        
//        stopAPICall = true
//
//        NetworkManagerr.request(url, method: .post) { [weak self] (result: Result<DashboardItemRoot>) in
//            guard let self = self else { return }
//            self.stopAPICall = false
//            switch result {
//            case .success(let post):
////                if post.data.isEmpty && self.posts.isEmpty {
////                    self.emptyListMessageLbl.text = self.searchEnabled ? "No result found" : "No result found"//post.message?.capitalized
////                    self.emptyListMessageLbl.isHidden = false
////                    return
////                }
//                
////                if inserted {
////                    if post.data.isEmpty {
////
////                    } else {
////                        self.posts.append(contentsOf: post.data)
////                    }
////                } else {
//                    self.posts = post.data
////                    self.postSeeMore.removeAll()
////                }
//                
////                for (index, post) in post.data.enumerated() {
////                    let lines = CGFloat(post.content?.calculateMaxLines(width: self.view.frame.width - 10) ?? 1)
////                    self.postSeeMore[index] = self.postSeeMore[index] == nil ? (lines: lines, enabled: false) : self.postSeeMore[index]
////                }
////                self.emptyListMessageLbl.isHidden = true
////                self.emptyListMessageLbl.text = ""
//            case .failure(let failure):
//                self.presentAlert("Error", nil, failure)
//            }
//            
//        }
//    }
    
    @objc func showVideoView(sender: UIButton) {
        if Is_Reaction {
            let bindModelData = reactions[sender.tag]
            configureVideoView(getUrl: bindModelData.postVideo)
        } else {
            let bindModelData = posts[sender.tag]
            configureVideoView(getUrl: bindModelData.postVideo)
        }
    }
    
    //Configure Custom View
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
    
}

extension UserProfileVC: PostActionable, CollectionViewCellDelegate {
    func didSelectItem(at indexPath: Int, imgArr: [String?]) {
        let image = imgArr[indexPath]
        if image != nil {
            let imgString = image!
            let vc = DownloadChatImgVC.instantiate(imageString: imgString)
            vc.modalPresentationStyle = .fullScreen
            vc.isFromHomeVc = true
            vc.completion = {
                
            }
            self.navigationController?.present(vc, animated: true)
            print("Selected:", imgString)
        }
    }
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        switch action {
         case .like:
            let post = posts[sender.tag]
            likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike", at: sender.tag)
         case .comment:
            goToCommentVC(index: sender.tag)
         case .article:
            let articleContent = posts[sender.tag].postDocuments?[0] ?? ""
            self.openSafari(strURL: articleContent)
            //self.openArticle(strURL: articleContent)
         case .edit:
            openEditPost(sender)
            
         case .delete:
 //           presentAlertWithAction(title: "Delete", message: "Do you want to Delete this Post") { [weak self] in self?.deletePost(sender) }
            break
         default:
//             shareItemIndex = sender.tag
            break
         }
    }
}

extension UserProfileVC {
    func likePost(postId: Int, status: String, action: String, at: Int) {
        showActivity()
        let param: AFParameters = [ selectedTab.likePostKey: postId,
                                    "created_by_id":  myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.likePostServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            self.hideActivity()
            if error == 0 {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.reactionTblVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.reactionTblVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func goToCommentVC(index: Int) {
        IQKeyboardManager.shared.isEnabled = false
        let homePost = posts[index]
//        updateSpecificPost = homePost.id
//        let link = homePost.content?.link
        
        if homePost.postVideo != "" && homePost.postVideo != nil {//Video
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postDocuments?.count ?? 0 > 0 {//Document
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.datumPostImage!.count > 0 {//Image
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else {//Text
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // && post.postDocument == nil
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .simpleText
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] {//Video
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .video
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        } else if homePost.postDocument != "" && homePost.postImage == []{ //document Cell
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .article
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        } else { // Image Cell
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .image
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        }
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
    
    func openEditPost(_ sender: UIButton) {
        let postVC = StoryboardRouter.postVC()
        postVC.mode = .edit
        postVC.postType = returnPostType(post: posts[sender.tag])
        postVC.data = posts[sender.tag]
        navigationController?.pushViewController(postVC, animated: true)
    }
    func returnPostType(post: DashboardItem) -> PostType {
        if !post.datumPostImage!.isEmpty { return .image }
        else if post.postVideo != nil { return .video }
        else if post.postDocument != nil { return .article }
        else { return .simpleText }
    }
    
    @objc func handleShare(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.posts[sender.tag].id ?? 0
        vc.type = .post
        vc.modalPresentationStyle = .popover
//        vc.completion = {
//            self.showToast(message: "Successfully Shared with desired Connection")
//        }
        self.present(vc, animated: true)
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

extension UserProfileVC: RefreshUpdateable {
    
    func refresh(homeStatus: Bool) {
        selectedTab = .posts
        fetchUserDetailsData()
        getPosts(offSet: 1)
    }

}

extension UserProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.reactionTblVw {
            if self.Is_Reaction {
                if reactions.count <= 2 {
                    return reactions.count
                } else {
                    return 2
                }
            } else {
                if posts.count <= 2 {
                    return posts.count
                } else {
                    return 2
                }
            }
//        } else {
//            profileSettings.count
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = posts.count
        if indexPath.row + 1 == count && !stopAPICall && count > 9 {
            getPosts(offSet: indexPath.row + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Is_Reaction {
            let cell: ReactionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.descriptionBaseVw.layer.cornerRadius = 8.0
            cell.openVideoBtn.isHidden = true
            let obj = reactions[indexPath.row]
            
            if obj.type!.elementsEqual("post") {
                if obj.isPostLike == 0 {
                    cell.likeImgVw.image = UIImage(named: "Like")
                } else {
                    cell.likeImgVw.image = UIImage(named: "like_selected")
                }
            } else {   //news
                if obj.isNewsLike == 0 {
                    cell.likeImgVw.image = UIImage(named: "Like")
                } else {
                    cell.likeImgVw.image = UIImage(named: "like_selected")
                }
            }
            
            cell.gotoProfileBtn.tag = indexPath.row
            cell.gotoProfileBtn.addTarget(self, action: #selector(goToReactionProfileTapped(_:)), for: .touchUpInside)

            if  obj.datumPostImage == [] && obj.postVideo == "" && obj.postDocument == "" {
                //==> Text Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"
                
//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                cell.docView.isHidden = true
                cell.postImg.isHidden = true
                cell.videoView.isHidden = true
                cell.textView.isHidden = false
                
                return cell
                
            }
            else if obj.postVideo != "" && obj.postDocument == "" && obj.datumPostImage == [] {
                //==> Video Cell...

                cell.openVideoBtn.isHidden = false
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                cell.docView.isHidden = true
                cell.postImg.isHidden = true
                cell.videoView.isHidden = false
                cell.textView.isHidden = true
                
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: obj.postVideo ?? "",ratio: .resize)
                cell.videoView.stop()
                
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.openVideoBtn.tag = indexPath.row

                return cell
                
            }
            else if obj.postDocument != "" && obj.datumPostImage == [] {
                //==> Document Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                
                cell.docView.isHidden = false
                cell.postImg.isHidden = true
                cell.videoView.isHidden = true
                cell.textView.isHidden = true
                return cell
            }
            else if obj.datumPostImage!.count > 0 {
                //==> Image Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                cell.docView.isHidden = true
                cell.postImg.isHidden = false
                cell.videoView.isHidden = true
                cell.textView.isHidden = true
                
                cell.setImages(imageUrl: obj.datumPostImage)
                
                return cell
            } else {
                return cell
            }
        }
        else {
            let homePost = posts[indexPath.row]
            
            if homePost.postVideo != "" && homePost.postVideo != nil {//Video
                let cell: HomeVideo = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                
                cell.delegate = self
                cell.uiData(dataMaper: homePost)
                
                cell.sharedBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.openVideoBtn.tag = indexPath.row
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resizeAspectFill)
                cell.videoView.stop()
                cell.videoView.isHidden = false

                return cell
            } else if homePost.postDocuments?.count ?? 0 > 0 {//Document
                let cell: HomeUrl = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.backgroundColor = UIColor(hex: "#F8F6F8")
                cell.delegate = self
                cell.uiData(homePost: homePost)
                cell.likeBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.sharedBtn.tag = indexPath.row
                cell.openArticleBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)

                return cell
            } else if homePost.datumPostImage!.count > 0 {//Image
                let cell: HomeImage = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.backgroundColor = UIColor(hex: "#F8F6F8")
                cell.uiData(dataMaper: homePost)
                cell.delegate = self
                cell.delegateDidSelect = self
                cell.parentViewController = self

                cell.likeButton.tag = indexPath.row
                cell.commentButton.tag = indexPath.row
                cell.shareButton.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)

                return cell
            } else {//Text
                let cell: HomeText = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.detailsView.layer.cornerRadius = 13
                cell.delegate = self
                cell.uiData(dataMaper: homePost)
                
                cell.shareBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
//                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                
                return cell
            }
            
//            if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" {
//                let cell: HomeText = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.detailsView.layer.cornerRadius = 13
//                cell.delegate = self
//                cell.uiData(dataMaper: homePost)
//                
//                cell.shareBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.likeBtn.tag = indexPath.row
//                cell.goToProfileBtn.tag = indexPath.row
//                cell.reportBtn.tag = indexPath.row
////                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                
//                return cell
//                
//            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] { //Video Cell
//                let cell: HomeVideo = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                
//                cell.delegate = self
//                cell.uiData(dataMaper: homePost)
//                
//                cell.sharedBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.likeBtn.tag = indexPath.row
//                cell.goToProfileBtn.tag = indexPath.row
//                cell.reportBtn.tag = indexPath.row
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
////                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//                cell.openVideoBtn.tag = indexPath.row
//                cell.videoView.backgroundColor = .black
//                cell.videoView.configure(url: homePost.postVideo!,ratio: .resizeAspectFill)
//                cell.videoView.stop()
//                cell.videoView.isHidden = false
//
//                return cell
//                
//            } else if homePost.postDocument != "" && homePost.postImage == [] { //document Cell
//                
//                let cell: HomeUrl = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.delegate = self
//                cell.uiData(homePost: homePost)
//                cell.likeBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.sharedBtn.tag = indexPath.row
//                cell.openArticleBtn.tag = indexPath.row
//                cell.goToProfileBtn.tag = indexPath.row
//                cell.reportBtn.tag = indexPath.row
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
////                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//
//                return cell
//            } else if homePost.postImage!.count > 0 { //Image Cell
//
//                let cell: HomeImage = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.uiData(dataMaper: homePost)
//                cell.delegate = self
//                cell.delegateDidSelect = self
//                cell.parentViewController = self
//
//                cell.likeButton.tag = indexPath.row
//                cell.commentButton.tag = indexPath.row
//                cell.shareButton.tag = indexPath.row
//                cell.goToProfileBtn.tag = indexPath.row
//                cell.reportBtn.tag = indexPath.row
//                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
////                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//
//                return cell
//            } else {
//                let cell = UITableViewCell()
//                return cell
//            }
        }
        
        
//        if tableView == self.reactionTblVw {
//            if Is_Reaction {
//                let cell: ReactionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                return cell
//            }
//            else {
//
//
////                switch contents[indexPath.item] {
////                case .text(let text, _):
////                    let cell: TextViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
////                cell.delegate = self
////                cell.text = text
////                    return cell
////                case .image(let url, let image):
////                    let cell: PostImageViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
////                cell.delegate = self
////                cell.data = (index: indexPath.item, url: url, image: image)
////                cell.mode = mode
////                    return cell
////                case .video(_, let image):
////                    let cell: PostImageViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
////                cell.delegate = self
////                cell.video = (index: indexPath.item, thumbnail: image)
////                cell.mode = mode
////                    return cell
////                case .document(let url):
////                    let cell: PostDocumentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
////                cell.delegate = self
////                cell.content = (index: indexPath.item, url: url)
////                cell.mode = mode
////                    return cell
////                }
//
//
//                let homePost = posts[indexPath.row]
//                let link = posts[indexPath.row].content?.link
//    //
//                if  homePost.postImage!.isEmpty && homePost.postVideo == nil && link == nil { //&& homePost.postDocument == nil {
//                    let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.detailsView.layer.cornerRadius = 13
////                    cell.delegate = self
//                    cell.uiData(dataMaper: homePost)
//    //                cell.seeMore = (row: indexPath.row, lines: postSeeMore[indexPath.row]?.lines ?? 1, enabled: postSeeMore[indexPath.row]?.enabled ?? false)
//    //
//    //                cell.openProfile.tag = indexPath.row
//    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//    //                cell.openProfile.addGestureRecognizer(tapGesture)
//    //                cell.openProfile.isUserInteractionEnabled = true
//                    cell.shareBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//    //                cell.moreOption.tag = indexPath.row
//    //                cell.isConnectedBtn.tag = indexPath.row
//                    cell.likeBtn.tag = indexPath.row
////                    self.objectId = homePost.id
////                    self.type = .post
////                    cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//    //                cell.shouldSeeMore = { [weak self] index in self?.shouldSeeMoreLess(index: index) }
//                    return cell
//
//    //            } else if homePost.postVideo != nil && link == nil { //Video Cell
//    //                let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
//
//    //                cell.delegate = self
//    //                cell.uiData(dataMaper: homePost)
//    //                cell.isConnectedBtn.tag = indexPath.row
//    //                cell.seeMore = (row: indexPath.row, lines: postSeeMore[indexPath.row]?.lines ?? 1, enabled: postSeeMore[indexPath.row]?.enabled ?? false)
//    //
//    //                cell.openProfile.tag = indexPath.row
//    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//    //                cell.openProfile.addGestureRecognizer(tapGesture)
//    //                cell.openProfile.isUserInteractionEnabled = true
//    //                cell.sharedBtn.tag = indexPath.row
//    //                cell.commentBtn.tag = indexPath.row
//    //                cell.isConnectedBtn.tag = indexPath.row
//    //                cell.likeBtn.tag = indexPath.row
//    //                cell.moreOption.tag = indexPath.row
//    //                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//    //                cell.isConnectedBtn.applyGradient(colors: [UIColor.clear.cgColor,UIColor.clear.cgColor])
//    //                cell.selectionStyle = .default
//    //                cell.openProfile.tag = indexPath.row
//    //                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//    //                cell.openVideoBtn.tag = indexPath.row
//    //                cell.videoView.backgroundColor = .black
//    //                cell.videoView.configure(url: homePost.postVideo!,ratio: .resize)
//    //                cell.videoView.stop()
//    //                cell.videoView.isHidden = false
//    //                cell.shouldSeeMore = { [weak self] index in self?.shouldSeeMoreLess(index: index) }
//    //                return cell
//
//    //            } else if homePost.postDocument != nil || link != nil { //document Cell
//    //                let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
//    //                cell.delegate = self
//    //                cell.uiData(homePost: homePost)
//    //                cell.isConnectedBtn.tag = indexPath.row
//    //
//    //                cell.likeBtn.tag = indexPath.row
//    //                cell.commentBtn.tag = indexPath.row
//    //                cell.sharedBtn.tag = indexPath.row
//    //                cell.openArticleBtn.tag = indexPath.row
//    //                cell.moreOption.tag = indexPath.row
//    //                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//    //                cell.openProfile.tag = indexPath.row
//    //                cell.didTapURL = { [weak self] url in
//    //                    self?.present(SFSafariViewController(url: url), animated: true, completion: nil)
//    //                }
//    //
//    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//    //                cell.openProfile.addGestureRecognizer(tapGesture)
//    //                cell.openProfile.isUserInteractionEnabled = true
//
//    //                return cell
//                } else if homePost.postImage!.count > 0 { //Image Cell
//    //
//                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.uiData(dataMaper: homePost)
//    //                cell.seeMore = (row: indexPath.row, lines: postSeeMore[indexPath.row]?.lines ?? 1, enabled: postSeeMore[indexPath.row]?.enabled ?? false)
////                    cell.delegate = self
//    //
//                    cell.likeButton.tag = indexPath.row
//                    cell.commentButton.tag = indexPath.row
//    //                cell.navigateToDetail.tag = indexPath.row
//    //                cell.doubleLike.tag = indexPath.row
//                    cell.shareButton.tag = indexPath.row
//    //                cell.moreOption.tag = indexPath.row
////                    self.objectId = homePost.id
////                    self.type = .post
////                    cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//    //
//    //                cell.openProfile.tag = indexPath.row
//    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//    //                cell.openProfile.addGestureRecognizer(tapGesture)
//    //                cell.openProfile.isUserInteractionEnabled = true
//    //
//    //                let doubleTap = UITapGestureRecognizer(target: self, action:#selector(likeByDoubleClick(gesture:)))
//    //                doubleTap.numberOfTapsRequired = 2
//    //                cell.doubleLike.tag = indexPath.row
//    //                cell.doubleLike.addGestureRecognizer(doubleTap)
//    //                cell.shouldSeeMore = { [weak self] index in self?.shouldSeeMoreLess(index: index) }
//
//                    return cell
//                } else {
//                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    return cell
//                }
//
//            }
//        }
//        else {
//            switch profileSettings[indexPath.item] {
//            case .profile(let profile):
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
//                cell.titleLbl.text = profile.title
//                cell.cellImage.image = profile.userImage
//                return cell
//            case .posts(let posts):
//                return tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            case .custom(let identifier):
//                return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.Is_Reaction {
            return UITableView.automaticDimension
        } else {
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
}

extension UserProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.reactionTblVw {
            print("none")
        }
        else {
            switch profileSettings[indexPath.row] {
            case .profile(let profile):
                didSelectProfileItem(profile)
            default:
                break
            }
        }
    }
    
    private func didSelectProfileItem(_ item: ProfileData) {
        
        switch item.title {
        case "Notification":
            navigateToNotifiations()
        case "Edit Profile":
            let editProfile = StoryboardRouter.editUserProfile()
            editProfile.userDetail = userDetail
            navigationController?.pushViewController(editProfile, animated: true)
        case "Settings":
            let settings = StoryboardRouter.userSettings()
            navigationController?.pushViewController(settings, animated: true)
        default:
            break
        }
    }
}

extension UserProfileVC {
    
    func addConnection(id: Int) {
        profileButtons[0].isUserInteractionEnabled.toggle()
        ProfileManager.shared.addConnection(id: id) { [weak self] title, message in
            guard let self = self else { return }
            self.profileButtons[0].isUserInteractionEnabled.toggle()
            if title == "Failure" || title == "Error" {
                self.presentAlert(title, message, nil)
            } else {
                self.presentAlertWithAction(title: title, message: message) { self.navigationController?.popViewController(animated: true) }
            }
        }
    }
    
    func updateConnection() {
        guard let connectionId = connectionDetail?.connectionID ?? userDetail?.connectionID else { return }
        profileButtons[0].isUserInteractionEnabled.toggle()
        ProfileManager.shared.updateConnection(id: connectionId) { [weak self] title, message in
            guard let self = self else { return }
            self.profileButtons[0].isUserInteractionEnabled.toggle()
            if title == "Failure" || title == "Error" {
                self.presentAlert(title, message, nil)
            } else {
                self.presentAlertWithAction(title: title, message: message) { self.navigationController?.popViewController(animated: true) }
            }
        }
    }
    
    func deleteConnection(id: Int) {
        
        let endPoint = EndPoints.deleteConnection + "\(id)/"
        showActivity()
        
        NetworkManagerr.request(endPoint, method: .delete) { (response) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        self.presentAlert("Success", "Your Connection is Remove Successfully", nil)
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            }
        }
    }
    
    func blockConnection(id: Int) {
        
        let parameters: AFParameters = [ "receiver_id": id,
                                         "sender_id" : myUserDefaults.userId,
                                         "status": "deleted" ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.blockConnection, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
              
                self.view.isUserInteractionEnabled = true
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        self.presentAlert("Success", "Connection is Block Successfully", nil)
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
}

//extension UserProfileVC {
//    
//    private func convertEvaUserToUser(_ user: EvaUser) -> User {
//        User(id: user.id ?? 0, firstName: user.firstName ?? "", email: user.email ?? "", uniqueCode: user.uniqueCode, lastName: user.lastName, username: user.username ?? "none",
//             dateOfBirth: user.dateOfBirth, userImage: user.username, city: user.city, country: user.country, bioData: user.bioData, type: user.type,
//             status: user.status, address: user.address, companyName: user.companyName, field: user.field, designation: user.designation,
//             isConnected: user.isConnected?.rawValue, isReceiver: user.isReceiver == "true", isOnline: false, lastOnlineDateTime: nil, connectionID: user.connectionID,
//             isNotifications: user.is_notifications)
//    }
//    
//}
