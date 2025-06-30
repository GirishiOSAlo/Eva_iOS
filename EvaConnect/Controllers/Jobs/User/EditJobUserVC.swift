//
//  editJobUserPostVC.swift
//  EvaConnect
//
//  Created by Metis on 10/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class EditJobUserVC: BaseVC {
    
    //MARK: OutLets
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet var boderView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentView: UIView!

    //MARK: Variables
    
    var jobId: Int!
    var jobDetail: ShowJobDetailModel?
    weak var delegate: RefreshUpdateable?
    var comments: [Comments] = []
    var navigationType: JobNavigationType = .onlyDetail
    var mode: PostLoadingMode = .create
    var senderButton = UIButton()
    var isMyPost = false
    
    enum JobNavigationType {
        case onlyDetail, comments
    }
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
        showJobDetail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let jobApply = segue.destination as? JobApplyVC, let jobDetail = sender as? ShowJobDetailModel {
              jobApply.jobDetail = jobDetail
              jobApply.delegate = self
          }
      }
}

// MARK: IB Actions
extension EditJobUserVC {
    
    @IBAction func likePost(_ sender: UIButton) {
        
        view.isUserInteractionEnabled = false
        let bindModelData = jobDetail
        
        if bindModelData?.isJobLike == nil || bindModelData?.isJobLike == 1{
            
            updateLikeStatus(action: "unlike")
            
        } else {
            updateLikeStatus(action: "like")
        }
    }
    
    @IBAction func openEditVCAction(_ sender: Any) {
        if jobDetail?.isApplied != 0 {
            makeAlert(titleMsg: "Info", messageData: "You have already applied for this post")
        } else {
            let storyboard = UIStoryboard(name: "Jobs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "JobApplyVC") as! JobApplyVC
            vc.jobDetail = jobDetail!
            self.navigationController?.pushViewController(vc, animated: true)
            //self.performSegue(withIdentifier: Constants.Segues.jobApply, sender: jobDetail)
        }
    }
    
    @IBAction func sendComment_touchUpInside(_ sender: UIButton) {
        view.isUserInteractionEnabled = false
        commentTextView.resignFirstResponder()
        if !commentTextView.text.isEmpty {
            if mode == .edit {
                self.updateComment(content: commentTextView!.text!, sender: senderButton)
            } else{
                addComments()
            }
            
            // commentTextView.text = ""
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        delegate?.refresh(homeStatus: false)
        navigationController?.popViewController(animated: true)
    }
}

extension EditJobUserVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Chat.reply
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: Network Calls
extension EditJobUserVC {
    
    private func showJobDetail() {
     
           let endPoint = EndPoints.showJobDetailById + "\(jobId!)"
           let parameters: AFParameters = ["user_id": myUserDefaults.userId] //LoggedUserDetails.shared.user!.id]
           
           self.showActivity()
           NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { (response) in
               
               self.hideActivity()
               if response.result.isSuccess {
                   do {
                       let jsonDecoder = JSONDecoder()
                       let jobDetailsRoot = try jsonDecoder.decode(AllShowJobDetail.self, from:response.data!)
                       
                       if !jobDetailsRoot.error, jobDetailsRoot.data.count > 0 {
                           
                           let jobDetailModel = jobDetailsRoot.data[0]
                           self.jobDetail = jobDetailModel
                            self.updateUI(jobDetail: jobDetailModel)
                       }
                   } catch {
                       self.presentAlert("failure", nil, error)
                   }
               }
           }
       }
    
    private func updateLikeStatus(action: String) {
        
        let parameters: AFParameters = [ "job_id" : jobId!,
                                       "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                       "status": "active",
                                       "action": action ]
        
        NetworkManagerr.request(EndPoints.jobLikePost, method: .post, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        self.showJobDetail()
                    }
                    
                } catch {
                    self.presentAlert("failure", nil, error)

                }
            }
        }
    }
    
    func addComments() {
        
        let parameters: AFParameters = [ "job_id": jobId!,
                                         "created_by_id" :  myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "status": "pending",
                                         "content": commentTextView.text.encodeEmoji ]
        
        NetworkManagerr.request(EndPoints.postJobComment, method: .post, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        //self.presentAlert("Success", "Comment Successfully posted", nil)
                        self.commentTextView.text = Constants.Chat.reply
                        self.commentTextView.textColor = UIColor.lightGray
                        self.getComments()
                    }
                } catch {
                    self.presentAlert("failure", nil, error)
                }
            } else {
                self.presentAlert("failure", nil, response.result.error)
            }
        }
    }
    func updateComment(content: String, sender: UIButton) {
        let commentId = comments[sender.tag].id
        let parameters: AFParameters = [ "content": content,
                                         "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        let url = "\(EndPoints.updateJobComment)\(commentId)/"
        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
            self.view.isUserInteractionEnabled = true
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                //IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.commentTextView.text = Constants.Chat.reply
                    self.commentTextView.textColor = UIColor.lightGray
                    self.getComments()
                    
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
    func deleteComment(content: String, sender: UIButton) {
        let commentId = comments[sender.tag].id
      
        let url = "\(EndPoints.deleteJobComment)\(commentId)/"
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
                    self.getComments()
                    self.mode = .create
                    self.commentTextView.text = ""
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
    
    func getComments() {
        
        let parameters: AFParameters = ["job_id": jobId!]
        //showActivity()
        NetworkManagerr.request(EndPoints.getJobComment, method: .post, parameters: parameters) { (response) in
            
           // self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentsRoot = try jsonDecoder.decode(CommentDetailRoot.self, from: response.data!)
                    if commentsRoot.error == false {
                        self.comments = commentsRoot.data
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        self.showJobDetail()
                    }
                } catch {
                    self.presentAlert("failure", nil, error)
                }
            } else {
                self.presentAlert("failure", nil, response.result.error)
            }
        }
    }
}
    
//MARK: UI Updates
extension EditJobUserVC {

    func setLayout() {
                
        content.font = UIFont(defaultFontStyle: .regular, size: 12.0)
        likeButton.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 11.0)
        commentButton.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 11.0)
        shareButton.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 11.0)
        applyBtn.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 12.0)
        applyBtn.layer.cornerRadius = applyBtn.frame.height / 2
        applyBtn.applyGradient(colors: [AppColors.blueHigherGradient.cgColor,
                                        AppColors.lowerGradient.cgColor,
                                        AppColors.higherGradient.cgColor,
                                        AppColors.lowestGradient.cgColor])
        applyBtn.roundOnly()
        makeImageRound(view: userProfileImage, setBoader: true)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
        
        if navigationType == .comments {
            applyBtn.isHidden = true
            commentView.isHidden = false
            tableView.dataSource = self
            tableView.registerCell(withType: CommentCell.self)
            commentTextView.textColor = .lightGray
            commentTextView.text = Constants.Chat.reply
            commentTextView.delegate = self
            commentTextView.contentInset = UIEdgeInsets(top: -5, left: 2, bottom: 2, right: 2)
            commentTextView.textContainerInset = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 10)
            getComments()

        }
        
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }
    
    func updateUI(jobDetail: ShowJobDetailModel) {
        
        content.text = jobDetail.content
        userName.text = jobDetail.jobNature
        positionLbl.text = jobDetail.jobTitle
        locationLbl.text = jobDetail.location
        salaryLbl.text = "£ \(jobDetail.salary ?? 0) pa"
        hoursLbl.text = "active for  \(jobDetail.activeHours ?? 0) days"
        userProfileImage.sd_setImage(with: URL(string: (jobDetail.jobImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        
        likeImage.image = jobDetail.isJobLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like")
        //    applyBtn.isHidden = LoggedUserDetails.shared.user?.id == jobDetail.userID
        if navigationType != .comments {
            if LoggedUserDetails.shared.user?.type == "user"{
                applyBtn.isHidden = false
                view.sendSubviewToBack(tableView)
                
            }
            else {
                applyBtn.isHidden = true
                view.bringSubviewToFront(tableView)
            }
        }
        myPost(detail: jobDetail)
    }
    func myPost(detail: ShowJobDetailModel?) {
        
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
    
    @objc func handleShare(){
        guard let jobDetails = jobDetail else {
            return
        }
        openShareVC(id: jobDetails.id, type: .job)
    }
}

extension EditJobUserVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as? CommentCell {
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

extension EditJobUserVC: RefreshUpdateable {

    func refresh(homeStatus: Bool) {
        showJobDetail()
    }
}
extension EditJobUserVC: PostActionable {
    
    func actionType(sender: UIButton, action: HomeCellAcitonType) {
        
       
        
        switch action {
        case .edit:
            commentTextView.becomeFirstResponder()
            commentTextView.text = comments[sender.tag].content
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
