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
    
    @IBOutlet weak var secondBorderVw: UIView!
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
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var jobListTblVw: UITableView!
    @IBOutlet weak var jobListTblVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsListTblVw: UITableView!
    @IBOutlet weak var newsListTblVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var postListTblVw: UITableView!
    @IBOutlet weak var postListTblVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noCurrentEventLbl: UILabel!
    @IBOutlet weak var noCurrentEventLblHeight: NSLayoutConstraint!
    @IBOutlet weak var noOtherEventLbl: UILabel!
    @IBOutlet weak var noOtherEventLblHeight: NSLayoutConstraint!
    
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
            self.postListTblVw.reloadData()
        }
    }
    var jobList: [DashboardJob] = [] {
        didSet {
            self.jobListTblVw.reloadData()
        }
    }
    
    var newsList: [HomeNews] = [] {
        didSet {
            self.newsListTblVw.reloadData()
        }
    }
    
    
    var currentEventList: [EventListData] = [] {
        didSet {
            self.currentEventCollectionVw.reloadData()
        }
    }
    
    var allEventList: [EventListData] = []
    var upcomingEventList: [EventListData] = []
    var requestedEventList: [EventListData] = []
    var savedEventList: [EventListData] = []
    var passedEventList: [EventListData] = []
    var showEventList: [EventListData] = [] {
        didSet {
            self.tableView.reloadData()
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
    var currentPage = 1
    var lastPage = 1
    var isLoading = false
    
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
        
        //        //--> Set up the refresh control
        //        refreshControl.addTarget(self, action: #selector(refreshingContent), for: .valueChanged)
        //        tableView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendToken), name: NSNotification.Name(rawValue: "FCMToken"), object: nil)
        
        isSeparatorHidden = true
        setLayOut()
        addObservers()
        
        if selectedTab == .events {
            self.selectedHomeFilter = .new
        } else if selectedTab == .jobs || selectedTab == .industryJobs {
            if myUserDefaults.isIndivisualUser {
                selectedHomeFilter = .all
            } else {
                selectedHomeFilter = .active
            }
        } else if selectedTab == .news {
            selectedHomeFilter = .none
        }
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshingContent), for: .valueChanged)
        scrollvw.refreshControl = refreshControl
        
        //getPosts(offSet: 0)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.posts = []
//    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if(keyPath == "contentSize"){
//            self.tableViewHeightConst.constant = self.tableView.contentSize.height == 0 ? 1 : self.tableView.contentSize.height
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        isSeparatorHidden = true
        if myUserDefaults.isIndivisualUser {
            self.selectedTab = Constants.getEnumFromUserDefaults() ?? .news
        } else {
            self.selectedTab = Constants.getEnumFromUserDefaults() ?? .news
        }
        
        self.noCurrentEventLblHeight.constant = 0
        self.noOtherEventLblHeight.constant = 0
        self.currentEventLblHeight.constant = 0
        self.allEventLblHeight.constant = 0
        self.currentEventListHeight.constant = 0
        self.tableViewHeightConst.constant = 0
        self.jobListTblVwHeight.constant = 0
        self.postListTblVwHeight.constant = 0
        self.newsListTblVwHeight.constant = 0
        self.emptyListMessageLbl.text = ""
        
        self.offsetCount = 1
        
        if selectedTab == .jobs || selectedTab == .industryJobs {
            if myUserDefaults.isIndivisualUser {
                homeTabFilter = HomeTabFilter.job
            } else {
                homeTabFilter = HomeTabFilter.industryJobs
            }
            height = 32
            searchHeight = 40
            //selectedHomeFilter = .all
            let filter = self.selectedHomeFilter.rawValue.lowercased()
            self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
        } else if selectedTab == .events {
            height = 32
            searchHeight = 0
            if myUserDefaults.isIndivisualUser {
                homeTabFilter = HomeTabFilter.userEvent
            } else {
                homeTabFilter = HomeTabFilter.industryEvents
            }
            
            self.currentEventLbl.text = "Current Event"
            self.noCurrentEventLblHeight.constant = 0.0
            self.noOtherEventLblHeight.constant = 0.0
            self.currentEventLblHeight.constant = 0.0
            self.allEventLblHeight.constant = 0.0
            self.currentEventListHeight.constant = 0
            DispatchQueue.main.async {
                if self.selectedHomeFilter == .new {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "All Event"
                    self.fetchAllEventData()
                } else if self.selectedHomeFilter == .going {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "Upcoming Event"
                    self.fetchUpcomingEventData()
                } else if self.selectedHomeFilter == .requested {
                    self.fetchRequestedEventData()
                } else if self.selectedHomeFilter == .saved {
                    self.fetchSavedEventData()
                } else if self.selectedHomeFilter == .passed {
                    self.fetchPassedEventData()
                }
            }
            
        } else if selectedTab == .posts {
            height = 0
            searchHeight = 0
            reloadData(inserted: false)
            //posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
        }
        else if selectedTab == .news {
            height = 32
            searchHeight = 0
            self.offsetCount = 1
            self.fetchNewsListData(offSet: offsetCount)
            //posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
        }
        
        animateTopView()
        
        IQKeyboardManager.shared.isEnabled = true
        let searchIcon = UIImage(named: "TopSearch")?.withRenderingMode(.alwaysOriginal)
        searchButton = UIBarButtonItem(image: searchIcon, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(openSearchVC(_:)))
        if let hamBurgerButton = hamBurgerButton { navigationItem.rightBarButtonItems = [hamBurgerButton, searchButton!] }
        if posts.isEmpty {
            UIView.transition(with: collectionView, duration: 0.9, options: .transitionCrossDissolve) { [weak self] in self?.collectionView.reloadData() }
        }
//        posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offsetCount = 0
    }
    
    func setPostTableHeight() {
        var totalHeight = 0.0
        for homePost in self.posts {            
            var lblHeight: CGFloat = 0.0
            if homePost.isExpand {
                lblHeight = heightForView(homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            } else {
                let truncatedText = Constants.truncateContent(homePost.content ?? "", isExpanded: false)
                lblHeight = heightForView(truncatedText, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
            }
            
            let marginHeight = 160.0
            
            if homePost.postVideo != "" && homePost.postVideo != nil {
                let height = lblHeight + marginHeight + 210.0
                totalHeight = totalHeight + height
            } else if homePost.postDocuments?.count ?? 0 > 0 {
                let height = lblHeight + marginHeight + 200.0//80.0
                totalHeight = totalHeight + height
            } else if homePost.datumPostImage!.count > 0 {
                if homePost.datumPostImage!.count == 0 || homePost.datumPostImage!.count == 1 {
                    let height = lblHeight + marginHeight + 210.0 //-30 is page control view hidden...
                    totalHeight = totalHeight + height
                } else {
                    let height = lblHeight + marginHeight + 240.0
                    totalHeight = totalHeight + height
                }
            } else {
                let height = lblHeight + marginHeight
                totalHeight = totalHeight + height
            }
        }
        self.postListTblVwHeight.constant = totalHeight
        self.postListTblVw.reloadData()
    }
        
//    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = text
//
//        label.sizeToFit()
//        return label.frame.height
//    }
    func heightForView(_ text: Any, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var boundingBox: CGRect
        
        if let text = text as? String {
            boundingBox = text.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        } else if let attributedText = text as? NSAttributedString {
            boundingBox = attributedText.boundingRect(with: constraintRect,
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: nil)
        } else {
            return 0
        }
        
        return ceil(boundingBox.height)
    }
    
    func fetchCurrentEventData() {
        let parameters = [ "filter": "current" ] as [String: Any]
        
        showActivity()
            NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                self.refreshControl.endRefreshing()
                self.indicatorView.stopAnimating()
                guard let responseData = response.data else {
                    print("No response data received.")
                    // Optionally show an alert here
                    self.noCurrentEventLblHeight.constant = 50.0
                    return
                }

                do {
                    let jsonDecoder = JSONDecoder()
                    let currentEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)
                    self.filterCollectionView.isUserInteractionEnabled = true

                    if currentEventRoot.error == true {
                        print("Current Event Failure :: \(currentEventRoot.message ?? "Error")")
                        self.currentEventList = []
                        self.currentEventListHeight.constant = 0
                        self.noCurrentEventLblHeight.constant = 50.0
                        // Optionally show an alert here
                        // self.presentAlert("Info", currentEventRoot.message, nil)
                        return
                    }

                    if let events = currentEventRoot.data, !events.isEmpty {
                        self.currentEventList = events
                        self.currentEventListHeight.constant = CGFloat(events.count * 440)
                        self.noCurrentEventLblHeight.constant = 0.0
                    } else {
                        print("No current events found.")
                        self.currentEventList = []
                        self.currentEventListHeight.constant = 0
                        self.noCurrentEventLblHeight.constant = 50.0
                    }

                } catch {
                    self.offsetCount -= 1
                    print("Current Decoding error: \(error.localizedDescription)")
                    // Optionally show an alert here
                }
            }
    }
        
    func fetchAllEventData() {
        let parameters: [String: Any] = ["filter": "all_posts"]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            guard let responseData = response.data else {
                print("No response data received.")
                // Optionally show an alert here
                self.noOtherEventLbl.text = "No All Event Found."
                self.noOtherEventLblHeight.constant = 50.0
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let allEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)
                self.filterCollectionView.isUserInteractionEnabled = true

                if allEventRoot.error == true {
                    print("All Event Failure :: \(allEventRoot.message ?? "Error")")
                    self.allEventList = []
                    self.showEventList = self.allEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No All Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                    // Optionally show an alert here
                    // self.presentAlert("Info", currentEventRoot.message, nil)
                    return
                }

                if let events = allEventRoot.data, !events.isEmpty {
                    self.allEventList = events
                    self.showEventList = self.allEventList
                    self.tableViewHeightConst.constant = CGFloat(self.showEventList.count * 440)
                    self.noOtherEventLblHeight.constant = 0.0
                } else {
                    print("No current events found.")
                    self.allEventList = []
                    self.showEventList = self.allEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No All Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                }

            } catch {
                self.offsetCount -= 1
                print("All Decoding error: \(error.localizedDescription)")
                // Optionally show an alert here
            }
        }
    }

    
    func fetchUpcomingEventData() {
        let parameters = [ "filter": "upcoming" ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            guard let responseData = response.data else {
                print("No response data received.")
                // Optionally show an alert here
                self.noOtherEventLbl.text = "No Upcoming Event Found."
                self.noOtherEventLblHeight.constant = 50.0
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let upcomingEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)

                if upcomingEventRoot.error == true {
                    print("Upcoming Event Failure :: \(upcomingEventRoot.message ?? "Error")")
                    self.upcomingEventList = upcomingEventRoot.data ?? []
                    self.showEventList = self.upcomingEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Upcoming Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                    // Optionally show an alert here
                    // self.presentAlert("Info", currentEventRoot.message, nil)
                    return
                }

                if let events = upcomingEventRoot.data, !events.isEmpty {
                    self.upcomingEventList = events
                    self.showEventList = self.upcomingEventList
                    self.tableViewHeightConst.constant = CGFloat(self.showEventList.count * 440)
                    self.noOtherEventLblHeight.constant = 0.0
                } else {
                    print("No Requested events found.")
                    self.upcomingEventList = []
                    self.showEventList = self.upcomingEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Upcoming Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                }

            } catch {
                self.offsetCount -= 1
                print("Upcoming Decoding error: \(error.localizedDescription)")
                // Optionally show an alert here
            }
        }
    }
    
    func fetchRequestedEventData() {
        let parameters: [String: Any] = ["filter": "requested"]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            guard let responseData = response.data else {
                print("No response data received.")
                // Optionally show an alert here
                self.noOtherEventLbl.text = "No Requested Event Found."
                self.noOtherEventLblHeight.constant = 50.0
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let requestedEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)

                if requestedEventRoot.error == true {
                    print("Requested Event Failure :: \(requestedEventRoot.message ?? "Error")")
                    self.requestedEventList = requestedEventRoot.data ?? []
                    self.showEventList = self.requestedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Requested Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                    // Optionally show an alert here
                    // self.presentAlert("Info", currentEventRoot.message, nil)
                    return
                }

                if let events = requestedEventRoot.data, !events.isEmpty {
                    self.requestedEventList = events
                    self.showEventList = self.requestedEventList
                    self.tableViewHeightConst.constant = CGFloat(self.showEventList.count * 440)
                    self.noOtherEventLblHeight.constant = 0.0
                } else {
                    print("No Requested events found.")
                    self.requestedEventList = []
                    self.showEventList = self.requestedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Requested Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                }

            } catch {
                self.offsetCount -= 1
                print("Requested Decoding error: \(error.localizedDescription)")
                // Optionally show an alert here
            }
        }
    }
    
    func fetchSavedEventData() {
        let parameters = [ "filter": "saved" ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            guard let responseData = response.data else {
                print("No response data received.")
                // Optionally show an alert here
                self.noOtherEventLbl.text = "No Saved Event Found."
                self.noOtherEventLblHeight.constant = 50.0
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let savedEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)

                if savedEventRoot.error == true {
                    print("Saved Event Failure :: \(savedEventRoot.message ?? "Error")")
                    self.savedEventList = savedEventRoot.data ?? []
                    self.showEventList = self.savedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Saved Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                    // Optionally show an alert here
                    // self.presentAlert("Info", currentEventRoot.message, nil)
                    return
                }

                if let events = savedEventRoot.data, !events.isEmpty {
                    self.savedEventList = events
                    self.showEventList = self.savedEventList
                    self.tableViewHeightConst.constant = CGFloat(self.showEventList.count * 440)
                    self.noOtherEventLblHeight.constant = 0.0
                } else {
                    print("No saved events found.")
                    self.savedEventList = []
                    self.showEventList = self.savedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Saved Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                }

            } catch {
                self.offsetCount -= 1
                print("Saved Decoding error: \(error.localizedDescription)")
                // Optionally show an alert here
            }
        }

    }
    
    func fetchPassedEventData() {
        let parameters = [ "filter": "passed" ] as [String: Any]
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            guard let responseData = response.data else {
                print("No response data received.")
                // Optionally show an alert here
                self.noOtherEventLbl.text = "No Passed Event Found."
                self.noOtherEventLblHeight.constant = 50.0
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let passedEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: responseData)

                if passedEventRoot.error == true {
                    print("Passed Event Failure :: \(passedEventRoot.message ?? "Error")")
                    self.passedEventList = passedEventRoot.data ?? []
                    self.showEventList = self.passedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Passed Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                    // Optionally show an alert here
                    // self.presentAlert("Info", currentEventRoot.message, nil)
                    return
                }

                if let events = passedEventRoot.data, !events.isEmpty {
                    self.passedEventList = events
                    self.showEventList = self.passedEventList
                    self.tableViewHeightConst.constant = CGFloat(self.showEventList.count * 440)
                    self.noOtherEventLblHeight.constant = 0.0
                } else {
                    print("No passed events found.")
                    self.passedEventList = []
                    self.showEventList = self.passedEventList
                    self.tableViewHeightConst.constant = 0
                    self.noOtherEventLbl.text = "No Passed Event Found."
                    self.noOtherEventLblHeight.constant = 50.0
                }

            } catch {
                self.offsetCount -= 1
                print("Passed Decoding error: \(error.localizedDescription)")
                // Optionally show an alert here
            }
        }
    }
    
//    func fetchNewsListData(offSet: Int) {
//        let url = "\(selectedTab.getPostEndPoint)?limit=\(pageSize)&offset=\(offSet)"
//        let parameters: AFParameters = ["filter": selectedHomeFilter.getFilter(tab: selectedTab)]
//        showActivity()
//        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
//            self.hideActivity()
//            self.refreshControl.endRefreshing()
//            self.indicatorView.stopAnimating()
//            guard let responseData = response.data else {
//                print("No response data received.")
//                // Optionally show an alert here
//                self.noOtherEventLbl.text = "No News Data Found."
//                self.noOtherEventLblHeight.constant = 50.0
//                return
//            }
//
//            do {
//                let jsonDecoder = JSONDecoder()
//                let newsRoot = try jsonDecoder.decode(HomeNewsDataModel.self, from: responseData)
//
//                if newsRoot.error == true {
//                    print("News Failure :: \(newsRoot.message ?? "Error")")
//                    self.newsList = newsRoot.data?.news ?? []
//                    self.newsListTblVwHeight.constant = 0
//                    self.noOtherEventLbl.text = "No News Data Found."
//                    self.noOtherEventLblHeight.constant = 50.0
//                    // Optionally show an alert here
//                    // self.presentAlert("Info", currentEventRoot.message, nil)
//                    return
//                }
//
//                if let news = newsRoot.data?.news, !news.isEmpty {
//                    self.newsList = news
//                    self.newsListTblVwHeight.constant = CGFloat(self.newsList.count * 430)
//                    self.noOtherEventLblHeight.constant = 0.0
//                } else {
//                    print("No news found.")
//                    self.newsList = newsRoot.data?.news ?? []
//                    self.newsListTblVwHeight.constant = 0
//                    self.noOtherEventLbl.text = "No News Data Found."
//                    self.noOtherEventLblHeight.constant = 50.0
//                }
//
//            } catch {
//                self.offsetCount -= 1
//                print("news Decoding error: \(error)")
//                // Optionally show an alert here
//            }
//        }
//    }
    
    func fetchNewsListData(offSet: Int, isRefreshing: Bool = false) {
        guard !isLoading else { return } // 🔒 prevent multiple calls
        isLoading = true

        let url = "\(selectedTab.getPostEndPoint)?limit=\(pageSize)&offset=\(offSet)"
        let parameters: AFParameters = ["filter": selectedHomeFilter.getFilter(tab: selectedTab)]

        if !isRefreshing {
            showActivity()
        }

        NetworkManagerr.request(url, method: .post, parameters: parameters) { response in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            self.isLoading = false

            guard let responseData = response.data else {
                self.noOtherEventLbl.text = "No News Data Found."
                self.noOtherEventLblHeight.constant = 50
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(HomeNewsDataModel.self, from: responseData)

                if newsRoot.error == true {
                    print("News Failure :: \(newsRoot.message ?? "Error")")
                    if isRefreshing {
                        self.newsList.removeAll()
                    }
                    DispatchQueue.main.async {
                        self.newsListTblVw.reloadData()
                        self.newsListTblVwHeight.constant = 0
                        self.noOtherEventLbl.text = "No News Data Found."
                        self.noOtherEventLblHeight.constant = 50
                    }
                    return
                }

                guard let data = newsRoot.data else {
                    DispatchQueue.main.async {
                        self.newsListTblVw.reloadData()
                        self.newsListTblVwHeight.constant = 0
                        self.noOtherEventLbl.text = "No News Data Found."
                        self.noOtherEventLblHeight.constant = 50
                    }
                    return
                }

                self.lastPage = data.lastPage ?? 1 // save last page info

                if let newNews = data.news, !newNews.isEmpty {
                    if isRefreshing || offSet == 1 {
                        self.newsList = newNews
                    } else {
                        self.newsList.append(contentsOf: newNews)
                    }

                    DispatchQueue.main.async {
                        self.newsListTblVw.reloadData()
                        self.newsListTblVwHeight.constant = CGFloat(self.newsList.count * 430)
                        self.noOtherEventLblHeight.constant = 0
                    }
                } else {
                    DispatchQueue.main.async {
                        self.newsListTblVw.reloadData()
                        self.newsListTblVwHeight.constant = 0
                        self.noOtherEventLbl.text = "No News Data Found."
                        self.noOtherEventLblHeight.constant = 50
                    }
                }

            } catch {
                self.offsetCount -= 1
                print("Decoding error: \(error)")
            }
        }
    }

    
    func fetchJobListData(filter: String, currentPage: Int, searchStr: String) {
        showActivity()
        // Base URL
        guard var urlComponents = URLComponents(string: EndPoints.getJobList) else {
            print("Invalid URL")
            hideActivity()
            return
        }
        
        // Query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "\(currentPage)"),
            URLQueryItem(name: "filter", value: filter),
            URLQueryItem(name: "search", value: searchStr)
        ]
        
        guard let finalURL = urlComponents.url?.absoluteString else {
            print("Failed to create final URL")
            hideActivity()
            return
        }
        
        print("Request URL: \(finalURL)")
        
        // Network request
        NetworkManagerr.request(finalURL, method: .get) { response in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            self.indicatorView.stopAnimating()
            self.filterCollectionView.isUserInteractionEnabled = true
            
            let decoder = JSONDecoder()
            
            do {
                let jobListData = try decoder.decode(DashboardJobDataModel.self, from: response.data!)
                
                if !(jobListData.error ?? false) {
                    self.lastPage = jobListData.data?.lastPage ?? 1
                    let jobs = jobListData.data?.jobs ?? []
                    
                    // Update job list
                    if currentPage <= 1 {
                        self.jobList = jobs
                    } else {
                        self.jobList.append(contentsOf: jobs)
                    }
                    
                    // Empty state
                    if jobs.isEmpty {
                        self.emptyListMessageLbl.isHidden = false
                        self.emptyListMessageLbl.text = jobListData.message ?? "Job list is empty"
                    } else {
                        self.emptyListMessageLbl.isHidden = true
                        self.emptyListMessageLbl.text = ""
                    }
                    
                    // Table view height
//                    let rowHeight = self.selectedHomeFilter == .applied ? 234 : 284
//                    self.jobListTblVwHeight.constant = CGFloat(self.jobList.count * rowHeight)
                    
                    var finalHeight = 0.0
                    for job in self.jobList {
                        if job.isApplied == 0 {
                            finalHeight = finalHeight + 284.0
                        } else {
                            finalHeight = finalHeight + 234.0
                        }
                    }
                    self.jobListTblVwHeight.constant = finalHeight
                    
                    self.jobListTblVw.reloadData()
                    
                } else {
                    self.presentAlert("Failure", jobListData.message, nil)
                }
            } catch {
                self.offsetCount -= 1
                print("Job Decoding error: \(error)")
                self.presentAlert("Error", "Failed to parse response", nil)
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
            self.objectId = event.id ?? 0
            self.type = .event
            
            if let imageUrl = event.tempImage,
               !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
               let url = URL(string: imageUrl),
               UIApplication.shared.canOpenURL(url) {
                cell.imgVW.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
            } else {
                cell.imgVW.image = UIImage(named: "eventPlaceholder")
            }
            
            cell.titleLbl.text = event.name ?? ""
            cell.dateLbl.text = "\(event.startDate ?? "") - \(event.endDate ?? "")"
            cell.locationLbl.text = "\(event.address ?? ""), \(event.city ?? ""), \(event.country ?? "")"
            
            cell.timeLbl.text = "\(event.startTime ?? "") - \(event.endTime ?? "")"
            
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
            
//            let eventAttendeesStatus = event.eventAttendeesStatus ?? ""
//            if eventAttendeesStatus == "accepted" {
//                cell.requestJoinBtn.setTitle("View details", for: .normal)
//            }
//            else if eventAttendeesStatus == "Request_To_Join" {
//                cell.requestJoinBtn.setTitle("Requested", for: .normal)
//            }
//            else if eventAttendeesStatus == "decline" {
//                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//            }
//            else {
//                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//            }
            
            cell.saveBtn.tag = indexPath.row
            cell.saveBtn.addTarget(self, action: #selector(saveCurrentEventTapped(sender:)), for: .touchUpInside)
            cell.detailNavigateBtn.tag = indexPath.row
            cell.detailNavigateBtn.addTarget(self, action: #selector(openCurrentEventDetail(sender:)), for: .touchUpInside)
            cell.viewDetailsBtn.tag = indexPath.row
            cell.viewDetailsBtn.addTarget(self, action: #selector(currentEventViewDetailsTapped(sender:)), for: .touchUpInside)
            
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
        vc.eventId = currentEventList[sender.tag].id ?? 0 //4
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if tableView.refreshControl!.isRefreshing || indicatorView.isAnimating { return }
//        if self.collectionView == collectionView || selectedTabFilter == indexPath.item { return }
        selectedHomeFilter = homeTabFilter[indexPath.item]
        self.offsetCount = 1
        if selectedTab == .events {
            
            self.currentEventList = []
            self.allEventList = []
            self.upcomingEventList = []
            self.requestedEventList = []
            self.savedEventList = []
            self.passedEventList = []
            self.showEventList = []
            
            self.currentEventLbl.text = "Current Event"
            self.noCurrentEventLblHeight.constant = 0.0
            self.noOtherEventLblHeight.constant = 0.0
            self.currentEventLblHeight.constant = 0.0
            self.allEventLblHeight.constant = 0.0
            self.currentEventListHeight.constant = 0
            if self.selectedHomeFilter == .new {
                self.currentEventLblHeight.constant = 70.0
                self.allEventLblHeight.constant = 70.0
                self.fetchCurrentEventData()
                self.allEventLbl.text = "All Event"
                self.fetchAllEventData()
            } else if self.selectedHomeFilter == .going {
                self.currentEventLblHeight.constant = 70.0
                self.allEventLblHeight.constant = 70.0
                self.fetchCurrentEventData()
                self.allEventLbl.text = "Upcoming Event"
                self.fetchUpcomingEventData()
            } else if self.selectedHomeFilter == .requested {
                self.fetchRequestedEventData()
            } else if self.selectedHomeFilter == .saved {
                self.fetchSavedEventData()
            } else if self.selectedHomeFilter == .passed {
                self.fetchPassedEventData()
            }
        } else if selectedTab == .jobs {
            print(selectedHomeFilter)
            self.jobList = []
            self.currentPage = 1
            let filter = self.selectedHomeFilter.rawValue.lowercased()
            self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
        } else if selectedTab == .news {
            self.newsList = []
            self.offsetCount = 1
            self.fetchNewsListData(offSet: offsetCount)
        }
        else {
            self.posts = []
            //refreshingContent()
            reloadData()
        }
        //filterCollectionView.isUserInteractionEnabled = false
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
extension HomeVC: UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate, PostCellHeightDelegate {
    func postTblHeightManaged(index: Int, isExpand: Bool, tapOther: Bool) {
        if tapOther {
            self.goToCommentVC(index: index)
        } else {
            self.posts[index].isExpand = isExpand
            self.setPostTableHeight()
            self.postListTblVw.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

    func didSelectItem(at indexPath: Int, imgArr: [String?]) {
        print("Post Image Clicked.")
        if imgArr.count != 0 {
            let vc = DownloadChatImgVC.instantiate(images: imgArr, at: indexPath)
            vc.modalPresentationStyle = .fullScreen
            vc.isFromHomeVc = true
            vc.completion = {
                
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            switch selectedTab {
            case .posts:
                return 0
            case .events:
                return 440
            case .jobs:
                return 0
            case .news:
                return 0
            case .industryEvents:
                return 398
            case .industryJobs:
                return 0 //UITableView.automaticDimension
            case .industryPost:
                return UITableView.automaticDimension
            }
            
        case jobListTblVw:
            if myUserDefaults.isIndivisualUser {
                let job = self.jobList[indexPath.row]
                if job.isApplied == 0 {
//                if selectedHomeFilter == .applied {
                    return 284
                } else {
                    return 234
                }
            } else {
                return 284
            }
            
        case newsListTblVw:
            return 430
            
        case postListTblVw:
            if selectedTab == .posts {
                let homePost = posts[indexPath.row]
                var lblHeight: CGFloat = 0.0
                if homePost.isExpand {
                    lblHeight = heightForView(homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                } else {
                    let truncatedText = Constants.truncateContent(homePost.content ?? "", isExpanded: false)
                    lblHeight = heightForView(truncatedText, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                }
                let marginHeight = 160.0
                
                if homePost.postVideo != "" && homePost.postVideo != nil {
                    let height = lblHeight + marginHeight + 210.0
                    return height
                } else if homePost.postDocuments?.count ?? 0 > 0 {
                    let height = lblHeight + marginHeight + 200.0//80.0
                    return height
                } else if homePost.datumPostImage!.count > 0 {
                    if homePost.datumPostImage!.count == 0 || homePost.datumPostImage!.count == 1 {
                        let height = lblHeight + marginHeight + 210.0 //-30 is page control view hidden...
                        return height
                    } else {
                        let height = lblHeight + marginHeight + 240.0
                        return height
                    }
                } else {
                    let height = lblHeight + marginHeight
                    return height
                }
            } else {
                return 0
            }

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            if selectedTab == .events {
                return self.showEventList.count
            } else { return 0 }
//            if selectedTab == .jobs {
//                return 0//self.jobList.count
//            }
//            else if selectedTab == .events {
//                return self.showEventList.count
//            }
//            else if selectedTab == .posts {
//                return 0//posts.count
//            }
//            else if selectedTab == .news{
//                return 0//posts.count
//            }
//            else {
//                return 0
//            }
            
        case self.jobListTblVw:
            if selectedTab == .jobs || selectedTab == .industryJobs {
                return self.jobList.count
            } else { return 0 }
            
        case self.newsListTblVw:
            if selectedTab == .news {
                return newsList.count
            } else { return 0 }
            
        case self.postListTblVw:
            if selectedTab == .posts {
                return posts.count
            } else { return 0 }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.jobListTblVw:
            //            if user?.type == userType.user.rawValue {
            let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.baseMainView.layer.cornerRadius = 12
            cell.indivisualViewStack.isHidden = false
            cell.indivisualVw.isHidden = true
            cell.industryView.isHidden = true
            cell.saveJobBtn.isHidden = false
            //cell.job = self.jobList[indexPath.row]
            let job = self.jobList[indexPath.row]
            cell.setData(data: job)
            cell.viewDetailsBtn.tag = indexPath.row
            cell.saveJobBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            cell.applicantBtn.tag = indexPath.row
            cell.applyNowBtn.tag = indexPath.row
            //cell.goToAd = { [weak self] in self?.navigateToJobListing(job: $0) }
            
            if myUserDefaults.isIndivisualUser {
                cell.indivisualVw.isHidden = false
                cell.saveJobBtn.isHidden = false
//                if selectedHomeFilter == .applied {
                if job.isApplied == 0 {
                    cell.applyNowBtnHeight.constant = 50
                } else {
                    cell.applyNowBtnHeight.constant = 0.0
                }
            } else {
                cell.industryView.isHidden = false
                cell.saveJobBtn.isHidden = true
            }
            
            
            cell.viewDetailsBtn.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
            cell.applyNowBtn.addTarget(self, action: #selector(tapJobApply(sender:)), for: .touchUpInside)
            cell.saveJobBtn.addTarget(self, action: #selector(saveJobTapped(sender:)), for: .touchUpInside)
            cell.editBtn.addTarget(self, action:  #selector(tapEditJob(sender:)), for: .touchUpInside)
            cell.applicantBtn.addTarget(self, action:  #selector(tapApplicantsList(sender:)), for: .touchUpInside)
            return cell
            //            } else {
            //                let cell: CompanyJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            //                cell.item = posts[indexPath.row]
            //                cell.edit = { [weak self] in self?.navigateToEditJob(job: $0) }
            //                return cell
            //            }
            
        case self.postListTblVw:
            
            let cell: HomePostTVC = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let homePost = posts[indexPath.row]
            cell.selectedPost = homePost
            if homePost.postVideo != "" && homePost.postVideo != nil {
                cell.uiData(dataMaper: homePost, type: "video")
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.openVideoBtn.tag = indexPath.row
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resizeAspectFill)
                cell.videoView.stop()
                cell.videoView.isHidden = false
            }
            else if (homePost.postDocuments?.count ?? 0) > 0 {
                cell.uiData(dataMaper: homePost, type: "document")
            }
            else if homePost.datumPostImage!.count > 0 {
                cell.uiData(dataMaper: homePost, type: "image")
                cell.delegateDidSelect = self
            }
            else {
                cell.uiData(dataMaper: homePost, type: "text")
            }
            
            cell.delegate = self
            cell.postCellHeightDelegate = self
            self.objectId = homePost.id ?? 0
            self.type = .post
            cell.goToProfileBtn.tag = indexPath.row
            cell.reportBtn.tag = indexPath.row
            cell.likeButton.tag = indexPath.row
            cell.commentButton.tag = indexPath.row
            cell.shareButton.tag = indexPath.row
            cell.openArticleBtn.tag = indexPath.row
            cell.followBtn.tag = indexPath.row
            
            cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
            cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
            cell.shareButton.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
            cell.followBtn.addTarget(self, action: #selector(handlePostFollow(_:)), for: .touchUpInside)
            
            return cell
            
//            if selectedTab == .posts {
//                let homePost = posts[indexPath.row]
//                //let homePostUserId = homePost.user?.id ?? 0
//                
//                if homePost.postVideo != "" && homePost.postVideo != nil {
//                    let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.delegate = self
//                    cell.uiData(dataMaper: homePost)
//                    
//                    cell.sharedBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.likeBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.sharedBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                    cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//                    cell.openVideoBtn.tag = indexPath.row
//                    cell.videoView.backgroundColor = .black
//                    cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resizeAspectFill)
//                    cell.videoView.stop()
//                    cell.videoView.isHidden = false
//                    return cell
//                }
//                else if (homePost.postDocuments?.count ?? 0) > 0 {
//                    let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
//                    cell.delegate = self
//                    cell.uiData(homePost: homePost)
//                    cell.likeBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.sharedBtn.tag = indexPath.row
//                    cell.openArticleBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.sharedBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                }
//                else if homePost.datumPostImage!.count > 0 {
//                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
//                    cell.uiData(dataMaper: homePost)
//                    cell.delegate = self
//                    cell.delegateDidSelect = self
//                    cell.parentViewController = self
//                    
//                    cell.likeButton.tag = indexPath.row
//                    cell.commentButton.tag = indexPath.row
//                    cell.shareButton.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.shareButton.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                }
//                else {
//                    let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    
//                    cell.detailsView.layer.cornerRadius = 13
//                    cell.delegate = self
//                    cell.uiData(dataMaper: homePost)
//                    cell.shareBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.likeBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.shareBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    return cell
//                }
//            }
            
        case self.newsListTblVw:
            let cell: HomeNewz = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let newz = newsList[indexPath.row]
            
            cell.setNewsData(dataMaper: newz)
            cell.likeBtn.tag = indexPath.row
            cell.sharedBtn.tag = indexPath.row
            cell.commentBtn.tag = indexPath.row
            cell.openURl.tag = indexPath.row
            cell.saveNewsBtn.tag = indexPath.row
            cell.detailNavigateBtn.tag = indexPath.row
            
            self.objectId = newz.id ?? 0
            self.type = .news
            cell.detailNavigateBtn.addTarget(self, action: #selector(newsDetails(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
            cell.sharedBtn.addTarget(self, action: #selector(handleNewsShare(_:)), for: .touchUpInside)
            cell.openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action:#selector(newsCommentVCPost(sender:)), for: .touchUpInside)
            cell.saveNewsBtn.addTarget(self, action:#selector(saveNewsTapped(sender:)), for: .touchUpInside)
            
            return cell
            
        case self.tableView:
            if selectedTab == .events {
                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                
                let event = showEventList[indexPath.row]
                cell.uiData(event: event)
                cell.delegate = self
                cell.eventDelegate = self
                cell.navigateToDetail.tag = indexPath.row
                cell.saveEventBtn.tag = indexPath.row
                cell.viewDetailsBtn.tag = indexPath.row
                self.objectId = event.id ?? 0
                self.type = .event
                cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
                cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
                cell.viewDetailsBtn.addTarget(self, action: #selector(eventViewDetailsTapped(sender:)), for: .touchUpInside)
                return cell
            }
            
//            switch selectedTab {
//            case .posts, .industryPost:
//                let homePost = posts[indexPath.row]
//                
//                if homePost.postVideo != "" && homePost.postVideo != nil {
//                    let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.delegate = self
//                    cell.uiData(dataMaper: homePost)
//                    
//                    cell.sharedBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.likeBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.sharedBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                    cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//                    cell.openVideoBtn.tag = indexPath.row
//                    cell.videoView.backgroundColor = .black
//                    cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resizeAspectFill)
//                    cell.videoView.stop()
//                    cell.videoView.isHidden = false
//                    return cell
//                }
//                else if (homePost.postDocuments?.count ?? 0) > 0 {
//                    let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
//                    cell.delegate = self
//                    cell.uiData(homePost: homePost)
//                    cell.likeBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.sharedBtn.tag = indexPath.row
//                    cell.openArticleBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.sharedBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                }
//                else if homePost.datumPostImage!.count > 0 {
//                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
//                    cell.uiData(dataMaper: homePost)
//                    cell.delegate = self
//                    cell.delegateDidSelect = self
//                    cell.parentViewController = self
//                    
//                    cell.likeButton.tag = indexPath.row
//                    cell.commentButton.tag = indexPath.row
//                    cell.shareButton.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.shareButton.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                }
//                else {
//                    let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                    
//                    cell.detailsView.layer.cornerRadius = 13
//                    cell.delegate = self
//                    cell.uiData(dataMaper: homePost)
//                    cell.shareBtn.tag = indexPath.row
//                    cell.commentBtn.tag = indexPath.row
//                    cell.likeBtn.tag = indexPath.row
//                    cell.goToProfileBtn.tag = indexPath.row
//                    cell.reportBtn.tag = indexPath.row
//                    self.objectId = homePost.id ?? 0
//                    self.type = .post
//                    cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//                    cell.shareBtn.addTarget(self, action: #selector(handlePostShare(_:)), for: .touchUpInside)
//                    cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
//                    return cell
//                }
//                
//            case .events:
//                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                
//                let event = showEventList[indexPath.row]
//                cell.uiData(event: event)
//                cell.delegate = self
//                cell.eventDelegate = self
//                cell.navigateToDetail.tag = indexPath.row
//                cell.saveEventBtn.tag = indexPath.row
//                cell.viewDetailsBtn.tag = indexPath.row
//                self.objectId = event.id ?? 0
//                self.type = .event
//                cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//                cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
//                cell.viewDetailsBtn.addTarget(self, action: #selector(eventViewDetailsTapped(sender:)), for: .touchUpInside)
//                
////                if self.selectedHomeFilter == .new {
////                    let event = allEventList[indexPath.row]
////                    cell.uiData(event: event)
////                    cell.delegate = self
////                    cell.eventDelegate = self
////                    cell.navigateToDetail.tag = indexPath.row
////                    cell.saveEventBtn.tag = indexPath.row
////                    cell.viewDetailsBtn.tag = indexPath.row
////                    self.objectId = event.id ?? 0
////                    self.type = .event
////                    cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
////                    cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
////                    cell.viewDetailsBtn.addTarget(self, action: #selector(eventViewDetailsTapped(sender:)), for: .touchUpInside)
////                    
////                }
////                else if self.selectedHomeFilter == .going {
////                    let event = upcomingEventList[indexPath.row]
////                    cell.uiData(event: event)
////                    cell.delegate = self
////                    cell.eventDelegate = self
////                    cell.navigateToDetail.tag = indexPath.row
////                    cell.saveEventBtn.tag = indexPath.row
////                    cell.viewDetailsBtn.tag = indexPath.row
////                    self.objectId = event.id ?? 0
////                    self.type = .event
////                    cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
////                    cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
////                    cell.viewDetailsBtn.addTarget(self, action: #selector(eventViewDetailsTapped(sender:)), for: .touchUpInside)
////                }
////                else {
////                    
////                    let event = posts[indexPath.row]
////                    cell.uiData(dataMaper: event)
////                    cell.dashboardItem = event
////                    cell.delegate = self
////                    cell.eventDelegate = self
//////                    cell.interrestedBtn.tag = indexPath.row
//////                    if LoggedUserDetails.shared.user!.id != event.user!.id {
//////                        cell.attendingBtn.isHidden = false
//////                        cell.attendingBtn.tag = indexPath.row
//////                        //cell.attendingBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//////                    }
//////                    else {
//////                        cell.attendingBtn.isHidden = true
//////                    }
//////                    if self.selectedTabFilter == 1 {
//////                        cell.BottomViewStack.isHidden = true
//////                    } else {
//////                        cell.BottomViewStack.isHidden = false
//////                    }
//////                    cell.industryUserView.isHidden = true
//////                    cell.indivisualUserView.isHidden = false
//////                    
//////                    cell.sharedBtn.tag = indexPath.row
////                    cell.navigateToDetail.tag = indexPath.row
////                    cell.saveEventBtn.tag = indexPath.row
////                    cell.viewDetailsBtn.tag = indexPath.row
////                    self.objectId = event.id ?? 0
////                    self.type = .event
////                    
////                    
//////                    let eventAttendeesStatus = event.eventAttendeesStatus ?? ""
//////                    if eventAttendeesStatus == "accepted" {
//////                        cell.requestJoinBtn.setTitle("View details", for: .normal)
//////                    }
//////                    else if eventAttendeesStatus == "Request_To_Join" {
//////                        cell.requestJoinBtn.setTitle("Requested", for: .normal)
//////                    }
//////                    else if eventAttendeesStatus == "decline" {
//////                        cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//////                    }
//////                    else {
//////                        cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//////                    }
//////                    
//////                    cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
////                    cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
////                    cell.saveEventBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
////                    cell.viewDetailsBtn.addTarget(self, action: #selector(eventViewDetailsTapped(sender:)), for: .touchUpInside)
//////                    cell.interrestedBtn.addTarget(self, action: #selector(interestedBtnTapped(_:)), for: .touchUpInside)
//////                    
//////                    cell.intrestedTapped = { [weak self] dashboardItem in
//////                        let vc = StoryboardRouter.intrested()
//////                        vc.dashboardItem = dashboardItem
//////                        self?.navigationController?.pushViewController(vc, animated: true)
//////                    }
////                }
//                return cell
//                
//            case .industryEvents:
//                let event = posts[indexPath.row]
//                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                cell.uiData(dataMaper: event)
//                cell.dashboardItem = event
//                //            cell.delegate = self
//                //            cell.eventDelegate = self
//                //            if LoggedUserDetails.shared.user!.id != event.user!.id {
//                //                cell.attendingBtn.isHidden = false
//                //                cell.attendingBtn.tag = indexPath.row
//                //                //cell.attendingBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//                //            }
//                //            else {
//                //                cell.attendingBtn.isHidden = true
//                //            }
//                
//                //                      cell.sharedBtn.tag = indexPath.row
////                if self.selectedTabFilter == 1 {
////                    cell.BottomViewStack.isHidden = true
////                } else {
////                    cell.BottomViewStack.isHidden = false
////                }
////                cell.industryUserView.isHidden = false
////                cell.indivisualUserView.isHidden = true
////                cell.navigateToDetail.tag = indexPath.row
////                cell.noOfIntererstedBtn.tag = indexPath.row
//                //                      cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                cell.navigateToDetail.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
//                cell.intrestedTapped = { [weak self] dashboardItem in
//                    let vc = StoryboardRouter.intrested()
//                    vc.dashboardItem = dashboardItem
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
////                cell.noOfIntererstedBtn.addTarget(self, action:#selector(interestedListTapped(_:)), for: .touchUpInside)
//                return cell
//            case .news:
//                let cell: HomeNewz = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                let newz = newsList[indexPath.row]
//                
//                //cell.uiData(dataMaper: newz)
//                cell.setNewsData(dataMaper: newz)
//                cell.likeBtn.tag = indexPath.row
//                cell.sharedBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.openURl.tag = indexPath.row
//                cell.saveNewsBtn.tag = indexPath.row
//                cell.detailNavigateBtn.tag = indexPath.row
//                
//                self.objectId = newz.id ?? 0
//                self.type = .news
//                cell.detailNavigateBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
//                cell.likeBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
//                cell.sharedBtn.addTarget(self, action: #selector(handleNewsShare(_:)), for: .touchUpInside)
//                cell.openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
//                cell.commentBtn.addTarget(self, action:#selector(newsCommentVCPost(sender:)), for: .touchUpInside)
//                cell.saveNewsBtn.addTarget(self, action:#selector(saveNewsTapped(sender:)), for: .touchUpInside)
//                
//                return cell
//            case .jobs:
//                //            if user?.type == userType.user.rawValue {
//                let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                cell.baseMainView.layer.cornerRadius = 12
//                cell.indivisualViewStack.isHidden = false
//                cell.industryView.isHidden = true
//                cell.indivisualVw.isHidden = false
//                cell.saveJobBtn.isHidden = false
//                //                cell.job = self.jobList[indexPath.row]
//                let job = self.jobList[indexPath.row]
//                cell.setData(data: job)
//                cell.viewDetailsBtn.tag = indexPath.row
//                cell.saveJobBtn.tag = indexPath.row
////                cell.editBtn.tag = indexPath.row
////                cell.applicantBtn.tag = indexPath.row
//                cell.applyNowBtn.tag = indexPath.row
//                //                cell.goToAd = { [weak self] in self?.navigateToJobListing(job: $0) }
//                
//                if selectedHomeFilter == .applied {
//                    cell.applyNowBtnHeight.constant = 0
//                } else {
//                    cell.applyNowBtnHeight.constant = 50.0
//                }
//                
//                cell.viewDetailsBtn.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
//                cell.applyNowBtn.addTarget(self, action: #selector(tapJobApply(sender:)), for: .touchUpInside)
//                cell.saveJobBtn.addTarget(self, action: #selector(saveJobTapped(sender:)), for: .touchUpInside)
//                return cell
//                //            } else {
//                //                let cell: CompanyJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                //                cell.item = posts[indexPath.row]
//                //                cell.edit = { [weak self] in self?.navigateToEditJob(job: $0) }
//                //                return cell
//                //            }
//            case .industryJobs:
//                let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//                cell.job = posts[indexPath.row]
//                cell.baseMainView.layer.cornerRadius = 12
//                cell.indivisualViewStack.isHidden = true
//                cell.industryView.isHidden = false
//                cell.saveJobBtn.isHidden = true
//                cell.editBtn.tag = indexPath.row
//                cell.applicantBtn.tag = indexPath.row
//                
//                if self.selectedTabFilter == 0 {
//                    cell.jobActiveTimeLbl.isHidden = false
//                } else {
//                    cell.jobActiveTimeLbl.isHidden = true
//                }
//                cell.editBtn.addTarget(self, action:  #selector(tapEditJob(sender:)), for: .touchUpInside)
//                cell.applicantBtn.addTarget(self, action:  #selector(tapApplicantsList(sender:)), for: .touchUpInside)
//                //            cell.detailButton.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
//                
//                return cell
//            }
            return UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func tapJobDetail(sender: UIButton){
        
        let jobListing = StoryboardRouter.userJobListing()
        jobListing.jobId = jobList[sender.tag].id ?? 0
//        jobListing.job = jobList[sender.tag]
        navigationController?.pushViewController(jobListing, animated: true)
    }
    
    @objc func tapJobApply(sender: UIButton){
        let obj = jobList[sender.tag]
        if obj.isApplied == 0 {
            let vc = StoryboardRouter.userApplyJob()
            vc.dashboardJob = obj
            vc.jobId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            //showToastWithLogo(message: "You have already applied for this job.")
            self.presentAlert("You have already applied for this job.")
        }
    }
    
    @objc func tapApplicantsList(sender: UIButton){
        let job = jobList[sender.tag]
        let countStr = jobList[sender.tag].applicationsCount ?? ""
        if countStr == "0" || countStr.isEmpty {
            print("Applications are not available")
        } else {
            let vc = StoryboardRouter.applicantList()
            vc.jobId = job.id ?? 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapEditJob(sender: UIButton){
        let vc = StoryboardRouter.createEditJobPost()
        vc.roleType = .edit
        vc.jobStatus = selectedHomeFilter.getFilter(tab: selectedTab)
        vc.jobId = jobList[sender.tag].id ?? 0
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
//        tableView.deselectRow(at: indexPath, animated: true)
//        if selectedTab == .jobs && user?.type == userType.company.rawValue { navigateToJobDetail(job: posts[indexPath.item]) }
//        else if selectedTab == .posts {
//            print("Post Selected")
//            goToCommentVC(index: indexPath.row)
//        }
        print("i am called tableViewDidSelectRowAt: ")
        switch tableView {
        case self.jobListTblVw:
            if selectedTab == .jobs && user?.type == userType.company.rawValue { navigateToJobDetail(job: posts[indexPath.item]) }
        case self.postListTblVw:
            goToCommentVC(index: indexPath.row)
        case self.newsListTblVw:
            break
        case self.tableView:
            break
        default:
            break
        }
    }
    
    func scrollToTop() {
        let topIndex = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topIndex, at: .top, animated: true)
    }
    
    func shouldSeeMoreLess(index: Int) {
        postSeeMore[index]?.enabled.toggle()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if selectedTab == .jobs {
//            if self.jobList.count > 0 {
//                if indexPath.row == self.jobList.count - 1 {
//                    print("👉 Last tableview cell is visible")
//                    // Load next page if not already fetching and not at the last page
//                    if currentPage < lastPage {
//                        currentPage += 1
//                        let filter = self.selectedHomeFilter.rawValue.lowercased()
//                        self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
//                    } else {
//                        print("Page completed. No Api call")
//                    }
//                }
//            } else {
//                print("Job list is empty.")
//            }
//        }
//    }
}

//MARK: Scroll View Delegate...
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == filterCollectionView {
            print("Category Collection Scroll....")
        } else {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
            if bottomEdge >= scrollView.contentSize.height {
                print("👉 Last ScrollView is visible")
                if selectedTab == .jobs || selectedTab == .industryJobs {
                    if currentPage < lastPage {
                        currentPage += 1
                        let filter = self.selectedHomeFilter.rawValue.lowercased()
                        self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
                    } else {
                        print("Page completed. No Api call")
                    }
                } else if selectedTab == .posts {
                    if paginatedPosts.count > 9 {
                        offsetCount += 1
                        getPosts(offSet: offsetCount, inserted: true)
                    }
                } else if selectedTab == .news {
                    guard !isLoading else { return }
                    guard offsetCount < lastPage else { return } // ✅ stop at last page
                    
                    offsetCount += 1
                    fetchNewsListData(offSet: offsetCount)
                }
                else if selectedTab == .events || selectedTab == .industryEvents {
                    offsetCount += 1
                    print(offsetCount)
                    showActivity()
                    DispatchQueue.main.async {
                        if self.selectedHomeFilter == .new {
                            self.fetchAllEventData()
                        } else if self.selectedHomeFilter == .going {
                            self.fetchUpcomingEventData()
                        } else if self.selectedHomeFilter == .requested {
                            self.fetchRequestedEventData()
                        } else if self.selectedHomeFilter == .saved {
                            self.fetchSavedEventData()
                        } else if self.selectedHomeFilter == .passed {
                            self.fetchPassedEventData()
                        }
                    }
                }
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
//                self.filterCollectionView.isUserInteractionEnabled = true
                self.stopAPICall = false
                self.updateSpecificPost = nil
                switch result {
                    
                case .success(let post):
                    self.hideActivity()
                    if post.data?.isEmpty ?? false && self.posts.isEmpty {
//                        self.emptyListMessageLbl.text = self.searchEnabled ? "No result found" : "No result found"//post.message?.capitalized
                        self.emptyListMessageLbl.text = "No result found"
                        self.emptyListMessageLbl.isHidden = false
                        //return
                    } else {
                        if inserted {
                            if post.data?.isEmpty ?? false {
                                
                            } else {
                                paginatedPosts = post.data ?? []
                                self.posts.append(contentsOf: paginatedPosts)
                            }
                        } else {
                            self.posts = post.data ?? []
                            self.postSeeMore.removeAll()
                        }
                    }
                    
//                    for (index, post) in post.data.enumerated() {
//                        let lines = CGFloat(post.content?.calculateMaxLines(width: self.view.frame.width - 10) ?? 1)
//                        self.postSeeMore[index] = self.postSeeMore[index] == nil ? (lines: lines, enabled: false) : self.postSeeMore[index]
//                    }
                    self.postListTblVw.reloadData()
                    if selectedTab == .news {
                        self.postListTblVwHeight.constant = CGFloat(self.posts.count)
                    } else if selectedTab == .posts {
                        self.setPostTableHeight()
                    } else if selectedTab == .events {
                        self.postListTblVwHeight.constant = 0.0
                    }
                    else {
                        self.postListTblVwHeight.constant = 0.0
                    }
                    self.emptyListMessageLbl.isHidden = true
                    self.emptyListMessageLbl.text = ""
                    self.hideActivity()
                case .failure(let failure):
                    self.hideActivity()
                    self.presentAlert("Error", nil, failure)
                default:
                    break
                }
            }
        }

    }
    
    
//    func EventsAPICall(offSet: Int) {
//        let url =  URL(string: "https://aviationconnect.com/api/v1/event/filter?limit=\(pageSize)&offset=\(offSet)")! // Replace with your API endpoint URL
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        if let token = (UserDefaults.standard.value(forKey: "UserToken")) {
//            // Replace 'YOUR_ACCESS_TOKEN' with your actual bearer token
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        
////        ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "filter": selectedHomeFilter.getFilter(tab: selectedTab)]
//        // Example payload (parameters) in JSON format
//        let parameters: [String: Any] = [
//            "user_id": myUserDefaults.userId,
//            "filter": selectedHomeFilter.getFilter(tab: selectedTab)
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                
//                self.hideActivity()
//                if let error = error {
//                    print("Error making the request: \(error)")
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("Invalid response")
//                    return
//                }
//                
//                if (200..<300).contains(httpResponse.statusCode) {
//                    print("Request was successful!")
//                    if let data = data {
//                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                        print("Response:", responseJSON ?? "")
//                        
//                    }
//                } else {
//                    print("Request failed with status code: \(httpResponse.statusCode)")
//                    if let data = data {
//                        let responseString = String(data: data, encoding: .utf8)
//                        print("Response:", responseString ?? "")
//                    }
//                }
//            }
//            
//            task.resume()
//            
//        } catch {
//            print("Error encoding parameters: \(error)")
//        }
//    }
    
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
                UIView.performWithoutAnimation { self.postListTblVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.postListTblVw.reloadRows(at: [indexPath], with: .none) }
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
                UIView.performWithoutAnimation { self.newsListTblVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.newsListTblVw.reloadRows(at: [indexPath], with: .none) }
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
                self.offsetCount = 1
                self.fetchNewsListData(offSet: self.offsetCount)
                //self.getPosts(offSet: 1, inserted: false)
//                self.posts = self.likeManager.homeLikeManager(homePosts: self.posts, indexAt: at, likeType: self.selectedTab.likeType)
                
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.newsListTblVw.reloadRows(at: [indexPath], with: .none) }
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
                self.noCurrentEventLblHeight.constant = 0
                self.noOtherEventLblHeight.constant = 0
                self.currentEventLblHeight.constant = 0
                self.allEventLblHeight.constant = 0
                self.currentEventListHeight.constant = 0
                
                if self.selectedHomeFilter == .new {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "All Event"
                    self.fetchAllEventData()
                } else if self.selectedHomeFilter == .going {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "Upcoming Event"
                    self.fetchUpcomingEventData()
                } else if self.selectedHomeFilter == .requested {
                    self.fetchRequestedEventData()
                } else if self.selectedHomeFilter == .saved {
                    self.fetchSavedEventData()
                } else if self.selectedHomeFilter == .passed {
                    self.fetchPassedEventData()
                }
//                else {
//                    self.currentEventLblHeight.constant = 0
//                    self.allEventLblHeight.constant = 0
//                    self.currentEventListHeight.constant = 0
//                    self.getPosts(offSet: 1, inserted: false)
//                }
//                self.getPosts(offSet: 1, inserted: false)
//                self.fetchCurrentEventData()
//                self.fetchAllEventData()
//                self.fetchUpcomingEventData()
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    self.currentEventCollectionVw.reloadItems(at: [indexPath])
                }
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
                self.currentEventLbl.text = "Current Event"
                self.noCurrentEventLblHeight.constant = 0.0
                self.noOtherEventLblHeight.constant = 0.0
                self.currentEventLblHeight.constant = 0.0
                self.allEventLblHeight.constant = 0.0
                self.currentEventListHeight.constant = 0
                if self.selectedHomeFilter == .new {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "All Event"
                    self.fetchAllEventData()
                } else if self.selectedHomeFilter == .going {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "Upcoming Event"
                    self.fetchUpcomingEventData()
                } else if self.selectedHomeFilter == .requested {
                    self.fetchRequestedEventData()
                } else if self.selectedHomeFilter == .saved {
                    self.fetchSavedEventData()
                } else if self.selectedHomeFilter == .passed {
                    self.fetchPassedEventData()
                }
//                if self.selectedHomeFilter == .new {
//                    self.fetchCurrentEventData()
//                    self.allEventLbl.text = "All Event"
//                    self.fetchAllEventData()
//                } else if self.selectedHomeFilter == .going {
//                    self.fetchCurrentEventData()
//                    self.allEventLbl.text = "Upcoming Event"
//                    self.fetchUpcomingEventData()
//                } else {
//                    self.currentEventLblHeight.constant = 0
//                    self.allEventLblHeight.constant = 0
//                    self.currentEventListHeight.constant = 0
//                    self.getPosts(offSet: 1, inserted: false)
//                }
                self.view.isUserInteractionEnabled = true
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    self.currentEventCollectionVw.reloadItems(at: [indexPath])
                }
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
    
    
    private func saveJob(jobId: Int, at: Int) {
        
        let param: AFParameters = [ "job_id": jobId]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.saveJobServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                print("Job saved!!")
                //self.getPosts(offSet: 1, inserted: false)
                let filter = self.selectedHomeFilter.rawValue.lowercased()
                self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
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
    
    func likeNews(newsId: Int, status: String, action: String) {
        let param: AFParameters = [ "rss_news_id": newsId,
                                    "created_by_id":  myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        
        view.isUserInteractionEnabled = false
        showActivity()
        ApiCallerClass.likeNewsServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                self.offsetCount = 1
                self.fetchNewsListData(offSet: self.offsetCount)
            }
            else {
                //self.presentAlert("Alert", "No more news")
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func blockUser(userId: Int) {
        let url = EndPoints.blockUser
        let parameters = ["target_user_key": userId]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let res = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(res.error) {
                    let alert = UIAlertController(title: "User Blocked", message: "You can unblock this user anytime from your account settings under 'BlockList'", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            self.reloadData(inserted: false)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Error :: \(res.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

//MARK: LAYOUT SETTING
extension HomeVC {
    
    func setLayOut() {
        scrollvw.delegate = self
        registerCell()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 7.0
//        collectionView.backgroundColor = AppColors.lightGrayBG
        
        self.searchTxtField.delegate = self
        self.searchTxtField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)

        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
//        filterCollectionView.backgroundColor = AppColors.lightGrayBG
        
//        tableView.refreshControl = refreshControl
//        tableView.estimatedRowHeight = 600
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.tableFooterView =  UIView()
        
        noCurrentEventLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        noOtherEventLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
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
    
    func registerCell() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells(withTypes: [HomeUrl.self, HomeText.self, HomeJob.self, HomeEvent.self, HomeImage.self, HomeVideo.self, HomeNewz.self, UserJobCell.self, CompanyJobCell.self])
        
        jobListTblVw.dataSource = self
        jobListTblVw.delegate = self
        jobListTblVw.registerCell(withType: UserJobCell.self)
        
        newsListTblVw.dataSource = self
        newsListTblVw.delegate = self
        newsListTblVw.registerCell(withType: HomeNewz.self)
        
        postListTblVw.dataSource = self
        postListTblVw.delegate = self
        postListTblVw.registerCells(withTypes: [HomeUrl.self, HomeText.self, HomeImage.self, HomeVideo.self, HomeNewz.self, HomePostTVC.self])
        
    }
    
}

//MARK: Text Field Delegate...
extension HomeVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTxtField.text ?? ""
        print("Search Text :: \(searchStr)")
        if selectedTab == .jobs {
            self.jobList = []
            DispatchQueue.main.async {
                self.currentPage = 1
                let filter = self.selectedHomeFilter.rawValue.lowercased()
                self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
            }
        }
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
        self.posts = []
        self.jobList = []
        self.newsList = []
        self.currentEventList = []
        self.allEventList = []
        self.upcomingEventList = []
        self.requestedEventList = []
        self.savedEventList = []
        self.passedEventList = []
        self.showEventList = []
        self.offsetCount = 1
        //reloadData()
        if selectedTab == .jobs || selectedTab == .industryJobs {
            if myUserDefaults.isIndivisualUser {
                homeTabFilter = HomeTabFilter.job
            } else {
                homeTabFilter = HomeTabFilter.industryJobs
            }
            height = 32
            searchHeight = 40
            self.jobList = []
            self.currentPage = 1
            let filter = self.selectedHomeFilter.rawValue.lowercased()
            self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
        } else if selectedTab == .events {
            height = 32
            searchHeight = 0
            if myUserDefaults.isIndivisualUser {
                homeTabFilter = HomeTabFilter.userEvent
            } else {
                homeTabFilter = HomeTabFilter.industryEvents
            }
            
            self.currentEventLbl.text = "Current Event"
            self.noCurrentEventLblHeight.constant = 0.0
            self.noOtherEventLblHeight.constant = 0.0
            self.currentEventLblHeight.constant = 0.0
            self.allEventLblHeight.constant = 0.0
            self.currentEventListHeight.constant = 0
            DispatchQueue.main.async {
                if self.selectedHomeFilter == .new {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "All Event"
                    self.fetchAllEventData()
                } else if self.selectedHomeFilter == .going {
                    self.currentEventLblHeight.constant = 70.0
                    self.allEventLblHeight.constant = 70.0
                    self.fetchCurrentEventData()
                    self.allEventLbl.text = "Upcoming Event"
                    self.fetchUpcomingEventData()
                } else if self.selectedHomeFilter == .requested {
                    self.fetchRequestedEventData()
                } else if self.selectedHomeFilter == .saved {
                    self.fetchSavedEventData()
                } else if self.selectedHomeFilter == .passed {
                    self.fetchPassedEventData()
                }
            }
            
        } else if selectedTab == .posts {
            height = 0
            searchHeight = 0
            reloadData(inserted: false)
            //posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
        }
        else if selectedTab == .news {
            height = 32
            searchHeight = 0
            offsetCount = 1
            fetchNewsListData(offSet: offsetCount, isRefreshing: true)
            //posts.isEmpty ? refreshingContent() : reloadData(inserted: false)
        }
    }
    
    @objc func reloadData(inserted: Bool = true) {
        selectedTab = Constants.getEnumFromUserDefaults() ?? .news
        if selectedTab == .posts {
            if let updateSpecificPost = updateSpecificPost {
                fetchSpecificPost(updateSpecificPost)
                return
            }
            emptyListMessageLbl.isHidden = true
            emptyListMessageLbl.text = ""
            
            if !inserted { refreshControl.programaticallyBeginRefreshing(in: postListTblVw) }
            if !(refreshControl.isRefreshing) { indicatorView.startAnimating() }
            
            getPosts(offSet: 1, inserted: inserted)
        }
    }
    
    @objc func likeByDoubleClick(gesture: UIGestureRecognizer) {
        let tapImageView = gesture.view as! UIButton
        let post = posts[tapImageView.tag]
        likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike != nil ? "unlike" : "like", at: tapImageView.tag)
    }
    
    private func getPostType(at index: Int) -> DashboardItem { posts[index] }
        
    private func navigateToJobListing(job: DashboardItem) {
        let jobListing = StoryboardRouter.userJobListing()
        //jobListing.job = job
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
        vc.eventId = self.showEventList[sender.tag].id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func interestedListTapped(_ sender: UIButton) {
        let vc = StoryboardRouter.interestedList()
        //vc.interestedList = posts[sender.tag].interestedUsers ?? []
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
        self.searchTxtField.text = ""
        homeTabFilter.removeAll()
        
        self.posts = []
        self.jobList = []
        self.newsList = []
        self.currentEventList = []
        self.allEventList = []
        self.upcomingEventList = []
        self.requestedEventList = []
        self.savedEventList = []
        self.passedEventList = []
        self.showEventList = []

        self.noCurrentEventLblHeight.constant = 0
        self.noOtherEventLblHeight.constant = 0
        self.currentEventLblHeight.constant = 0
        self.allEventLblHeight.constant = 0
        self.currentEventListHeight.constant = 0
        self.tableViewHeightConst.constant = 0
        self.jobListTblVwHeight.constant = 0
        self.postListTblVwHeight.constant = 0
        self.newsListTblVwHeight.constant = 0
        self.emptyListMessageLbl.text = ""
                
        //var tableViewBottom: CGFloat = 0
        
        switch sender.tag {
        case 0:
            print("News Tab Select")
//            if isIndivisualUser {
                self.newsList = []
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
//            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
//            reloadData()
            //getPosts(offSet: 1, inserted: false)
            self.offsetCount = 1
            self.fetchNewsListData(offSet: offsetCount)
        case 1:
            print("Event Tab Select")
            self.currentEventList = []
            self.allEventList = []
            self.upcomingEventList = []
            self.requestedEventList = []
            self.savedEventList = []
            self.passedEventList = []
            self.showEventList = []
            
            //            if isIndivisualUser {
            selectedTab = .events
            Constants.saveEnumToUserDefaults(.events)
            selectedHomeFilter = .all
            //homeTabFilter = HomeTabFilter.userEvent
            //homeTabFilter = jobListingBtn.isHidden ? HomeTabFilter.userEvent : HomeTabFilter.companyEvent
            
            height = 32
            searchHeight = 0
            //homeTabFilter = HomeTabFilter.userEvent
            homeTabFilter = myUserDefaults.isIndivisualUser ? HomeTabFilter.userEvent : HomeTabFilter.industryEvents
            self.currentEventLblHeight.constant = 70.0
            self.allEventLblHeight.constant = 70.0
            
            DispatchQueue.main.async {
                self.selectedHomeFilter = .new
                self.fetchCurrentEventData()
                self.allEventLbl.text = "All Event"
                self.fetchAllEventData()
            }
//            } else {
//                selectedTab = .industryJobs
//                Constants.saveEnumToUserDefaults(.industryJobs)
//                selectedHomeFilter = .active
//                height = 32
//                searchHeight = 40
//                homeTabFilter = HomeTabFilter.industryJobs
//            }
//            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
//            reloadData()
        case 2:
            print("Job Tab Select")
            self.jobList = []
            
//                selectedTab = .jobs
//                Constants.saveEnumToUserDefaults(.jobs)
//                selectedHomeFilter = .all
            
//            if jobListingBtn.isHidden {
               // homeTabFilter = HomeTabFilter.job
            if myUserDefaults.isIndivisualUser {
                selectedTab = .jobs
                Constants.saveEnumToUserDefaults(.jobs)
                selectedHomeFilter = .all
                homeTabFilter = HomeTabFilter.job
            } else {
                selectedTab = .industryJobs
                Constants.saveEnumToUserDefaults(.industryJobs)
                selectedHomeFilter = .active
                homeTabFilter = HomeTabFilter.industryJobs
            }
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
            self.currentPage = 1
            let filter = self.selectedHomeFilter.rawValue.lowercased()
            self.fetchJobListData(filter: filter, currentPage: self.currentPage, searchStr: self.searchTxtField.text ?? "")
//            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { tableViewBottom = -70 }
//            reloadData()
        case 3:
            print("Post Tab Select")
            self.posts = []
            selectedTab = .posts
            Constants.saveEnumToUserDefaults(.posts)
            selectedHomeFilter = .none
            height = 0
            searchHeight = 0
//            reloadData()
            getPosts(offSet: 1, inserted: false)

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
    
    @objc func openArticle(strURL: String) {
//        if let urlString = strURL, let url = URL(string: urlString) {
//            let webVC = WebVC(url: url)
//            present(webVC, animated: true, completion: nil)
//        }
        let docVC = DocumentVC.instantiate()
        docVC.documentURL = URL(string: strURL)
        navigationController?.pushViewController(docVC, animated: true)
    }
    
    func openSafari(strURL: String) {
        let deocURl = URL(string: strURL)
        if let url = deocURl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
//        if !post.postImage!.isEmpty { return .image }
//        else if post.postVideo != nil { return .video }
//        else if post.postDocument != nil { return .article }
//        else { return .simpleText }
        if post.postVideo != "" {
            return .video
        } else if post.postDocuments?.count ?? 0 > 0 {
            return .article
        } else if post.datumPostImage!.count > 0 {
            return .image
        } else {
            return .simpleText
        }
    }
    
}

// MARK: Cell Actions
extension HomeVC {
    
    @objc func postLiked(_ sender: UIButton) {
        SVProgressHUD.show()
        let post = posts[sender.tag]
        likePost(postId: post.id ?? 0, status: "active", action: !post.isPostLike.isNil ? "unlike" : "like", at: sender.tag)
    }
    
    @objc func newsLiked(_ sender: UIButton) {
//        SVProgressHUD.show()
//        let post = posts[sender.tag]
//        likeNews(postId: post.id, status: "active", action: !post.isNewsLike.isNil ? "unlike" : "like", at: sender.tag)
        //self.openNewsDetailsPage(index: sender.tag)
        let news = self.newsList[sender.tag]
        if news.isNewsLike == 1 {
            self.likeNews(newsId: news.id ?? 0, status: "deactivate", action: "dislike")
        } else {
            self.likeNews(newsId: news.id ?? 0, status: "active", action: "like")
        }
    }
    
//    @objc func eventsLiked(_ sender: UIButton) {
//        IHProgressHUD.show()
//        let post = posts[sender.tag]
//        likeEvents(postId: post.id, status: "active", action: post.isEventLike == 1 ? "unlike" : "like", at: sender.tag)
//    }
    
//    @objc func interestedBtnTapped(_ sender: UIButton) {
//        let obj = posts[sender.tag]
//        self.agenda = obj.agenda == 1 ? true : false
//        if !agenda {
//            let registrationLink = obj.registrationLink
//            if let urlString = registrationLink, let url = URL(string: urlString), urlString.isValidEmail {
//                let webVC = WebVC(url: url)
//                webVC.modalPresentationStyle = .popover
//                present(webVC, animated: true, completion: nil)
//            }
//        } else {
//            let post = posts[sender.tag]
//            likeEvents(postId: post.id, status: "active", action: post.isEventLike == 1 ? "unlike" : "like", at: sender.tag)
//        }
//    }
}

//MARK: REDIRECTION FUNCTION
extension HomeVC {
    
    @objc func urlCommentVCPost(sender: UIButton) { goToURLCommentVCPost(posts[sender.tag].id ?? 0) }
    
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
        //self.openNewsDetailsPage(index: sender.tag)
        let vc = CommentVC.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        vc.newsId = self.newsList[sender.tag].id ?? 0
        vc.isComeFromNews = true
        self.present(vc, animated: true)
    }
    
    @objc func saveNewsTapped(sender: UIButton) {
        showActivity()
        let post = newsList[sender.tag]
        saveNews(postId: post.id ?? 0, at: sender.tag)
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
                                    with: ["Report","Block"],
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
                
            case 1:
                print("User Block")
                let userID = self.posts[index].user?.id ?? 0
                self.blockUser(userId: userID)
                
            default:
                break
            }
        })
    }
    
    @objc func saveEventTapped(sender: UIButton) {
        print("saved Event")
        showActivity()
        let event = self.showEventList[sender.tag]
        saveEvent(postId: event.id ?? 0, at: sender.tag)
    }
    
//    @objc func reqToJoinTapped(sender: UIButton) {
//        print("resquested Event")
//        showActivity()
//        let post = posts[sender.tag]
//        reqToJoin(postId: post.id, at: sender.tag)
//    }
    @objc func eventViewDetailsTapped(sender: UIButton) {
        print("View Details Event")
        let obj = self.showEventList[sender.tag]
        let vc = EventMainVC.instantiate()
        vc.eventId = obj.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func currentEventViewDetailsTapped(sender: UIButton) {
        print("View Details Event")
        let obj = self.currentEventList[sender.tag]
        let vc = EventMainVC.instantiate()
        vc.eventId = obj.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveCurrentEventTapped(sender: UIButton) {
        print("saved Event")
        showActivity()
        let post = self.currentEventList[sender.tag]
        saveEvent(postId: post.id ?? 0, at: sender.tag)
    }
    
    @objc func saveJobTapped(sender: UIButton) {
        showActivity()
//        let post = posts[sender.tag]
        let job = jobList[sender.tag]
        saveJob(jobId: job.id ?? 0, at: sender.tag)
    }
    
    @objc func urlVCPost(sender: UIButton) {
        //self.openNewsDetailsPage(index: sender.tag)
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.newsList[sender.tag].id ?? 0
        vc.type = .news
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @objc func newsDetails(_ sender: UIButton) {
        let vc = StoryboardRouter.openNewsDetail() //openURLVC()
        let bindModelData = newsList[sender.tag]
        vc.selectedNewsId = bindModelData.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
//    
//    func openNewsDetailsPage(index: Int) {
//        let vc = StoryboardRouter.openNewsDetail() //openURLVC()
//        let bindModelData = newsList[index]
//        vc.selectedNewsId = bindModelData.id ?? 0
////        vc.categoryID = bindModelData.evaNewsCategory?[0].id ?? 0
////        vc.contentString = bindModelData.type == .news ? bindModelData.link : bindModelData.content!.fetchUrlFromString()
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
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
    
//    @objc func handleShare(_ sender: UIButton) {
//        tabBarController?.tabBar.isHidden = true
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
//        vc.objectId = self.objectId
//        vc.type = self.type
//        vc.modalPresentationStyle = .popover
////        vc.completion = {
////            self.showToast(message: "Successfully Shared with desired Connection")
////        }
//        self.present(vc, animated: true)
//    }
    
    
    @objc func handlePostShare(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.posts[sender.tag].id ?? 0 //self.objectId
        vc.type = .post
        vc.modalPresentationStyle = .popover
        vc.completion = {
            self.viewWillAppear(true)
            self.showToast(message: "Successfully Shared with desired Connection")
        }
        self.present(vc, animated: true)
    }
    
    @objc func handlePostDetails(_ sender: UIButton) {
        self.goToCommentVC(index: sender.tag)
    }
    
    @objc func handleNewsShare(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.newsList[sender.tag].id ?? 0 //self.objectId
        vc.type = .news
        vc.modalPresentationStyle = .popover
        vc.completion = {
            self.viewWillAppear(true)
            self.showToast(message: "Successfully Shared with desired Connection")
        }
        self.present(vc, animated: true)
    }
    
    @objc func handlePostFollow(_ sender: UIButton) {
        let post = self.posts[sender.tag]
        let receiverID = post.userID ?? 0
        
//        if post.isConnected == "connected" || homePost.isConnected == "active" {
//            //unfollow Call...
//        } else {
//            //Follow Call...
//        }
        self.connectionFollowUnfollow(receiverID: receiverID, status: 2) //2= follow & 6= Unfollow
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
                    self.presentAlert(networkEventRoot.message ?? "",networkEventRoot.data ?? "")
                    self.reloadData(inserted: false)
                } else {
                    self.presentAlert(networkEventRoot.message ?? "",networkEventRoot.data ?? "")
                    print("Error :: \(networkEventRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

// MARK: Post Actions Delegate
extension HomeVC: PostActionable {
    
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
            shareItemIndex = sender.tag
        }
    }
    
    private func goToCommentVC(index: Int) {
        IQKeyboardManager.shared.isEnabled = false
        let homePost = posts[index]
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
        
//        if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { //Text
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
//        } else if homePost.postDocument != "" && homePost.postImage == []{ //Document
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .article
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        } else { //Image
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .image
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
//MARK: Observer
extension HomeVC {
    
    func addObservers() {
        
        //tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        edgesForExtendedLayout = []
        
        NotificationCenter.default.addObserver(forName: .init(rawValue: "callUpdateApi"), object: nil, queue: .main) { [weak self] _ in
            self?.reloadData()
        }
    }
}

extension HomeVC: HomeEventDelegate {
    
    func intrestedInEvent(dashboardItem: DashboardItem, event: HomeEvent) {
//        let isGoing = dashboardItem.isAttending?.lowercased() != "going"
//        let attendanceStatus = isGoing ? "Going" : "Not Going"
//        let params: AFParameters = ["user_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
//                                    "event_id": dashboardItem.id, "status": "active",
//                                    "attendance_status": attendanceStatus]
//        showActivity()
//        NetworkManagerr.request(EndPoints.addAttendee, method: .post, parameters: params) { [weak self] (result: Result<Wrapper<[Int]>>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            switch result {
//            case .success(_):
//                if let indexPath = self.tableView.indexPath(for: event) {
//                    self.posts[indexPath.item].isAttending = attendanceStatus
//                    UIView.performWithoutAnimation {
//                        self.tableView.reloadRows(at: [indexPath], with: .none)
//                    }
//                }
//            case .failure(let error):
//                self.presentAlert("Error", nil, error)
//            default:
//                break
//            }
//        }
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
                if let post = result.data?.first {
                    self.posts[index] = post
                    UIView.performWithoutAnimation { self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none) }
                }
            case .failure(let error):
                print("error", error)
            default:
                break
            }
        }
    }
    
}
