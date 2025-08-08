//
//  UrlCommentVC.swift
//  EvaConnect
//
//  Created by Metis on 17/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


import UIKit
import Alamofire
//import IHProgressHUD
//import URLEmbeddedView
import SDWebImage
import WebKit
import SafariServices

@IBDesignable
class UrlCommentVC: BaseVC {
    
    @IBOutlet weak var shareCountBtn: UIButton!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    //MARK: Outlets
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var documentHeight: NSLayoutConstraint!
//    @IBOutlet weak var embeddedView: URLEmbeddedView!
    @IBOutlet weak var OtherProfileImage: UIImageView!
    @IBOutlet weak var yourCommnetBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var otherNameLbl: UILabel!
    @IBOutlet weak var openURl: UIButton!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var ComentLbl: UILabel!
    @IBOutlet weak var textTableView: UITableView!
    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var zeroBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var defaultBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var openArticleBtn: UIButton!
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var documentName: UILabel!
    
    //MARK: VARIABLES
    var getIncrement : Int = 0
    var postId: Int!
    var postDataModel: PostDetail?
    var comments: [Comments] = []
    var getContentOnly : String?
    var delegate: RefreshUpdateable?
    var textIsOk = true
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    var isMyPost = false
    
    
    //MARK: VIEW LIFECYLCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNotificationObserver()
        
        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //textTableView.isHidden = true
        getPostDetail(postId: postId!)
        getAllComments(postId: postId!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstant?.constant = isKeyboardShowing ? ((keyboardFrame!.height) - 25) : 0
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

}

// MARK: IB Actions
extension UrlCommentVC {
    
    @objc func likePost(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        view.isUserInteractionEnabled = false
        let bindModelData = postDataModel
        
        if bindModelData?.isPostLike != nil {
            likePost(postId: postId!, status: "pending", action: "unlike",at: sender.tag)
        } else {
            likePost(postId: postId!, status: "pending", action: "like",at: sender.tag)
        }
    }
    
    @IBAction func addComment(_ sender: Any) {
        view.isUserInteractionEnabled = false
        msgTxtView.resignFirstResponder()
        if self.textIsOk != true || msgTxtView.text.count > 0 {
            
            if mode == .edit {
                self.updateComment(content: msgTxtView!.text!, sender: senderButton)
            } else {
                
                let postManager = PostManager()
                self.view.isUserInteractionEnabled = true
                postManager.addComments(postId: postId!, text: msgTxtView.text) { (success, error) in
                    
                    if let _ = success {
                        
                        self.getPostDetail(postId: self.postId!)
                        self.comments.removeAll()
                        self.getAllComments(postId: self.postId!)
                        self.msgTxtView.text = ""
                        self.placeHolderLbl.isHidden = false
                    }
                    
                    if let error = error {
                        self.presentAlert("Failure", nil, error)
                    }
                }
            }
      
        }
        else{
            view.isUserInteractionEnabled = true
            self.makeAlert(messageData: "Field is Empty")
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func openArticle(_ sender: Any) {
        if let urlString = postDataModel?.postDocument, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            webVC.modalPresentationStyle = .formSheet
            present(webVC, animated: true, completion: nil)
        }
    }
}


// MARK: Network Calls
extension UrlCommentVC {
    private func getPostDetail(postId: Int){
        
        postDetail(postId: postId) { (postModel, postType, error) in
            
            if let post = postModel {
                self.postDataModel = post
                self.setUIData(postDetail: post)
                
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    func getAllComments(postId: Int) {
        
        getComments(postId: postId) { (comments, error) in
            if let comments = comments {
                self.getPostDetail(postId: self.postId!)
                self.comments.removeAll()
                self.comments.append(contentsOf: comments)
                self.textTableView.reloadData()
            }
            
            if let error = error {
                self.hideActivity()
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    private func likePost(postId: Int,status: String,action: String,at: Int) {
        updateLikeStatus(postId: postId, action: action) { (success, error) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
            if let _ = success {
                var likeCount = Int(self.likeLbl.text!)
                if action == "like" {
                    likeCount! += 1
                    self.postDataModel!.isPostLike = 1
                    self.likeImage.image = #imageLiteral(resourceName: "like_selected")
                    
                } else {
                    self.postDataModel!.isPostLike = nil
                    if likeCount! > 0 {
                        likeCount! -= 1
                        self.likeImage.image = #imageLiteral(resourceName: "like")
                    } else {
                        likeCount! = 0
                        self.likeImage.image = #imageLiteral(resourceName: "like")
                    }
                }
                self.likeLbl.text! = "\(likeCount!)"
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    func updateComment(content: String, sender: UIButton) {
        let commentId = comments[sender.tag].id
        let parameters: AFParameters = [ "content": content,
                                         "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        let url = "\(EndPoints.updatePostComment)\(commentId)/"
        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                //IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.getAllComments(postId: self.postId)
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
        let commentId = comments[sender.tag].id
         let url = "\(EndPoints.deletePostComment)\(commentId)/"
        let parameters: AFParameters = [ "status":"deleted",
                                         "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        
        NetworkManagerr.request(url,method: .delete, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                //IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.getAllComments(postId: self.postId)
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
}

extension UrlCommentVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = textTableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.row]
        cell.isMyPost = isMyPost
        cell.commentMode = .otherComment
        cell.delegate = self
        cell.moreOption.tag = indexPath.row
        return cell
    }
}

extension UrlCommentVC: UITextViewDelegate {
    
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

extension UrlCommentVC {
    
    func setLayout() {
        
        msgTxtView.delegate = self
        makeImageRound(view: OtherProfileImage)
        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        makeImageRound(view: OtherProfileImage)
        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        textTableView.dataSource = self
        textTableView.delegate = self
        textTableView.registerCell(withType: CommentCell.self)
        textTableView.backgroundView = UIView()
        textTableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
        likeBtn.addTarget(self, action:#selector(likePost(sender:)), for: .touchUpInside)
        sharedBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        
        setShareBottomSheetView()
        bottomShareSheet.delegate = self
    }
    
    func setUIData(postDetail: PostDetail) {
        
        let urlLink = postDetail.postDocument
        if postDetail.isPostLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        }
        else {
            likeImage.image = #imageLiteral(resourceName: "like")
        }
        if postDetail.user?.userImage != nil{
            OtherProfileImage.sd_setImage(with: URL(string: (postDetail.user?.userImage)!), placeholderImage:  #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        }
        else {
            OtherProfileImage.image = #imageLiteral(resourceName: "noImage")
        }
        
        if let link = postDetail.content?.link {
//            embeddedView.load(urlString: link.absoluteString)
            documentHeight.constant = 100
//            embeddedView.isHidden = false
//            embeddedView.didTapHandler = { [weak self] (_, url) in
//                if let url = url { self?.present(SFSafariViewController(url: url), animated: true, completion: nil) }
//            }
        } else {
            loadArticleForPreview(article: urlLink)
            documentContent(content: postDetail.content, document: postDetail.postDocument!)
            documentView.isHidden = false
        }
        
        contentTxt.text = postDetail.content
        likeLbl.text = "\(postDetail.likeCount!)"
        let (date, time) = postDetail.dateTime
        timeLbl.text = time.isEmpty ? postDetail.createdDatetime!.components(separatedBy: " ").last ?? "" : "at \(time)"
        dayLbl.text = date.isEmpty ? postDetail.createdDatetime!.components(separatedBy: " ").first ?? "" : date
        ComentLbl.text = "\(postDetail.commentCount ?? 0)"
        shareCountBtn.setTitle("Comments \(postDetail.shareCount ?? 0) Share", for: .normal)
        otherNameLbl.text = "\(postDetail.user!.firstName!)"
        myPost(detail: postDetail)
    }
    func myPost(detail: PostDetail?) {
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
    private func documentContent(content: String?,document:String){
        guard let documentContent = content else {
            documentName.text = document.fileName()
            contentTxt.text = document.fileName()
            return
        }
        documentName.text = documentContent.fileName()
        contentTxt.text = documentContent.fileName()
    }
    
    @objc func urlVCPost(sender:UIButton) {
        print("ButtonIndex\(sender.tag)")
    }
    
    
    private func loadArticleForPreview(article: String?){
        let sampleImage = "http://168.63.140.202:8003/media/public/no_image.png"
        guard let link = URL(string: article!) else {
            let link = URL(string: sampleImage)
            let request = URLRequest(url: link!)
            web.load(request)
            return
        }
        let request = URLRequest(url: link)
        web.isUserInteractionEnabled = false
        web.load(request)
    }
}
extension UrlCommentVC: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        
       
        
        switch action {
        case .edit:
            msgTxtView.becomeFirstResponder()
            msgTxtView.text = comments[sender.tag].content
            mode = .edit
            senderButton = sender
        break
        case .delete:
            let alert = UIAlertController(title: "Delete", message: "Do you want to Delete this Comment", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.deleteComment(content: "", sender: sender)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        break
        default:
        break
        }
        
    }
    
    
}

extension UrlCommentVC {
    
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDismiss),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstant.constant = keyboardHeight <= 290 ? 290 : keyboardHeight - 90
//            self.view.layoutIfNeeded()
//        }
//        
    }
    
    @objc func keyboardWillDismiss(_ notification: Notification) {
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstant.constant = 0
//            self.view.layoutIfNeeded()
//        }
    }
}

// MARK: Share Custom Action
extension UrlCommentVC : BottomContentPickerDelegate {
        
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        guard let postDetail = postDataModel else { return }
        shareContent(type: content, postType: .posts, postId: postDetail.id ?? 0)
    }
    
    @objc func handleShare(_ sender: UIButton) {
        bottomShareSheet.presentView()
    }
}
