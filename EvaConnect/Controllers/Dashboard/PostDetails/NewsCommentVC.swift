//
//  UrlCommentVC.swift
//  EvaConnect
//
//  Created by Metis on 17/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


import UIKit
import SDWebImage

@IBDesignable
class NewsCommentVC: BaseVC {
    
    //MARK: OutLets
    @IBOutlet weak var shareCountBtn: UIButton!
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var openURl: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var agoLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var ComentLbl: UILabel!
    @IBOutlet weak var textTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
//    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet weak var placeHolderLbl: UILabel!
//    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var newzTitle: UILabel!
    @IBOutlet weak var newzShortDetail: UILabel!
    @IBOutlet weak var newzName: UILabel!
//    @IBOutlet weak var newUrl: UILabel!

    //MARK: VARIABLES
    var btnTag: Int = 0
    var newId: Int = 0
    var newsData: NewsDetail?
    var CommentByIdArray: [NewsComment] = []
    var getContentOnly : String?
    var delegate: RefreshUpdateable?
    var textIsOk: Bool = true
    
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK:-VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textTableView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
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
extension NewsCommentVC {

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
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK: UI updates
extension NewsCommentVC {

    func setLayout() {
        likeBtn.tag = btnTag
        likeBtn.addTarget(self, action:#selector(likeNews(sender:)), for: .touchUpInside)
        sharedBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        msgTxtView.delegate = self
//        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        setUIData(modelSetter: newsData)
//        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        textTableView.delegate = self
        textTableView.dataSource = self
        textTableView.registerCell(withType: CommentCell.self)
        textTableView.backgroundView = UIView()
        textTableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
        buttonCustomization(actionBtn: openURl,
                            setClipsBound: false,
                            giveShadow: true,
                            borderColor: Constants.AppColorLiteral.signUpNew,
                            addBorder: true)
        
        setShareBottomSheetView()
        bottomShareSheet.delegate = self
    }
    
    func setUIData(modelSetter: NewsDetail?){
        if modelSetter != nil {
            if modelSetter!.isNewsLike == 1 {
                likeImage.image = #imageLiteral(resourceName: "like_selected")
            }
            else {
                likeImage.image = #imageLiteral(resourceName: "like")
            }
            //newzName.text =
            self.openURl.tag = btnTag
            openURl.addTarget(self, action: #selector(urlVCPost(sender:)), for: .touchUpInside)
            self.getContentOnly = modelSetter?.link
            PostImage.kf.setImage(with: URL(string: modelSetter!.image!))
            profileImage.kf.setImage(with: URL(string: modelSetter!.newsSource?.image ?? ""))
            likeLbl.text = "\(modelSetter!.likeCount!)"
            timeLbl.text = showTimeOnly(date: modelSetter!.createdDatetime!)
            ComentLbl.text = "\(modelSetter!.commentCount ?? 0)"
            shareCountBtn.setTitle("Comments \(modelSetter?.shareCount ?? 0) Share", for: .normal)
//            newUrl.text = modelSetter!.newsSource?.url
            newzTitle.text = modelSetter!.newsSource?.name
            newzName.text = modelSetter!.newsSource?.name
            timeLbl.text = modelSetter!.createdDatetime!.timeOnly()
            newzShortDetail.text = modelSetter!.title
            if modelSetter!.isNewsLike == 1 {
                likeImage.image = #imageLiteral(resourceName: "like_selected")
            }
            else {
                likeImage.image = #imageLiteral(resourceName: "like")
            }
        }
        else {
            print("Model is Not send")
        }
    }
}

// MARK: Network Calls
extension NewsCommentVC {

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
                        self.fetchNewsDetail(postId: self.newId)
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
    
    func fetchNewsDetail(postId: Int){
        
        let param: AFParameters = [ "user_id" :  LoggedUserDetails.shared.user!.id,
                                    "rss_news_id" : postId ]
        NetworkManagerr.request(EndPoints.getNewsById, method: .post, parameters: param) { (response) in
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let detail = try jsonDecoder.decode(NewsDetailRoot.self, from: response.data!)
                    if !(detail.error ?? false) {
                        self.newsData = detail.data?[0]
                        self.setUIData(modelSetter: self.newsData)
                    }
                }
                catch {
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }

    
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
                        self.textTableView.isHidden = false
                        self.fetchNewsDetail(postId: self.newId)
                        self.CommentByIdArray.removeAll()
                        self.CommentByIdArray.append(contentsOf: commentsRoot.data)
                        self.CommentByIdArray = self.CommentByIdArray.reversed()
                        self.textTableView.reloadData()
                    }
                    else {
                        self.fetchNewsDetail(postId: self.newId)
                        self.textTableView.isHidden = true
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
                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
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
                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
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
    
    func likeNewsPost(postId: Int, status: String, action: String) {
        
        let param: AFParameters = [ "rss_news_id" : postId,
                                    "created_by_id" : LoggedUserDetails.shared.user!.id,
                                    "status":status,
                                    "action": action ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.newsLikePost, method: .post, parameters: param) { (response) in
            self.view.isUserInteractionEnabled = true
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        self.fetchNewsDetail(postId: self.newId)
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.error)
                }
            }
        }
    }
}

//MARK: TEXTVIEW DELEGATES
extension NewsCommentVC: UITextViewDelegate {

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
extension NewsCommentVC: UITableViewDataSource, UITableViewDelegate {
    
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

        let cell = textTableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as! CommentCell
        
        cell.newsComment = CommentByIdArray[indexPath.row]
        cell.commentMode = .newsComment
        cell.delegate = self
        cell.moreOption.tag = indexPath.row
        cell.goToProfileBtn.tag = indexPath.row
        
        cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
        return cell
    }
}

//MARK: Custom Action
extension NewsCommentVC {
    
    @objc func urlVCPost(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OpenUrlVC") as! OpenUrlVC
        vc.contentString = getContentOnly
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likeNews(sender: UIButton) {
        view.isUserInteractionEnabled = false
        let modelSetter = newsData
        if modelSetter!.isNewsLike != nil  && modelSetter!.isNewsLike != 0{
            likeNewsPost(postId: newId, status: "pending", action: "unlike")
        } else {
            likeNewsPost(postId: newId, status: "pending", action: "like")
        }
    }
    
    @objc func goToProfileTapped(_ sender: UIButton) {
        let vc = StoryboardRouter.othersProfileVC()
        let comment = CommentByIdArray[sender.tag]
        vc.profileID = comment.user?.id ?? 0
        vc.isFrom = 0
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension NewsCommentVC: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        
        switch action {
        case .edit:
            msgTxtView.becomeFirstResponder()
            msgTxtView.text = CommentByIdArray[sender.tag].content
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

// MARK: Share Custom Action
extension NewsCommentVC: BottomContentPickerDelegate {
        
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        guard let newsId = newsData?.id else { return }
        shareContent(type: content, postType: .news, postId: newsId)
    }
    
    @objc func handleShare(_ sender: UIButton) {
        bottomShareSheet.presentView()
    }
}
