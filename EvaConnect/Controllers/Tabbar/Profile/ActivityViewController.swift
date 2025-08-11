//
//  ActivityViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 05/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
import AVKit

class ActivityViewController: UIViewController
{
    
    @IBOutlet weak var buttonBaseView: UIView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var reactionButton: UIButton!
    @IBOutlet weak var reactionTblVw: UITableView!
    @IBOutlet weak var noRecordLbl: UILabel!
    
    var Is_Reaction: Bool = false
    
    var stopAPICall  = false
    let pageSize = 10
    var articleContent: String?
    
    var posts: [DashboardItem] = [] {
        didSet {
            let count = posts.count
            if count > 0 {
                self.noRecordLbl.isHidden = true
            } else {
                self.noRecordLbl.isHidden = false
            }
            self.reactionTblVw.reloadData()
        }
    }
    
    var reactions: [ReactionData] = [] {
        didSet {
            let count = reactions.count
            if count > 0 {
                self.noRecordLbl.isHidden = true
            } else {
                self.noRecordLbl.isHidden = false
            }
            self.reactionTblVw.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onBackBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        self.noRecordLbl.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
//        self.isSeparatorHidden = true
        
        self.buttonBaseView.layer.cornerRadius = 8
        self.postButton.layer.cornerRadius = 8
        self.reactionButton.layer.cornerRadius = 8
        
        
        if self.Is_Reaction {
            self.onReactionBtnTapped(self.reactionButton)
        }
        else {
            self.onPostBtnTapped(self.postButton)
        }
        
        getPosts(offSet: 1)
        
//        self.postButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//        self.postButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//        self.reactionButton.backgroundColor = UIColor.clear
//        self.reactionButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)

        
        self.reactionTblVw.registerCells(withTypes: [ReactionTableViewCell.self])
        self.reactionTblVw.registerCells(withTypes: [TextViewCell.self,
                                            PostImageViewCell.self,
                                            PostDocumentCell.self])
        reactionTblVw.registerCells(withTypes: [HomeText.self, HomeImage.self, HomeVideo.self, HomeNewz.self, HomeUrl.self])

    }

    @IBAction func onPostBtnTapped(_ sender: UIButton) {
        self.getPosts(offSet: 1)
//        reactionTblVw.reloadData()
        self.postButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
        self.postButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.reactionButton.backgroundColor = UIColor.clear
        self.reactionButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.Is_Reaction = false
    }
    
    @IBAction func onReactionBtnTapped(_ sender: UIButton) {
        self.fetchRections()
//        reactionTblVw.reloadData()
        self.reactionButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
        self.reactionButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.postButton.backgroundColor = UIColor.clear
        self.postButton.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.Is_Reaction = true
    }

}

//MARK: API Calls

extension ActivityViewController {
    
    func getPosts(offSet: Int) {
        showActivity()
        let url = "\(EndPoints.getAllHomePost)?limit=\(pageSize)&offset=\(offSet)"
        print(url)

        let param: AFParameters = ["filter": "my_posts"] //

        NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<DashboardItemRoot>) in
            guard let self = self else { return }
            hideActivity()
            switch result {
            case .success(let post):
//                if post.data.isEmpty && self.posts.isEmpty {
//                    self.emptyListMessageLbl.text = self.searchEnabled ? "No result found" : "No result found"//post.message?.capitalized
//                    self.emptyListMessageLbl.isHidden = false
//                    return
//                }
                if post.message == "Account is Private" {
                    noRecordLbl.isHidden = true
                }

                if post.error == false {
                    if post.data?.count ?? 0 > 0 {
                        self.posts = post.data ?? []
                        noRecordLbl.isHidden = true
                    } else {
                        noRecordLbl.isHidden = false
                    }
                } else {
                    if post.data?.count ?? 0 > 0 {
                        self.posts = post.data ?? []
                        noRecordLbl.isHidden = true
                    } else {
                        noRecordLbl.isHidden = false
                    }
                }

            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
                
            default:
                break
            }
        }
    }
    
    func fetchRections(){
        showActivity()
        let params = ["limit": 10] as [String: Any]
        let url = EndPoints.reactions
        NetworkManagerr.request(url, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingRoot = try jsonDecoder.decode(ReactionsDataModel.self, from: response.data!)
                
                if !(meetingRoot.error!) {
                    if let data = meetingRoot.data {
                        self.reactions = data
                    }
                } else {
                    self.presentAlert("Failure", meetingRoot.message, nil)
                }
            } catch {
                print("Error: ",error)
            }
        }
    }
    
    func likePost(postId: Int, status: String, action: String, at: Int) {
        
        let param:Parameters = [
            "post_id" : postId,
            "created_by_id" :  myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
            "status":status,
            "action":action
        ]
        
        self.view.isUserInteractionEnabled = false
        ApiCallerClass.likePostServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? NSDictionary
            let error = data?["error"] as? Int
            self.hideActivity()
            if error == 0 {
                if self.Is_Reaction {
                    self.fetchRections()
                } else {
                    self.getPosts(offSet: 1)
                }
                let indexPath = IndexPath(item: at, section: 0)
                self.reactionTblVw.reloadRows(at: [indexPath], with: .none)
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.getPosts(offSet: 1)
                let indexPath = IndexPath(item: at, section: 0)
                self.reactionTblVw.reloadRows(at: [indexPath], with: .none)
                print(action)
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            self.hideActivity()
            print(action)
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Is_Reaction {
            return reactions.count
        } else {
            return posts.count
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let count = posts.count
//        if indexPath.row + 1 == count && !stopAPICall && count > 9 {
//            getPosts(offSet: indexPath.row + 1)
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Is_Reaction {
            let cell: ReactionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.descriptionBaseVw.layer.cornerRadius = 8.0
            cell.openVideoBtn.isHidden = true
            
            let obj = reactions[indexPath.row]
            
            if obj.type!.elementsEqual("post") {
                if obj.isPostLike == 0 {
                    cell.likeImgVw.image = UIImage(named: "Like")
                } else {
                    cell.likeImgVw.image = UIImage(named: "like_selected")
                }
            } else {   //news
                if obj.isNewsLike == 0 {
                    cell.likeImgVw.image = UIImage(named: "Like")
                } else {
                    cell.likeImgVw.image = UIImage(named: "like_selected")
                }
            }
            let Row = indexPath.row
            cell.likeBtn.tag = Row
            cell.commentBtn.tag = Row
            cell.shareBtn.tag = Row
            cell.openArticleBtn.tag = Row
            cell.gotoProfileBtn.tag = Row
            cell.gotoProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
            
            cell.likeBtn.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(addCommentOnPost(_:)), for: .touchUpInside)
            cell.openArticleBtn.addTarget(self, action: #selector(openDoc(_:)), for: .touchUpInside)
            
            if  obj.datumPostImage == [] && obj.postVideo == "" && obj.postDocument == "" {
                //==> Text Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"
                
//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content 
                cell.docView.isHidden = true
                cell.postImg.isHidden = true
                cell.videoView.isHidden = true
                cell.textView.isHidden = false
                return cell
                
            } 
            else if obj.postVideo != "" && obj.postDocument == "" && obj.datumPostImage == [] {
                //==> Video Cell...

                cell.openVideoBtn.isHidden = false
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                cell.docView.isHidden = true
                cell.postImg.isHidden = true
                cell.videoView.isHidden = false
                cell.textView.isHidden = true
                
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: obj.postVideo ?? "",ratio: .resize)
                cell.videoView.stop()
                
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.openVideoBtn.tag = indexPath.row

                return cell
                
            }
            else if obj.postDocument != "" && obj.datumPostImage == [] {
                //==> Document Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"
                cell.documentName.text = "\(obj.documentFileName ?? "")"
                cell.sizeLbl.text = "\(obj.documentSize ?? "")"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.docView.isHidden = false
                cell.postImg.isHidden = true
                cell.videoView.isHidden = true
                cell.textView.isHidden = true
                return cell
            } 
            else if obj.datumPostImage!.count > 0 {
                //==> Image Cell...
//                cell.reactedPersonImgView.kf.setImage(with: URL(string: obj.user?.userImage ?? ""))
                
                if obj.postLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postLike?[0].action
                    let userDetails = obj.postLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                else if obj.postComments?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postComments?[0].action
                    let userDetails = obj.postComments?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                } 
                else if obj.postCommentLike?.count ?? 0 > 0 {
                    cell.reactedPerName.text = obj.postCommentLike?[0].action
                    let userDetails = obj.postCommentLike?[0].userdetails
                    let userImg = userDetails?.userImage ?? ""
                    if userImg.elementsEqual("") {
                        cell.reactedPersonImgView.image = UIImage(named: "default_profile")
                    } else {
                        cell.reactedPersonImgView.kf.setImage(with: URL(string: userImg))
                    }
                    cell.postTitle.text = "\(obj.user?.firstName ?? "") \(obj.user?.lastName ?? "")"
                }
                
                cell.postTime.text = obj.createdDate ?? ""
                cell.likeCount.text = "\(obj.likeCount ?? 0)"
                cell.commentCount.text = "\(obj.commentCount ?? 0)"

//                cell.postTitle.text = obj.title
                cell.postContent.text = obj.content
                let img = obj.user?.userImage ?? ""
                if img.elementsEqual("") {
                    cell.postedPerImgVw.image = UIImage(named: "default_profile")
                } else {
                    cell.postedPerImgVw.kf.setImage(with: URL(string: img))
                }
                
                cell.docView.isHidden = true
                cell.postImg.isHidden = false
                cell.videoView.isHidden = true
                cell.textView.isHidden = true
                
                cell.setImages(imageUrl: obj.datumPostImage)
                
                return cell
            } else {
                return cell
            }
        }
        else {
            let homePost = posts[indexPath.row]
            if homePost.postVideo != "" && homePost.postVideo != nil {//Video
                let cell: HomeVideo = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.sharedBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.reportBtn.isHidden = true
                cell.uiData(dataMaper: homePost)
                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
                cell.openVideoBtn.tag = indexPath.row
                cell.openVideoBtn.isHidden = false
                cell.videoView.backgroundColor = .black
                cell.videoView.configure(url: homePost.postVideo ?? "",ratio: .resize)
                cell.videoView.stop()
                cell.videoView.isHidden = false
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                
                return cell
            }
            else if homePost.postDocuments?.count ?? 0 > 0 {//Document
                let cell: HomeUrl = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.sharedBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.uiData(homePost: homePost)
                cell.reportBtn.isHidden = true
                
                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }
            else if homePost.datumPostImage!.count > 0 {//Image
                let cell: HomeImage = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.shareButton.tag = indexPath.row
                cell.commentButton.tag = indexPath.row
                cell.likeButton.tag = indexPath.row
                cell.uiData(dataMaper: homePost)
                cell.reportBtn.isHidden = true
                
                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }
            else {//Text
                let cell: HomeText = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
                cell.detailsView.layer.cornerRadius = 13
                cell.delegate = self
                cell.shareBtn.tag = indexPath.row
                cell.commentBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.reportBtn.isHidden = true
                cell.uiData(dataMaper: homePost)

                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
                return cell
            }

//            if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" {
//                let cell: HomeText = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.detailsView.layer.cornerRadius = 13
//                cell.delegate = self
//                cell.shareBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.likeBtn.tag = indexPath.row
//                cell.reportBtn.isHidden = true
//                cell.uiData(dataMaper: homePost)
//                
//                
//                cell.shareBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                return cell
//                
//            } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] { //Video Cell
//                let cell: HomeVideo = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.delegate = self
//                cell.sharedBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.likeBtn.tag = indexPath.row
//                cell.reportBtn.isHidden = true
//                cell.uiData(dataMaper: homePost)
//                cell.openVideoBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
//                cell.openVideoBtn.tag = indexPath.row
//                cell.openVideoBtn.isHidden = false
//                cell.videoView.backgroundColor = .black
//                cell.videoView.configure(url: homePost.postVideo!,ratio: .resize)
//                cell.videoView.stop()
//                cell.videoView.isHidden = false
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                
////                cell.shouldSeeMore = { [weak self] index in self?.shouldSeeMoreLess(index: index) }
//                return cell
//                
//            } else if homePost.postDocument != "" && homePost.postImage == [] { //document Cell
//                let cell: HomeUrl = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.delegate = self
//                cell.sharedBtn.tag = indexPath.row
//                cell.commentBtn.tag = indexPath.row
//                cell.likeBtn.tag = indexPath.row
//                cell.uiData(homePost: homePost)
//                cell.reportBtn.isHidden = true
//                
//                cell.sharedBtn.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                return cell
//            } else if homePost.postImage!.count > 0 { //Image Cell
//
//                let cell: HomeImage = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                cell.delegate = self
//                cell.shareButton.tag = indexPath.row
//                cell.commentButton.tag = indexPath.row
//                cell.likeButton.tag = indexPath.row
//                cell.uiData(dataMaper: homePost)
//                cell.reportBtn.isHidden = true
//                
//                cell.shareButton.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
//                return cell
//            } else {
//                let cell: HomeText = reactionTblVw.dequeueReusableCell(forIndexPath: indexPath)
//                return cell
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.Is_Reaction {
//            return 451
//        } else {
            return UITableView.automaticDimension
//        }
    }
    
    
    @objc func showVideoView(sender: UIButton) {
        if Is_Reaction {
            let bindModelData = reactions[sender.tag]
            configureVideoView(getUrl: bindModelData.postVideo)
        } else {
            let bindModelData = posts[sender.tag]
            configureVideoView(getUrl: bindModelData.postVideo)
        }
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

}

// MARK: Post Actions Delegate
extension ActivityViewController: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
       switch action {
        case .like:
           self.showActivity()
           let post = posts[sender.tag]
           likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike", at: sender.tag)
        case .comment:
           goToCommentVC(index: sender.tag)
        case .article:
           articleContent = posts[sender.tag].postDocument
           openArticle()
        default:
//            shareItemIndex = sender.tag
           break
        }
    }
    
    private func goToCommentVC(index: Int) {
        
        let homePost = posts[index]
        if homePost.postVideo != "" && homePost.postVideo != nil {//Video
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.postDocuments?.count ?? 0 > 0 {//Document
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            navigationController?.pushViewController(vc, animated: true)
        } else if homePost.datumPostImage!.count > 0 {//Image
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            navigationController?.pushViewController(vc, animated: true)
        } else {//Text
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = homePost.id
            vc.dashboardItem = homePost
            navigationController?.pushViewController(vc, animated: true)
        }

//        if  homePost.postImage == [] && homePost.postVideo == "" && homePost.postDocument == "" { // && post.postDocument == nil
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .simpleText
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            navigationController?.pushViewController(vc, animated: true)
//        } else if homePost.postVideo != "" && homePost.postDocument == "" && homePost.postImage == [] {//Video
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .video
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            navigationController?.pushViewController(vc, animated: true)
//        } else if homePost.postDocument != "" && homePost.postImage == []{ //document Cell
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .article
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            navigationController?.pushViewController(vc, animated: true)
//        } else { // Image Cell
//            let vc = StoryboardRouter.textPostDetailVC()
//            vc.postType = .image
//            vc.postId = homePost.id
//            vc.dashboardItem = homePost
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}


extension ActivityViewController {
    
    @objc func openArticle() {
        if let urlString = articleContent, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            present(webVC, animated: true, completion: nil)
        }
    }
    
    @objc func handleShare(_ sender: UIButton) {
        if Is_Reaction {
            let post = reactions[sender.tag]
            tabBarController?.tabBar.isHidden = true
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
            vc.objectId = post.id ?? 0
            vc.type = .post
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        } else {
            let post = posts[sender.tag]
            tabBarController?.tabBar.isHidden = true
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
            vc.objectId = post.id ?? 0
            vc.type = post.type ?? .post
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        }
    }
    
    @objc func handleLike(_ sender: UIButton) {
        let post = reactions[sender.tag]
        
        likePost(postId: post.id ?? 0, status: post.status ?? "", action: post.isPostLike == 0 ? "like" : "unlike" , at: sender.tag)
    }
    
    @objc func openDoc(_ sender: UIButton) {
        let obj = reactions[sender.tag]
        articleContent = obj.postDocument
        openArticle()
    }
    
    @objc func goToProfileTapped(_ sender: UIButton) {
        let reaction = reactions[sender.tag]
        let id = reaction.user?.id
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
    
    @objc func addCommentOnPost(_ sender: UIButton) {
        let index = sender.tag
        let obj = reactions[index]
        
        if  obj.datumPostImage == [] && obj.postVideo == "" && obj.postDocument == "" { // && post.postDocument == nil
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .simpleText
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else if obj.postVideo != "" && obj.postDocument == "" && obj.datumPostImage == [] {
            //==> Video Cell...
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .video
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        } else if obj.postDocument != "" && obj.datumPostImage == [] { //document Cell
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .article
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        }  else if obj.datumPostImage!.count > 0 {
            let vc = StoryboardRouter.textPostDetailVC()
            vc.postType = .image
            vc.postId = obj.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
