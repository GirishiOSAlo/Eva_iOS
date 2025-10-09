//
//  SearchDetailsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 15/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class SearchDetailsVC: UIViewController {

    @IBOutlet weak var navBatTitle: UILabel!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var collectionParentViewTrailingConst: NSLayoutConstraint!
    
    
    var categoryArr = ["All", "News", "Connection", "Jobs", "Posts", "Events"]
    var industryCategoryArr = ["All", "Posts", "Followers", "Events"]
    
    var selectedCategoryIndex = 0
    var searchText = ""
    var searchResultsSingleTab: [GlobalSearchDataClass] = []
    var newsResults: [SearchNews] = []
    var connectionResults: [SearchConnection] = []
    var jobsResults: [SearchJob] = []
    var postsResults: [SearchPost] = []
    var eventsResults: [SearchEvent] = []
    var JobId = 0
    
    var resultData: [String: [Any]] = [:] // Dictionary to organize content by section
    var sectionTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        fetchSearchResults()
    }
    
    func setupUI() {
        navBatTitle.text = self.searchText
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.registerCell(withType: DocAudioTVCell.self)
        detailTableView.registerCell(withType: SearchNewsTVCell.self)
        detailTableView.registerCell(withType: HomeText.self)
        detailTableView.registerCell(withType: HomeVideo.self)
        detailTableView.registerCell(withType: HomeImage.self)
        detailTableView.registerCell(withType: HomeUrl.self)
        detailTableView.registerCell(withType: HomeEvent.self)
        detailTableView.registerCell(withType: UserJobCell.self)
        detailTableView.registerCell(withType: ConnectionCell.self)
        
        collectionParentViewTrailingConst.constant = myUserDefaults.isIndivisualUser ? 0 : 20
        
    }
    
    

    @IBAction func onBackBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapJobDetail(sender: UIButton){
        
        let jobListing = StoryboardRouter.userJobListing()
        jobListing.jobId = JobId
        navigationController?.pushViewController(jobListing, animated: true)
    }
}

extension SearchDetailsVC {
    func fetchSearchResults() {
        showActivity()
        resultData = [:]
        sectionTitles = []

        var filterValue = ""

        switch selectedCategoryIndex {
        case 0:
            filterValue = "all"
        case 1:
            filterValue = myUserDefaults.isIndivisualUser ? "news" : "posts"
        case 2:
            filterValue = "connections"
        case 3:
            filterValue = myUserDefaults.isIndivisualUser ? "jobs" : "events"
        case 4:
            filterValue = "posts"
        case 5:
            filterValue = "events"
        default:
            break
        }

        let parameters: [String: Any] = [
            "filter": filterValue,
            "search_text": self.searchText
        ]

        let url = EndPoints.globalSearchResults

        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let searchModel = try JSONDecoder().decode(GlobalSearchDataModel.self, from: response.data!)
                      
                guard let data = searchModel.data else {
                    print("No data in response")
                    return
                }
                
                if self.selectedCategoryIndex == 0 {
                    for sectionData in data {
                        for (key, value) in Mirror(reflecting: sectionData).children {
                            if ["news", "connections", "jobs", "posts", "events"].contains((key)) {
                                var sectionContent: [Any] = []

                                if let contentArray = value as? [Any] {
                                    for item in contentArray {
                                        if myUserDefaults.isIndivisualUser {
                                            switch key?.lowercased() {
                                            case "news", "connections", "jobs", "posts", "events":
                                                if let resultItem = item as? Codable {
                                                    sectionContent.append(resultItem)
                                                    self.sectionTitles.append(key ?? "")
                                                    self.emptyLabel.isHidden = true
                                                }
                                            default:
                                                self.emptyLabel.isHidden = false
                                                break
                                            }
                                        } else {
                                            switch key?.lowercased() {
                                            case "posts", "connections", "events":
                                                if let resultItem = item as? Codable {
                                                    sectionContent.append(resultItem)
                                                    self.sectionTitles.append(key ?? "")
                                                }
                                            default:
                                                break
                                            }
                                        }
                                    }
                                    let set = Set(self.sectionTitles)
                                    self.sectionTitles = Array(set)
                                }

                                self.resultData[key ?? ""] = sectionContent
                            } else {
                                self.emptyLabel.isHidden = false
                            }
                        }
                    }
                } else {
                    if searchModel.error == false {
                        if ((searchModel.data?.count ?? 0) > 0) {
                            let data = searchModel.data?[0]
                            
                            switch self.selectedCategoryIndex {
                            case 1:
                                if myUserDefaults.isIndivisualUser {
                                    self.newsResults = data?.news ?? []
                                    self.emptyLabel.isHidden = (self.newsResults.count > 0)
                                } else {
                                    self.postsResults = data?.posts ?? []
                                    self.emptyLabel.isHidden = (self.postsResults.count > 0)
                                }
                            case 2:
                                if myUserDefaults.isIndivisualUser {
                                    self.connectionResults = data?.connections ?? []
                                    self.emptyLabel.isHidden = (self.connectionResults.count > 0)
                                } else {
                                    self.connectionResults = data?.connections ?? []
                                    self.emptyLabel.isHidden = (self.connectionResults.count > 0)
                                }
                            case 3:
                                if myUserDefaults.isIndivisualUser {
                                    self.jobsResults = data?.jobs ?? []
                                    self.emptyLabel.isHidden = (self.jobsResults.count > 0)
                                } else {
                                    self.eventsResults = data?.events ?? []
                                    self.emptyLabel.isHidden = (self.eventsResults.count > 0)
                                }
                            case 4:
                                if myUserDefaults.isIndivisualUser {
                                    self.postsResults = data?.posts ?? []
                                    self.emptyLabel.isHidden = (self.postsResults.count > 0)
                                } else {
                                    break
                                }
                            case 5:
                                if myUserDefaults.isIndivisualUser {
                                    self.eventsResults = data?.events ?? []
                                    self.emptyLabel.isHidden = (self.eventsResults.count > 0)
                                } else {
                                    break
                                }
                            default:
                                break
                            }
                        } else {
                            self.emptyLabel.isHidden = false
                        }
                    }
                }

                // Reload the table view once outside the switch statements
                DispatchQueue.main.async {
                    self.detailTableView.reloadData()
                }
                
            } catch {
                print("Error: ",error)
            }
        }
    }
}

//MARK: Tableview Delegate Method.....
extension SearchDetailsVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count > 0 ? sectionTitles.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionTitles.count > 0 {
            let key = sectionTitles[section]
            return resultData[key]?.count ?? 0
        } else {
            switch selectedCategoryIndex {
            case 1:
                return myUserDefaults.isIndivisualUser ? newsResults.count : postsResults.count
            case 2:
                return connectionResults.count
            case 3:
                return myUserDefaults.isIndivisualUser ? jobsResults.count : eventsResults.count
            case 4:
                return postsResults.count
            case 5:
                return eventsResults.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sectionTitles.count > 0 {
            let key = sectionTitles[indexPath.section]
            if let content = resultData[key] {
                let item = content[indexPath.row]
                
                switch key {
                case "news":
                    if let news = item as? SearchNews {
                        let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsTVCell.id(), for: indexPath) as! SearchNewsTVCell
                        cell.titleLabel?.text = news.newsSource
                        cell.detailsLabel.text = news.title
                        cell.titleImageView.kf.setImage(with: URL(string: news.image ?? ""))
                        cell.subImageView.kf.setImage(with: URL(string: news.newsSourceImage ?? ""))
                        cell.timeLabel.text = news.relativeTime
                        // Set other cell properties based on the SearchNews model
                        return cell
                    }
                case "jobs":
                    if let job = item as? SearchJob {
                        let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        cell.baseMainView.layer.cornerRadius = 12
                        cell.indivisualViewStack.isHidden = false
                        cell.industryView.isHidden = true
                        cell.saveJobBtn.isHidden = false
                        cell.detailButton.tag = indexPath.row
                        self.JobId = Int(job.id ?? "") ?? 0
                        
                        cell.positionNameLbl.text = job.jobTitle ?? ""
                        cell.companyNameLbl.text = job.position ?? ""
                        cell.jobImageView.sd_setImage(with: URL(string: job.image ?? ""), placeholderImage: UIImage(named: "profile")!)
                        cell.salaryLbl.text = "£\(job.salary ?? "0")"
                        cell.locationLbl.text = job.location ?? ""
                        cell.contractLbl.text = job.jobType ?? ""
                        
                        //                        cell.job.saved == 1 ? saveJobBtn.setImage(UIImage(named: "save_selected"), for: .normal) : saveJobBtn.setImage(UIImage(named: "save"), for: .normal)
                        
                        cell.detailButton.tag = indexPath.row
                        cell.saveJobBtn.tag = indexPath.row
                        //                cell.goToAd = { [weak self] in self?.navigateToJobListing(job: $0) }
                        cell.detailButton.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
                        //                        cell.saveJobBtn.addTarget(self, action: #selector(saveJobTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                case "posts":
                    if let post = item as? SearchPost {
                        if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" { // text cell
                            let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
                            cell.reportBtn.isHidden = true
                            cell.uiData(dataMaper: post)
                            cell.shareBtn.tag = indexPath.row
                            cell.likeShareUIView.isHidden = true
                            return cell
                            
                        } else if post.postVideo != "" && post.postDocument == "" && post.postImages == [] { //Video Cell
                            let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
                            
                            cell.reportBtn.isHidden = true
                            cell.uiData(dataMaper: post)
                            cell.videoView.backgroundColor = .black
                            cell.videoView.configure(url: post.postVideo ?? "",ratio: .resize)
                            cell.videoView.stop()
                            cell.videoView.isHidden = false
                            cell.likeShareUiView.isHidden = true
                            return cell
                            
                        } else if post.postDocument != "" && post.postDocument != nil { //document Cell
                            let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
                            cell.backgroundColor = UIColor(hex: "#F8F6F8")
                            cell.reportBtn.isHidden = true
                            cell.uiData(post: post)
                            cell.likeShareUiView.isHidden = true
                            return cell
                        } else if post.postImages?.count ?? 0 > 0 { //Image Cell

                            let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
                            cell.backgroundColor = UIColor(hex: "#F8F6F8")
                            cell.reportBtn.isHidden = true
                            cell.uiData(dataMaper: post)
                            cell.likeShareUiView.isHidden = true
                            return cell
                        }
                    }
                case "events":
                    if let event = item as? SearchEvent {
                        let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        cell.uiData(dataMaper: event)
                        
                        //                        if self.selectedTabFilter == 1 {
//                        cell.BottomViewStack.isHidden = true
                        //                        } else {
                        //                            cell.BottomViewStack.isHidden = false
                        //                        }
//                        cell.industryUserView.isHidden = true
//                        cell.indivisualUserView.isHidden = false
                        return cell
                    }
                case "connections":
                    if let connection = item as? SearchConnection {
                        let cell: ConnectionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        
                        cell.userName.text = connection.firstName
                        cell.userDesignation.text = connection.designation ?? connection.companyName
                        cell.onlineStatusVw.isHidden = connection.isOnline == "0"
                        cell.userImage.sd_setImage(with: URL(string: connection.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
                        cell.blockedView.isHidden = true
                        cell.pendingView.isHidden = true
                        cell.connectedView.isHidden = false
                        cell.addFriendView.isHidden = true
                        cell.sentReqView.isHidden = true
                        cell.addFriendView.isHidden = true
                        
                        return cell
                    }
                default:
                    return UITableViewCell()
                }
            }
        } else {
            
            switch selectedCategoryIndex {
            case 1:
                if myUserDefaults.isIndivisualUser {
                    let item = newsResults[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsTVCell.id(), for: indexPath) as! SearchNewsTVCell
                    cell.titleLabel?.text = item.title
                    cell.titleImageView.kf.setImage(with: URL(string: item.image ?? ""))
                    cell.subImageView.kf.setImage(with: URL(string: item.newsSourceImage ?? ""))
                    cell.timeLabel.text = item.published
                    return cell
                } else {
                    let post = postsResults[indexPath.row]
                    if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" { // text cell
                        let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        cell.detailsView.layer.cornerRadius = 13
                        
                        cell.uiData(dataMaper: post)
                        cell.shareBtn.tag = indexPath.row
                        cell.likeShareUIView.isHidden = true
                        return cell
                        
                    } else if post.postVideo != "" && post.postVideo != nil { //Video Cell
                        let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        
                        cell.uiData(dataMaper: post)
                        
                        cell.videoView.backgroundColor = .black
                        cell.videoView.configure(url: post.postVideo ?? "",ratio: .resize)
                        cell.videoView.stop()
                        cell.likeShareUiView.isHidden = true
                        cell.videoView.isHidden = false
                        return cell
                        
                    } else if post.postDocument != "" && post.postDocument != nil { //document Cell
                        let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        cell.backgroundColor = UIColor(hex: "#F8F6F8")
                        cell.uiData(post: post)
                        cell.likeShareUiView.isHidden = true
                        return cell
                    } else if post.postImages?.count ?? 0 > 0 { //Image Cell
                        //
                        let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
                        cell.backgroundColor = UIColor(hex: "#F8F6F8")
                        cell.uiData(dataMaper: post)
                        cell.likeShareUiView.isHidden = true
                        return cell
                    }
                }
            case 2:
                let item = connectionResults[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
                print(item.firstName ?? "")
                cell.userName.text = item.firstName
                cell.userDesignation.text = item.designation
                cell.onlineStatusVw.isHidden = item.isOnline == "0"
                cell.userImage.sd_setImage(with: URL(string: item.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
                cell.blockedView.isHidden = true
                cell.pendingView.isHidden = true
                cell.connectedView.isHidden = false
                cell.addFriendView.isHidden = true
                cell.sentReqView.isHidden = true
                cell.addFriendView.isHidden = true
                return cell
            case 3:
                if myUserDefaults.isIndivisualUser {
                    let job = jobsResults[indexPath.row]
                    let cell: UserJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.baseMainView.layer.cornerRadius = 12
                    cell.indivisualViewStack.isHidden = false
                    cell.industryView.isHidden = true
                    cell.saveJobBtn.isHidden = false
                    cell.detailButton.tag = indexPath.row
                    self.JobId = Int(job.id ?? "") ?? 0
                    
                    cell.positionNameLbl.text = job.jobSector ?? ""
                    cell.companyNameLbl.text = job.position ?? ""
                    cell.jobImageView.sd_setImage(with: URL(string: job.image ?? ""), placeholderImage: UIImage(named: "profile")!)
                    cell.salaryLbl.text = "£\(job.salary ?? "0")"
                    cell.locationLbl.text = job.location ?? ""
                    cell.contractLbl.text = job.jobType ?? ""
                    cell.detailButton.addTarget(self, action: #selector(tapJobDetail(sender:)), for: .touchUpInside)
                    
                    return cell
                } else {
                    let event = eventsResults[indexPath.row]
                    let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.uiData(dataMaper: event)
//                    cell.BottomViewStack.isHidden = true
//                    cell.industryUserView.isHidden = true
//                    cell.indivisualUserView.isHidden = false
                    return cell
                }
            case 4:
                let post = postsResults[indexPath.row]
                if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" { // text cell
                    let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.detailsView.layer.cornerRadius = 13
                    
                    cell.uiData(dataMaper: post)
                    cell.shareBtn.tag = indexPath.row
                    cell.likeShareUIView.isHidden = true
                    return cell
                    
                } else if post.postVideo != "" && post.postVideo != nil { //Video Cell
                    let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    
                    cell.uiData(dataMaper: post)
                    
                    cell.videoView.backgroundColor = .black
                    cell.videoView.configure(url: post.postVideo ?? "",ratio: .resize)
                    cell.videoView.stop()
                    cell.likeShareUiView.isHidden = true
                    cell.videoView.isHidden = false
                    return cell
                    
                } else if post.postDocument != "" && post.postDocument != nil { //document Cell
                    let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
                    cell.uiData(post: post)
                    cell.likeShareUiView.isHidden = true
                    return cell
                } else if post.postImages?.count ?? 0 > 0 { //Image Cell
                    //
                    let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.backgroundColor = UIColor(hex: "#F8F6F8")
                    cell.uiData(dataMaper: post)
                    cell.likeShareUiView.isHidden = true
                    return cell
                }
            case 5:
                let event = eventsResults[indexPath.row]
                let cell: HomeEvent = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.uiData(dataMaper: event)
//                cell.BottomViewStack.isHidden = true
//                cell.industryUserView.isHidden = true
//                cell.indivisualUserView.isHidden = false
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles.count > 0 ? sectionTitles[section] : "" // Set section titles (SearchNews, SearchJobs, SearchPosts, SearchEvents)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch selectedCategoryIndex {
        case 0:
            let key = sectionTitles[indexPath.section]
            if let content = resultData[key] {
                let item = content[indexPath.row]
                
                switch key {
                case "news":
                    if let news = item as? SearchNews {
                        let vc = StoryboardRouter.openNewsDetail()
                        vc.selectedNewsId = Int(news.id ?? "0") ?? 0
//                        vc.delegate = self
                        navigationController?.pushViewController(vc, animated: true)
                    }
                case "connections":
                    if let connection = item as? SearchConnection {
                        let vc = StoryboardRouter.othersProfileVC()
                        vc.profileID = Int(connection.id ?? "") ?? 0
                        vc.isFrom = 0
                        navigationController?.pushViewController(vc, animated: true)
                    }
                case "jobs":
                    if let job = item as? SearchJob {
                        let jobListing = StoryboardRouter.userJobListing()
                        jobListing.jobId = Int(job.id ?? "0") ?? 0
//                        jobListing.job = job
                        navigationController?.pushViewController(jobListing, animated: true)
                    }
                case "posts":
                    if let post = item as? SearchPost {
                        if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" {
                            // Text Cell
                            let vc = StoryboardRouter.textPostDetailVC()
                            vc.postType = .simpleText
                            vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                            navigationController?.pushViewController(vc, animated: true)
                        } else if post.postVideo != "" && post.postDocument == "" && post.postImages == [] {
                            // Video Cell
                            let vc = StoryboardRouter.textPostDetailVC()
                            vc.postType = .video
                            vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                            navigationController?.pushViewController(vc, animated: true)
                        } else if post.postDocument != "" && post.postImages == [] {
                            // Document Cell
                            let vc = StoryboardRouter.textPostDetailVC()
                            vc.postType = .article
                            vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                            navigationController?.pushViewController(vc, animated: true)
                        } else if post.postImages?.count ?? 0 > 0 {
                            // Image Cell
                            let vc = StoryboardRouter.textPostDetailVC()
                            vc.postType = .image
                            vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                case "events":
//                    if let event = item as? SearchEvent {
//                        let vc = StoryboardRouter.eventCommentVC()
//                        vc.eventId = Int(event.id ?? "0")
//                //        vc.userId = posts[sender.tag].userID
//                        vc.isGalleryEnable = true
////                        vc.delegate = self
//                        navigationController?.pushViewController(vc, animated: true)
//                    }
                    break
                default:
                    break
                }
            }
        case 1:
            if myUserDefaults.isIndivisualUser {
                let news = newsResults[indexPath.row]
                let vc = StoryboardRouter.newsPopupVC()
                vc.newId = Int(news.id ?? "0") ?? 0
                navigationController?.pushViewController(vc, animated: true)
                break
            } else {
                let post = postsResults[indexPath.row]
                if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" {
                    // Text Cell
    //                let id = post.id
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postType = .simpleText
                    vc.postId = Int(post.id ?? "0")
    //                            vc.dashboardItem = post
                    navigationController?.pushViewController(vc, animated: true)
                } else if post.postVideo != "" && post.postDocument == "" && post.postImages == [] {
                    // Video Cell
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postType = .video
                    vc.postId = Int(post.id ?? "0")
    //                            vc.dashboardItem = post
                    navigationController?.pushViewController(vc, animated: true)
                } else if post.postDocument != "" && post.postImages == [] {
                    // Document Cell
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postType = .article
                    vc.postId = Int(post.id ?? "0")
    //                            vc.dashboardItem = post
                    navigationController?.pushViewController(vc, animated: true)
                } else if post.postImages?.count ?? 0 > 0 {
                    // Image Cell
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postType = .image
                    vc.postId = Int(post.id ?? "0")
    //                            vc.dashboardItem = post
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            }
            
        case 2:
            let connection = connectionResults[indexPath.row]
            let vc = StoryboardRouter.othersProfileVC()
            vc.profileID = Int(connection.id ?? "") ?? 0
            vc.isFrom = 0
            navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            if myUserDefaults.isIndivisualUser {
                let job = jobsResults[indexPath.row]
                //            let itemId = job.id
                let jobListing = StoryboardRouter.userJobListing()
                jobListing.jobId = Int(job.id ?? "0") ?? 0
                navigationController?.pushViewController(jobListing, animated: true)
                break
            } else {
//                let event = eventsResults[indexPath.row]
//                let vc = StoryboardRouter.eventCommentVC()
//                vc.eventId = Int(event.id ?? "0")
//        //        vc.userId = posts[sender.tag].userID
//                vc.isGalleryEnable = true
//    //                        vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
                break
            }
        case 4:
            let post = postsResults[indexPath.row]
            if  post.postImages == [] && post.postVideo == "" && post.postDocument == "" {
                // Text Cell
//                let id = post.id
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .simpleText
                vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                navigationController?.pushViewController(vc, animated: true)
            } else if post.postVideo != "" && post.postDocument == "" && post.postImages == [] {
                // Video Cell
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .video
                vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                navigationController?.pushViewController(vc, animated: true)
            } else if post.postDocument != "" && post.postImages == [] {
                // Document Cell
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .article
                vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                navigationController?.pushViewController(vc, animated: true)
            } else if post.postImages?.count ?? 0 > 0 {
                // Image Cell
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .image
                vc.postId = Int(post.id ?? "0")
//                            vc.dashboardItem = post
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 5:
//            let event = eventsResults[indexPath.row]
//            let vc = StoryboardRouter.eventCommentVC()
//            vc.eventId = Int(event.id ?? "0")
//    //        vc.userId = posts[sender.tag].userID
//            vc.isGalleryEnable = true
////                        vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            // Handle unexpected selectedCategoryIndex values
            break
        }
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if sectionTitles.count > 0 {
                let key = sectionTitles[indexPath.section]
                if let content = resultData[key] {
                    let item = content[indexPath.row]
                    
                    switch key {
                    case "news":
                        return UITableView.automaticDimension
                    case "connections":
                        return 116
                    case "jobs":
                        return 155
                    default:
                        return UITableView.automaticDimension
                    }
                } else {
                    return UITableView.automaticDimension
                }
            } else {
                switch selectedCategoryIndex {
                case 1:
                    return UITableView.automaticDimension
                case 2:
                    return 116
                case 3:
                    return 155
                default:
                    return UITableView.automaticDimension
                }
            }
            
        }
    
}

//MARK: Collectionview Delegate Method.....
extension SearchDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myUserDefaults.isIndivisualUser ? self.categoryArr.count : self.industryCategoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCollctionCell", for: indexPath) as! SearchCategoryCollctionCell
            
        cell.layer.cornerRadius = 8.0
        cell.categoryLbl.layer.cornerRadius = 8.0
        cell.categoryLbl.text =  myUserDefaults.isIndivisualUser ? self.categoryArr[indexPath.row] : self.industryCategoryArr[indexPath.row]
        
        if indexPath.row == 0 {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        
        if (indexPath.row == self.selectedCategoryIndex) {
            cell.categoryLbl.backgroundColor = UIColor(hex: "#5894DD", alpha: 0.10)
            cell.categoryLbl.textColor = UIColor(hex: "#4D76CD")
            cell.categoryLbl.font = UIFont(name: "SFProText-Medium", size: 14.0)
        }
        else {
            cell.categoryLbl.backgroundColor = UIColor.white
            cell.categoryLbl.textColor = UIColor(hex: "#707070")
            cell.categoryLbl.font = UIFont(name: "SFProText-Regular", size: 14.0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = myUserDefaults.isIndivisualUser ? categoryArr[indexPath.row] : industryCategoryArr[indexPath.row]
        label.sizeToFit()

        let width = label.frame.width + 30
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryIndex = indexPath.row
        self.fetchSearchResults()
        self.categoryCollectionView.reloadData()
    }
}

