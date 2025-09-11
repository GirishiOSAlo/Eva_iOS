//
//  CommentVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentVC: UIViewController, XIBed {
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topLineVw: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var commentsCollectionVw: UICollectionView!
    @IBOutlet weak var noCommentsLbl: UILabel!
    
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var replayBaseVw: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewUIHeightConst: NSLayoutConstraint!
    
    var expandedIndexPath: IndexPath?
    var isComeFromNews:Bool = false
    var commentData: [Comment] = []
    var selectdNewsReplyComment: Comment?
    var newsId = 0
    var postId = 0
    var isPost = false
    var placeholderLabel : UILabel!
    var isReplyComment:Bool = false
    var postCommentId = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupUI()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            if translation.y > 0 { // dragging down
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 300 { // threshold to dismiss
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.roundCorners([.topLeft, .topRight], radius: 35)
    }
    
    func setupUI() {
        self.noCommentsLbl.isHidden = true
        topLineVw.layer.cornerRadius = topLineVw.frame.size.height / 2
        titleLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        noCommentsLbl.font = UIFont(name: Myfonts.medium, size: 20.0)
        
        replayBaseVw.layer.cornerRadius = 14.0
        attachBtn.layer.cornerRadius = attachBtn.frame.size.height / 2
        sendBtn.layer.cornerRadius = 10.0
        self.setupTextView()
        self.registerCell()
        //        self.getComments()
        self.commentsCollectionVw.reloadData()
        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        if self.isComeFromNews {
            self.getNewsComments(id: self.newsId)
        }
    }
    
    func setupTextView() {
        commentTextView.delegate = self
        commentTextView.isScrollEnabled = false
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write you reason here..."
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        placeholderLabel.sizeToFit()
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (commentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(hex: "#8C8C8C", alpha: 1.0)
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
    }
    
    func registerCell() {
        commentsCollectionVw.registerNib(cellNib: CommentCVC.self)
        commentsCollectionVw.delegate = self
        commentsCollectionVw.dataSource = self
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
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        if commentTextView.text != "" {
            showActivity()
            if isComeFromNews {
                if self.isReplyComment {
                    let rssNewsID = self.selectdNewsReplyComment?.rssNewsID ?? 0
                    let commentId = self.selectdNewsReplyComment?.id ?? 0
                    let content = self.commentTextView.text.encodeEmoji
                    self.createNewsReplyComment(newsId: rssNewsID, commentId: commentId, status: "active", content: content)
                } else {
                    let rssNewsID = newsId
                    let content = self.commentTextView.text.encodeEmoji
                    self.createNewsComment(newsId: rssNewsID, status: "active", content: content)
                }
            } else {
                addPostComment()
            }
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
    
    func getComments(postId: Int, completion: @escaping ([Comment]?, Error?) -> Void) {
        
        let parameters: AFParameters = ["post_id": postId]
        NetworkManagerr.request(EndPoints.getCommentList, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                let commentsRoot = try! jsonDecoder.decode(CommentsModel.self, from: response.data!)
                completion(commentsRoot.data, nil)
                if commentsRoot.data?.count ?? 0 > 0 {
                    completion(commentsRoot.data, nil)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func getComments() {
        showActivity()
        getComments(postId: postId) { (comments, error) in
            self.hideActivity()
            if let comments = comments {
                self.commentData = comments
                self.commentsCollectionVw.reloadData()
                self.view.layoutIfNeeded()
            }
            
            if let error = error {
                self.hideActivity()
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    func addPostComment(){
        var parameters: AFParameters = [:]
        
        if isReplyComment {
            parameters = [ "post_id": postId,
                           "created_by_id" :  myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                           "comment_id": self.postCommentId,
                           "status": "active",
                           "content": commentTextView.text.encodeEmoji ]
        } else {
            parameters = [ "post_id": postId,
                           "created_by_id" :  myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                           "status": "active",
                           "content": commentTextView.text.encodeEmoji ]
        }
        
        self.showActivity()
        NetworkManagerr.request(EndPoints.addComment, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                self.hideActivity()
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !(commentRoot.error) {
                        if commentRoot.error {
                            self.presentAlert("Failure", commentRoot.message, nil)
                        } else {
                            self.commentTextView.resignFirstResponder()
                            self.getComments()
                        }
                    } else {
                        self.presentAlert("Failure", commentRoot.message, nil)
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
    
    
    func didTapDropdownButton(in cell: CommentCVC) {
        guard let indexPath = commentsCollectionVw.indexPath(for: cell) else { return }
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        if let previous = expandedIndexPath, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        // Update the expandedIndexPath
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil // collapse
        } else {
            expandedIndexPath = indexPath // expand new
        }
        
        // Animate height and layout changes
        commentsCollectionVw.performBatchUpdates {
            commentsCollectionVw.reloadItems(at: indexPathsToReload)
        }
    }
    
    //--> Comment Like & Dislike...
    @objc func likeCommentTapped(sender: UIButton){
        let comment = self.commentData[sender.tag]
        let rssNewsID = comment.rssNewsID ?? 0
        let commentID = comment.id ?? 0
        
        if self.isComeFromNews {
            //            if comment.isCommentLike == 1 { //--> Dislike...
            //                self.likeNewsComment(newsId: rssNewsID, commentId: commentID, status: "deactivate", action: "dislike")
            //            } else { //--> Like...
            self.likeNewsComment(newsId: rssNewsID, commentId: commentID, status: "active", action: "like")
            //            }
        } else {
            //            if comment.isCommentLike == 1 {
            //                self.likePostComment(postId: self.postId, commentId: commentID, status: "deactivate", action: "dislike")
            //            } else {
            self.likePostComment(postId: self.postId, commentId: commentID, status: "active", action: "like")
            //            }
        }
    }
    @objc func dislikeCommentTapped(sender: UIButton){
        let comment = self.commentData[sender.tag]
        let rssNewsID = comment.rssNewsID ?? 0
        let commentID = comment.id ?? 0
        if self.isComeFromNews {
            self.likeNewsComment(newsId: rssNewsID, commentId: commentID, status: "deactivate", action: "dislike")
        } else {
            self.likePostComment(postId: self.postId, commentId: commentID, status: "deactivate", action: "dislike")
        }
    }
    
    //--> Comment Reply...
    @objc func replyCommentTapped(sender: UIButton){
        self.isReplyComment = true
        self.selectdNewsReplyComment = self.commentData[sender.tag]
        self.postCommentId = self.commentData[sender.tag].id ?? 0
        self.commentTextView.becomeFirstResponder()
    }
    
    //--> Coment More Button...
    @objc func commentMoreTapped(sender: UIButton){
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Report"],
                                    popOverPosition: .automatic,
                                    config: Constants.configWithMenuStyle(),
                                    done: { (selectedIndex) in
            switch selectedIndex {
            case 0: //Report...
                let vc = ReportVC.instantiate()
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                vc.selectedNewsId = self.newsId
                vc.commentID = self.commentData[sender.tag].id ?? 0
                self.present(vc, animated: true)
            case 1: //Block...
                break
            default:
                break
            }
        })
    }
}

//Comment Reply Button....
extension CommentVC: CommentsCellDelegate {
    //Reply Comment Like...
    func didTapReplyLikeButton(replyComment: RepliesComment, isComeFromNews: Bool) {
        let commentID = replyComment.id ?? 0
        if isComeFromNews {
            let rssNewsID = replyComment.rssNewsID ?? 0
            self.likeNewsComment(newsId: rssNewsID, commentId: commentID, status: "active", action: "like")
        } else {
            self.likePostComment(postId: self.postId, commentId: commentID, status: "active", action: "like")
        }
    }
    
    //Reply Comment Dislike...
    func didTapReplyDislikeButton(replyComment: RepliesComment, isComeFromNews: Bool) {
        let commentID = replyComment.id ?? 0
        if isComeFromNews {
            let rssNewsID = replyComment.rssNewsID ?? 0
            self.likeNewsComment(newsId: rssNewsID, commentId: commentID, status: "deactivate", action: "dislike")
        } else{
            self.likePostComment(postId: self.postId, commentId: commentID, status: "deactivate", action: "dislike")
        }
    }
    
    //Reply Comment Reply...
    func didTapReplyButton(replyComment: RepliesComment, isComeFromNews: Bool) {
        presentAlert("Coming Soon..")
        //        self.isReplyComment = true
        //        self.postCommentId = replyComment.id ?? 0
        //        self.commentTextView.becomeFirstResponder()
    }
    
    //Reply Comment More...
    func didTapMoreButton(in cell: CommentCVC, sender: UIButton, replyComment: RepliesComment, isComeFromNews: Bool) {
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Report"],
                                    popOverPosition: .automatic,
                                    config: Constants.configWithMenuStyle(),
                                    done: { (selectedIndex) in
            switch selectedIndex {
            case 0:
                let vc = ReportVC.instantiate()
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                vc.selectedNewsId = self.newsId
                vc.commentID = self.commentData[sender.tag].id ?? 0
                self.present(vc, animated: true)
            default:
                break
            }
        })
    }
}

extension CommentVC: ReportCellDelegate {
    func didTapSelectButton(report: ReportData, newsID: Int, commentId: Int) {
        self.reportCommet(tagID: report.id ?? 0, newsID: newsID, commentID: commentId)
    }
}

extension CommentVC {
    func getNewsComments(id: Int) {
        let parameters: AFParameters = [ "rss_news_id" : id]
        showActivity()
        NetworkManagerr.request(EndPoints.fetchNewsComment, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentsRoot = try jsonDecoder.decode(CommentsModel.self, from: response.data!)
                        
                    if commentsRoot.data?.count ?? 0 > 0 {
                        self.noCommentsLbl.isHidden = true
                        self.commentData = commentsRoot.data ?? []
                        self.commentsCollectionVw.reloadData()
                    }
                    else {
                        self.noCommentsLbl.isHidden = false
                    }
                }
                catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            }
            else {
                self.presentAlert("Failure", nil, response.result.error)
            }
        }
    }
    
    func likeNewsComment(newsId: Int, commentId: Int, status: String, action: String) {
        let param: AFParameters = [ "rss_news_id": newsId,
                                    "created_by_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                                    "comment_id" : commentId,
                                    "action": action,
                                    "status": status]
        
        showActivity()
        NetworkManagerr.request(EndPoints.newsCommentLike, method: .post, parameters: param) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        if self.isComeFromNews {
                            self.getNewsComments(id: self.newsId)
                        }
                    }
                } catch {
//                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
//                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func likePostComment(postId: Int, commentId: Int, status: String, action: String) {
        let param: AFParameters = [ "post_id": postId,
                                    "created_by_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                                    "comment_id" : commentId,
                                    "action": action,
                                    "status": status]
        
        showActivity()
        NetworkManagerr.request(EndPoints.postCommentLike, method: .post, parameters: param) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        self.getComments()
                    }
                } catch {
//                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
//                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func createNewsComment(newsId: Int, status: String, content: String) {
        let param: AFParameters = [ "rss_news_id": newsId,
                                    "created_by_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                                    "content": content,
                                    "status": status]
        
        showActivity()
        NetworkManagerr.request(EndPoints.addNewsComment, method: .post, parameters: param) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        self.commentTextView.text = ""
                        self.commentTextView.resignFirstResponder()
                        if self.isComeFromNews {
                            self.commentTextView.text = ""
                            self.getNewsComments(id: self.newsId)
                        }
                    }
                } catch {
//                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
//                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func createNewsReplyComment(newsId: Int, commentId: Int, status: String, content: String) {
        let param: AFParameters = [ "rss_news_id": newsId,
                                    "created_by_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id ?? 0,
                                    "comment_id": commentId,
                                    "content": content,
                                    "status": status]
        
        showActivity()
        NetworkManagerr.request(EndPoints.addNewsComment, method: .post, parameters: param) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        self.commentTextView.text = ""
                        self.commentTextView.resignFirstResponder()
                        if self.isComeFromNews {
                            self.commentTextView.text = ""
                            self.getNewsComments(id: self.newsId)
                        }
                    }
                } catch {
//                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
//                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func reportCommet(tagID: Int, newsID: Int, commentID: Int) {
        let url = EndPoints.complain
        let parameters = [
            "tag_id": tagID,
            "comment_id": commentID,
            "news_id": newsID ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let reporteRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(reporteRoot.error) {
                    print("Success")
                    self.showToast(message: reporteRoot.message)
                } else {
                    print("Error :: \(reporteRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    
}

//MARK: UITextview
extension CommentVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
        
        let maxHeight: CGFloat = 176 // Optional: set a limit
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        // Resize height constraint with animation
        let newHeight = min(estimatedSize.height + 20, maxHeight)
        textViewUIHeightConst.constant = newHeight
        view.layoutIfNeeded()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}


//MARK: UICollection Delegate & DataSource....
extension CommentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.commentsCollectionVw.dequeueReusableCell(withReuseIdentifier: CommentCVC.ReuseId, for: indexPath) as! CommentCVC
        
        cell.isComeFromNews = self.isComeFromNews
        cell.treadVwWidth.constant = 0.0
        cell.treadVericalLine.isHidden = false
        
        let comment = commentData[indexPath.row]
        cell.descLbl.text = comment.content
        cell.timeLbl.text = comment.createdDate
        
        let user = comment.user
        cell.nameLbl.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        if let imageUrl = user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            cell.profileImgVw.image = UIImage(named: "profile")
        }
        
        cell.likeBtn.setTitle("\(comment.likeCount ?? 0)", for: .normal) //Comment Like Count...
        let commentLike = comment.isCommentLike ?? 0
        if commentLike == 1 {
            cell.likeBtn.setImage(UIImage(named: "ic_commentLikeFill"), for: .normal)
        } else {
            cell.likeBtn.setImage(UIImage(named: "ic_commentLike"), for: .normal)
        }
        
        cell.dislikeBtn.setTitle("\(comment.dislikeCount ?? 0)", for: .normal) //Comment Dislike Count...
        let commentDislike = comment.isCommentDisLike ?? 0
        if commentDislike == 1 {
            cell.dislikeBtn.setImage(UIImage(named: "ic_commentDisliikeFill"), for: .normal)
        } else {
            cell.dislikeBtn.setImage(UIImage(named: "ic_commentDislike"), for: .normal)
        }
        
        cell.replies = comment.replies ?? []
        cell.delegate = self
        cell.isExpanded = (indexPath == expandedIndexPath)
        
        if comment.replies?.count ?? 0 > 0 {
            cell.viewReplyBtnVwHeight.constant = 30.0
        } else {
            cell.viewReplyBtnVwHeight.constant = 0.0
        }
        
        if cell.isExpanded {
            cell.treadVericalLine.isHidden = false
            var insideReplyHeight = 0.0
            for reply in comment.replies ?? [] {
                let lblHeight = self.heightForView(text: reply.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 184.0)
                let cellHeight = lblHeight + 112.0
                insideReplyHeight = insideReplyHeight + cellHeight
            }
            cell.insideRepliesCollectionVwHeight.constant = insideReplyHeight
        }
        else {
            cell.treadVericalLine.isHidden = true
            cell.insideRepliesCollectionVwHeight.constant = 0.0
        }

        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeCommentTapped(sender:)), for: .touchUpInside)
        cell.dislikeBtn.tag = indexPath.row
        cell.dislikeBtn.addTarget(self, action: #selector(dislikeCommentTapped(sender:)), for: .touchUpInside)
        cell.replyBtn.tag = indexPath.row
        cell.replyBtn.addTarget(self, action: #selector(replyCommentTapped(sender:)), for: .touchUpInside)
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(commentMoreTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == expandedIndexPath {
            //-->Expanded height
            let comment = commentData[indexPath.row].content ?? ""
            let lblHeight = self.heightForView(text: comment, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            let cellHeight = lblHeight + 142.0
            
            var insideReplyHeight = 0.0
            for reply in commentData[indexPath.row].replies ?? [] {
                let lblHeight = self.heightForView(text: reply.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 184.0)
                let insideCellHeight = lblHeight + 112.0
                insideReplyHeight = insideReplyHeight + insideCellHeight
            }
            let totalHeight = cellHeight + insideReplyHeight + 16.0
            return CGSize(width: self.commentsCollectionVw.frame.size.width, height: totalHeight)
        }
        else {
            //-->Normal height
            let reply = self.commentData[indexPath.row].content ?? ""
            let lblHeight = self.heightForView(text: reply, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 92.0)
            var cellHeight = lblHeight + 142.0
            
            //--> View Reply Button Show Hide...
            let replies = commentData[indexPath.row].replies ?? []
            if replies.count > 0 {
               //show view reply button
            } else {
                cellHeight = cellHeight - 30.0
            }
            return CGSize(width: self.commentsCollectionVw.frame.size.width, height: cellHeight)
        }
    }
}
