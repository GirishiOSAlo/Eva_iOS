//
//  NewsDetailVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import SVProgressHUD

class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navBarImageView: UIImageView!
    @IBOutlet weak var navBarTitleLbl: UILabel!
    
    @IBOutlet weak var navBarTimeLbl: UILabel!
    @IBOutlet weak var NewsTitleLbl: UILabel!
    @IBOutlet weak var newsSorceLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var saveNewsButton: UIButton!
    
    @IBOutlet weak var NewsDescLbl: UILabel!
    
    @IBOutlet weak var otherRelatedNewsLbl: UILabel!
    @IBOutlet weak var otherNewsTableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var loadMoreBtn: UIButton!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var likeNewsImg: UIImageView!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareCountLbl: UILabel!
    
    @IBOutlet weak var newsTagCollectionVw: UICollectionView!
    @IBOutlet weak var newsTagCollectionVwHeight: NSLayoutConstraint!
    var tagArray: [NewsTag] = []
    
    @IBOutlet weak var trendingNewsBaseVw: UIView!
    @IBOutlet weak var trendingNewsBaseVwHeight: NSLayoutConstraint!
    @IBOutlet weak var trendingNewsCollectionVw: UICollectionView!
    
    @IBOutlet weak var relatedNewsVwHeight: NSLayoutConstraint!
    
    var trendingNewsList: [NewsTrendingList] = [] {
        didSet {
            self.trendingNewsCollectionVw.reloadData()
        }
    }

    var selectedNewsId = 0
    var newsDetails: NewsDetailData?
    
    var newsID = 0
    var categoryID = 0
    var offsetCount = 1
    
    var newsList: [RelatedNewsData] = [] {
        didSet {
            self.otherNewsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        otherNewsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func setupUI() {
        otherNewsTableView.delegate = self
        otherNewsTableView.dataSource = self
        //otherNewsTableView.registerCell(withType: NewsDetailsTVC.self)
        otherNewsTableView.registerCell(withType: HomeNewz.self)
        
        newsTagCollectionVw.registerNib(cellNib: NewsTagCVC.self)
        newsTagCollectionVw.delegate = self
        newsTagCollectionVw.dataSource = self
        
        trendingNewsCollectionVw.registerNib(cellNib: TrendingNewsDetailsCVC.self)
        trendingNewsCollectionVw.delegate = self
        trendingNewsCollectionVw.dataSource = self
        
        loadMoreBtn.layer.cornerRadius = 20
        newsImageView.layer.cornerRadius = 20
        navBarImageView.layer.cornerRadius = navBarImageView.layer.bounds.width/2
        
        self.trendingNewsBaseVwHeight.constant = 50.0 // +50.0 is header label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        fetchNewsDetails()
        fetchRelatedNewsDetails(offset: 1)
        fetchTrendingNews()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
//            self.tableViewHeightConst.constant = self.otherNewsTableView.contentSize.height == 0 ? 100 : self.otherNewsTableView.contentSize.height
            let tableHeight = self.otherNewsTableView.contentSize.height == 0 ? 100 : self.otherNewsTableView.contentSize.height
            self.relatedNewsVwHeight.constant = tableHeight + 120.0
        }
    }
    
    func updateUI(data: NewsDetailData) {
        
        guard let newsImage = data.sourceImage else {
            navBarImageView.image = UIImage(named: "eventPlaceholder")
            return
        }
        navBarImageView.kf.setImage(with: URL(string: newsImage))
        self.navBarTitleLbl.text = data.newsSource ?? "--"
        navBarTimeLbl.text = data.relativeTime ?? "--"
        
        self.NewsTitleLbl.text = data.title ?? ""
        //self.newsSorceLbl.text = data.href ?? "--"
        self.dateTimeLbl.text = data.relativeTime ?? "--"
        
        guard let newsImage = data.newsImage else {
            newsImageView.image = UIImage(named: "eventPlaceholder")
            return
        }
        newsImageView.kf.setImage(with: URL(string: newsImage))
        
        let str = data.content
        let descStr = str?.replacingOccurrences(of: "\n", with: "\n\n\t")
        NewsDescLbl.text = "\t\(descStr ?? "")"
        
        likeCountLbl.text = "\(data.likesCount ?? 0)"
        commentCountLbl.text = "\(data.commentsCount ?? 0)"
        shareCountLbl.text = "\(data.sharesCount ?? 0)"

        if data.isNewsLike == 1 {
            likeNewsImg.image = UIImage(named: "like_selected")
        } else {
            likeNewsImg.image = UIImage(named: "ic_like")
        }
        
        if data.isNewsSave == 1 {
            saveNewsButton.setImage(UIImage(named: "save_selected"), for: .normal)
        } else {
            saveNewsButton.setImage(UIImage(named: "save"), for: .normal)
        }
        
        let linkTxt = data.href ?? "--"
        let attributedString = NSMutableAttributedString(string: linkTxt)
        let linkRange = (linkTxt as NSString).range(of: linkTxt)
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#4D76CD"), range: linkRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        self.newsSorceLbl.attributedText = attributedString
                
        self.tagArray = data.newsTags ?? []
        self.newsTagCollectionVw.reloadData()
        self.updateTagCollection()
    }

    func updateTagCollection() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.newsTagCollectionVw.collectionViewLayout = layout
        
        self.newsTagCollectionVwHeight.constant = newsTagCollectionVw.collectionViewLayout.collectionViewContentSize.height
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
    }
    
    @IBAction func saveNewsTapped(_ sender: UIButton) {
        saveNews(postId: selectedNewsId, at: sender.tag)
    }
    
    @IBAction func loadMoreTapped(_ sender: UIButton) {
        offsetCount += 1
        fetchRelatedNewsDetails(offset: offsetCount)
    }
    
    @IBAction func likeNewsTapped(_ sender: UIButton) {
//        likeNews(postId: news?.id ?? newsID, status: "active", action: !(news?.isNewsLike.isNil ?? false) ? "unlike" : "like")
        let isNewsLike = self.newsDetails?.isNewsLike ?? 0
        let newsId = self.newsDetails?.id ?? 0
        if isNewsLike == 1 {
            self.likeNews(postId: newsId, status: "deactivate", action: "dislike")
        } else {
            self.likeNews(postId: newsId, status: "active", action: "like")
        }
    }
    
    @IBAction func commentNewsTapped(_ sender: UIButton) {
        //fetchCommentVC()
        let vc = CommentVC.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        vc.newsId = self.newsDetails?.id ?? 0
        vc.isComeFromNews = true
        self.present(vc, animated: true)
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        handleShare(id: selectedNewsId)
    }
        
    @IBAction func onNewsSourceBtn(_ sender: UIButton) {
        let sourceLink = self.newsDetails?.href ?? ""
        if let url = URL(string: sourceLink) {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: UICollection Delegate....
extension NewsDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.newsTagCollectionVw:
            return self.tagArray.count
            
        case self.trendingNewsCollectionVw:
            return self.trendingNewsList.count
                        
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.newsTagCollectionVw:
            let cell = self.newsTagCollectionVw.dequeueReusableCell(withReuseIdentifier: NewsTagCVC.ReuseId, for: indexPath) as! NewsTagCVC
            cell.tagLbl.text = self.tagArray[indexPath.row].name ?? ""
            return cell
            
        case self.trendingNewsCollectionVw:
            let cell = self.trendingNewsCollectionVw.dequeueReusableCell(withReuseIdentifier: TrendingNewsDetailsCVC.ReuseId, for: indexPath) as! TrendingNewsDetailsCVC
            
            let trendingNews = self.trendingNewsList[indexPath.row]
            
            cell.imgVw.kf.setImage(with: URL(string: trendingNews.newsSource?.image ?? ""))
            cell.titleLbl.text = trendingNews.title ?? ""
            cell.categoryLbl.text = trendingNews.newsSource?.name ?? ""
            cell.dateTimeLbl.text = trendingNews.createdDatetime ?? ""
            
            cell.likeCountLbl.text = "\(trendingNews.likeCount ?? 0)"
            cell.commentCountLbl.text = "\(trendingNews.commentCount ?? 0)"
            cell.shareCountLbl.text = "\(trendingNews.shareCount ?? 0)"
            
            if trendingNews.isNewsLike == 1 {
                cell.likeImageVw.image = UIImage(named: "like_selected")
            } else {
                cell.likeImageVw.image = UIImage(named: "ic_like")
            }
            
            cell.detailNavigateBtn.tag = indexPath.row
            cell.detailNavigateBtn.addTarget(self, action: #selector(detailNavigateTapped(sender:)), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeTrendingNewsTapped(sender:)), for: .touchUpInside)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(commentTrendingNewsTapped(sender:)), for: .touchUpInside)
            cell.sharedBtn.tag = indexPath.row
            cell.sharedBtn.addTarget(self, action: #selector(shareTrendingNewsTapped(sender:)), for: .touchUpInside)

            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.newsTagCollectionVw:
            let label = UILabel(frame: CGRect.zero)
            label.text = "\(tagArray[indexPath.row].name ?? "")"
            label.sizeToFit()
            return CGSize(width: label.frame.width+16, height: 30)
            
        case self.trendingNewsCollectionVw:
            return CGSize(width: self.trendingNewsCollectionVw.frame.size.width, height: 112.0)

        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}

extension NewsDetailVC {
    

        func processHTML(content: String) -> String {
            // First replace <br> tags with newlines
            var processedText = content.replacingOccurrences(of: "<br>", with: "\r\n ")
            
            // Remove all HTML tags
            processedText = processedText.replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression,
                range: nil
            )
            
            // Remove extra whitespace and trim
            processedText = processedText.replacingOccurrences(
                of: "\\s+",
                with: " ",
                options: .regularExpression,
                range: nil
            ).trimmingCharacters(in: .whitespacesAndNewlines)
            
            return processedText
        }

    
    func fetchCommentVC(){
        let vc = StoryboardRouter.newsPopupVC()
//        vc.btnTag = sender.tag
        vc.newId = selectedNewsId
//        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    func handleShare(id: Int) {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = id
        vc.type = .news
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    func fetchNewsDetails(){
        let parameters = [
            "user_id": myUserDefaults.userId,
            "news_id": selectedNewsId
        ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.newsDetails,method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(NewsDetailsDataModel.self, from: response.data!)
                
                if !(newsRoot.error!) {
                    if (newsRoot.data?.count ?? 0) > 0 {
                        if let data = newsRoot.data?[0] {
                            self.newsDetails = data
                            self.updateUI(data: data)
                            self.otherNewsTableView.reloadData()
                        }
                    } else {
                        //self.presentAlert("Alert", "No more news", nil)
                    }
                    
                } else {
                    self.offsetCount -= 1
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                self.offsetCount -= 1
                print("Error:: ", error)
            }
        }
    }
    
    func fetchTrendingNews() {
        let parameterss: AFParameters  = [:]
        showActivity()
        NetworkManagerr.request(EndPoints.trendingNewsDetails,method: .post, parameters: parameterss) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(NewsTrendingModel.self, from: response.data!)
                
                if !(newsRoot.error!) {
                    if (newsRoot.data?.count ?? 0) > 0 {
                        if let data = newsRoot.data {
                            self.trendingNewsList = data
                            //Height Managed.....
                            let count = Double(self.trendingNewsList.count)
                            let trendingCellHeight = (112.0 * count)
                            self.trendingNewsBaseVwHeight.constant = trendingCellHeight + 50.0 // +50.0 is header label
                        }
                    } else {
                        self.trendingNewsBaseVwHeight.constant = 50.0 // +50.0 is header label
                    }
                    
                } else {
                    self.offsetCount -= 1
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                self.offsetCount -= 1
                print("Error:: ", error)
            }
        }
    }
    
    func fetchRelatedNewsDetails(offset: Int){
        let parameters = [
            "category_id": self.categoryID
           ] as [String: Any]
        
        let url = "\(EndPoints.relatedNewsDetails)?limit=10&offset=\(offset)"
        
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
                        } else {
//                            self.presentAlert("Alert", "No more news")
                            self.offsetCount = 1
                        }
                    }
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
     }
    
    private func likeNews(postId: Int, status: String, action: String) {
        let param: AFParameters = [ "rss_news_id": postId,
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
                self.fetchNewsDetails()
                self.fetchRelatedNewsDetails(offset: 1)
                self.fetchTrendingNews()
            }
            else {
//                self.presentAlert("Alert", "No more news")
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
//    @objc func visitRelatedNewsTapped(_ Sender: UIButton){
//        
//    }
    
    @objc func saveRelatedNewsTapped(sender: UIButton){
        SVProgressHUD.show()
        let relatedNews = self.newsList[sender.tag]
        saveNews(postId: relatedNews.id ?? 0, at: sender.tag)
    }
    
    private func saveNews(postId: Int, at: Int) {
        let param: AFParameters = [ "rss_news_id": postId]
        
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.saveNewsServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            SVProgressHUD.dismiss()
            if error == 0 {
                print("News saved!!")
                self.fetchNewsDetails()
                self.fetchRelatedNewsDetails(offset: self.offsetCount)
                
                let indexPath = IndexPath(item: at, section: 0)
                UIView.performWithoutAnimation { self.otherNewsTableView.reloadRows(at: [indexPath], with: .none) }
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
    
    //--> Trending News...
    @objc func detailNavigateTapped(sender: UIButton){
        SVProgressHUD.show()
        let trendingNews = self.trendingNewsList[sender.tag]
        let vc = StoryboardRouter.openNewsDetail() //openURLVC()
        vc.newsID = trendingNews.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func likeTrendingNewsTapped(sender: UIButton){
        SVProgressHUD.show()
        let trendingNews = self.trendingNewsList[sender.tag]
        if trendingNews.isNewsLike == 1 {
            self.likeNews(postId: trendingNews.id ?? 0, status: "deactivate", action: "dislike")
        } else {
            self.likeNews(postId: trendingNews.id ?? 0, status: "active", action: "like")
        }
    }
    @objc func commentTrendingNewsTapped(sender: UIButton){
        let vc = CommentVC.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        vc.newsId = self.trendingNewsList[sender.tag].id ?? 0
        vc.isComeFromNews = true
        self.present(vc, animated: true)
    }
    @objc func shareTrendingNewsTapped(sender: UIButton){
        self.handleShare(id: self.trendingNewsList[sender.tag].id ?? 0)
    }
    
    //--> Related News...
    @objc func detailRelatedNavigateTapped(sender: UIButton){
        SVProgressHUD.show()
        let relatedNews = self.newsList[sender.tag]
        let vc = StoryboardRouter.openNewsDetail()
        vc.newsID = relatedNews.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func likeRelatedNewsTapped(sender: UIButton){
        SVProgressHUD.show()
        let relatedNews = self.newsList[sender.tag]
        if relatedNews.isNewsLike == 1 {
            self.likeNews(postId: relatedNews.id ?? 0, status: "deactivate", action: "dislike")
        } else {
            self.likeNews(postId: relatedNews.id ?? 0, status: "active", action: "like")
        }
    }
    @objc func commentRelatedNewsTapped(sender: UIButton){
        let vc = CommentVC.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        vc.newsId = self.newsList[sender.tag].id ?? 0
        vc.isComeFromNews = true
        self.present(vc, animated: true)
    }
    @objc func shareRelatedNewsTapped(sender: UIButton){
        handleShare(id: self.newsList[sender.tag].id ?? 0)
    }
    
}

//MARK: TABLEVIEW DELEGATES
extension NewsDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = otherNewsTableView.dequeueReusableCell(withIdentifier: NewsDetailsTVC.id(), for: indexPath) as! NewsDetailsTVC
//       
//        cell.uiData(dataMaper: obj)
//        cell.selectionStyle = .none
////        cell.visitNewsBtn.tag = indexPath.row
////        cell.visitNewsBtn.addTarget(self, action: #selector(visitRelatedNewsTapped(_:)), for: .touchUpInside)

        let cell: HomeNewz = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let obj = newsList[indexPath.row]
        
        let newsSource = obj.newsSource
        cell.profileImage.kf.setImage(with: URL(string: newsSource?.image ?? ""))
        cell.newzName.text = newsSource?.name ?? ""
        cell.timeWhenPost.text = obj.createdDatetime ?? ""
        
        cell.urlImage.kf.setImage(with: URL(string: obj.image ?? ""))
        cell.newzShortDetail.text = obj.title ?? ""
        
        cell.likeCountLbl.text = "\(obj.likeCount ?? 0)"
        cell.commentCountLbl.text = "\(obj.commentCount ?? 0)"
        cell.shareCountLbl.text = "\(obj.shareCount ?? 0)"
        
        if obj.isNewsLike == 1 {
            cell.likeImage.image = UIImage(named: "like_selected")
        } else {
            cell.likeImage.image = UIImage(named: "ic_like")
        }
        
        if obj.isNewsSave == 1 {
            cell.saveNewsImgView.image = UIImage(named: "save_selected")
        } else {
            cell.saveNewsImgView.image = UIImage(named: "save")
        }
        
        cell.detailNavigateBtn.tag = indexPath.row
        cell.detailNavigateBtn.addTarget(self, action: #selector(detailRelatedNavigateTapped(sender:)), for: .touchUpInside)
        cell.saveNewsBtn.tag = indexPath.row
        cell.saveNewsBtn.addTarget(self, action: #selector(saveRelatedNewsTapped(sender:)), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeRelatedNewsTapped(sender:)), for: .touchUpInside)
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self, action: #selector(commentRelatedNewsTapped(sender:)), for: .touchUpInside)
        cell.sharedBtn.tag = indexPath.row
        cell.sharedBtn.addTarget(self, action: #selector(shareRelatedNewsTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = newsList[indexPath.row]
//        let vc = StoryboardRouter.openNewsDetail()
//        vc.newsID = obj.id ?? 0
//        vc.categoryID = obj.evaNewsCategory?[0].id ?? 0
//        navigationController?.pushViewController(vc, animated: true)
    }
}
