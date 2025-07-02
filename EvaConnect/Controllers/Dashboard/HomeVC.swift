//
//  HomeVC.swift
//  EvaConnect
//
//  Created by Metis on 16/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import SVProgressHUD
import Alamofire
import SDWebImage
import AVKit
import SafariServices
import IQKeyboardManagerSwift

protocol RefreshUpdateable: NSObject {
    func refresh(homeStatus: Bool)
}

@IBDesignable
class HomeVC: BaseVC {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var tabCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyListMessageLbl: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var filterCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollvw: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchUIView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchHeightConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var currentEventLbl: UILabel!
    @IBOutlet weak var currentEventLblHeight: NSLayoutConstraint!
    @IBOutlet weak var allEventLbl: UILabel!
    @IBOutlet weak var allEventLblHeight: NSLayoutConstraint!
    @IBOutlet weak var currentEventCollectionVw: UICollectionView!
    @IBOutlet weak var currentEventListHeight: NSLayoutConstraint!
    
    var categoryList = ["News","Events","Jobs","Posts"]
    var categoryIndex = 0
    var agenda = false
    //MARK: VARIABLES
    
    var posts: [DashboardItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var jobList: [DashboardJob] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var currentEventList: [DashboardItem] = [] {
        didSet {
            self.currentEventCollectionVw.reloadData()
        }
    }
    
    var paginatedPosts: [DashboardItem] = []
    
    var data: [DashboardItem] = []
    
    private var postSeeMore = [Int: (lines: CGFloat, enabled: Bool)]()
    private var homeTabFilter = [HomeTabFilter]()
    var selectedHomeFilter = HomeTabFilter.none
    var selectedTabFilter = 0
    let pageSize = 10
    var shareItemIndex: Int!
    var isShareViewShown: Bool = false
    var selectedTab: HomeTabs = .news
    var btnChange = 0
    let likeManager = LikeManager()
    var shareView: ShareView!
    var articleContent: String?
    var postDetail: PostDetail?
    var stopAPICall  = false
    let user = LoggedUserDetails.shared.user
    private var updateSpecificPost: Int? = nil
    var objectId = 0
    var type : TypePostEnum = .news
    var offsetCount = 1
    var height: CGFloat = 0
    var searchHeight: CGFloat = 0
    
    var refreshControl = UIRefreshControl()
    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = .black
//        refreshControl.addTarget(self, action: #selector(refreshingContent), for: .valueChanged)
//        return refreshControl
//    }()
    
    var expandedCells: Set<Int> = []
    var specificUserPost: Int? = nil
    var searchEnabled = false
    
    var searchFilterKey: (key: String, query: String)? = nil {
        didSet {
            searchEnabled = false
            refreshingContent()
        }
    }
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
//        if isIndivisualUser {
//            Constants.saveEnumToUserDefaults(.news)
//        } else {
//            Constants.saveEnumToUserDefaults(.industryEvents)
//        }
        // Set up the refresh control
        refreshControl.addTarget(self, action: #selector(refreshingContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendToken), name: NSNotification.Name(rawValue: "FCMToken"), object: nil)
        
        isSeparatorHidden = true
        setLayOut()
        addObservers()
        if selectedTab == .events {
            self.selectedHomeFilter = .new
        }
        //getPosts(offSet: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.posts = []
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            self.tableViewHeightConst.constant = self.tableView.contentSize.height == 0 ? 100 : self.tableView.contentSize.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        isSeparatorHidden = true
//        if isIndivisualUser {
            self.selectedTab = Constants.getEnumFromUserDefaults() ?? .news
//        } else {
//            self.selectedTab = Constants.getEnumFromUserDefaults() ?? .news
//        }
        
        self.currentEventLblHeight.constant = 0
        self.allEventLblHeight.constant = 0
        self.currentEventListHeight.constant = 0

        if selectedTab == .jobs {
            homeTabFilter = HomeTabFilter.job
            height = 32
            searchHeight = 40
            selectedHomeFilter = .all
            self.fetchJobListData(with: self.selectedHomeFilter.rawValue)
        } else if selectedTab == .posts {
            height = 0
            searchHeight = 0
        } else if selectedTab == .events {
            height = 32
            searchHeight = 0
            homeTabFilter = HomeTabFilter.userEvent
            self.currentEventLblHeight.constant = 70.0
            self.allEventLblHeight.constant = 70.0
            if self.selectedHomeFilter == .new {
                self.fetchCurrentEventData()
                self.allEventLbl.text = "All Event"
            } else if self.selectedHomeFilter == .going {
                self.fetchCurrentEventData()
                self.allEventLbl.text = "Upcoming Event"
            } else {
                self.currentEventLblHeight.constant = 0
                self.allEventLblHeight.constant = 0
                self.currentEventListHeight.constant = 0
            }
        }
        else {
            height = 32
            searchHeight = 0
        }
        
        animateTopView()
        
        IQKeyboardManager.shared.isEnabled = true
        let searchIcon = UIImage(named: "TopSearch")?.withRenderingMode(.alwaysOriginal)
        searchButton = UIBarButtonItem(image: searchIcon, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(openSearchVC(_:)))
        if let hamBurgerButton = hamBurgerButton { navigationItem.rightBarButtonItems = [hamBurgerButton, searchButton!] }
        if posts.isEmpty {
            UIView.transition(with: collectionView, duration: 0.9, options: .transitionCrossDissolve) { [weak self] in self?.collectionView.reloadData() }
        }
        posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offsetCount = 0
    }
        
    func fetchCurrentEventData() {
        let parameters = [
            "filter": "current",
        ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents,method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let currentEventRoot = try jsonDecoder.decode(DashboardItemRoot.self, from: response.data!)
                self.filterCollectionView.isUserInteractionEnabled = true
                if !(currentEventRoot.error) {
                    if (currentEventRoot.data.count) > 0 {
                        self.currentEventList = currentEventRoot.data
                        self.currentEventListHeight.constant = CGFloat(self.currentEventList.count * 440)
                    } else {
                        self.currentEventListHeight.constant = 0
                    }
                } else {
                    self.presentAlert("Failure", currentEventRoot.message, nil)
                }
            } catch {
                self.offsetCount -= 1
                print("Error:: ", error)
            }
        }
    }
    
    func fetchJobListData(with: String) {
        showActivity()
        let params = [
            "filter": with // applied,all,saved,industry,my_jobs'
        ]
        let url = "\(EndPoints.getJobList)?limit=10&offset=1"
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

        let finalURL = urlComponents.url!.absoluteString
        print(finalURL)

        NetworkManagerr.request(finalURL, method: .get) { (response) in
            self.hideActivity()
            self.filterCollectionView.isUserInteractionEnabled = true
            let jsonDecoder = JSONDecoder()
            
            let jobListData = try! jsonDecoder.decode(DashboardJobDataModel.self, from:response.data ?? Data())
            if !(jobListData.error ?? false) {
                if (jobListData.data?.jobs?.count ?? 0) > 0 {
                    self.emptyListMessageLbl.text = ""
                    self.jobList = jobListData.data?.jobs ?? []
                } else {
                    self.emptyListMessageLbl.text = "\(jobListData.message ?? "Default Error")"
                    print("Job list is empty.")
                }
            } else {
                self.presentAlert("Failure", jobListData.message, nil)
            }
        }
    }
    
    func convertTo12HourFormat(from time24: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: time24) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return nil
    }
}

//MARK: CollectionView Delegates
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        filterCollectionView == collectionView
//                        ? homeTabFilter.count
//                        : UserType.user.rawValue == user?.type ? HomeTabs.allCases.count : HomeTabs.allCases.filter({ $0 != .news }).count
        
//        filterCollectionView == collectionView
//                        ? homeTabFilter.count
//                        : HomeTabs.allCases.count
        if collectionView == currentEventCollectionVw {
            return self.currentEventList.count
        }
        else if collectionView == filterCollectionView {
//            if isIndivisualUser {
                return homeTabFilter.count
//            } else {
//                return 2
//            }
        } else {
//            if isIndivisualUser {
                return 4 //HomeTabs.allCases.count
//            } else {
//                return 4 //return HomeTabs.allCases.filter({ $0 != .posts }).count
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.currentEventCollectionVw {
            let cell = self.currentEventCollectionVw.dequeueReusableCell(withReuseIdentifier: HomeEventCVC.ReuseId, for: indexPath) as! HomeEventCVC
            
            let event = self.currentEventList[indexPath.row]
            self.objectId = event.id
            self.type = .event
            
            if let imageUrl = event.tempImage,
               !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
               let url = URL(string: imageUrl),
               UIApplication.shared.canOpenURL(url) {
                cell.imgVW.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
            } else {
                cell.imgVW.image = UIImage(named: "eventPlaceholder")
            }
            
            cell.titleLbl.text = event.eventName ?? ""
            cell.dateLbl.text = "\(event.eventStartDate ?? "") - \(event.eventEndDate ?? "")"
            cell.locationLbl.text = "\(event.eventCity ?? ""), \(event.eventCountry ?? "")"
            
            var startTime = ""
            var endTime = ""
            if let startTime12 = convertTo12HourFormat(from: "\(event.startTime ?? "")") {
                startTime = startTime12
            }
            if let endTime12 = convertTo12HourFormat(from: "\(event.endTime ?? "")") {
                endTime = endTime12
            }
            cell.timeLbl.text = "\(startTime) - \(endTime)"
            
            if event.isNewsSave == 1 {
                cell.saveImgVw.image = UIImage(named: "save_selected")
            } else {
                cell.saveImgVw.image = UIImage(named: "save")
            }
            
            if event.isPrivate == 1 {
                cell.privateBtn.isHidden = false
            } else {
                cell.privateBtn.isHidden = true
            }
            
            switch event.eventAttendeesStatus {
            case .none:
                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
            case .requestToJoin:
                cell.requestJoinBtn.setTitle("Requested", for: .normal)
            case .accepted:
                cell.requestJoinBtn.setTitle("View details", for: .normal)
            case .decline:
                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
            }
            
            cell.saveBtn.tag = indexPath.row
            cell.saveBtn.addTarget(self, action: #selector(saveCurrentEventTapped(sender:)), for: .touchUpInside)
            cell.detailNavigateBtn.tag = indexPath.row
            cell.detailNavigateBtn.addTarget(self, action: #selector(openCurrentEventDetail(sender:)), for: .touchUpInside)
            cell.requestJoinBtn.tag = indexPath.row
            cell.requestJoinBtn.addTarget(self, action: #selector(reqToJoinTapped(sender:)), for: .touchUpInside)
            
            return cell
        }
        else {
            
            let isFilter = collectionView == filterCollectionView
            let isSelected = isFilter ? selectedTabFilter == indexPath.row : selectedTab.selectedIndex == indexPath.row
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTabsCell", for: indexPath) as! HomeTabsCell
            //        if isIndivisualUser {
            cell.tab.setTitle(isFilter ? homeTabFilter[indexPath.item].rawValue : HomeTabs.allCases[indexPath.row].rawValue.capitalized, for: .normal)
            //        } else {
            //            cell.tab.setTitle(isFilter ? homeTabFilter[indexPath.item].rawValue : HomeTabs.allCases[indexPath.row + 1].rawValue.capitalized, for: .normal)
            //        }
            
            cell.selectedImage.isHidden = true
            
            if isFilter {
                cell.layer.cornerRadius = cell.frame.size.height/2
                cell.layer.borderWidth = 1.0
                cell.tab.titleLabel?.font = UIFont(name: "SF-Pro-Text-Medium", size: 12.0)
                if isSelected {
                    offsetCount = 1
                    cell.tab.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
                    cell.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.10)
                    cell.borderColor = UIColor(hex: "#4D76CD",alpha: 1)
                }
                else {
                    cell.tab.setTitleColor(UIColor(hex: "#707070",alpha: 0.50), for: .normal)
                    cell.backgroundColor = UIColor.clear
                    cell.borderColor = UIColor(hex: "#707070",alpha: 0.20)
                }
            }
            else {
                cell.layer.cornerRadius = 8
                cell.layer.borderWidth = 0
                
                if isSelected {
                    cell.tab.titleLabel?.font = UIFont(name: "SF-Pro-Text-Medium", size: 14.0)
                    cell.tab.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
                    //                cell.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.10)
                }
                else {
                    cell.tab.titleLabel?.font = UIFont(name: "SF-Pro-Text-Regular", size: 14.0)
                    cell.tab.setTitleColor(UIColor(hex: "#707070"), for: .normal)
                    //                cell.backgroundColor = UIColor.clear
                }
            }
            
            cell.tab.isUserInteractionEnabled = !isFilter
            // cell.tab.backgroundColor = .clear
            
            if !isFilter {
                cell.tab.tag = indexPath.row
                cell.tab.addTarget(self, action: #selector(tabDidChange(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    @objc func openCurrentEventDetail(sender: UIButton) {
        let vc = EventMainVC.instantiate()
        vc.eventId = currentEventList[sender.tag].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tableView.refreshControl!.isRefreshing || indicatorView.isAnimating { return }
        if self.collectionView == collectionView || selectedTabFilter == indexPath.item { return }
        selectedHomeFilter = homeTabFilter[indexPath.item]
        if selectedTab == .events {
            self.currentEventLblHeight.constant = 70.0
            self.allEventLblHeight.constant = 70.0
            if self.selectedHomeFilter == .new {
                self.fetchCurrentEventData()
                self.allEventLbl.text = "All Event"
            } else if self.selectedHomeFilter == .going {
                self.fetchCurrentEventData()
                self.allEventLbl.text = "Upcoming Event"
            } else {
                self.currentEventLblHeight.constant = 0
                self.allEventLblHeight.constant = 0
                self.currentEventListHeight.constant = 0
            }
        } else if selectedTab == .jobs {
            print(selectedHomeFilter)
            self.fetchJobListData(with: self.selectedHomeFilter.rawValue)
        }
        else {
            refreshingContent()
        }
        filterCollectionView.isUserInteractionEnabled = false
        filterCollectionView.performBatchUpdates { [weak self] in
            guard let self = self else { return }
            self.filterCollectionView.reloadItems(at: [IndexPath(item: self.selectedTabFilter, section: 0)])
            self.selectedTabFilter = indexPath.item
            self.filterCollectionView.reloadItems(at: [indexPath])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let inset: CGFloat = 3
//        let filterMultiplier = selectedTab == .events && UserType.company.rawValue == user?.type ? 0.5 : 0.26
//        let width = collectionView.frame.width * (filterCollectionView == collectionView ? filterMultiplier : (UserType.user.rawValue == user?.type ? 0.22 : 0.32))
//        let height = collectionView.frame.height
//        return CGSize(width: width - inset, height: height - inset)
        if collectionView == self.currentEventCollectionVw {
            return CGSize(width: collectionView.frame.width, height: 440.0)
        }
        else if collectionView == self.collectionView {
            var categoryCount = 0
//            if isIndivisualUser {
                categoryCount = 4
//            } else {
//                categoryCount = 3
//            }
            let height = self.collectionView.frame.size.height - CGFloat(categoryCount)
            let width = (self.collectionView.frame.size.width / CGFloat(categoryCount)) - 8
            return CGSize(width: width, height: height)
        }
        else {
            let label = UILabel(frame: CGRect.zero)
//            if !isIndivisualUser && homeTabFilter.isEmpty {
//                label.text = ""
//            } else {
                label.text = homeTabFilter[indexPath.item].rawValue
//            }
            label.sizeToFit()

            var width = label.frame.width + 30
            let height = (self.filterCollectionView.frame.size.height - 4)
            
            if width < ((self.filterCollectionView.frame.size.width/4) - 8) {
                width = ((self.filterCollectionView.frame.size.width/4) - 8)
            }
            return CGSize(width: width, height: height)
        }
    }
}

//MARK: TABLEVIEW DATASOURCE
extension HomeVC: UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate {
    
    func didSelectItem(at indexPath: Int, imgArr: [String?]) {
        print("Post Image Clicked.")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
//        case self.currentEventListTableVw:
//            return 398
            
        case self.tableView:
            switch selectedTab {
            case .posts:
                //            let homePost = posts[indexPath.row]
                //            let link = homePost.content?.link
                //            if homePost.type == .post {
                //                if !homePost.postImage!.isEmpty  { //image cell with text
                //                    return UITableView.automaticDimension
                //                } else if homePost.postDocument != nil || link != nil { //Url cell with text
                //                    return UITableView.automaticDimension
                //                } else if homePost.content != nil && homePost.postVideo == nil && homePost.postImage!.isEmpty && homePost.postDocument == nil { //Simple Text cell
                //                    let seeMoreEnabled = postSeeMore[indexPath.row]?.enabled ?? false
                //                    let lines = postSeeMore[indexPath.row]?.lines ?? 1
                //                    let actualLines = seeMoreEnabled ? lines : lines > 3 ? 3 : lines
                //                    return (180 + (actualLines * (seeMoreEnabled ? 22 : 15)))
                //                } else if homePost.postVideo != nil { //video cell with text
                //                    return UITableView.automaticDimension
                //                } else {
                //                    return 0.0
                //                }
                //            }
                
                //            let homePost = posts[indexPath.row]
                //            if homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" {
                //                let cell = tableView.cellForRow(at: indexPath) as! HomeText
                //                let labelSize = cell.postMsgLbl.sizeThatFits(CGSize(width: cell.postMsgLbl.frame.width, height: CGFloat.greatestFiniteMagnitude))
                //                let calculatedHeight = labelSize.height + 215/* additional space for other UI elements */
                //                return cell.isExpanded ? calculatedHeight : min(calculatedHeight, 600)
                //            } else {
                return UITableView.automaticDimension //400
                //            }
            case .events:
                //            return UITableView.automaticDimension
                return 440//398
            case .jobs:
                //            return userType.company.rawValue == user?.type ? UITableView.automaticDimension : 110
                return 284
            case .news:
                return UITableView.automaticDimension
            case .industryEvents:
                //            return UITableView.automaticDimension
                return 398
            case .industryJobs:
                return 282 //UITableView.automaticDimension
            case .industryPost:
                return UITableView.automaticDimension
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        posts.count
//        return 3
        switch tableView {
//        case self.currentEventListTableVw:
//            return self.currentEventList.count
        case self.tableView:
            if selectedTab == .jobs {
                return self.jobList.count
            } else {
                return posts.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch tableView {
//        case self.currentEventListTableVw:
//            let event = self.currentEventList[indexPath.row]
//            let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
//            cell.uiData(dataMaper: event)
//            cell.dashboardItem = event
//            cell.delegate = self
//            cell.eventDelegate = self
//            cell.interrestedBtn.tag = indexPath.row
//            if self.selectedTabFilter == 1 {
//                cell.BottomViewStack.isHidden = true
//            } else {
//                cell.BottomViewStack.isHidden = false
//            }
//            cell.industryUserView.isHidden = true
//            cell.indivisualUserView.isHidden = false
//
//            cell.sharedBtn.tag = indexPath.row
//            cell.navigateToDetail.tag = indexPath.row
//            cell.saveEventBtn.tag = indexPath.row
//            self.objectId = event.id
//            self.type = .event
//            cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//            cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//            cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
//            return cell
//
//        case self.tableView:
            
            switch selectedTab {
            case .posts, .industryPost:
                let homePost = posts[indexPath.row]
                
                if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // text cell
                    let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.detailsView.layer.cornerRadius = 13
                    cell.delegate = self
                    cell.uiData(dataMaper: homePost)
                    cell.shareBtn.tag = indexPath.row
                    cell.commentBtn.tag = indexPath.row
                    cell.likeBtn.tag = indexPath.row
                    cell.goToProfileBtn.tag = indexPath.row
                    cell.reportBtn.tag = indexPath.row
                    self.objectId = homePost.id
                    self.type = .post
                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                    cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                    return cell
                    
                } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] { //Video Cell
                    let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    
                    cell.delegate = self
                    cell.uiData(dataMaper: homePost)
                    
                    cell.sharedBtn.tag = indexPath.row
                    cell.commentBtn.tag = indexPath.row
                    cell.likeBtn.tag = indexPath.row
                    cell.goToProfileBtn.tag = indexPath.row
                    cell.reportBtn.tag = indexPath.row
                    self.objectId = homePost.id
                    self.type = .post
                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                    cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                    cell.openVideoBtn.tag = indexPath.row
                    cell.videoView.backgroundColor = .black
                    cell.videoView.configure(url: homePost.postVideo!,ratio: .resizeAspectFill)
                    cell.videoView.stop()
                    cell.videoView.isHidden = false
                    return cell
                    
                } else if homePost.postDocument != "" && homePost.postImage == [] { //document Cell
                    let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.delegate = self
                    cell.uiData(homePost: homePost)
                    //                cell.isConnectedBtn.tag = indexPath.row
                    //
                    cell.likeBtn.tag = indexPath.row
                    cell.commentBtn.tag = indexPath.row
                    cell.sharedBtn.tag = indexPath.row
                    cell.openArticleBtn.tag = indexPath.row
                    cell.goToProfileBtn.tag = indexPath.row
                    cell.reportBtn.tag = indexPath.row
                    self.objectId = homePost.id
                    self.type = .post
                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                    cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    
                    //                cell.moreOption.tag = indexPath.row
                    //                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    //                cell.openProfile.tag = indexPath.row
                    //                cell.didTapURL = { [weak self] url in
                    //                    self?.present(SFSafariViewController(url: url), animated: true, completion: nil)
                    //                }
                    //
                    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
                    //                cell.openProfile.addGestureRecognizer(tapGesture)
                    //                cell.openProfile.isUserInteractionEnabled = true
                    
                    return cell
                } else if homePost.postImage!.count > 0 { //Image Cell
                    //
                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.uiData(dataMaper: homePost)
                    //                cell.seeMore = (row: indexPath.row, lines: postSeeMore[indexPath.row]?.lines ?? 1, enabled: postSeeMore[indexPath.row]?.enabled ?? false)
                    cell.delegate = self
                    cell.delegateDidSelect = self
                    cell.parentViewController = self
                    //
                    cell.likeButton.tag = indexPath.row
                    cell.commentButton.tag = indexPath.row
                    cell.shareButton.tag = indexPath.row
                    cell.goToProfileBtn.tag = indexPath.row
                    cell.reportBtn.tag = indexPath.row
                    self.objectId = homePost.id
                    self.type = .post
                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                    cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                    //
                    //                cell.openProfile.tag = indexPath.row
                    //                let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openProfileVC(gesture:)))
                    //                cell.openProfile.addGestureRecognizer(tapGesture)
                    //                cell.openProfile.isUserInteractionEnabled = true
                    //
                    //                let doubleTap = UITapGestureRecognizer(target: self, action:#selector(likeByDoubleClick(gesture:)))
                    //                doubleTap.numberOfTapsRequired = 2
                    //                cell.doubleLike.tag = indexPath.row
                    //                cell.doubleLike.addGestureRecognizer(doubleTap)
                    //                cell.shouldSeeMore = { [weak self] index in self?.shouldSeeMoreLess(index: index) }
                    
                    return cell
                }
            case .events:
                let event = posts[indexPath.row]
                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.uiData(dataMaper: event)
                cell.dashboardItem = event
                cell.delegate = self
                cell.eventDelegate = self
//                cell.interrestedBtn.tag = indexPath.row
                //            if LoggedUserDetails.shared.user!.id != event.user!.id {
                //                cell.attendingBtn.isHidden = false
                //                cell.attendingBtn.tag = indexPath.row
                //                //cell.attendingBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
                //            }
                //            else {
                //                cell.attendingBtn.isHidden = true
                //            }
//                if self.selectedTabFilter == 1 {
//                    cell.BottomViewStack.isHidden = true
//                } else {
//                    cell.BottomViewStack.isHidden = false
//                }
//                cell.industryUserView.isHidden = true
//                cell.indivisualUserView.isHidden = false
//                
//                cell.sharedBtn.tag = indexPath.row
                cell.navigateToDetail.tag = indexPath.row
                cell.saveEventBtn.tag = indexPath.row
                cell.requestJoinBtn.tag = indexPath.row
                self.objectId = event.id
                self.type = .event
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
                cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
                cell.requestJoinBtn.addTarget(self, action: #selector(reqToJoinTapped(sender:)), for: .touchUpInside)
                //            cell.interrestedBtn.addTarget(self, action: #selector(interestedBtnTapped(_:)), for: .touchUpInside)
                
                //            cell.intrestedTapped = { [weak self] dashboardItem in
                //                let vc = StoryboardRouter.intrested()
                //                vc.dashboardItem = dashboardItem
                //                self?.navigationController?.pushViewController(vc, animated: true)
                //            }
                
                return cell
            case .industryEvents:
                let event = posts[indexPath.row]
                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.uiData(dataMaper: event)
                cell.dashboardItem = event
                //            cell.delegate = self
                //            cell.eventDelegate = self
                //            if LoggedUserDetails.shared.user!.id != event.user!.id {
                //                cell.attendingBtn.isHidden = false
                //                cell.attendingBtn.tag = indexPath.row
                //                //cell.attendingBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
                //            }
                //            else {
                //                cell.attendingBtn.isHidden = true
                //            }
                
                //                      cell.sharedBtn.tag = indexPath.row
//                if self.selectedTabFilter == 1 {
//                    cell.BottomViewStack.isHidden = true
//                } else {
//                    cell.BottomViewStack.isHidden = false
//                }
//                cell.industryUserView.isHidden = false
//                cell.indivisualUserView.isHidden = true
//                cell.navigateToDetail.tag = indexPath.row
//                cell.noOfIntererstedBtn.tag = indexPath.row
                //                      cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
                cell.intrestedTapped = { [weak self] dashboardItem in
                    let vc = StoryboardRouter.intrested()
                    vc.dashboardItem = dashboardItem
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
//                cell.noOfIntererstedBtn.addTarget(self, action:#selector(interestedListTapped(_:)), for: .touchUpInside)
                return cell
            case .news:
                let cell: HomeNewz = tableView.dequeueReusableCell(forIndexPath: indexPath)
                let newz = posts[indexPath.row]
                
                cell.uiData(dataMaper: newz)
                cell.likeBtn.tag = indexPath.row
                cell.sharedBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.openURl.tag = indexPath.row
                cell.saveNewsBtn.tag = indexPath.row
                cell.detailNavigateBtn.tag = indexPath.row
                
                self.objectId = newz.id
                self.type = .news
                cell.detailNavigateBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
                cell.likeBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
                cell.commentBtn.addTarget(self, action:#selector(newsCommentVCPost(sender:)), for: .touchUpInside)
                cell.saveNewsBtn.addTarget(self, action:#selector(saveNewsTapped(sender:)), for: .touchUpInside)
                
                return cell
            case .jobs:
                //            if user?.type == userType.user.rawValue {
                let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.baseMainView.layer.cornerRadius = 12
                cell.indivisualViewStack.isHidden = false
                cell.industryView.isHidden = true
                cell.saveJobBtn.isHidden = false
//                cell.job = self.jobList[indexPath.row]
                cell.setData(data: self.jobList[indexPath.row])
                cell.viewDetailsBtn.tag = indexPath.row
                cell.saveJobBtn.tag = indexPath.row
                cell.editBtn.tag = indexPath.row
                cell.applicantBtn.tag = indexPath.row
                cell.applyNowBtn.tag = indexPath.row
                //                cell.goToAd = { [weak self] in self?.navigateToJobListing(job: $0) }
                
                cell.viewDetailsBtn.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
                cell.applyNowBtn.addTarget(self, action: #selector(tapJobApply(sender:)), for: .touchUpInside)
                cell.saveJobBtn.addTarget(self, action: #selector(saveJobTapped(sender:)), for: .touchUpInside)
                return cell
                //            } else {
                //                let cell: CompanyJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                //                cell.item = posts[indexPath.row]
                //                cell.edit = { [weak self] in self?.navigateToEditJob(job: $0) }
                //                return cell
                //            }
            case .industryJobs:
                let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.job = posts[indexPath.row]
                cell.baseMainView.layer.cornerRadius = 12
                cell.indivisualViewStack.isHidden = true
                cell.industryView.isHidden = false
                cell.saveJobBtn.isHidden = true
                cell.editBtn.tag = indexPath.row
                cell.applicantBtn.tag = indexPath.row
                
                if self.selectedTabFilter == 0 {
                    cell.jobActiveTimeLbl.isHidden = false
                } else {
                    cell.jobActiveTimeLbl.isHidden = true
                }
                cell.editBtn.addTarget(self, action:  #selector(tapEditJob(sender:)), for: .touchUpInside)
                cell.applicantBtn.addTarget(self, action:  #selector(tapApplicantsList(sender:)), for: .touchUpInside)
                //            cell.detailButton.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
                
                return cell
            }
            return UITableViewCell()
            
//        default:
//            return UITableViewCell()
//        }
    }
    
    @objc func tapJobDetail(sender: UIButton){
        
        let jobListing = StoryboardRouter.userJobListing()
        jobListing.jobId = posts[sender.tag].id
        jobListing.job = posts[sender.tag]
        navigationController?.pushViewController(jobListing, animated: true)
    }
    
    @objc func tapJobApply(sender: UIButton){
        let obj = posts[sender.tag]
        if obj.isApplied == 0 {
            let vc = StoryboardRouter.userApplyJob()
            vc.job = obj
            vc.jobId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showToastWithLogo(message: "You have already applied for this job.")
        }
    }
    
    @objc func tapApplicantsList(sender: UIButton){
        
        let vc = StoryboardRouter.applicantList()
        vc.jobId = posts[sender.tag].id
//        vc.job = posts[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapEditJob(sender: UIButton){
        
        let vc = StoryboardRouter.createEditJobPost()
        vc.roleType = .edit
        vc.jobStatus = selectedHomeFilter.getFilter(tab: selectedTab)
        vc.jobId = posts[sender.tag].id
        navigationController?.pushViewController(vc, animated: true)
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        let count = posts.count
//        print("Post count= \(posts.count) and indexpath= \(indexPath.row)")
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//
//        // Check if the last visible cell is about to be displayed
//        if indexPath.row == lastRowIndex {
//            offsetCount += 1
//            getPosts(offSet: offsetCount, inserted: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedTab == .jobs && user?.type == userType.company.rawValue { navigateToJobDetail(job: posts[indexPath.item]) }
        else if selectedTab == .posts { goToCommentVC(index: indexPath.row) }
        print("i am called tableViewDidSelectRowAt: ")
    }
    
    func scrollToTop() {
        let topIndex = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topIndex, at: .top, animated: true)
    }
    
    func shouldSeeMoreLess(index: Int) {
        postSeeMore[index]?.enabled.toggle()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

//MARK: Scroll View Delegate...
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            if paginatedPosts.count > 9 {
                offsetCount += 1
                getPosts(offSet: offsetCount, inserted: true)
            }
        }
    }
}

// MARK: Network Calls
private extension HomeVC {
    
    @objc func sendToken() {
        
//        let id = LoggedUserDetails.shared.user?.id ?? 0
        let parameters: AFParameters = ["device_token": myUserDefaults.deviceToken, "device_type": "iOS"]
        showActivity()
        NetworkManagerr.request(EndPoints.sendDevice, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        print("Device token sent")
                    } else {
                        self.presentAlert("Error", genericRoot.message)
                    }
                } catch {
                    self.presentAlert("Error", "\(error)")
                }
            }
        }
    }
    
    func getPosts(offSet: Int, inserted: Bool = true) {
        if offSet > 1 {
            showActivity()
        }
        if stopAPICall { return }
        if searchEnabled {
            tabCollectionViewHeight.constant = 0
            indicatorView.stopAnimating()
            return
        } else {
            tabCollectionViewHeight.constant = 50.0
        }
        
        selectedTab = Constants.getEnumFromUserDefaults() ?? .news
        
        var url = "\(selectedTab.getPostEndPoint)?limit=\(pageSize)&offset=\(offSet)"
        print(url)
        var param: AFParameters = ["filter": selectedHomeFilter.getFilter(tab: selectedTab)] //"user_id": LoggedUserDetails.shared.user?.id ?? 0, 
        
        if let uid = specificUserPost {
            param["user_key"] = uid
            param["filter"] = "my_posts"
            url = "\(EndPoints.homeFilterPosts)?limit=\(pageSize)&offset=\(offSet)"
            tabCollectionViewHeight.constant = 0
        } else if let searchFilterKey = searchFilterKey {
            url = "\(EndPoints.searhDashboard)?limit=\(pageSize)&offset=\(offSet)"
            param["filter"] = searchFilterKey.key
            param["search_key"] = searchFilterKey.query
        }
        
        stopAPICall = true
        
        switch selectedTab {
//        case .jobs:
//            var url = "\(selectedTab.getPostEndPoint)?limit=\(pageSize)&offset=\(offSet)&filter=all"
//            NetworkManagerr.request(url) { [weak self] (result: Result<DashboardItemRoot>) in
//                guard let self = self else { return }
//                if self.refresher.isRefreshing || self.indicatorView.isAnimating { self.postSeeMore.removeAll() }
//                self.refresher.endRefreshing()
//                self.indicatorView.stopAnimating()
//                self.filterCollectionView.isUserInteractionEnabled = true
//                self.stopAPICall = false
//                self.updateSpecificPost = nil
//                switch result {
//                case .success(let post):
//                    if post.data.isEmpty && self.posts.isEmpty {
//                        self.emptyListMessageLbl.text = self.searchEnabled ? "No result found" : "No result found"//post.message?.capitalized
//                        self.emptyListMessageLbl.isHidden = false
//                        return
//                    }
//                    
//                    if inserted {
//                        if post.data.isEmpty {
//                            
//                        } else {
//                           self.posts.append(contentsOf: post.data)
//                        }
//                    } else {
//                        self.posts = post.data
//                        self.postSeeMore.removeAll()
//                    }
//                    
//                    for (index, post) in post.data.enumerated() {
//                        let lines = CGFloat(post.content?.calculateMaxLines(width: self.view.frame.width - 10) ?? 1)
//                        self.postSeeMore[index] = self.postSeeMore[index] == nil ? (lines: lines, enabled: false) : self.postSeeMore[index]
//                    }
//                    self.emptyListMessageLbl.isHidden = true
//                    self.emptyListMessageLbl.text = ""
//                case .failure(let failure):
//                    self.presentAlert("Error", nil, failure)
//                }
//            }
            
        default:
            NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<DashboardItemRoot>) in
                guard let self = self else { return }
                if self.refreshControl.isRefreshing || self.indicatorView.isAnimating { self.postSeeMore.removeAll() }
                self.refreshControl.endRefreshing()
                self.indicatorView.stopAnimating()
                self.filterCollectionView.isUserInteractionEnabled = true
                self.stopAPICall = false
                self.updateSpecificPost = nil
                switch result {
                    
                case .success(let post):
                    self.hideActivity()
                    if post.data.isEmpty && self.posts.isEmpty {
                        self.emptyListMessageLbl.text = self.searchEnabled ? "No result found" : "No result found"//post.message?.capitalized
                        self.emptyListMessageLbl.isHidden = false
                        return
                    }
                    
                    if inserted {
                        if post.data.isEmpty {
                           
                        } else {
                            paginatedPosts = post.data
                            self.posts.append(contentsOf: paginatedPosts)
//                            tableView.reloadData()
//                            self.data.append(contentsOf: post.data)
                        }
                    } else {
                        self.posts = post.data
//                        self.data = post.data
                        self.postSeeMore.removeAll()
                    }
                    
//                    for (index, post) in post.data.enumerated() {
//                        let lines = CGFloat(post.content?.calculateMaxLines(width: self.view.frame.width - 10) ?? 1)
//                        self.postSeeMore[index] = self.postSeeMore[index] == nil ? (lines: lines, enabled: false) : self.postSeeMore[index]
//                    }
                    self.emptyListMessageLbl.isHidden = true
                    self.emptyListMessageLbl.text = ""
                    self.hideActivity()
                case .failure(let failure):
                    self.hideActivity()
                    self.presentAlert("Error", nil, failure)
                }
            }
        }

    }
    
    
    func EventsAPICall(offSet: Int) {
        var url =  URL(string: "https://aviationconnect.com/api/v1/event/filter?limit=\(pageSize)&offset=\(offSet)")! // Replace with your API endpoint URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = (UserDefaults.standard.value(forKey: "UserToken")) {
            // Replace 'YOUR_ACCESS_TOKEN' with your actual bearer token
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
//        ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "filter": selectedHomeFilter.getFilter(tab: selectedTab)]
        // Example payload (parameters) in JSON format
        let parameters: [String: Any] = [
            "user_id": myUserDefaults.userId,
            "filter": selectedHomeFilter.getFilter(tab: selectedTab)
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                self.hideActivity()
                if let error = error {
                    print("Error making the request: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    print("Request was successful!")
                    if let data = data {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        print("Response:", responseJSON ?? "")
                        
                    }
                } else {
                    print("Request failed with status code: \(httpResponse.statusCode)")
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response:", responseString ?? "")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Error encoding parameters: \(error)")
        }
    }
    
//    func deletePost(postId: Int) {
//        let url = "\(selectedTab.deletePostEndPoint)\(postId)/"
//        let param: AFParameters? = selectedTab == .events ? nil : ["modified_by_id": LoggedUserDetails.shared.user!.id,
//                                                                  "modified_datetime": Date().toString(formatter: .standardDateWithTime),
//                                                                  "status": "deleted"]
//        let method: HTTPMethod = selectedTab == .posts ? .patch : .delete
//        IHProgressHUD.show()
//
//        NetworkManagerr.request(url, method: method, parameters: param) { [weak self] (result: Result<GenericResponse>) in
//            IHProgressHUD.dismiss()
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                if response.error {
//                    self.presentAlert("Error", response.message)
//                } else if let index = self.posts.firstIndex(where: { $0.id == postId }) {
//                    self.posts.remove(at: index)
//                    self.postSeeMore[index] = nil
//                    self.tableView.reloadData()
//                    // self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//                }
//                print("response", response.message)
//            case .failure(let error):
//                self.presentAlert("Error", nil, error)
//            }
//        }
//    }
    
    private func likePost(postId: Int, status: String, action: String, at: Int) {
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
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    private func likeNews(postId: Int, status: String, action: String, at: Int) {
        let param: AFParameters = [ "rss_news_id": postId,
                                    "created_by_id":  myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.likeNewsServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            if error == 0 {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    
    private func likeEvents(postId: Int, status: String, action: String, at: Int) {
        let param: AFParameters = [ "id": postId,
                                    "created_by_id": myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.likeEventsServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            if error == 0 {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    private func saveNews(postId: Int, at: Int) {
        let param: AFParameters = [ "rss_news_id": postId]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.saveNewsServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            if error == 0 {
                print("News saved!!")
                self.getPosts(offSet: 1, inserted: false)
//                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                print("News error!!",error as Any)
//                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
//                let indexPath = IndexPath(item: at, section: 0)
//                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    private func saveEvent(postId: Int, at: Int) {
        
        let param: AFParameters = [ "event_id": postId]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.saveEventServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
//            self.hideActivity()
            if error == 0 {
                print("Event saved!!")
                self.getPosts(offSet: 1, inserted: false)
                self.fetchCurrentEventData()
//                let indexPath = IndexPath(item: at, section: 0)
//                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.hideActivity()
                print("Event error!!",error as Any)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    private func reqToJoin(postId: Int, at: Int) {
        
        let param: AFParameters = [ "event_id": postId,
                                    "type": 1]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.reqToJoinFunc(usertoken: myUserDefaults.token, para: param) { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
//            self.hideActivity()
            if error == 0 {
                print("Event saved!!")
                self.getPosts(offSet: 1, inserted: false)
                self.fetchCurrentEventData()
                self.view.isUserInteractionEnabled = true

            }
            else {
                self.hideActivity()
                print("Event error!!",error as Any)
                self.view.isUserInteractionEnabled = true
            }
        } failure: { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    private func saveJob(postId: Int, at: Int) {
        
        let param: AFParameters = [ "job_id": postId]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.saveJobServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                print("Job saved!!")
                self.getPosts(offSet: 1, inserted: false)
//                let indexPath = IndexPath(item: at, section: 0)
//                UIView.performWithoutAnimation { self.tableView.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                print("Job error!!",error as Any)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
}

//MARK: LAYOUT SETTING
extension HomeVC {
    
    func setLayOut() {
        scrollvw.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells(withTypes: [HomeUrl.self, HomeText.self, HomeJob.self, HomeEvent.self, HomeImage.self, HomeVideo.self, HomeNewz.self, UserJobCell.self, CompanyJobCell.self])
        tableView.registerCell(withType: HomeImage.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 7.0
//        collectionView.backgroundColor = AppColors.lightGrayBG

        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
//        filterCollectionView.backgroundColor = AppColors.lightGrayBG
        
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView =  UIView()
        
        currentEventLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        allEventLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        
        currentEventCollectionVw.registerNib(cellNib: HomeEventCVC.self)
        currentEventCollectionVw.delegate = self
        currentEventCollectionVw.dataSource = self
        
        setShareBottomSheetView()
        bottomShareSheet.delegate = self
        
//        if isIndivisualUser {
            homeTabFilter = HomeTabFilter.news
//        } else {
//            homeTabFilter = HomeTabFilter.industryEvents
//        }
        reloadData()
    }
    
}

//MARK: CUSTOM FUNCTION
extension HomeVC {
    
//    func getAttributedString(for text: String, isExpanded: Bool) -> NSAttributedString {
//        let fullText = isExpanded ? text : text + " ...See More"
//
//        let attributedString = NSMutableAttributedString(string: fullText)
//        let range = (fullText as NSString).range(of: "See More")
//
//        // Customize the appearance of the "See More" part
//        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
//        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
//
//        return attributedString
//    }
    
//    func getAttributedString(for text: String, isExpanded: Bool, cell: HomeText) -> NSAttributedString {
//            var truncatedText = text
//            if !isExpanded {
//                let numberOfLines = calculateNumberOfLines(for: text, label: cell.postMsgLbl)
//                if numberOfLines > 2 {
//                    truncatedText = truncateText(to: 3, from: text)
//                }
//            }
//            
//            let fullText = truncatedText + " ...See More"
//            let attributedString = NSMutableAttributedString(string: fullText)
//            
//            if !isExpanded {
//                let range = (fullText as NSString).range(of: "See More")
//                
//                // Customize the appearance of the "See More" part
//                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
////                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
//            }
//            
//            return attributedString
//        }
    func getAttributedString(for text: String, isExpanded: Bool) -> NSAttributedString {
            let truncatedText = isExpanded ? text : truncateText(to: 3, from: text)
            let fullText = truncatedText + (isExpanded ? "" : " ...See More")

            let attributedString = NSMutableAttributedString(string: fullText)

            if !isExpanded {
                let range = (fullText as NSString).range(of: "See More")

                // Customize the appearance of the "See More" part
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }

            return attributedString
        }

        func truncateText(to lines: Int, from text: String) -> String {
            let linesArray = text.components(separatedBy: "\n")
            let truncatedLines = linesArray.prefix(lines)
            return truncatedLines.joined(separator: "\n")
        }

        func calculateNumberOfLines(for text: String, label: UILabel) -> Int {
            let maxSize = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let textRect = (text as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
            let numberOfLines = Int(ceil(textRect.height / label.font.lineHeight))
            return numberOfLines
        }
    
    func didTapExpandButton(in cell: HomeText, at index: Int) {
//            if expandedCells.contains(index) {
//                expandedCells.remove(index)
//            } else {
//                expandedCells.insert(index)
//            }

            if let indexPath = tableView.indexPath(for: cell) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
  
    @objc private func refreshingContent() {
        postSeeMore.removeAll()
        posts.removeAll()
        tableView.reloadData()
        reloadData()
    }
    
    @objc func reloadData(inserted: Bool = true) {
        if let updateSpecificPost = updateSpecificPost {
            fetchSpecificPost(updateSpecificPost)
            return
        }
        if !inserted { refreshControl.programaticallyBeginRefreshing(in: tableView) }
        if !(refreshControl.isRefreshing) { indicatorView.startAnimating() }
        emptyListMessageLbl.isHidden = true
        emptyListMessageLbl.text = ""
//        getPosts(offSet: 0, inserted: inserted)
        getPosts(offSet: 1, inserted: inserted)
    }
    
    @objc func likeByDoubleClick(gesture: UIGestureRecognizer) {
        let tapImageView = gesture.view as! UIButton
        let post = posts[tapImageView.tag]
        likePost(postId: post.id, status: post.status ?? "", action: post.isPostLike != nil ? "unlike" : "like", at: tapImageView.tag)
    }
    
    private func getPostType(at index: Int) -> DashboardItem { posts[index] }
        
    private func navigateToJobListing(job: DashboardItem) {
        let jobListing = StoryboardRouter.userJobListing()
        jobListing.job = job
        navigationController?.pushViewController(jobListing, animated: true)
    }
    
    private func navigateToEditJob(job: DashboardItem) {
        let editPostedJob = StoryboardRouter.createEditJobPost()
        editPostedJob.jobId = job.id
        editPostedJob.roleType = .edit
        navigationController?.pushViewController(editPostedJob, animated: true)
    }
    
    private func navigateToJobDetail(job: DashboardItem) {
        let postedJobDetail = StoryboardRouter.postedJobDetail()
//        postedJobDetail.jobId = job.id
//        postedJobDetail.userImage = job.user?.userImage ?? ""
        navigationController?.pushViewController(postedJobDetail, animated: true)
    }
    
    @objc func navigateToJobComments(_ sender: UIButton) {
        let jobVC = StoryboardRouter.jobVC()
        jobVC.jobId = posts[sender.tag].id
        jobVC.navigationType = .comments
        jobVC.delegate = self
        navigationController?.pushViewController(jobVC, animated: true)
    }
    
    @objc func openEventVCPost(sender: UIButton) {
        let vc = EventMainVC.instantiate()
        vc.eventId = posts[sender.tag].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func interestedListTapped(_ sender: UIButton) {
        let vc = StoryboardRouter.interestedList()
        vc.interestedList = posts[sender.tag].interestedUsers ?? []
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openProfileVC(gesture: UIGestureRecognizer) {
        let tapImageView = gesture.view!
        let postType: DashboardItem! = getPostType(at: tapImageView.tag)
        updateSpecificPost = postType.id
        let profile = StoryboardRouter.newProfile()
        profile.connectionDetail = postType
        profile.userId = postType.user?.id
        navigationController?.pushViewController(profile, animated: true)
    }
    
    @objc func tabDidChange(_ sender: UIButton) {
        if tableView.refreshControl?.isRefreshing ?? false || indicatorView.isAnimating || selectedTab.selectedIndex == sender.tag { return }
        
        homeTabFilter.removeAll()
        posts.removeAll()
        jobList.removeAll()
//        tableView.reloadData()
        
        self.currentEventLblHeight.constant = 0
        self.allEventLblHeight.constant = 0
        self.currentEventListHeight.constant = 0
        
        var tableViewBottom: CGFloat = 0
        
        switch sender.tag {
        case 0:
            print("News Tab Select")
//            if isIndivisualUser {
                selectedTab = .news
                Constants.saveEnumToUserDefaults(.news)
                selectedHomeFilter = .all
                height = 32
                searchHeight = 0
                homeTabFilter = HomeTabFilter.news
//            } else {
//                selectedTab = .industryEvents
//                Constants.saveEnumToUserDefaults(.industryEvents)
//                selectedHomeFilter = .all
//                height = 32
//                homeTabFilter = HomeTabFilter.industryEvents
//            }
            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
            reloadData()
        case 1:
            print("Event Tab Select")
//            if isIndivisualUser {
                selectedTab = .events
                Constants.saveEnumToUserDefaults(.events)
                selectedHomeFilter = .all
                homeTabFilter = HomeTabFilter.userEvent
                //homeTabFilter = jobListingBtn.isHidden ? HomeTabFilter.userEvent : HomeTabFilter.companyEvent
                height = 32
                searchHeight = 0
                self.currentEventLblHeight.constant = 70.0
                self.allEventLblHeight.constant = 70.0
                //--> Set Event New Data...
                self.fetchCurrentEventData()
                self.allEventLbl.text = "All Event"
//            } else {
//                selectedTab = .industryJobs
//                Constants.saveEnumToUserDefaults(.industryJobs)
//                selectedHomeFilter = .active
//                height = 32
//                searchHeight = 40
//                homeTabFilter = HomeTabFilter.industryJobs
//            }
            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
            reloadData()
        case 2:
            print("Job Tab Select")
//            if isIndivisualUser {
                selectedTab = .jobs
                Constants.saveEnumToUserDefaults(.jobs)
                selectedHomeFilter = .all
//            if jobListingBtn.isHidden {
                homeTabFilter = HomeTabFilter.job
                height = 32
                searchHeight = 40
                //            } else {
                //                homeTabFilter = []
                //                height = 20
                //            }
//            } else {
//                selectedTab = .industryPost
//                Constants.saveEnumToUserDefaults(.industryPost)
//                selectedHomeFilter = .none
//                reloadData()
//                
//            }
            self.fetchJobListData(with: self.selectedHomeFilter.rawValue)
            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
//            reloadData()
        case 3:
            print("Post Tab Select")
            selectedTab = .posts
            Constants.saveEnumToUserDefaults(.posts)
            selectedHomeFilter = .none
            height = 0
            searchHeight = 0
            reloadData()
            

        default:
            break
        }
        
        sender.setTitleColor(Constants.AppColorLiteral.signUpNew, for: .normal)
        selectedTabFilter = 0
        animateTopView()
    }
    
    func animateTopView() {
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.filterCollectionViewHeight.constant = self.height
//            self.tableViewBottomConst.constant = tableViewBottom
            self.collectionView.reloadData()
            self.filterCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.searchHeightConst.constant = self.searchHeight
//            self.tableViewBottomConst.constant = tableViewBottom
            self.collectionView.reloadData()
            self.filterCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func showVideoView(sender: UIButton) {
        let bindModelData = posts[sender.tag]
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
    
    @objc func openArticle() {
        if let urlString = articleContent, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            present(webVC, animated: true, completion: nil)
        }
    }
        
    func openEditPost(_ sender: UIButton) {
        updateSpecificPost = posts[sender.tag].id
        switch selectedTab {
        case .posts:
            let postVC = StoryboardRouter.postVC()
            postVC.mode = .edit
            postVC.postType = returnPostType(post: posts[sender.tag])
            postVC.data = posts[sender.tag]
            navigationController?.pushViewController(postVC, animated: true)
       case .events:
//            let event =  StoryboardRouter.createEvent()
//            event.eventId = posts[sender.tag].id
//            event.mode = .edit
//            event.imageChanged = true
//            navigationController?.pushViewController(event, animated: true)
        break
        case .jobs:
            let id = posts[sender.tag].id
            let editPostedJob = StoryboardRouter.createEditJobPost()
            editPostedJob.jobId = id
            editPostedJob.roleType = .edit
            editPostedJob.delegate = self
            self.navigationController?.pushViewController(editPostedJob, animated: true)
            break
        default:
            break
        }
    }
    
    func returnPostType(post: DashboardItem) -> PostType {
        if !post.postImage!.isEmpty { return .image }
        else if post.postVideo != nil { return .video }
        else if post.postDocument != nil { return .article }
        else { return .simpleText }
    }
    
//    func deletePost(_ sender: UIButton) {
//        if selectedTab == .news { return  }
//        deletePost(postId: posts[sender.tag].id)
//    }
}

// MARK: Cell Actions
extension HomeVC {
    
    @objc func postLiked(_ sender: UIButton) {
        SVProgressHUD.show()
        let post = posts[sender.tag]
        likePost(postId: post.id, status: "active", action: !post.isJobLike.isNil ? "unlike" : "like", at: sender.tag)
    }
    
    @objc func newsLiked(_ sender: UIButton) {
//        SVProgressHUD.show()
//        let post = posts[sender.tag]
//        likeNews(postId: post.id, status: "active", action: !post.isNewsLike.isNil ? "unlike" : "like", at: sender.tag)
        self.openNewsDetailsPage(index: sender.tag)
    }
    
//    @objc func eventsLiked(_ sender: UIButton) {
//        IHProgressHUD.show()
//        let post = posts[sender.tag]
//        likeEvents(postId: post.id, status: "active", action: post.isEventLike == 1 ? "unlike" : "like", at: sender.tag)
//    }
    
    @objc func interestedBtnTapped(_ sender: UIButton) {
        let obj = posts[sender.tag]
        self.agenda = obj.agenda == 1 ? true : false
        if !agenda {
            let registrationLink = obj.registrationLink
            if let urlString = registrationLink, let url = URL(string: urlString), urlString.isValidEmail {
                let webVC = WebVC(url: url)
                webVC.modalPresentationStyle = .popover
                present(webVC, animated: true, completion: nil)
            }
        } else {
            let post = posts[sender.tag]
            likeEvents(postId: post.id, status: "active", action: post.isEventLike == 1 ? "unlike" : "like", at: sender.tag)
        }
    }
}

//MARK: REDIRECTION FUNCTION
extension HomeVC {
    
    @objc func urlCommentVCPost(sender: UIButton) { goToURLCommentVCPost(posts[sender.tag].id) }
    
    private func goToURLCommentVCPost(_ postId: Int) {
        let vc = StoryboardRouter.urlComment()
        vc.postId = postId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToOtherCommentVCPost(_ postId: Int) {
        let vc = StoryboardRouter.otherComment()
        vc.postId = postId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func newsCommentVCPost(sender: UIButton) {
//        let vc = StoryboardRouter.newsPopupVC()
//        vc.btnTag = sender.tag
//        vc.newId = posts[sender.tag].id
//        vc.delegate = self
//        vc.completion = { id in
//            if id == LoggedUserDetails.shared.user?.id ?? 0 {
//                let vc = DashboardTabbarVC.instantiate()
//                vc.tabType = 1
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                let vc = StoryboardRouter.othersProfileVC()
//                vc.profileID = id
//                vc.isFrom = 0
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//        navigationController?.present(vc, animated: true)
        self.openNewsDetailsPage(index: sender.tag)
    }
    
    @objc func saveNewsTapped(sender: UIButton) {
        showActivity()
        let post = posts[sender.tag]
        saveNews(postId: post.id, at: sender.tag)
    }
    
    @objc func goToProfileTapped(_ sender: UIButton) {
        let posts = posts[sender.tag]
        let id = posts.user?.id
        if id == myUserDefaults.userId {
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
        
    @objc func reportBtnTapped(_ sender: UIButton) {
        let index = sender.tag
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Report"],
                                    popOverPosition: .automatic,
                                    config: Constants.configWithMenuStyle(),
                                    done: { (selectedIndex) in
            switch selectedIndex {
            case 0:
                print("Report")
                let vc = reportPopupVC.instantiate()
                vc.postId = self.posts[index].id
                vc.userId = self.posts[index].user?.id ?? 0
                vc.completion = {
                    let vc = otherReasonPopupVC.instantiate()
                    vc.postId = self.posts[index].id
                    vc.userId = self.posts[index].user?.id ?? 0
                    self.navigationController?.present(vc, animated: true)
                }
                self.navigationController?.present(vc, animated: true)
            default:
                break
            }
        })
    }
    
    @objc func saveEventTapped(sender: UIButton) {
        print("saved Event")
        showActivity()
        let post = posts[sender.tag]
        saveEvent(postId: post.id, at: sender.tag)
    }
    
    @objc func reqToJoinTapped(sender: UIButton) {
        print("resquested Event")
        showActivity()
        let post = posts[sender.tag]
        reqToJoin(postId: post.id, at: sender.tag)
    }
    
    @objc func saveCurrentEventTapped(sender: UIButton) {
        print("saved Event")
        showActivity()
        let post = self.currentEventList[sender.tag]
        saveEvent(postId: post.id, at: sender.tag)
    }
    
    @objc func saveJobTapped(sender: UIButton) {
        showActivity()
        let post = posts[sender.tag]
        saveJob(postId: post.id, at: sender.tag)
    }
    
    @objc func urlVCPost(sender: UIButton) {
        self.openNewsDetailsPage(index: sender.tag)
    }
    
    func openNewsDetailsPage(index: Int) {
        let vc = StoryboardRouter.openNewsDetail() //openURLVC()
        let bindModelData = posts[index]
        vc.selectedNewsId = bindModelData.id
        vc.categoryID = bindModelData.evaNewsCategory?[0].id ?? 0
//        vc.contentString = bindModelData.type == .news ? bindModelData.link : bindModelData.content!.fetchUrlFromString()
        navigationController?.pushViewController(vc, animated: true)

    }
}

//MARK: CUSTOM PROTOCAL FOR API CALLING
extension HomeVC: RefreshUpdateable {
    
    func refresh(homeStatus: Bool) {
//        if homeStatus == true {
//            managePostStatus()
//        }
        selectedTab = .posts
        reloadData()
    }

}

// MARK: Share Custom Action
extension HomeVC : BottomContentPickerDelegate {
    
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        updateSpecificPost = (bottomShareSheet.data as? Int)
        shareContent(type: content, postType: selectedTab, postId: (bottomShareSheet.data as? Int) ?? 0, userId: bottomShareSheet.userId as? Int)
        bottomShareSheet.data = nil
        bottomShareSheet.userId = nil
    }
    
    @objc func handleShare(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.objectId
        vc.type = self.type
        vc.modalPresentationStyle = .popover
//        vc.completion = {
//            self.showToast(message: "Successfully Shared with desired Connection")
//        }
        self.present(vc, animated: true)
    }
}

// MARK: Post Actions Delegate
extension HomeVC: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
       switch action {
        case .like:
           let post = posts[sender.tag]
           likePost(postId: post.id, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike", at: sender.tag)
        case .comment:
           goToCommentVC(index: sender.tag)
        case .article:
           articleContent = posts[sender.tag].postDocument
//           updateSpecificPost = posts[sender.tag].id
           openArticle()
        case .edit:
           openEditPost(sender)
        case .delete:
//           presentAlertWithAction(title: "Delete", message: "Do you want to Delete this Post") { [weak self] in self?.deletePost(sender) }
           break
        default:
            shareItemIndex = sender.tag
        }
    }
    
    private func goToCommentVC(index: Int) {
        IQKeyboardManager.shared.isEnabled = false
        let homePost = posts[index]
//        updateSpecificPost = homePost.id
//        let link = homePost.content?.link
        if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // && post.postDocument == nil
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] {//Video
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postDocument != "" && homePost.postImage == []{ //document Cell
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else { // Image Cell
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
//            (!post.postDocument.isNil || link != nil) ? goToURLCommentVCPost(post.id) : goToOtherCommentVCPost(post.id)
//            (!post.postDocument.isNil || link != nil) ? goToOtherCommentVCPost(post.id) : goToURLCommentVCPost(post.id)
        }
    }
}
//MARK: Observer
extension HomeVC {
    
    func addObservers() {
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        edgesForExtendedLayout = []
        
        NotificationCenter.default.addObserver(forName: .init(rawValue: "callUpdateApi"), object: nil, queue: .main) { [weak self] _ in
            self?.reloadData()
        }
    }
}

extension HomeVC: HomeEventDelegate {
    
    func intrestedInEvent(dashboardItem: DashboardItem, event: HomeEvent) {
        let isGoing = dashboardItem.isAttending?.lowercased() != "going"
        let attendanceStatus = isGoing ? "Going" : "Not Going"
        let params: AFParameters = ["user_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                    "event_id": dashboardItem.id, "status": "active",
                                    "attendance_status": attendanceStatus]
        showActivity()
        NetworkManagerr.request(EndPoints.addAttendee, method: .post, parameters: params) { [weak self] (result: Result<Wrapper<[Int]>>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(_):
                if let indexPath = self.tableView.indexPath(for: event) {
                    self.posts[indexPath.item].isAttending = attendanceStatus
                    UIView.performWithoutAnimation {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            case .failure(let error):
                self.presentAlert("Error", nil, error)
            }
        }
    }
    
}

extension HomeVC {
    
    private func fetchSpecificPost(_ id: Int) {
        guard let index = posts.firstIndex(where: { $0.id == id }) else { return }
        let parameters: AFParameters = ["user_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                        "post_id" : id]
        NetworkManagerr.request(EndPoints.postDetails, method: .post, parameters: parameters) { [weak self] (result: Result<DashboardItemRoot>) in
            guard let self = self else { return }
            self.updateSpecificPost = nil
            switch result {
            case .success(let result):
                if let post = result.data.first {
                    self.posts[index] = post
                    UIView.performWithoutAnimation { self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none) }
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
}
