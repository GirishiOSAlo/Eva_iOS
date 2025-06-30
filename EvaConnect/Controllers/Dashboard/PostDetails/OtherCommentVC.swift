//
//  OtherCommentVC.swift
//  EvaConnect
//
//  Created by Metis on 23/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD
//import URLEmbeddedView
import SDWebImage
import AVKit
import ImageSlideshow
@IBDesignable
class OtherCommentVC: BaseVC {
    
    @IBOutlet weak var shareCountBtn: UIButton!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    //MARK: OutLets
    @IBOutlet weak var OtherProfileImage: UIImageView!
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var yourCommnetBtn: UIButton!
    @IBOutlet weak var doubleClickLike: UIButton!
    @IBOutlet weak var openVideoBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mainLikeView: UIView!
    @IBOutlet weak var CommentView: UIView!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var ConnectionLbl: UILabel!
    @IBOutlet weak var otherNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var agoLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var ComentLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var textTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var goBackFooter: UIButton!
    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var imgSliderView: ImageSlideshow!
    @IBOutlet weak var contentTxt: UITextView!
    
    
    //MARK: VARIABLES
    var postId: Int?
    var PostDataModel: PostDetail?
    var comments: [Comments] = []
    var imageArray = [String]()
    var images: [InputSource] = []
    
    weak var delegate: RefreshUpdateable?
    var textIsOk = true
    let postManager = PostManager()
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    var isMyPost = false
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setLayout()
        setNotificationObserver()
        
        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPostDetail(postId: postId!)
        getAllComments(postId: postId!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        delegate?.refresh(homeStatus: false)
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likePost_touchUpInside(_ sender: UIButton) {
        view.isUserInteractionEnabled = false
        let bindModelData = PostDataModel
        
        if bindModelData?.isPostLike != nil {
            updateLikeStatus(action: "unlike")
        } else {
            updateLikeStatus(action: "like")
        }
    }
    
    @IBAction func addComment(_ sender: Any) {
        view.isUserInteractionEnabled = false
        msgTxtView.resignFirstResponder()
        if self.textIsOk != true || msgTxtView.text.count > 0 {
            if mode == .edit {
                
                self.updateComment(content: msgTxtView!.text!, sender: senderButton)
            } else {
                self.view.isUserInteractionEnabled = true
                postManager.addComments(postId: postId!, text: msgTxtView.text) { (success, error) in
                    
                    if let _ = success {
                        //self.getPostDetail(postId: self.postId!)
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
         
        } else {
            view.isUserInteractionEnabled = true
            self.makeAlert(messageData: "Field is Empty")
        }
    }
    
    @objc func likeByDoubleClick(gesture: UIGestureRecognizer) {
        
        if PostDataModel?.isPostLike != nil {
            updateLikeStatus(action: "unlike")
        } else{
            updateLikeStatus(action: "like")
        }
    }
}

// MARK: Layout Updates
extension OtherCommentVC {
    
    func setLayout() {
        
        //doubleClickLike
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(likeByDoubleClick(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        doubleClickLike.isUserInteractionEnabled = true
        doubleClickLike.addGestureRecognizer(doubleTap)
        msgTxtView.delegate = self
        textTableView.dataSource = self
        textTableView.delegate = self
        makeImageRound(view: OtherProfileImage)
        profileView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        textTableView.registerCell(withType: CommentCell.self)
        sharedBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        textTableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
        
        setShareBottomSheetView()
        bottomShareSheet.delegate = self
    }
    
    func setUIData(post: PostDetail) {
        
        likeImage.image = post.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like")
        
        if post.user?.userImage !=  nil {
            OtherProfileImage.sd_setImage(with: URL(string: (post.user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        } else {
            OtherProfileImage.image = #imageLiteral(resourceName: "noImage")
        }
        if post.postImage!.count >= 1 {
            imageArray.removeAll()
            images.removeAll()
            if post.postImage!.count != 0 && !post.postImage!.isEmpty {
                for i in post.postImage! {
                    imageArray.append(i)
                }
                //ImageSlider Setting
                imgSliderView.slideshowInterval = 3
                imgSliderView.activityIndicator = DefaultActivityIndicator()
                imgSliderView.delegate = self
                
                for i in imageArray {
                    images.append(SDWebImageSource(url: URL(string:i)!))
                }
                imgSliderView.setImageInputs(images)
                doubleClickLike.isHidden = false
                videoView.isHidden = true
                imgSliderView.isHidden = false
               // PostImage.isHidden = true
            }
        }
        
        else if post.postVideo != nil && post.postImage?.count == 0 {
            
            doubleClickLike.isHidden = true
            //PostImage.isHidden = true
            
            self.videoView.configure(url: post.postVideo!,ratio: .resize)
            self.videoView.isLoop = true
            self.videoView.stop()
            openVideoBtn.isHidden = false
            self.view.bringSubviewToFront(openVideoBtn)
            openVideoBtn.addTarget(self, action: #selector(configureVideoView), for: .touchUpInside)
            imgSliderView.isHidden = true
            videoView.isHidden = false
        }
        
        likeLbl.text = "\(post.likeCount!)"
        if post.content.isNil {
            contentTxt.isHidden = true
        } else {
            contentTxt.isHidden = false
            contentTxt.text = post.content
        }
        
        let (date, time) = post.dateTime
        timeLbl.text = time.isEmpty ? post.createdDatetime!.components(separatedBy: " ").last ?? "" : "at \(time)"
        dayLbl.text = date.isEmpty ? post.createdDatetime!.components(separatedBy: " ").first ?? "" : date
        
        ComentLbl.text = "\(post.commentCount ?? 0)"
        shareCountBtn.setTitle("Comments \(post.shareCount ?? 0) Share", for: .normal)
        otherNameLbl.text = post.user!.firstName!
        myPost(detail: post)
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
    //Configure Custom View
    @objc func configureVideoView() {
        if PostDataModel != nil {
            let bindData = PostDataModel
            let videoURL = URL(string: bindData!.postVideo!)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerViewController()
            playerLayer.player = player
            self.present(playerLayer, animated: true, completion: {
                player.play()
            })
        }
    }
    
}


//MARK: TEXTVIEW DELEGATES
extension OtherCommentVC: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if msgTxtView.text.count > 0  && msgTxtView.text.count != 0 && !msgTxtView.text.isEmpty{
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

extension OtherCommentVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = textTableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as? CommentCell {
    
           
            cell.comment = comments[indexPath.row]
            cell.isMyPost = isMyPost
            cell.commentMode = .otherComment
            cell.delegate = self
            cell.moreOption.tag = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: Network Calls
extension OtherCommentVC {

    private func getPostDetail(postId: Int){
        
        postDetail(postId: postId) { (postModel, postType, error) in
            
            if let post = postModel {
                self.PostDataModel = post
                self.setUIData(post: post)
                
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    func getAllComments(postId: Int) {
        
        getComments(postId: postId) { (comments, error) in
            if let comment = comments {
                self.getPostDetail(postId: self.postId!)
                self.comments.removeAll()
                self.comments.append(contentsOf: comment)
                self.textTableView.reloadData()
                self.textTableView.isHidden = false
            }
            
            if let error = error {
                self.hideActivity()
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    func updateLikeStatus(action: String) {
        
        showActivity()
        updateLikeStatus(postId: postId!, action: action) { (success, error) in
            
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
            if let _ = success {
                var likeCount = Int(self.likeLbl.text!)
                if action == "like" {
                    likeCount! += 1
                    self.PostDataModel!.isPostLike = 1
                    self.likeImage.image = #imageLiteral(resourceName: "like_selected")
                    
                } else {
                    self.PostDataModel!.isPostLike = nil
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
                    self.getAllComments(postId: self.postId!)
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
                    self.getAllComments(postId: self.postId!)
                    self.mode = .create
                    self.msgTxtView.text = ""
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
extension OtherCommentVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}

extension OtherCommentVC: PostActionable {
    
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

extension OtherCommentVC {
    
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
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.25) {
            self.bottomConstant.constant = keyboardHeight <= 290 ? 290 : keyboardHeight - 90
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillDismiss(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomConstant.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: Share Custom Action
extension OtherCommentVC : BottomContentPickerDelegate {
        
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        guard let postDetail = PostDataModel else { return }
        shareContent(type: content, postType: .posts, postId: postDetail.id)
    }
    
    @objc func handleShare(_ sender: UIButton) {
        bottomShareSheet.presentView()
    }
}
