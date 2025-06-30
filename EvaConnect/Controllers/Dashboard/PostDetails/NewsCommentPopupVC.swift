//
//  NewsCommentPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 10/10/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class NewsCommentPopupVC: BaseVC {
    
    
    @IBOutlet weak var mainPopupView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var totalCommentLabel: UILabel!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var msgTextWholeView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    var btnTag: Int = 0
    var newId: Int = 0
    var newsData: NewsDetail?
    var CommentByIdArray: [NewsComment] = []
    var getContentOnly : String?
    var delegate: RefreshUpdateable?
    var textIsOk: Bool = true
    var completion: ((Int) -> ())? = nil
    
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        //Keyboard Show Hide managed...
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        commentTableView.isHidden = true
//        self.navigationController?.isNavigationBarHidden = true
        //        fetchNewsDetail(postId: newId)
        getAllComments()
        
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
extension NewsCommentPopupVC {

    @IBAction func addNewsComment(_ sender: Any) {
        view.isUserInteractionEnabled = false
        msgTxtView.resignFirstResponder()
        if self.textIsOk != true || msgTxtView.text.count > 0 {
            if mode == .edit {
                self.updateComment(content: msgTxtView!.text!, sender: senderButton)
            }
            else{
                self.view.isUserInteractionEnabled = true
                addNewsComment(postId: newId, content: msgTxtView.text)
            }
           
        }
        else {
            view.isUserInteractionEnabled = true
            self.makeAlert(messageData: "Field is Empty")
        }
    }
    
    @objc func commentLiked(_ sender: UIButton) {
        let comment = CommentByIdArray[sender.tag]
        
//        likeNews(postId: post.id, status: "active", action: !post.isJobLike.isNil ? "unlike" : "like", at: sender.tag)
        //action: !comment.isJobLike.isNil ? "unlike" : "like"
        likeNewsComment(commentId: comment.id ?? 0, status: "active", action: !comment.isCommentLike.isNil ? "unlike" : "like", at: sender.tag)
    }
    
    @objc func goToProfileTapped(_ sender: UIButton) {
        let comment = self.CommentByIdArray[sender.tag]
        let id = comment.user?.id ?? 0
        self.dismiss(animated: true)
        self.completion?(id)
    }
    
}

// MARK: UI updates
extension NewsCommentPopupVC {

    func setLayout() {
        msgTxtView.delegate = self
//        setUIData(modelSetter: newsData)
        popupView(uiView: mainPopupView)
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.registerCell(withType: CommentCell.self)
        commentTableView.backgroundView = UIView()
    
    }
}

// MARK: Network Calls
extension NewsCommentPopupVC {

    func addNewsComment(postId: Int, content: String) {
        
        let param: AFParameters = [ "rss_news_id": newId,
                                    "created_by_id":  myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "status": "active",
                                    "content": content.encodeEmoji ]
        
        NetworkManagerr.request(EndPoints.addNewsComment, method: .post, parameters: param) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)

                    if !genericResponse.error {
//                        self.fetchNewsDetail(postId: self.newId)
                        self.CommentByIdArray.removeAll()
                        self.getAllComments()
                        self.msgTxtView.text = ""
                        self.delegate?.refresh(homeStatus: false)
                        self.placeHolderLbl.isHidden = false
                    }
                } catch {
                    self.msgTxtView.text = ""
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func likeNewsComment(commentId: Int, status: String, action: String, at: Int) {
        
        let param: AFParameters = [ "rss_news_id": newId,
                                    "comment_id": commentId,
                                    "created_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                    "action": action,
                                    "status": "active"]
        
        NetworkManagerr.request(EndPoints.newsCommentLike, method: .post, parameters: param) { (response) in
//            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)

                    if !genericResponse.error {
//                        self.fetchNewsDetail(postId: self.newId)
                        self.CommentByIdArray.removeAll()
                        self.getAllComments()
                        self.msgTxtView.text = ""
                        self.delegate?.refresh(homeStatus: false)
                        self.placeHolderLbl.isHidden = false
                    }
                } catch {
                    self.msgTxtView.text = ""
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
//    func fetchNewsDetail(postId: Int){
//
//        let param: AFParameters = [ "user_id" :  LoggedUserDetails.shared.user!.id,
//                                    "rss_news_id" : postId ]
//        NetworkManagerr.request(EndPoints.getNewsById, method: .post, parameters: param) { (response) in
//
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let detail = try jsonDecoder.decode(NewsDetailRoot.self, from: response.data!)
//                    if !detail.error {
//                        self.newsData = detail.data[0]
//                        self.setUIData(modelSetter: self.newsData)
//                    }
//                }
//                catch {
//                    self.presentAlert("Failure", nil, response.error)
//                }
//            } else {
//                self.presentAlert("Failure", nil, response.error)
//            }
//        }
//    }

    
    func getAllComments() {
        let parameters: AFParameters = [ "rss_news_id" : newId]
        showActivity()
        NetworkManagerr.request(EndPoints.fetchNewsComment, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentsRoot = try jsonDecoder.decode(NewsCommentRoot.self, from: response.data!)
                        
                    if commentsRoot.data.count > 0 {
//                        self.commentTableView.isHidden = false
//                        self.fetchNewsDetail(postId: self.newId)
                        self.totalCommentLabel.text = "Comments(\((commentsRoot.data.count) - 1)+)"
                        self.CommentByIdArray.removeAll()
                        self.CommentByIdArray.append(contentsOf: commentsRoot.data)
                        self.CommentByIdArray = self.CommentByIdArray.reversed()
                        self.commentTableView.reloadData()
                    }
                    else {
                        self.totalCommentLabel.text = "No Comments!"
//                        self.fetchNewsDetail(postId: self.newId)
//                       self. self.commentTableView.isHidden = true
                       // self.presentAlert("Failure", nil, response.result.error)
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
    
    func updateComment(content: String, sender: UIButton) {
        let commentId = CommentByIdArray[sender.tag].id
        let parameters: AFParameters = [ "content": content,
                                         "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        let url = "\(EndPoints.updateNewsComment)\(commentId!)/"
        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                //IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.getAllComments()
                    self.mode = .create
                    self.msgTxtView.text = ""
                    self.view.isUserInteractionEnabled = true
                    self.placeHolderLbl.isHidden = false
                }
                else {
                    // self.makeAlert(messageData:data?["message"] as! String)
                    self.view.isUserInteractionEnabled = true
                }
                
            } else {
                //self.makeAlert(messageData:response.data?["message"] as! String)
            }
        }
    }
    
    func deleteComment(content: String, sender: UIButton) {
        let commentId = CommentByIdArray[sender.tag].id
        let url = "\(EndPoints.deleteNewsComment)\(commentId!)/"
        let parameters: AFParameters = [ "status":"deleted",
                                         "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        
        NetworkManagerr.request(url,method: .delete, parameters: parameters){ (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                //IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.getAllComments()
                    self.view.isUserInteractionEnabled = true
                }
                else {
                    // self.makeAlert(messageData:data?["message"] as! String)
                    self.view.isUserInteractionEnabled = true
                }
                
            } else {
                //self.makeAlert(messageData:response.data?["message"] as! String)
            }
        }
    }
    
//    func likeNewsPost(postId: Int, status: String, action: String) {
//        
//        let param: AFParameters = [ "rss_news_id" : postId,
//                                    "created_by_id" : LoggedUserDetails.shared.user!.id,
//                                    "status":status,
//                                    "action": action ]
//        
//        showActivity()
//        NetworkManagerr.request(EndPoints.newsLikePost, method: .post, parameters: param) { (response) in
//            self.view.isUserInteractionEnabled = true
//            self.hideActivity()
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
//                    if !genericResponse.error {
//                        self.fetchNewsDetail(postId: self.newId)
//                    }
//                } catch {
//                    self.presentAlert("Failure", nil, response.error)
//                }
//            }
//        }
//    }
}

//MARK: TEXTVIEW DELEGATES
extension NewsCommentPopupVC: UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if msgTxtView.text.count > 0  && msgTxtView.text.count != 0 && !msgTxtView.text.isEmpty{
            placeHolderLbl.isHidden = true
            self.textIsOk = false
        }
        else {
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

//MARK: TABLEVIEW DELEGATES
extension NewsCommentPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentByIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentTableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as! CommentCell
        
        cell.backgroundColor = UIColor.white
        cell.mainUIView.backgroundColor = UIColor.init(hex: "#F8F6F8")
       
        cell.newsComment = CommentByIdArray[indexPath.row]
        cell.commentMode = .newsComment
//        cell.delegate = self
        cell.moreOption.tag = indexPath.row
        cell.likeBtn.tag = indexPath.row
        cell.goToProfileBtn.tag = indexPath.row

        cell.likeBtn.addTarget(self, action: #selector(commentLiked(_:)), for: .touchUpInside)
        cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
        return cell
    }
}
