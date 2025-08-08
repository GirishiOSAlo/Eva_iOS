//
//  SearchHome.swift
//  EvaConnect
//
//  Created by Metis on 14/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import SVProgressHUD
import Alamofire
//import URLEmbeddedView
import SDWebImage
import AVKit

class SearchHome: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var newPostBtn: UIButton!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet var MainVideoView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var postsTableView: UITableView! {
        didSet {
            
        }
    }
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var totalRecode: UILabel!
    
    //MARK: VARIABLES
    
    //ModelArray
    var dashBoardModelArray: [DashboardItem] = []
    var offSetChanger = 0
    let minPageLimit = 10
    var shareViewObj: ShareView!
    var getShareIndex : Int?
    var isShareViewShown: Bool = false
    var urlString: String?
    var mainIndexPathCustom: IndexPath?
    let tabs = ["Posts", "Events", "Jobs", "News"]
    let likeManager = LikeManager()
    var selectedIndexx = -1
    var searchText: String!
    var isSearchFieldEmpty = false
    var articleContent: String?
    var selectedTab: HomeTabs = .posts
    var stopAPICall  = false
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
        addObservers()
        //selectedIndexx = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedTab = .posts
        mainCollectionView.contentInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        //selectedIndexx = 1
        dashBoardModelArray.removeAll()
        getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "post")
        postsTableView.reloadData()
        blurView.isHidden = true
        //self.mainIndexPathCustom = IndexPath(item: selectedIndexx, section: 0)
        UIView.transition(with: mainCollectionView, duration: 0.9, options: .transitionCrossDissolve, animations: {self.mainCollectionView.reloadData()}, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let inviteConnections = segue.destination as? InviteConnectionVC, let (id, type) = sender as? (Int, TypePostEnum) {
            inviteConnections.objectID = id
            inviteConnections.type = type
            inviteConnections.invitationType = .postShare
        }
        
        if let textPostDetails = segue.destination as? TextPostDetailVC, let postId = sender as? Int {
            textPostDetails.postId = postId
            textPostDetails.delegate = self
            
        }
        
        if let otherComments = segue.destination as? OtherCommentVC, let postId = sender as? Int {
            otherComments.postId = postId
            otherComments.delegate = self
        }
        
        if let urlComment = segue.destination as? UrlCommentVC, let postId = sender as? Int {
            urlComment.postId = postId
            urlComment.delegate = self
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch? = touches.first
        if touch?.view == MainVideoView {
            hideShareView()
        }
        else if touch?.view == blurView {
            newPostBtn.setBackgroundImage(#imageLiteral(resourceName: "addNew"), for: .normal)
            blurView.isHidden = true
        }
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
}
//MARK: IBOutlet Action
extension SearchHome {
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: CollectionView Delegates
extension SearchHome: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTabsCell", for: indexPath) as! HomeTabsCell
        if selectedTab.selectedIndex == indexPath.row {
            cell.tab.setTitleColor(.black, for: .normal)
            cell.tab.titleLabel?.font = UIFont(defaultFontStyle: .bold,size: 12)
            cell.tab.setTitleColor(Constants.AppColorLiteral.signUpNew, for: .normal)
        } else {
            cell.tab.titleLabel?.font = UIFont(defaultFontStyle: .regular,size: 12)
            cell.tab.setTitleColor(.darkGray, for: .normal)
        }
        cell.tab.layer.cornerRadius = 0
        cell.tab.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
        cell.tab.tag = indexPath.row
        cell.tab.addTarget(self, action: #selector(tabDidChange(_:)), for: .touchUpInside)
        cell.tab.setTitle(tabs[indexPath.row], for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset: CGFloat = 3
        let width = mainCollectionView.frame.width * 0.32
        let height = mainCollectionView.frame.height
        return CGSize(width: width - inset, height: height - inset)
    }
}

//MARK: TEXTFIELD METHOD
extension SearchHome {
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if !textfield.text!.isEmpty || textfield.text!.count != 0 {
            
            switch selectedTab {
            case .posts, .industryPost:
                dashBoardModelArray.removeAll()
                getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "post")
                
            case .events, .industryEvents:
                dashBoardModelArray.removeAll()
                getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "event")
                
            case .jobs, .industryJobs:
                dashBoardModelArray.removeAll()
                getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "job")
            case .news:
                dashBoardModelArray.removeAll()
                getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "news")
                postsTableView.reloadData()
                
            }
            //postsTableView.reloadData()
            postsTableView.isHidden = false
        }
        else if textfield.text!.isEmpty {
            isSearchFieldEmpty = true
            dashBoardModelArray.removeAll()
            totalRecode.text =  "Found \(0) result"
            postsTableView.reloadData()
            postsTableView.isHidden = true
        }
        
    }
}

//MARK: TABLEVIEW DELEGATES
extension SearchHome: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedTab {
        case .posts, .industryPost:
            if dashBoardModelArray.count != 0 {
                let homePost = dashBoardModelArray[indexPath.row]
                if homePost.type == .post {
                    if homePost.postVideo != "" {
                        print("Video")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 356.0
                        return height
                    } else if homePost.postDocuments?.count ?? 0 > 0 {
                        print("Document")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 231.0
                        return height
                    } else if homePost.datumPostImage!.count > 0 {
                        print("Images")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 416.0
                        return height
                    } else {
                        print("Text")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 195.0
                        return height
                    }
//                    //image cell with text
//                    if homePost.postImage!.count > 0  {
//                        return UITableView.automaticDimension
//                    }
//                    
//                    //document cell with text
//                    else if homePost.postDocument != nil {
//                        return  390.0
//                    }
//                   
//                    //video cell with text
//                    else if homePost.postVideo != nil {
//                        return UITableView.automaticDimension
//                    }
//                    else {
//                        //Simple Text cell
//                        return 220.0
//                        
//                    }
                }
            }
        case .events, .industryEvents:
            return 377
        case .jobs, .industryJobs:
            return 222
        case .news:
            return UITableView.automaticDimension
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch selectedTab {
        case .posts, .industryPost:
            
            if dashBoardModelArray.count != 0 {
                let homePost = dashBoardModelArray[indexPath.row]
                if homePost.type == .post {
                    if homePost.postVideo != "" {
                        print("Video")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 356.0
                        return height
                    } else if homePost.postDocuments?.count ?? 0 > 0 {
                        print("Document")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 231.0
                        return height
                    } else if homePost.datumPostImage!.count > 0 {
                        print("Images")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 416.0
                        return height
                    } else {
                        print("Text")
                        let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                        let height = lblHeight + 195.0
                        return height
                    }
//                    //image cell with text
//                    if homePost.postImage!.count > 0  {
//                        return UITableView.automaticDimension
//                    }
//                    
//                    //document cell
//                    else if homePost.postDocument != nil {
//                        return  390.0
//                    }
//                    
//                    //video cell with text
//                    else if homePost.postVideo != nil {
//                        return UITableView.automaticDimension
//                        
//                    }
//                    //Simple Text cell
//                    else {
//                        return 220.0
//                        
//                    }
                }
            }
            
        case .events, .industryEvents:
            return 377
        case .jobs, .industryJobs:
            return 222
        case .news:
            return UITableView.automaticDimension
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dashBoardModelArray.count != 0 {
            return dashBoardModelArray.count
        } else {
            return  0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[indexPath.row]
            if bindModelData.type == .post {
                
                //Video Cell
                if bindModelData.postVideo != nil {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideo.id(), for: indexPath) as! HomeVideo
                    
                    cell.delegate = self
                    cell.uiData(dataMaper: bindModelData)
                    cell.isConnectedBtn.tag = indexPath.row
                    switch cell.configureConnectedStatus(dataMaper: bindModelData) {
                    case .createConnect:
                        cell.isConnectedBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
                    case .accept:
                        cell.isConnectedBtn.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
                    default:
                        break
                    }
//                    cell.openProfile.tag = indexPath.row
                    let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//                    cell.openProfile.addGestureRecognizer(tapGesture)
//                    cell.openProfile.isUserInteractionEnabled = true
                    cell.sharedBtn.tag = indexPath.row
                    cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.commentBtn.tag = indexPath.row
                    cell.isConnectedBtn.tag = indexPath.row
                    cell.likeBtn.tag = indexPath.row
//                    cell.moreOption.tag = indexPath.row
                    
                    cell.isConnectedBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                    cell.isConnectedBtn.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
                    cell.isConnectedBtn.applyGradient(colors: [UIColor.clear.cgColor,UIColor.clear.cgColor])
                    cell.selectionStyle = .default
//                    cell.openProfile.tag = indexPath.row
                    cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                    cell.openVideoBtn.tag = indexPath.row
                    cell.videoView.backgroundColor = .black
                    cell.videoView.configure(url: bindModelData.postVideo ?? "",ratio: .resizeAspect)
                    cell.videoView.stop()
                    //cell.videoView.addSubview(cell.openVideoBtn)
                    cell.videoView.isHidden = false
                    //cell.openVideoBtn.isEnabled = false
                    
                    return cell
                    
                }
                //document Cell
                else if bindModelData.postDocument != nil {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeUrl.id(), for: indexPath) as! HomeUrl
                    let regex = try! NSRegularExpression(pattern: "<a[^>]+href=\"(.*?)\"[^>]*>")
                    let range = NSMakeRange(0, bindModelData.content!.count)
                    let matches = regex.matches(in: bindModelData.content!, range: range)
                    for match in matches {
                        let htmlLessString = (bindModelData.content! as NSString).substring(with: match.range(at: 1))
                        print(htmlLessString)
                        urlString = htmlLessString
                    }
                    
                    cell.delegate = self
                    cell.uiData(homePost: bindModelData)
//                    cell.isConnectedBtn.tag = indexPath.row
//                    switch cell.configureConnectedStatus(dataMaper: bindModelData) {
//                    case .createConnect:
//                        cell.isConnectedBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
//                    case .accept:
//                        cell.isConnectedBtn.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
//                    default:
//                        break
//                    }
                    cell.sharedBtn.tag = indexPath.row
                    cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.likeBtn.tag = indexPath.row
                    cell.likeBtn.addTarget(self, action:#selector(likePost(sender:)), for: .touchUpInside)
                    cell.commentBtn.tag = indexPath.row
//                    cell.openProfile.tag = indexPath.row
//                    cell.moreOption.tag = indexPath.row
//                    let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
//                    cell.openProfile.addGestureRecognizer(tapGesture)
//                    cell.openProfile.isUserInteractionEnabled = true
//                    cell.selectionStyle = UITableViewCell.SelectionStyle.default
//                    cell.isConnectedBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
//                    cell.isConnectedBtn.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
//                    cell.isConnectedBtn.applyGradient(colors: [UIColor.clear.cgColor,UIColor.clear.cgColor])
                    return cell
                }
                //Image Cell
                else if bindModelData.postDocuments!.count > 0 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeImage.id(), for: indexPath) as! HomeImage
                    
                    cell.uiData(dataMaper: bindModelData)
                    cell.delegate = self
                    
                    cell.likeButton.tag = indexPath.row
                    cell.commentButton.tag = indexPath.row
                    cell.shareButton.tag = indexPath.row
                    cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.openProfile.tag = indexPath.row
                    let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
                    cell.openProfile.addGestureRecognizer(tapGesture)
                    cell.openProfile.isUserInteractionEnabled = true
                    let doubleTap = UITapGestureRecognizer(target: self, action:#selector(likeByDoubleClick(gesture:)))
                    doubleTap.numberOfTapsRequired = 2
                    
                    return cell
                }
                //Text Cell
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeText.id(), for: indexPath) as! HomeText
                    cell.delegate = self
                    cell.uiData(dataMaper: bindModelData)
                    cell.isConnectedBtn.tag = indexPath.row
//                    switch cell.configureConnectedStatus(dataMaper: bindModelData) {
//                    case .createConnect:
//                        cell.isConnectedBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
//                    case .accept:
//                        cell.isConnectedBtn.addTarget(self, action:#selector(updateConnectionFunction(sender:)), for: .touchUpInside)
//                    default:
//                        break
//                    }
                    cell.openProfile.tag = indexPath.row
                    let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
                    cell.openProfile.addGestureRecognizer(tapGesture)
                    cell.openProfile.isUserInteractionEnabled = true
                    cell.shareBtn.tag = indexPath.row
                    cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.commentBtn.tag = indexPath.row
                    cell.likeBtn.tag = indexPath.row
                    cell.moreOption.tag = indexPath.row
                    cell.isConnectedBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                    cell.isConnectedBtn.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
                    cell.isConnectedBtn.applyGradient(colors: [UIColor.clear.cgColor,UIColor.clear.cgColor])
                    cell.selectionStyle = UITableViewCell.SelectionStyle.default
                    return cell
                }
            }
            
            else if bindModelData.type == .job {
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeJob.id(), for: indexPath) as! HomeJob
                
                cell.uiData(dataMaper: bindModelData)
                cell.delegate = self
                if LoggedUserDetails.shared.user!.type == "user" {
                    cell.applyBtn.isHidden = false
                    cell.applyBtn.tag = indexPath.row
                    cell.applyBtn.addTarget(self, action:#selector(openJobVCPost(sender:)), for: .touchUpInside)
                }
                else {
                    cell.applyBtn.isHidden = true
                }
                cell.sharedBtn.tag = indexPath.row
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.moreOption.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.commentBtn.addTarget(self, action:#selector(navigateToJobComments(_:)), for: .touchUpInside)
                cell.likeBtn.addTarget(self, action:#selector(jobLikePost(sender:)), for: .touchUpInside)
                return cell
                
            }
            
            else if bindModelData.type == .event {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeEvent.id(), for: indexPath) as! HomeEvent
                cell.uiData(dataMaper: bindModelData)
                
//                if LoggedUserDetails.shared.user!.id != bindModelData.user!.id {
//                    cell.attendingBtn.isHidden = false
//                    cell.attendingBtn.tag = indexPath.row
//                    cell.attendingBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//                }
//                else {
//                    cell.attendingBtn.isHidden = true
//                }
//                cell.sharedBtn.tag = indexPath.row
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.moreOption.tag = indexPath.row
//                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeNewz.id(), for: indexPath) as! HomeNewz
                cell.uiData(dataMaper: bindModelData)
                cell.likeBtn.tag = indexPath.row
                cell.likeBtn.addTarget(self, action:#selector(newsLikePost(sender:)), for: .touchUpInside)
                cell.commentBtn.tag = indexPath.row
                cell.commentBtn.addTarget(self, action:#selector(newsCommentVCPost(sender:)), for: .touchUpInside)
                cell.openURl.tag = indexPath.row
                cell.openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
                cell.sharedBtn.tag = indexPath.row
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch selectedTab {
        case .posts, .industryPost:
            if indexPath.row + 1 == dashBoardModelArray.count {
                if !stopAPICall {
                getAllDashBoardPost(limit: minPageLimit, offSet: indexPath.row+1, searchText: searchField.text!, filter: "post")
                }
            }
            else if indexPath.row == dashBoardModelArray.index(before: indexPath.row-1){
                SVProgressHUD.show()
            }
            break
        case .events, .industryEvents:
            if indexPath.row + 1 == dashBoardModelArray.count {
                if !stopAPICall {
                getAllDashBoardPost(limit: minPageLimit, offSet: indexPath.row+1, searchText: searchField.text!, filter: "event")
                }
            }
            else if indexPath.row == dashBoardModelArray.index(before: indexPath.row-1){
                SVProgressHUD.show()
            }
            break
        case .jobs, .industryJobs:
            if indexPath.row + 1 == dashBoardModelArray.count {
                if !stopAPICall {
                    getAllDashBoardPost(limit: minPageLimit, offSet: indexPath.row+1, searchText: searchField.text!, filter: "job")
                    
                }
            }
            else if indexPath.row == dashBoardModelArray.index(before: indexPath.row-1){
                SVProgressHUD.show()
            }
            break
        case .news:
            if indexPath.row + 1 == dashBoardModelArray.count {
                if !stopAPICall {
                getAllDashBoardPost(limit: minPageLimit, offSet: indexPath.row+1, searchText: searchField.text!, filter: "news")
                }
            }
            else if indexPath.row == dashBoardModelArray.index(before: indexPath.row-1){
                SVProgressHUD.show()
            }
            break
        }
    }
}

//MARK: NETWORK CALLING
extension SearchHome {
    
    func getAllDashBoardPost(limit: Int, offSet: Int, searchText: String, filter: String) {
        
        let param: AFParameters = [
            "user_id" :  myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "search_key":searchText,
            "filter": filter
        ]
        
        let limit = "?limit=\(limit)"
        let offset = "&offset=\(offSet)"
        let endPoint = EndPoints.searhDashboard + limit + offset
        NetworkManagerr.request(endPoint, method: .post, parameters: param) { (response) in
            self.postsTableView.refreshControl?.endRefreshing()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let dashboardPostsRoot = try jsonDecoder.decode(DashboardItemRoot.self, from: response.data!)
                    if dashboardPostsRoot.error == false {
                        if self.searchField.text!.isEmpty {
                            self.dashBoardModelArray.removeAll()
                            self.totalRecode.text =  "Found \(0) result"
                            self.noRecordLbl.isHidden = false
                        } else {
                            for i in dashboardPostsRoot.data ?? [] {
                                self.dashBoardModelArray.append(i)
                            }
                            if self.dashBoardModelArray.isEmpty || self.dashBoardModelArray.count <= 0{
                                self.totalRecode.text =  "Found \(0) result"
                                self.stopAPICall = true
                                self.noRecordLbl.isHidden = false
                            } else {
                                self.totalRecode.text = "Found \(self.dashBoardModelArray.count)"
                                self.noRecordLbl.isHidden = true
                            }
                        }
                        
                        
                        self.postsTableView.reloadData()
                    }
                } catch {
                    self.presentAlert("Error", nil, error)
                }
            } else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
    
    
    func deletePost(postId: Int) {
        
        let url = "\(EndPoints.deletePost)\(postId)/"
        
        
        //showActivity()
        let param: AFParameters = [ "modified_by_id" :myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "modified_datetime":Date().toString(formatter: .standardDateWithTime),
                                    "status":"deleted"
        ]
        
        NetworkManagerr.request(url, method: .delete, parameters: param) {
            
            (response) in
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let result = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                if result.error == false{
                    self.reloadData()
                }
                else {
                    self.presentAlert("Error", nil, response.result.error)
                }
                
            }
            else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
    func deleteEvent(postId: Int) {
        
        let url = "\(EndPoints.deleteEvent)\(postId)/"
        
        
        let param: AFParameters = [ "modified_by_id" :myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "modified_datetime":Date().toString(formatter: .standardDateWithTime),
                                    "status":"deleted"
        ]
        
        NetworkManagerr.request(url, method: .delete, parameters: param) {
            
            (response) in
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let result = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                if result.error == false{
                    self.reloadData()
                }
                else {
                    self.presentAlert("Error", nil, response.result.error)
                }
                
            }
            else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
    func deleteJob(postId: Int) {
        
        let url = "\(EndPoints.deleteJob)\(postId)/"
        
        
        let param: AFParameters = [ "modified_by_id" :myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "modified_datetime":Date().toString(formatter: .standardDateWithTime),
                                    "status":"deleted"
        ]
        
        NetworkManagerr.request(url, method: .delete, parameters: param) {
            
            (response) in
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let result = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
                if result.error == false{
                    self.reloadData()
                }
                else {
                    self.presentAlert("Error", nil, response.result.error)
                }
                
            }
            else {
                self.presentAlert("Error", nil, response.result.error)
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
            SVProgressHUD.dismiss()
            if error == 0 {
                print(action)
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .post)
                
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .post)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            print(action)
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
        }
        
    }
    func likeJobPost(postId: Int, status: String, action: String, at: Int) {
        
        let param:Parameters = [
            "job_id" : postId,
            "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "status":status,
            "action":action
            
        ]
        
        self.view.isUserInteractionEnabled = false
        ApiCallerClass.jobLikePostServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            
            SVProgressHUD.dismiss()
            if error == 0 {
                print(action)
                
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .job)
                
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .job)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                
                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            print(action)
            print(error.localizedDescription)
            
            self.view.isUserInteractionEnabled = true
        }
        
    }
    func likeEventPost(postId: Int, status: String, action: String ,at: Int) {
        
        let param:Parameters = [
            "event_id" : postId,
            "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "status":status,
            "action":action
            
        ]
        
        self.view.isUserInteractionEnabled = false
        ApiCallerClass.eventLikePostServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            
            SVProgressHUD.dismiss()
            
            if error == 0 {
                print(action)
                
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .event)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                self.view.isUserInteractionEnabled = true
            }
            else {
                
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .event)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                
                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            print(action)
            print(error.localizedDescription)
            
            self.view.isUserInteractionEnabled = true
        }
    }
    func likeNewsPost(postId: Int, status: String, action: String, at: Int) {
        
        let param:Parameters = [
            "rss_news_id" : postId,
            "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "status":status,
            "action":action
            
        ]
        
        self.view.isUserInteractionEnabled = false
        ApiCallerClass.newsLikePostServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            
            SVProgressHUD.dismiss()
            
            if error == 0 {
                print(action)
                
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .news)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                self.view.isUserInteractionEnabled = true
            }
            else {
                
                self.dashBoardModelArray = self.likeManager.homeLikeManager(homePosts: self.dashBoardModelArray, indexAt: at, likeType: .news)
                let indexPath = IndexPath(item: at, section: 0)
                self.postsTableView.reloadRows(at: [indexPath], with: .none)
                
                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            print(action)
            print(error.localizedDescription)
            
            self.view.isUserInteractionEnabled = true
        }
    }
    func addConnection(otherID: Int, status: String) {
        let parameters: AFParameters = [
            "receiver_id" : otherID,
            "sender_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "status":status
        ]
        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.reloadData()
                    self.view.isUserInteractionEnabled = true
                }
                else {
                    // self.makeAlert(messageData:data?["message"] as! String)
                    self.view.isUserInteractionEnabled = true
                }
                
            } else {
                //self.makeAlert(messageData:response.data?["message"] as! String)
                SVProgressHUD.dismiss()
            }
        }
        
    }
    func updateConnection(otherID: Int, isDecline: Bool = false) {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myCurrentDate = formatter.string(from: currentDateTime)
        print(myCurrentDate)
        var parameters: AFParameters = [:]
        if isDecline == false {
            parameters =  [
                "modified_by_id":myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                "status":"active",//"deleted"
                "modified_datetime" : myCurrentDate
            ]
        }
        else {
            parameters =  [
                "modified_by_id":myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                "status":"decline",//"deleted"
                "modified_datetime" : myCurrentDate
            ]
        }
        let id = "\(otherID)/"
        NetworkManagerr.request(EndPoints.updateConnection+id, method: .patch, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.reloadData()
                    self.view.isUserInteractionEnabled = true
                }
                else {
                    //self.makeAlert(messageData: data?["message"])
                }
                
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}

//MARK: LAYOUT SETTING
extension SearchHome {
   
    func setLayOut() {
        blurView.isHidden = true
        MainVideoView.isHidden = true
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.registerCell(withType: HomeUrl.self)
        postsTableView.registerCell(withType: HomeText.self)
        postsTableView.registerCell(withType: HomeJob.self)
        postsTableView.registerCell(withType: HomeEvent.self)
        postsTableView.registerCell(withType: HomeImage.self)
        postsTableView.registerCell(withType: HomeVideo.self)
        postsTableView.registerCell(withType: HomeNewz.self)
        //mainCollectionView.registerClass(cellClass: HomeTabsCell.self)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.reloadData()
        mainCollectionView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        postsTableView.refreshControl = refresher
        searchField.text = searchText
    }
}

//MARK: CUSTOM FUNCTION
extension SearchHome {
    
    func scrollToTop() {
        
        let topIndex = IndexPath(row: 0, section: 0)
        postsTableView.reloadData()
        postsTableView.scrollToRow(at: topIndex, at: .top, animated: true)
        self.postsTableView.endUpdates()
    }
    
    @objc func reloadData() {
        
        switch selectedTab {
        case .posts, .industryPost:
            dashBoardModelArray.removeAll()
            getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "post")
            postsTableView.reloadData()
        case .events, .industryEvents:
            dashBoardModelArray.removeAll()
            getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "event")
            postsTableView.reloadData()
        case .jobs, .industryJobs:
            dashBoardModelArray.removeAll()
            getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "job")
            postsTableView.reloadData()
        case .news:
            dashBoardModelArray.removeAll()
            getAllDashBoardPost(limit: minPageLimit, offSet: 0, searchText: searchField.text!, filter: "news")
            postsTableView.reloadData()
        }
        
    }

    func hideShareView() {
        isShareViewShown = false
        UIView.animate(withDuration: Constants.MenuAnimationTime.menuViewAnimationTime, animations: {
            self.shareViewObj?.alpha = 0.0
        }) { (finsished) in
            self.MainVideoView?.isHidden = true
            self.shareViewObj?.isHidden = true
        }
    }
    
    @objc func tabDidChange(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            selectedTab = .posts
            reloadData()
            
        case 1:
            selectedTab = .events
            reloadData()
            
        case 2:
            selectedTab = .jobs
            reloadData()
            
        case 3:
            selectedTab = .news
            reloadData()
            
        default:
            break
        }
        
        sender.setTitleColor(Constants.AppColorLiteral.signUpNew, for: .normal)
        
        UIView.transition(with: mainCollectionView, duration: 0.9, options: .transitionCrossDissolve, animations: { self.mainCollectionView.reloadData()
        }, completion: nil)
        
    }
    
    @objc func showVideoView(sender: UIButton) {
        
        let bindModelData = dashBoardModelArray[sender.tag]
        configureVideoView(getUrl: bindModelData.postVideo)
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
   
    @objc func openingShare(sender: UIButton){
        getShareIndex = sender.tag
        MainVideoView?.isHidden = false
        shareViewObj?.isHidden = false
        isShareViewShown = true
        UIView.animate(withDuration: Constants.MenuAnimationTime.menuViewAnimationTime) {
            self.shareViewObj?.alpha = 1.0
        }
    }
    
   func setImageAction(image: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
    }
    
    @objc func openArticle() {
        if let urlString = articleContent, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            webVC.modalPresentationStyle = .formSheet
            present(webVC, animated: true, completion: nil)
        }
    }
    
    func openEditPost(_ sender: UIButton) {
        
        let textVC = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:
                                                                                "AddPostVC") as! AddPostVC
        //textVC.delegate = self
        textVC.mode = .edit
        switch selectedTab {
        case .posts:
            let id = dashBoardModelArray[sender.tag].id
            let type = returnPostType(post: dashBoardModelArray[sender.tag])
            textVC.postId = id ?? 0
            switch type {
            case .image:
                textVC.postType = .image
                
                self.navigationController?.pushViewController(textVC, animated: true)
            case .video:
                textVC.postType = .videoURL
                self.navigationController?.pushViewController(textVC, animated: true)
            case .article:
                textVC.postType = .article
                self.navigationController?.pushViewController(textVC, animated: true)
            case .simpleText:
                textVC.postType = .simpleText
                self.navigationController?.pushViewController(textVC, animated: true)
                
            }
            //deletePost(postId: id)
            break
        case .events:
//            let id = dashBoardModelArray[sender.tag].id
//            let event =  StoryboardRouter.createEvent()
//            event.eventId = id
//            event.mode = .edit
//            event.imageChanged = true
//            navigationController?.pushViewController(event, animated: true)
            break
        case .jobs:
            let id = dashBoardModelArray[sender.tag].id
            let editPostedJob = StoryboardRouter.createEditJobPost()
            editPostedJob.jobId = id
            editPostedJob.roleType = .edit
            // editPostedJob.delegate = self
            self.navigationController?.pushViewController(editPostedJob, animated: true)
            break
        default:
            break
            
        }
        
    }
    
    func returnPostType(post: DashboardItem) -> PostType {
        if post.datumPostImage!.count > 0 {
            return .image
        }
        else if post.postVideo != nil {
            return .video
        }
        else if post.postDocument != nil{
            return .article
        }
        else {
            return .simpleText
        }
    }
    
    func deletePost(_ sender: UIButton) {
            switch selectedTab {
            case .posts:
                let id = dashBoardModelArray[sender.tag].id ?? 0
                deletePost(postId: id)
                break
            case .events:
                let id = dashBoardModelArray[sender.tag].id ?? 0
                deleteEvent(postId: id)
                break
            case .jobs:
                let id = dashBoardModelArray[sender.tag].id ?? 0
                deleteJob(postId: id)
                break
            default:
                break
            }
            
        }
}

//MARK: Cell Actions
extension SearchHome {
    
    @objc func likeByDoubleClick(gesture: UIGestureRecognizer) {
        
        let tapImageView = gesture.view as! UIButton
        print("ButtonIndex\(tapImageView.tag)")
        let bindModelData = dashBoardModelArray[tapImageView.tag]
        if dashBoardModelArray.count != 0 {
            if bindModelData.isPostLike != nil {
                likePost(postId: bindModelData.id ?? 0, status: bindModelData.status ?? "", action: "unlike",at: tapImageView.tag)
            }
            else{
                likePost(postId: bindModelData.id ?? 0, status: bindModelData.status ?? "", action: "like",at: tapImageView.tag)
            }
        }
    }
    
    @objc func likePost(sender: UIButton) {
        
        print("ButtonIndex\(sender.tag)")
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[sender.tag]
            if bindModelData.isPostLike != nil {
                likePost(postId: bindModelData.id ?? 0, status: bindModelData.status ?? "", action: "unlike",at: sender.tag)
            }
            else {
                likePost(postId: bindModelData.id ?? 0, status: bindModelData.status ?? "", action: "like",at: sender.tag)
            }
        }
    }
    
    @objc func jobLikePost(sender: UIButton) {
        
//        if dashBoardModelArray.count != 0 {
//            let bindModelData = dashBoardModelArray[sender.tag]
//            if bindModelData.isJobLike != nil {
//                likeJobPost(postId: bindModelData.id, status: "active", action: "unlike",at: sender.tag)
//            }
//            else{
//                likeJobPost(postId: bindModelData.id, status: "active", action: "like",at: sender.tag)
//            }
//        }
    }
    
    @objc func eventLikePost(sender: UIButton) {
        
//        if dashBoardModelArray.count != 0 {
//            let bindModelData = dashBoardModelArray[sender.tag]
//            if bindModelData.isEventLike != nil && bindModelData.isEventLike != 0{
//                likeEventPost(postId: bindModelData.id, status:"pending", action: "unlike",at: sender.tag)
//            }
//            else {
//                likeEventPost(postId: bindModelData.id, status:"pending", action: "like",at: sender.tag)
//            }
//        }
    }
    //likeNewsPost
    @objc func newsLikePost(sender: UIButton) {
        
//        if dashBoardModelArray.count != 0 {
//            let bindModelData = dashBoardModelArray[sender.tag]
//            if bindModelData.isNewsLike != nil && bindModelData.isNewsLike != 0{
//                likeNewsPost(postId: bindModelData.id, status:"pending", action: "unlike",at: sender.tag)
//            }
//            else {
//                likeNewsPost(postId: bindModelData.id, status:"pending", action: "like",at: sender.tag)
//            }
//        }
    }
    
    @objc func createConnection(sender: UIButton) {
        
        if  dashBoardModelArray.count != 0 {
            let bindData = dashBoardModelArray[sender.tag]
            if bindData.isConnected! == "not_connected" {
                addConnection(otherID: bindData.userID!,status: "pending")
            }
        }
    }
    
    @objc func updateConnectionFunction(sender: UIButton) {
        
        if dashBoardModelArray.count != 0 {
            let  bindData = dashBoardModelArray[sender.tag]
            if bindData.isConnected! == "pending" && bindData.isReceiver == true {
                if sender.titleLabel!.text == "Accept" {
                    updateConnection(otherID: bindData.connectionID!)
                }
                else {
                    updateConnection(otherID: bindData.connectionID!,isDecline: true)
                }
                sender.isUserInteractionEnabled = true
            }
        }
    }
}

//MARK: Custom Navigation
extension SearchHome {
    
    @objc func commentPost(sender: UIButton) {
        
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[sender.tag]
            if bindModelData.datumPostImage?.count == 0 && bindModelData.postVideo == nil {
                let textVC = StoryboardRouter.textPostDetailVC()
                textVC.postId = bindModelData.id
                SVProgressHUD.dismiss()
                navigationController?.pushViewController(textVC, animated: true)
            } else {
                let home = UIStoryboard(name: "Home", bundle: nil)
                let textVC = home.instantiateViewController(withIdentifier:
                                                                "OtherCommentVC") as! OtherCommentVC
                textVC.postId = bindModelData.user?.id
                SVProgressHUD.dismiss()
                navigationController?.pushViewController(textVC, animated: true)
            }
        }
    }
    
    @objc func urlCommentVCPost(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[sender.tag]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UrlCommentVC") as! UrlCommentVC
            vc.postId = bindModelData.id
            //vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func urlVCPost(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[sender.tag]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OpenUrlVC") as! OpenUrlVC
            if  bindModelData.type == .news {
//                vc.contentString = bindModelData.link
            }
            else {
                vc.contentString = bindModelData.content!.fetchUrlFromString()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newsCommentVCPost(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        if dashBoardModelArray.count != 0 {
            let bindModelData = dashBoardModelArray[sender.tag]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewsCommentVC") as! NewsCommentVC
            vc.btnTag = sender.tag
            vc.newId = bindModelData.id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func navigateToJobComments(_ sender: UIButton) {
        
        let jobVC = StoryboardRouter.jobVC()
        jobVC.jobId = dashBoardModelArray[sender.tag].id
        jobVC.navigationType = .comments
        //jobVC.delegate = self
        self.navigationController?.pushViewController(jobVC, animated: true)
    }
    
    @objc func openJobVCPost(sender: UIButton) {
        if dashBoardModelArray.count != 0 {
            let bindModelData =  dashBoardModelArray[sender.tag]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditJobUserVC") as! EditJobUserVC
            vc.jobId = bindModelData.id
            //vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func openEventVCPost(sender: UIButton) {
        if dashBoardModelArray.count != 0 {
            let bindModelData =  dashBoardModelArray[sender.tag]
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "EventCommentVC") as! EventCommentVC
//            vc.eventId = bindModelData.id
//            //vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func openProfileVC(gesture: UIGestureRecognizer) {
        let tapImageView = gesture.view!
        if dashBoardModelArray.count != 0 {
            let bindModelData =  dashBoardModelArray[tapImageView.tag]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.connectionDetail = bindModelData
            vc.userId = bindModelData.userID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:POST PROTOCAL
extension SearchHome: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        
        switch action {
        case .like:
            let post = dashBoardModelArray[sender.tag]
            if post.isPostLike != nil {
                likePost(postId: post.id ?? 0, status: post.status ?? "", action: "unlike",at: sender.tag)
            }
            else {
                likePost(postId: post.id ?? 0, status: post.status ?? "", action: "like", at: sender.tag)
            }
            
        case .comment:
            let post = dashBoardModelArray[sender.tag]
            if post.datumPostImage?.count == 0 && post.postVideo == nil && post.postDocument == nil {
                
                performSegue(withIdentifier: Constants.Segues.textComment, sender: post.id)
                
            } else if !post.postDocument.isNil {
                
                performSegue(withIdentifier: Constants.Segues.urlComment, sender: post.id)
                
            } else {
                performSegue(withIdentifier: Constants.Segues.otherComments, sender: post.id)
            }
        case .article:
            let post = dashBoardModelArray[sender.tag]
            articleContent = post.postDocument
            openArticle()
            break
        case .edit:
            openEditPost(sender)
            
            break
        case .delete:
            
            let alert = UIAlertController(title: "Delete", message: "Do you want to Delete this Post", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.deletePost(sender)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            break
        default:
            
            getShareIndex = sender.tag
            MainVideoView?.isHidden = false
            shareViewObj?.isHidden = false
            isShareViewShown = true
            UIView.animate(withDuration: Constants.MenuAnimationTime.menuViewAnimationTime) {
                self.shareViewObj?.alpha = 1.0
                
            }
        }
    }
}

//MARK: Observer
extension SearchHome {
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(callUpdateAPI), name: NSNotification.Name(rawValue: "callUpdateApi"), object: nil)
    }
    
    @objc func callUpdateAPI(){
        //self.getEventDetail()
        reloadData()
    }
}

//MARK: Share Action
extension SearchHome {
    @objc func handleShare(_ sender: UIButton) {
        
        switch selectedTab {
        case .posts, .industryPost:
            let postId = dashBoardModelArray[sender.tag].id ?? 0
            openShareVC(id: postId, type: .post)
        case .jobs, .industryJobs:
            let postId = dashBoardModelArray[sender.tag].id ?? 0
            openShareVC(id: postId, type: .job)
        case .events, .industryEvents:
            let postId = dashBoardModelArray[sender.tag].id ?? 0
            openShareVC(id: postId, type: .event)
        case .news:
            let postId = dashBoardModelArray[sender.tag].id ?? 0
            openShareVC(id: postId, type: .news)
            
        }
    }
    
}

//MARK: CUSTOM PROTOCAL FOR API CALLING
extension SearchHome: RefreshUpdateable {
    
    func refresh(homeStatus: Bool) {
        selectedTab = .posts
        reloadData()
    }
}
