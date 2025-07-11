//
//  HomePageVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 28/04/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import AVKit
import SVProgressHUD

class HomePageVC: UIViewController {
    
    @IBOutlet weak var scrollBaseView: UIView!
    
    @IBOutlet weak var bannerBaseVw: UIView!
    @IBOutlet weak var bannerCollectionVw: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    @IBOutlet weak var eventBaseVw: UIView!
    @IBOutlet weak var eventCollectionVw: UICollectionView!
    
    @IBOutlet weak var postBaseVw: UIView!
    @IBOutlet weak var postTableVw: UITableView!
    @IBOutlet weak var postTableVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsBaseVw: UIView!
    @IBOutlet weak var newsTableVw: UITableView!
    
    @IBOutlet weak var jobBaseVw: UIView!
    @IBOutlet weak var jobCollectionVw: UICollectionView!
    @IBOutlet weak var jobCollectionVwHeight: NSLayoutConstraint!
    
    var dashboardBannerList: [DashboardBannerData] = [] {
        didSet {
            self.bannerCollectionVw.reloadData()
        }
    }
    var dashboardPostList: [DashboardPostData] = [] {
        didSet {
            self.postTableVw.reloadData()
        }
    }
    var newsList: [RelatedNewsData] = [] {
        didSet {
            self.newsTableVw.reloadData()
        }
    }
    var eventList: [DashboardItem] = [] {
        didSet {
            self.eventCollectionVw.reloadData()
        }
    }
    var jobList: [DashboardJob] = [] {
        didSet {
            self.jobCollectionVw.reloadData()
        }
    }
    let likeManager = LikeManager()
    var objectId = 0
    var type : TypePostEnum = .news
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        postTableVw.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchBannerData()
        self.fetchDashboardPostData()
        self.fetchDashboardNews()
        self.fetchDashboardEvent()
        self.fetchDashboardJob()
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if(keyPath == "contentSize"){
//            self.postTableVwHeight.constant = self.postTableVw.contentSize.height == 0 ? 100 : self.postTableVw.contentSize.height
//            
//        }
//    }
    
    func setupUI() {
        self.registerCell()
        self.jobCollectionVwHeight.constant = 0.0
        if isIndivisualUser {
            Constants.saveEnumToUserDefaults(.news)
        } else {
            Constants.saveEnumToUserDefaults(.industryEvents)
        }
    }
    

    func registerCell() {
        bannerCollectionVw.registerNib(cellNib: HomeBannerCVC.self)
        bannerCollectionVw.delegate = self
        bannerCollectionVw.dataSource = self
        
        eventCollectionVw.registerNib(cellNib: HomeEventCVC.self)
        eventCollectionVw.delegate = self
        eventCollectionVw.dataSource = self
        
        postTableVw.registerCells(withTypes: [HomeText.self, HomeImage.self, HomeVideo.self, HomeUrl.self])
        newsTableVw.registerCells(withTypes: [HomeNewz.self])
        
        jobCollectionVw.registerNib(cellNib: HomeJobCVC.self)
        jobCollectionVw.delegate = self
        jobCollectionVw.dataSource = self
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
        
    @IBAction func onEventViewAllBtnTap(_ sender: UIButton) {
        Constants.saveEnumToUserDefaults(.events)
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPostViewAllBtnTap(_ sender: UIButton) {
        Constants.saveEnumToUserDefaults(.posts)
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onNewsViewAllBtnTap(_ sender: UIButton) {
        Constants.saveEnumToUserDefaults(.news)
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onJobViewAllBtnTap(_ sender: UIButton) {
        Constants.saveEnumToUserDefaults(.jobs)
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 3
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
}

extension HomePageVC: CollectionViewCellDelegate, PostActionable {
    func didSelectItem(at indexPath: Int, imgArr: [String?]) {
        print("Dashboard Post Image Clicked")
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
            print("Dashboard Post Like")
            let post = dashboardPostList[sender.tag]
            likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike", at: sender.tag)
         case .comment:
            print("Dashboard Post Comment")
            goToCommentVC(index: sender.tag)
         case .article:
            print("Dashboard Post Article")
//            articleContent = dashboardPostList[sender.tag].postDocument
//            openArticle()
         case .edit:
            print("Dashboard Post Edit")
//            openEditPost(sender)
         case .delete:
            print("Dashboard Post Delete")
         default:
            print("Dashboard Post share")
//             shareItemIndex = sender.tag
         }
    }
    
    private func goToCommentVC(index: Int) {
        let homePost = dashboardPostList[index]
        if  homePost.datumPostImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // && post.postDocument == nil
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = homePost.id
            //vc.dashboardItem = homePost
            //vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.datumPostImage == [] {//Video
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = homePost.id
            //vc.dashboardItem = homePost
            //vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postDocument != "" && homePost.datumPostImage == []{ //document Cell
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = homePost.id
            //vc.dashboardItem = homePost
            //vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else { // Image Cell
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = homePost.id
            //vc.dashboardItem = homePost
            //vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: Api Call
extension HomePageVC {
    func fetchBannerData() {
        showActivity()
        let url = "\(EndPoints.dashboardBanner)"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription as? Error ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let response = try JSONDecoder().decode(DashboardBannerDataModel.self, from: data)
                if let data = response.data {
                    self.dashboardBannerList = data
                    //--> Setup Pagination...
                    self.bannerPageControl.numberOfPages = self.dashboardBannerList.count
                    self.bannerPageControl.currentPage = 0
                } else {
                    print("Error ::", response.message as? Error ?? "Default Error")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
    func fetchDashboardPostData() {
        let url = "\(EndPoints.getAllHomePost)?limit=\(2)&offset=\(1)"
        let parameters = [
            "filter" :"all_posts",
            "type":"postindex" ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let postRoot = try jsonDecoder.decode(DashboardPostDataModel.self, from: response.data!)
                
                if !(postRoot.error!) {
                    if (postRoot.data?.count ?? 0) > 0 {
                        if let data = postRoot.data {
                            self.dashboardPostList = data
                            DispatchQueue.main.async {
                                let height = self.postTableVw.contentSize.height
                                self.postTableVwHeight.constant = height
                            }
                        }
                    } else {
                        self.postTableVwHeight.constant = 0.0
                    }
                } else {
                    print("Error :: \(postRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func fetchDashboardNews() {
        let url = "\(EndPoints.getAllHomeNews)?limit=\(2)&offset=\(1)"
        let parameters: AFParameters  = [:]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(RelatedNewsDataModel.self, from: response.data!)
                
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        if data.count > 0 {
                            self.newsList = data
                        }
                    }
                } else {
                    print("Error :: \(newsRoot.message ?? "")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func fetchDashboardEvent() {
        let url = "\(EndPoints.getAllHomeEvent)?limit=\(2)&offset=\(1)"
        let parameters = ["type":"eventlist"] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let eventRoot = try jsonDecoder.decode(DashboardItemRoot.self, from: response.data!)
                if !(eventRoot.error) {
                    self.eventList = eventRoot.data
                } else {
                    print("Error :: \(eventRoot.message ?? "")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func fetchDashboardJob() {
        let url = "\(EndPoints.getAllHomeJob)?limit=\(2)&offset=\(1)"
        let parameters = ["filter":"all"] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let jobRoot = try jsonDecoder.decode(DashboardJobDataModel.self, from: response.data!)
                if !(jobRoot.error ?? false) {
                    self.jobList = jobRoot.data?.jobs ?? []
                    //Set collection height as per data....
                    var height = 0.0
                    for job in self.jobList {
                        height = height + 290.0
                    }
                    self.jobCollectionVwHeight.constant = height
                } else {
                    print("Error :: \(jobRoot.message ?? "")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    private func likePost(postId: Int, status: String, action: String, at: Int) {
        showActivity()
        let param: AFParameters = [ "post_id": postId,
                                    "created_by_id":  myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.likePostServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                self.dashboardPostList = self.likeManager.dashboardPostLikeManager(homePosts: self.dashboardPostList, indexAt: at)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.postTableVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.dashboardPostList = self.likeManager.dashboardPostLikeManager(homePosts: self.dashboardPostList, indexAt: at)
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.postTableVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func reqToJoin(eventtId: Int, type: Int) {
        let param: AFParameters = [ "event_id": eventtId,
                                    "type": type]
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.reqToJoinFunc(usertoken: myUserDefaults.token, para: param) { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
//            self.hideActivity()
            if error == 0 {
                print("Event saved!!")
                self.fetchDashboardEvent()
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
    
    private func saveEvent(eventtId: Int, at: Int) {
        let param: AFParameters = [ "event_id": eventtId]
        view.isUserInteractionEnabled = false
        ApiCallerClass.saveEventServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            //self.hideActivity()
            if error == 0 {
                print("Event saved!!")
                self.fetchDashboardEvent()
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
    
    private func saveNews(newsId: Int, at: Int) {
        let param: AFParameters = [ "rss_news_id": newsId]
        view.isUserInteractionEnabled = false
        showActivity()
        ApiCallerClass.saveNewsServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            if error == 0 {
                print("News saved!!")
                self.fetchDashboardNews()
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.newsTableVw.reloadRows(at: [indexPath], with: .none) }
                self.view.isUserInteractionEnabled = true
            }
            else {
                print("News error!!",error as Any)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func saveJob(jobId: Int, at: Int) {
        showActivity()
        let param: AFParameters = [ "job_id": jobId]
        view.isUserInteractionEnabled = false
        ApiCallerClass.saveJobServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                print("Job saved!!")
                self.fetchDashboardJob()
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.jobCollectionVw.reloadItems(at: [indexPath]) }
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

//MARK: Custom Methods
extension HomePageVC {
    @objc func viewDetailsTapped(sender: UIButton) {
        let obj = eventList[sender.tag]
        let vc = EventMainVC.instantiate()
        vc.eventId = obj.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bannerReqToJoin(sender: UIButton) {
        let banner = self.dashboardBannerList[sender.tag]
        let bannerID = banner.id ?? 0
        let attendeesStatus = banner.eventAttendeesStatus ?? ""
        
        if attendeesStatus == "" {
            if banner.isinvited == 0 {
                self.reqToJoin(eventtId: bannerID, type: 1)
            } else {
                self.reqToJoin(eventtId: bannerID, type: 2)
            }
        } else {
            print("Button Not Clickable")
        }
    }
    
    @objc func showVideoView(sender: UIButton) {
        let bindModelData = self.dashboardPostList[sender.tag]
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
    
    @objc func openEventVCPost(sender: UIButton) {
        let vc = EventMainVC.instantiate()
        vc.eventId = eventList[sender.tag].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func reqToJoinTapped(sender: UIButton) {
        print("resquested Event")
        showActivity()
        let event = eventList[sender.tag]
        reqToJoin(eventtId: event.id, type: 1)
    }
    
    @objc func saveEventTapped(sender: UIButton) {
        print("saved Event")
        showActivity()
        let event = eventList[sender.tag]
        saveEvent(eventtId: event.id, at: sender.tag)
    }
    
    @objc func saveJobTapped(sender: UIButton) {
        let job = jobList[sender.tag]
        saveJob(jobId: job.id ?? 0, at: sender.tag)
    }
    
    @objc func applyJobTapped(sender: UIButton) {
        let job = jobList[sender.tag]
        if job.isApplied == 0 {
            let vc = StoryboardRouter.userApplyJob()
            vc.dashboardJob = job
            vc.jobId = job.id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showToastWithLogo(message: "You have already applied for this job.")
        }
    }
    @objc func detailJobTapped(sender: UIButton) {
        let jobID = jobList[sender.tag].id ?? 0
        let jobListing = StoryboardRouter.userJobListing()
        jobListing.jobId = jobID
        navigationController?.pushViewController(jobListing, animated: true)
    }
}

//MARK: UICollection Delegate....
extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.bannerCollectionVw:
            return self.dashboardBannerList.count
            
        case self.eventCollectionVw:
            return self.eventList.count
            
        case self.jobCollectionVw:
            return self.jobList.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.bannerCollectionVw:
            let cell = self.bannerCollectionVw.dequeueReusableCell(withReuseIdentifier: HomeBannerCVC.ReuseId, for: indexPath) as! HomeBannerCVC
            let banner = self.dashboardBannerList[indexPath.row]
            
            if let imageUrl = banner.featuredImage,
               !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
               let url = URL(string: imageUrl),
               UIApplication.shared.canOpenURL(url) {
                cell.imgView.kf.setImage(with: url, placeholder: UIImage(named: "bannerPlaceholder"))
            } else {
                cell.imgView.image = UIImage(named: "bannerPlaceholder")
            }
            
            cell.titleLbl.text = banner.name ?? ""
            cell.subtitleLbl.text = banner.content ?? ""
            cell.locationLbl.text = "\(banner.city ?? ""),\(banner.country ?? "")"
            cell.dateLbl.text = "\(banner.startDate ?? "") - \(banner.endDate ?? "")"
            cell.timeLbl.text = "\(banner.startTime ?? "") - \(banner.endTime ?? "")"
            
            let eventAttendeesStatus = banner.eventAttendeesStatus ?? ""
            
            //            isinvite = 1 --> accept --> type = 2
            //            isinvite = 0 --> request to join --> type = 1
            //            eventAttendeesStatus = "" --> button click else button not click { check isinvite }
            
            if eventAttendeesStatus == "" {
                if banner.isinvited == 0 {
                    cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
                } else {
                    cell.requestJoinBtn.setTitle("Accepted", for: .normal)
                }
            }
            else {
                cell.requestJoinBtn.setTitle(eventAttendeesStatus, for: .normal)
            }

//            switch banner.eventAttendeesStatus {
//            case .none:
//                cell.requestJoinBtn.isHidden = false
//                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//            case .requestToJoin:
//                cell.requestJoinBtn.isHidden = false
//                cell.requestJoinBtn.setTitle("Requested", for: .normal)
//            case .accepted:
//                cell.requestJoinBtn.isHidden = true
//                cell.requestJoinBtn.setTitle("View details", for: .normal)
//            case .decline:
//                cell.requestJoinBtn.setTitle("Request To Join", for: .normal)
//            }
            
            
            cell.viewDetailsBtn.tag = indexPath.row
            cell.viewDetailsBtn.addTarget(self, action: #selector(viewDetailsTapped(sender:)), for: .touchUpInside)
            cell.requestJoinBtn.tag = indexPath.row
            cell.requestJoinBtn.addTarget(self, action: #selector(bannerReqToJoin(sender:)), for: .touchUpInside)
            return cell
            
        case self.eventCollectionVw:
            let cell = self.eventCollectionVw.dequeueReusableCell(withReuseIdentifier: HomeEventCVC.ReuseId, for: indexPath) as! HomeEventCVC
            
            let event = self.eventList[indexPath.row]
            
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
            
            cell.detailNavigateBtn.tag = indexPath.row
            cell.detailNavigateBtn.addTarget(self, action:#selector(openEventVCPost(sender:)), for: .touchUpInside)
            cell.requestJoinBtn.tag = indexPath.row
            cell.requestJoinBtn.addTarget(self, action: #selector(reqToJoinTapped(sender:)), for: .touchUpInside)
            cell.saveBtn.tag = indexPath.row
            cell.saveBtn.addTarget(self, action: #selector(saveEventTapped(sender:)), for: .touchUpInside)
            
            return cell
            
        case self.jobCollectionVw:
            let cell = self.jobCollectionVw.dequeueReusableCell(withReuseIdentifier: HomeJobCVC.ReuseId, for: indexPath) as! HomeJobCVC
            
            let job = self.jobList[indexPath.row]
            if let imageUrl = job.jobImage,
               !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
               let url = URL(string: imageUrl),
               UIApplication.shared.canOpenURL(url) {
                cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "jobLogoPlaceholder"))
            } else {
                cell.profileImgVw.image = UIImage(named: "jobLogoPlaceholder")
            }

            cell.titleLbl.text = job.jobTitle ?? ""
            cell.subTitleLbl_1.text = job.position ?? ""
            cell.subTitleLbl_2.text = job.location ?? ""
            cell.salaryLbl.text = "£\(job.salary ?? 0)"
            cell.jobTimeLbl.text = job.jobtype ?? ""
            
            cell.saveBtn.tag = indexPath.row
            cell.saveBtn.addTarget(self, action: #selector(saveJobTapped(sender:)), for: .touchUpInside)
            cell.applyNowBtn.tag = indexPath.row
            cell.applyNowBtn.addTarget(self, action: #selector(applyJobTapped(sender:)), for: .touchUpInside)
            cell.viewDetailBtn.tag = indexPath.row
            cell.viewDetailBtn.addTarget(self, action: #selector(detailJobTapped(sender:)), for: .touchUpInside)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.bannerCollectionVw:
            Constants.saveEnumToUserDefaults(.events)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
    
        case self.eventCollectionVw:
            Constants.saveEnumToUserDefaults(.events)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
            
        case self.jobCollectionVw:
            Constants.saveEnumToUserDefaults(.jobs)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.bannerCollectionVw:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case self.eventCollectionVw:
            return CGSize(width: collectionView.frame.width, height: 440.0)
            
        case self.jobCollectionVw:
            return CGSize(width: collectionView.frame.width, height: 290.0)
            
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    
    //MARK :- UIScrollViewDelegate for PageControl...
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let pageFraction = scrollView.contentOffset.x / pageWidth
        self.bannerPageControl.currentPage = Int(round(pageFraction))
    }
}

//MARK: REDIRECTION FUNCTION
extension HomePageVC {
    @objc func goToProfileTapped(_ sender: UIButton) {
        let posts = dashboardPostList[sender.tag]
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
    
    @objc func handleShare(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.objectId
        vc.type = self.type
        vc.modalPresentationStyle = .popover
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
                print("Report")
                let vc = reportPopupVC.instantiate()
                vc.postId = self.dashboardPostList[index].id ?? 0
                vc.userId = self.dashboardPostList[index].user?.id ?? 0
                vc.completion = {
                    let vc = otherReasonPopupVC.instantiate()
                    vc.postId = self.dashboardPostList[index].id ?? 0
                    vc.userId = self.dashboardPostList[index].user?.id ?? 0
                    self.navigationController?.present(vc, animated: true)
                }
                self.navigationController?.present(vc, animated: true)
            default:
                break
            }
        })
    }
    
    func openNewsDetailsPage(index: Int) {
        let vc = StoryboardRouter.openNewsDetail() //openURLVC()
        let news = newsList[index]
        vc.selectedNewsId = news.id ?? 0
        vc.categoryID = news.evaNewsCategory?[0].id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func newsLiked(_ sender: UIButton) {
        self.openNewsDetailsPage(index: sender.tag)
    }
    
    @objc func urlVCPost(sender: UIButton) {
        self.openNewsDetailsPage(index: sender.tag)
    }
    
    @objc func newsCommentVCPost(sender: UIButton) {
        self.openNewsDetailsPage(index: sender.tag)
    }
    
    @objc func saveNewsTapped(sender: UIButton) {
        let news = newsList[sender.tag]
        saveNews(newsId: news.id ?? 0, at: sender.tag)
    }
}

//MARK: UITableView Delegate....
extension HomePageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.postTableVw:
            return self.dashboardPostList.count
            
        case self.newsTableVw:
            return self.newsList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.postTableVw:
            let homePost = self.dashboardPostList[indexPath.row]
            
            if  homePost.datumPostImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // text cell
                let cell: HomeText = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.detailsView.layer.cornerRadius = 13
                cell.delegate = self
                cell.setData(data: homePost)
                
                cell.likeBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.shareBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                
                self.objectId = homePost.id ?? 0
                self.type = .post
                
                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                return cell
            }
            else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.datumPostImage == [] { //Video Cell
                let cell: HomeVideo = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.setData(dataMaper: homePost)
                
                cell.likeBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.sharedBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                self.objectId = homePost.id ?? 0
                self.type = .post
                cell.delegate = self
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
            }
            else if homePost.postDocument != "" && homePost.datumPostImage == [] { //document Cell
                let cell: HomeUrl = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.setData(dataMaper: homePost)
                
                cell.likeBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.sharedBtn.tag = indexPath.row
                cell.openArticleBtn.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                self.objectId = homePost.id ?? 0
                self.type = .post
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }
            else if homePost.datumPostImage!.count > 0 { //Image Cell
                let cell: HomeImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.setData(data: homePost)
                cell.delegateDidSelect = self
                cell.parentViewController = self
                
                cell.likeButton.tag = indexPath.row
                cell.commentButton.tag = indexPath.row
                cell.shareButton.tag = indexPath.row
                cell.goToProfileBtn.tag = indexPath.row
                cell.reportBtn.tag = indexPath.row
                
                self.objectId = homePost.id ?? 0
                self.type = .post
                cell.reportBtn.addTarget(self, action: #selector(reportBtnTapped(_:)), for: .touchUpInside)
                cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }
            
        case self.newsTableVw:
            let cell: HomeNewz = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let obj = newsList[indexPath.row]
            cell.setData(obj: obj)
            cell.likeBtn.tag = indexPath.row
            cell.sharedBtn.tag = indexPath.row
            cell.commentBtn.tag = indexPath.row
            cell.openURl.tag = indexPath.row
            cell.saveNewsBtn.tag = indexPath.row
            cell.detailNavigateBtn.tag = indexPath.row
            
            self.objectId = obj.id ?? 0
            self.type = .news
            cell.detailNavigateBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(newsLiked(_:)), for: .touchUpInside)
            cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
            cell.openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action:#selector(newsCommentVCPost(sender:)), for: .touchUpInside)
            cell.saveNewsBtn.addTarget(self, action:#selector(saveNewsTapped(sender:)), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.postTableVw:
            let homePost = self.dashboardPostList[indexPath.row]
            if  homePost.datumPostImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // && post.postDocument == nil
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .simpleText
                vc.postId = homePost.id
//                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.datumPostImage == [] {//Video
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .video
                vc.postId = homePost.id
//                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            } else if homePost.postDocument != "" && homePost.datumPostImage == []{ //document Cell
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .article
                vc.postId = homePost.id
//                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            } else { // Image Cell
                let vc = StoryboardRouter.textPostDetailVC()
                vc.postType = .image
                vc.postId = homePost.id
//                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        case self.newsTableVw:
            Constants.saveEnumToUserDefaults(.news)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.postTableVw:
            let homePost = self.dashboardPostList[indexPath.row]
            if  homePost.datumPostImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // text cell
                return 200
            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.datumPostImage == [] { //Video Cell
                return 450
            } else if homePost.postDocument != "" && homePost.datumPostImage == [] { //document Cell
                
                let lblHeight = self.heightForView(text: homePost.content ?? "", font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 80.0)
                let height = lblHeight + 231.0
                return height
                
            } else if homePost.datumPostImage!.count > 0 { //Image Cell
                return 450
            }
            return UITableView.automaticDimension
        case self.newsTableVw:
            return 430
            
        default:
            return UITableView.automaticDimension
        }
    }
}
