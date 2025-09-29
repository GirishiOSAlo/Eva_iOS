//
//  TextCommentVC.swift
//  EvaConnect
//
//  Created by Metis on 23/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVKit

class TextPostDetailVC: BaseVC {
//
//    @IBOutlet weak var shareCountBtn: UIButton!
//    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    //MARK: OutLets
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var otherNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    //    @IBOutlet weak var likeLbl: UILabel!
//    @IBOutlet weak var ComentLbl: UILabel!
//    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var postContentLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalCommentLabel: UILabel!
    @IBOutlet weak var tableHeightConst: NSLayoutConstraint!
    @IBOutlet weak var reportBtn: UIButton!
    
    //textView
    @IBOutlet weak var textDetailView: UIView!
//    @IBOutlet weak var textLikeImg: UIImageView!
    
    //ImageView
    @IBOutlet weak var imageDetailView: UIView!
//    @IBOutlet weak var imagePostLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var imageShareBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    //VideoView
    @IBOutlet weak var videoDetailView: UIView!
//    @IBOutlet weak var videoPostLbl: UILabel!
//    @IBOutlet weak var videoLikeLbl: UILabel!
//    @IBOutlet weak var videolikeImage: UIImageView!
//    @IBOutlet weak var videoLikeBtn: UIButton!
    
//    @IBOutlet weak var videoCommentLbl: UILabel!
//    @IBOutlet weak var videoshareLbl: UILabel!
    @IBOutlet weak var videoPreviewView: VideoClass!
    @IBOutlet weak var playVideoBtn: UIButton!
    
    //DocumentView
    @IBOutlet weak var docDetailView: UIView!
//    @IBOutlet weak var docPostLbl: UILabel!
//    @IBOutlet weak var docLikeLbl: UILabel!
//    @IBOutlet weak var doclikeImage: UIImageView!
//    @IBOutlet weak var docLikeBtn: UIButton!
    @IBOutlet weak var docBorderView: UIView!
    
//    @IBOutlet weak var docCommentLbl: UILabel!
//    @IBOutlet weak var docshareLbl: UILabel!
    @IBOutlet weak var docAttachmntView: UIView!
    @IBOutlet weak var documentNameLbl: UILabel!
    @IBOutlet weak var docSizeLbl: UILabel!
    @IBOutlet weak var docTimeLbl: UILabel!
//    @IBOutlet weak var docShareBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    //MARK: VARIABLES
    var comments: [Comments] = []
    var images: [InputSource] = []
    var textIsOk = true
    var postId: Int!
    var postDetail: PostDetail?
    var dashboardItem: DashboardItem?
    weak var delegate: RefreshUpdateable?
    let postManager = PostManager()
    var isCheckUpdate = false
    var isMyPost = false
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    var postType: PostType = .simpleText
    var articleContent: String?
    var commentData: [Comment] = []
    var isComeFromNotificationPostComment = false
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        isSeparatorHidden = true
        setLayout()
        FetchCommentList()
        addObservers()
        getPostDetails()
//        setNotificationObserver()
        
        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            self.tableHeightConst.constant = self.tableView.contentSize.height == 0 ? 100 : self.tableView.contentSize.height
        }
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? ((keyboardFrame!.height) - 25) : 0
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }


}

// MARK: IBAction
extension TextPostDetailVC {
    
    @IBAction func likePost(_ sender: UIButton) {
        view.isUserInteractionEnabled = false
        if !postDetail!.isPostLike.isNil {
//            updateLikeStatus(action: "unlike")
            
        } else {
//            updateLikeStatus(action: "like")
        }
    }
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        self.openCommentPopup()
    }
    
    func openCommentPopup() {
        let vc = CommentVC.instantiate()
        vc.postId = self.postId
        vc.commentData = self.commentData
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func addComment(_ sender: Any) {
        
        let text = msgTxtView.text ?? ""
        view.isUserInteractionEnabled = false
        msgTxtView.resignFirstResponder()
        view.endEditing(true)
        msgTxtView.text = ""
        
        if !textIsOk || msgTxtView.text.count > 0 {
            if mode == .edit {
//                self.updateComment(content: text, sender: senderButton)
            }
            else {
                showActivity()
                view.isUserInteractionEnabled = true
                addComments(postId: postId!, text: text) { (success, error) in
                   
                    self.comments.removeAll()
//                    self.getComments()
                    self.msgTxtView.text = ""
                    self.placeHolderLbl.isHidden = false
                    self.hideActivity()
//                    if let error = error {
//                        self.presentAlert("Failure", nil, error)
//                    }
                    
                }
            }
            
        } else {
            self.hideActivity()
            view.isUserInteractionEnabled = true
//            makeAlert(messageData: "Field is Empty")
            
        }
    }
    
    @IBAction func share_touchUpInside(_ sender: UIButton) {
       // navigateToShareView(id: postId, type: .post, controller: self)
    }
    
    @IBAction func followBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        delegate?.refresh(homeStatus: false)
//        self.show
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func commentLiked(_ sender: UIButton) {
        let comment = comments[sender.tag]
        
//        likeNews(postId: post.id, status: "active", action: !post.isJobLike.isNil ? "unlike" : "like", at: sender.tag)
        //action: !comment.isJobLike.isNil ? "unlike" : "like"
        likePostComment(commentId: comment.id, status: "active", action: !comment.isCommentLike.isNil ? "unlike" : "like", at: sender.tag)
    }
    
    @objc func goToProfileTapped(_ sender: UIButton) {
        let comment = comments[sender.tag]
        let id = comment.user.id
        if id == myUserDefaults.userId {
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = StoryboardRouter.othersProfileVC()
            vc.profileID = id
            vc.isFrom = 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func textLikeBtnTapped(_ sender: UIButton) {
        likePost(postId: postId, status: postDetail?.status ?? "", action: postDetail?.isPostLike != nil ? "unlike" : "like")
    }
    
    @IBAction func textShareBtnTapped(_ sender: UIButton) {
        handleShare()
    }
    
    @IBAction func reportBtnTapped(_ sender: UIButton) {
        
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Report","Block"],
                                    popOverPosition: .automatic,
                                    config: Constants.configWithMenuStyle(),
                                    done: { (selectedIndex) in
            switch selectedIndex {
            case 0:
                let vc = reportPopupVC.instantiate()
                vc.postId = self.postId
                vc.userId = self.postDetail?.user?.id ?? 0
                vc.completion = {
                    let vc = otherReasonPopupVC.instantiate()
                    vc.postId = self.postId
                    vc.userId = self.postDetail?.user?.id ?? 0
                    self.navigationController?.present(vc, animated: true)
                }
                self.navigationController?.present(vc, animated: true)
                
            case 1:
                print("User Block")
                self.blockUser(userId: self.postId)
                
            default:
                break
            }
        })
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
                    self.presentAlert("User Blocked Successfully")
                } else {
                    print("Error :: \(res.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    @IBAction func videoLikeBtnTapped(_ sender: UIButton) {
        likePost(postId: postId, status: postDetail?.status ?? "", action: postDetail?.isPostLike != nil ? "unlike" : "like")
    }
    
    @IBAction func videoShareBtnTapped(_ sender: UIButton) {
        handleShare()
    }
    
    @IBAction func imageLikeBtnTapped(_ sender: UIButton) {
        likePost(postId: postDetail?.id ?? 0, status: postDetail?.status ?? "", action: postDetail?.isPostLike == 0 ? "like" : "unlike")
    }
    
    @IBAction func imageShareBtnTapped(_ sender: UIButton) {
        handleShare()
    }
    
    @IBAction func docLikeBtnTapped(_ sender: UIButton) {
        likePost(postId: postId, status: postDetail?.status ?? "", action: postDetail?.isPostLike != nil ? "unlike" : "like")
    }
    
    @IBAction func docShareBtnTapped(_ sender: UIButton) {
        handleShare()
    }
    
    @IBAction func playVideoBtnTapped(_ sender: UIButton) {
        configureVideoView(getUrl: postDetail?.postVideo)
    }
    
    @IBAction func article_touchUpInside(_ sender: UIButton) {
         openArticle()
     }
    
    @objc func openArticle() {
        if let urlString = articleContent, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            present(webVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: UI updates
extension TextPostDetailVC {
    
    func setLayout() {
        msgTxtView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        makeImageRound(view: userAvatar)
        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        tableView.registerCell(withType: CommentCell.self)
//        sharedBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
//        if let postDetail = dashboardItem { updateUI(post: postDetail) }
        
        setShareBottomSheetView()
        bottomShareSheet.delegate = self
        
        followBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 12)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        textDetailView.layer.cornerRadius = 12
//        textDetailView.dropShadow()
        imageDetailView.layer.cornerRadius = 12
//        imageDetailView.dropShadow()
        videoDetailView.layer.cornerRadius = 12
//        videoDetailView.dropShadow()
        docDetailView.layer.cornerRadius = 12
//        docDetailView.dropShadow()
        docBorderView.layer.cornerRadius = 12 //docBorderView.layer.bounds.width/2
        docAttachmntView.layer.cornerRadius = 15.5
        
        documentNameLbl.font = UIFont(name: Myfonts.semiBold, size: 16)
        documentNameLbl.textColor = .black
        docSizeLbl.font = UIFont(name: Myfonts.regular, size: 14)
        docTimeLbl.font = UIFont(name: Myfonts.regular, size: 14)
        
//        if self.dashboardItem?.user?.id == myUserDefaults.userId {
//           followBtn.isHidden = true
//        } else {
//            if self.dashboardItem?.isConnected == "connected" || self.dashboardItem?.isConnected == "active" {
//                followBtn.isHidden = true
//            } else {
//                followBtn.isHidden = false
//            }
//        }
        
        switch postType {
        case .simpleText:
            self.textDetailView.isHidden = false
            self.imageDetailView.isHidden = true
            self.videoDetailView.isHidden = true
            self.docDetailView.isHidden = true
            self.playVideoBtn.isHidden = true
        case .image:
            self.textDetailView.isHidden = true
            self.imageDetailView.isHidden = false
            self.videoDetailView.isHidden = true
            self.docDetailView.isHidden = true
            self.playVideoBtn.isHidden = true
        case .video:
            self.textDetailView.isHidden = true
            self.imageDetailView.isHidden = true
            self.videoDetailView.isHidden = false
            self.docDetailView.isHidden = true
            self.playVideoBtn.isHidden = false
        case .article:
            self.textDetailView.isHidden = true
            self.imageDetailView.isHidden = true
            self.videoDetailView.isHidden = true
            self.docDetailView.isHidden = false
            self.playVideoBtn.isHidden = true
        }
    }
    
    func updateUI(post: PostDetail) {
        let userid = post.user?.id ?? 0
        if userid == myUserDefaults.userId {
            followBtn.isHidden = true
            reportBtn.isHidden = true
        } else {
            followBtn.isHidden = false
            reportBtn.isHidden = false
        }
        
        if post.user?.userImage != nil {
            userAvatar.sd_setImage(with: URL(string: (post.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            userAvatar.image = #imageLiteral(resourceName: "profile")
        }
        
        self.likeLbl.text = "\(post.likeCount ?? 0)"
        self.postContentLbl.text = post.content
        
        self.commentLbl.text = "\(post.commentCount ?? 0)"
        self.shareLbl.text = "\(post.shareCount ?? 0)"
        
        dayLbl.text = post.createdDate
        otherNameLbl.text = post.user?.firstName ?? ""
        likeImage.image = post.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "Like")
        self.textDetailView.isHidden = false
        self.imageDetailView.isHidden = true
        self.videoDetailView.isHidden = true
        self.docDetailView.isHidden = true
        self.playVideoBtn.isHidden = true
    }
    
    func FetchCommentList(){
        let parameters = ["post_id": self.postId ?? 0] as [String : Any]
        self.showActivity()
        NetworkManagerr.request(EndPoints.getCommentList, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                self.hideActivity()
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentRoot = try jsonDecoder.decode(CommentsModel.self, from: response.data!)
                    
                    if !(commentRoot.error!), ((commentRoot.data?.count ?? 0) > 0) {
                        self.commentData = []
                        self.commentData = commentRoot.data ?? []
                        
                    } else {
                        self.commentData = []
                    }
                    //When is come from notification side...
                    if self.isComeFromNotificationPostComment {
                        self.openCommentPopup()
                    } else {
                        print("Not Come From Notifiction Post Comment")
                    }
                    
                } catch {
                    print("\(String(describing: response.result.error?.localizedDescription))")
                }
            }
            else {
                self.hideActivity()
                self.presentAlert("Error", nil, response.result.error)
            }
        }
        
    }

    func setVideoData(videoPost: PostDetail) {
        let userid = videoPost.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
            reportBtn.isHidden = true
        } else {
            reportBtn.isHidden = false
            followBtn.isHidden = false
        }
        
        if videoPost.user?.userImage != nil {
            userAvatar.sd_setImage(with: URL(string: (videoPost.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            userAvatar.image = #imageLiteral(resourceName: "profile")
        }
        
        postContentLbl.text = videoPost.content
        likeLbl.text = "\(videoPost.likeCount ?? 0)"
        commentLbl.text = "\(videoPost.commentCount ?? 0)"
        shareLbl.text = "\(videoPost.shareCount ?? 0)"
        dayLbl.text = videoPost.createdDate
        otherNameLbl.text = videoPost.user?.firstName ?? ""
        
        if videoPost.isPostLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        }
        else {
            likeImage.image = #imageLiteral(resourceName: "Like")
        }
        videoPreviewView.backgroundColor = .black
        videoPreviewView.configure(url: videoPost.postVideo!,ratio: .resize)
        videoPreviewView.stop()
        videoPreviewView.isHidden = false
        
        self.textDetailView.isHidden = true
        self.imageDetailView.isHidden = true
        self.videoDetailView.isHidden = false
        self.docDetailView.isHidden = true
        self.playVideoBtn.isHidden = false
    }
    
    func setImageData(imagePost: PostDetail) {
        let userid = imagePost.user?.id ?? 0
        if userid == myUserDefaults.userId {
            reportBtn.isHidden = true
           followBtn.isHidden = true
        } else {
            reportBtn.isHidden = false
            followBtn.isHidden = false
        }
        
        if imagePost.user?.userImage != nil {
            userAvatar.sd_setImage(with: URL(string: (imagePost.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            userAvatar.image = #imageLiteral(resourceName: "profile")
        }

        likeLbl.text = "\(imagePost.likeCount ?? 0)"
        commentLbl.text = "\(imagePost.commentCount ?? 0)"
        shareLbl.text = "\(imagePost.shareCount ?? 0)"
        postContentLbl.text = imagePost.content
        dayLbl.text = imagePost.createdDate
        otherNameLbl.text = imagePost.user?.firstName ?? ""
        
        if !imagePost.datumPostImage!.isEmpty {
            setImages(imageUrl: imagePost.datumPostImage)
        }
        
        likeImage.image = imagePost.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "Like")
        
        self.textDetailView.isHidden = true
        self.imageDetailView.isHidden = false
        self.videoDetailView.isHidden = true
        self.docDetailView.isHidden = true
        self.playVideoBtn.isHidden = true
    }
    
    func setImages(imageUrl: [String?]?) {
        
        //ImageSlider Setting
        imageSlider.slideshowInterval = 3
        imageSlider.activityIndicator = DefaultActivityIndicator()
        imageSlider.contentScaleMode = .scaleAspectFill
        images.removeAll()
        for i in (imageUrl!) {
            if !i.isNil{
                images.append(SDWebImageSource(url: URL(string: i!)!))
            }
        }
        if !images.isEmpty {
            imageSlider.setImageInputs(images)
        }
        
    }
    
    func setDocData(docPost: PostDetail) {
        let userid = docPost.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
            reportBtn.isHidden = true
        } else {
            reportBtn.isHidden = false
            followBtn.isHidden = false
        }
        
        if docPost.user?.userImage != nil {
            userAvatar.sd_setImage(with: URL(string: (docPost.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            userAvatar.image = #imageLiteral(resourceName: "profile")
        }
        
        likeLbl.text = "\(docPost.likeCount ?? 0)"
        commentLbl.text = "\(docPost.commentCount ?? 0)"
        shareLbl.text = "\(docPost.shareCount ?? 0)"

        likeImage.image = docPost.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : UIImage(named: "Like")
        
        articleContent = docPost.postDocument
        dayLbl.text = docPost.createdDate
        otherNameLbl.text = docPost.user?.firstName ?? ""
        

        if docPost.content.isNilOrEmpty {
            postContentLbl.text = docPost.postDocument?.fileName()
        } else {
            postContentLbl.text = docPost.content
        }
        let docName = docPost.documentFileName ?? ""
        if docName == "" {
            documentNameLbl.text = "No Name"
        } else {
            documentNameLbl.text = docPost.postDocument
        }
        docSizeLbl.text = "\(docPost.documentSize ?? "0") kB"
        
        self.textDetailView.isHidden = true
        self.imageDetailView.isHidden = true
        self.videoDetailView.isHidden = true
        self.docDetailView.isHidden = false
        self.playVideoBtn.isHidden = true
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
    
    private func likePost(postId: Int, status: String, action: String) {
        showActivity()
        let param: AFParameters = [ "post_id": postId,
                                    "created_by_id": myUserDefaults.userId,
                                    "status": status,
                                    "action": action ]
        view.isUserInteractionEnabled = false
        
        ApiCallerClass.likePostServiceFunc(usertoken: myUserDefaults.token,para: param, success: { (dataRespose) in
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
            if error == 0 {
                self.getPostDetails()
            }
            else {
                self.presentAlert("Error!","\(String(describing: data?["error"]))")
            }
        })
        { (error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleShare() {
        tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.postId
        vc.type = .post
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    func myPost(detail: PostDetail?){
        guard let detail = detail else {
            
            return
        }
        if myUserDefaults.userId == detail.userID {
            isMyPost = true
        }
        else {
            isMyPost = false
        }
       
    }
}

// MARK: Network Calls
extension TextPostDetailVC {
    
    func getPostDetails() {
        showActivity()
        postDetail(postId: postId) { (postModel, postType, error) in
           self.hideActivity()
            if let post = postModel {
                self.postDetail = post
                
                if self.postDetail?.user?.id == myUserDefaults.userId {
                    self.followBtn.isHidden = true
                    self.reportBtn.isHidden = true
                } else {
                    self.reportBtn.isHidden = false
                    if self.postDetail?.isConnected == "connected" || self.postDetail?.isConnected == "active" {
                        self.followBtn.isHidden = true
                    } else {
                        self.followBtn.isHidden = false
                    }
                }
                
                if post.postVideo != "" && post.postVideo != nil {
                    self.postType = .video
                    self.setVideoData(videoPost: post)
                }
                else if (post.postDocuments?.count ?? 0) > 0 {
                    self.postType = .article
                    self.setDocData(docPost: post)
                }
                else if post.datumPostImage!.count > 0 {
                    self.postType = .image
                    self.setImageData(imagePost: post)
                }
                else {
                    self.postType = .simpleText
                    self.updateUI(post: post)
                }
//                self.postType = postType ?? .simpleText
//                switch self.postType {
//                case .simpleText:
//                    self.updateUI(post: post)
//                case .image:
//                    self.setImageData(imagePost: post)
//                case .video:
//                    self.setVideoData(videoPost: post)
//                case .article:
//                    self.setDocData(docPost: post)
//                }
//                //self.updateUI(post: post)
//                //self.postDetail = post
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
//    func getComments() {
//        showActivity()
//        getComments(postId: postId!) { (comments, error) in
//            self.hideActivity()
//            if let comments = comments {
//                self.getPostDetails()
//                self.comments.removeAll()
//                self.comments.append(contentsOf: comments)
//                
//                if self.comments.count > 0 {
//                    self.tableView.isHidden = false
//                    self.totalCommentLabel.text = "Comments(\(comments.count))"
//                } else if self.comments.count > 20 {
//                    self.tableView.isHidden = false
//                    self.totalCommentLabel.text = "Comments(\(20)+)"
//                }
//                else {
//                    self.totalCommentLabel.text = "No Comments!"
//                    self.tableView.isHidden = true
//                }
//                self.tableView.reloadData()
//            }
//            
//            if let error = error {
//                self.hideActivity()
//                self.presentAlert("Failure", nil, error)
//            }
//        }
//    }
    
    func likePostComment(commentId: Int, status: String, action: String, at: Int) {
        
        let param: AFParameters = [ "post_id": postId ?? 0,
                                    "comment_id": commentId,
                                    "created_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "action": action,
                                    "status": "active"]
        self.showActivity()
        NetworkManagerr.request(EndPoints.postCommentLike, method: .post, parameters: param) { (response) in
//            self.view.isUserInteractionEnabled = true
            
            if response.result.isSuccess {
                self.hideActivity()
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)

                    if !genericResponse.error {
//                        self.fetchNewsDetail(postId: self.newId)
                        self.comments.removeAll()
//                        self.getComments()
                    } else {
                        self.presentAlert("Error", genericResponse.message)
                    }
                } catch {
                    self.msgTxtView.text = ""
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.hideActivity()
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    
//    func updateComment(content: String, sender: UIButton) {
//        let commentId = comments[sender.tag].id
//        let parameters: AFParameters = [ "content": content,
//                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
//                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
//        let url = "\(EndPoints.updatePostComment)\(commentId)/"
//        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
//            self.view.isUserInteractionEnabled = true
//            if response.result.isSuccess {
//                let data = response.result.value as? NSDictionary
//                let error = data?["error"] as? Int
//                //IHProgressHUD.dismiss()
//                self.view.isUserInteractionEnabled = true
//                if error == 0 {
//                    self.getComments()
//                    self.mode = .create
//                    self.msgTxtView.text = ""
//                    self.placeHolderLbl.isHidden = false
//                    self.view.isUserInteractionEnabled = true
//                }
//                else {
//                    // self.makeAlert(messageData:data?["message"] as! String)
//                    self.view.isUserInteractionEnabled = true
//                }
//                self.hideActivity()
//            } else {
//                //self.makeAlert(messageData:response.data?["message"] as! String)
//            }
//        }
//    }
    
//    func deleteComment(content: String, sender: UIButton) {
//        let commentId = comments[sender.tag].id
//        let parameters: AFParameters = [ "status":"deleted",
//                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
//                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
//        let url = "\(EndPoints.deletePostComment)\(commentId)/"
//        NetworkManagerr.request(url,method: .delete, parameters: parameters) { (response) in
//            self.view.isUserInteractionEnabled = true
//            if response.result.isSuccess {
//                let data = response.result.value as? NSDictionary
//                let error = data?["error"] as? Int
//                //IHProgressHUD.dismiss()
//                self.view.isUserInteractionEnabled = true
//                if error == 0 {
//                    self.getComments()
//                    self.view.isUserInteractionEnabled = true
//
//                }
//                else {
//                    // self.makeAlert(messageData:data?["message"] as! String)
//                    self.view.isUserInteractionEnabled = true
//                }
//
//            } else {
//                //self.makeAlert(messageData:response.data?["message"] as! String)
//            }
//        }
//    }
    
//    func updateLikeStatus(action: String) {
//
//        showActivity()
//        updateLikeStatus(postId: postId!, action: action) { (success, error) in
//            self.view.isUserInteractionEnabled = true
//            self.hideActivity()
//            if let _ = success {
//                var likeCount = self.postDetail?.likeCount
//                if action == "like" {
//                    likeCount! += 1
//                    self.postDetail!.isPostLike = 1
//                    self.likeImage.image = #imageLiteral(resourceName: "like_selected")
//
//                } else {
//                    self.postDetail!.isPostLike = nil
//                    if likeCount! > 0 {
//                        likeCount! -= 1
//                        self.likeImage.image = #imageLiteral(resourceName: "like_selected")
//                    } else {
//                        likeCount! = 0
//                        self.likeImage.image = #imageLiteral(resourceName: "like")
//                    }
//                }
//                self.likeLbl.text! = "\(likeCount!)"
//            }
//
//            if let error = error {
//                self.presentAlert("Failure", nil, error)
//            }
//        }
//    }
}

extension TextPostDetailVC: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if msgTxtView.text.count > 0  && msgTxtView.text.count != 0 && !msgTxtView.text.isEmpty {
            placeHolderLbl.isHidden = true
            self.textIsOk = false
            
        } else {
            self.textIsOk = true
            placeHolderLbl.isHidden = false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        textView.text = ""
        placeHolderLbl.isHidden = true
        
        return true
    }
}

extension TextPostDetailVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as? CommentCell {
            
            cell.backgroundColor = UIColor.init(hex: "#F8F6F8")
            cell.mainUIView.backgroundColor = UIColor.white

            cell.comment = comments[indexPath.row]
            cell.isMyPost = isMyPost
            cell.commentMode = .otherComment
            cell.delegate = self
            cell.moreOption.tag = indexPath.row
            cell.likeBtn.tag = indexPath.row
            cell.goToProfileBtn.tag = indexPath.row
            
            cell.likeBtn.addTarget(self, action: #selector(commentLiked(_:)), for: .touchUpInside)
            cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension
    }
}
extension TextPostDetailVC: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        
       
        
        switch action {
        case .edit:
            
            msgTxtView.becomeFirstResponder()
            msgTxtView.text = comments[sender.tag].content
            mode = .edit
            senderButton = sender
            //createInputAlert(sender: sender)
        break
        case .delete:
            let alert = UIAlertController(title: "Delete", message: "Do you want to Delete this Comment", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//                self.deleteComment(content: "", sender: sender)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        break
        default:
        break
        }
        
    }
    
    
}

extension TextPostDetailVC {
    
    func addObservers() {
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
//    private func setNotificationObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillDismiss),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstant.constant = keyboardHeight <= 290 ? 290 : keyboardHeight - 90
//            self.view.layoutIfNeeded()
//        }
//
//    }
    
//    @objc func keyboardWillDismiss(_ notification: Notification) {
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstant.constant = 0
//            self.view.layoutIfNeeded()
//        }
//    }
}

// MARK: Share Custom Action
extension TextPostDetailVC : BottomContentPickerDelegate {
        
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        guard let postDetail = postDetail else { return }
        shareContent(type: content, postType: .posts, postId: postDetail.id ?? 0)
    }
    
//    @objc func handleShare(_ sender: UIButton) {
//        bottomShareSheet.presentView()
//    }
}
