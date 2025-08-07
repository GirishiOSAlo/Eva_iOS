//
//  HomeVideo.swift
//  EvaConnect
//
//  Created by Metis on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
import ImageSlideshow


class HomeVideo: BaseCellClass {
    
//MARK: -Outlets
    @IBOutlet weak var commentValueLbl: UILabel!
    @IBOutlet weak var likeValueLbl: UILabel!
    @IBOutlet weak var postMsgLbl: UILabel!
    @IBOutlet weak var connectionNameLbl: UILabel!
    @IBOutlet weak var shareValueLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var openVideoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet var boderView: UIView!
    @IBOutlet weak var isConnectedBtn: UIButton!
    @IBOutlet weak var likeShareUiView: UIView!
    @IBOutlet weak var goToProfileBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    var checkForMultipleImages : Bool = false
    var imageArray=[String]()
    
    var delegate: PostActionable?
    var editPostView: EditDeleteView?
    var isMoreViewSelected = true
    
    let maxCharactersToShow = 100
    var isFullTextVisible = false
    var actualString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        connectionNameLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        dateLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        postMsgLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        likeValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        commentValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        shareValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        mainView.layer.cornerRadius = 20.0
        //mainView.dropShadow()
        followBtn.layer.cornerRadius = 12
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.loginByNew, boderValue: 2.0)
        makeImageRound(view: profileImage)
        isConnectedBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
    }
    
    func uiData(dataMaper: DashboardItem) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        if dataMaper.user?.userImage != nil {
            profileImage.sd_setImage(with: URL(string: dataMaper.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else { profileImage.image = #imageLiteral(resourceName: "profile") }
        
        connectionNameLbl.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""
        dateLbl.text = dataMaper.createdDate

        
        likeValueLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentValueLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareValueLbl.text = "\(dataMaper.shareCount ?? 0)"
        postMsgLbl.text = dataMaper.content
        if dataMaper.isPostLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        }
        else {
            likeImage.image = #imageLiteral(resourceName: "Like")
        }
        actualString = dataMaper.content ?? ""
        configure(with: actualString)
    }
    
    func setData(dataMaper: DashboardPostData) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        
        if let imageUrl = dataMaper.user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImage.image = UIImage(named: "profile")
        }
        connectionNameLbl.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""
        dateLbl.text = dataMaper.createdDate
        
        likeValueLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentValueLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareValueLbl.text = "\(dataMaper.shareCount ?? 0)"
        postMsgLbl.text = dataMaper.content
        
        if dataMaper.isPostLike == 1 {
            self.likeImage.image = UIImage(named: "like_selected")
        } else {
            self.likeImage.image = UIImage(named: "ic_like")
        }
        actualString = dataMaper.content ?? ""
        configure(with: actualString)
    }
    
    func uiData(dataMaper: SearchPost) {
        let userid = Int(dataMaper.userID ?? "")
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        if dataMaper.userImage != nil {
            profileImage.sd_setImage(with: URL(string: dataMaper.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else { profileImage.image = #imageLiteral(resourceName: "profile") }

        
        connectionNameLbl.text = dataMaper.userName
        dateLbl.text = dataMaper.createdDatetime
        
        likeValueLbl.text = "\(dataMaper.count?.likeCount ?? "")"
        commentValueLbl.text = "\(dataMaper.count?.commentCount ?? "")"
        shareValueLbl.text = "\(dataMaper.count?.shareCount ?? "")"

        actualString = dataMaper.content ?? ""
        configure(with: actualString)
    }
    
    func configure(with content: String) {
        postMsgLbl.attributedText = Constants.truncateContent(content)

        // Add tap gesture recognizer to the label
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        postMsgLbl.isUserInteractionEnabled = true
        postMsgLbl.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func labelTapped() {
        isFullTextVisible.toggle()
        if isFullTextVisible {
            postMsgLbl.text = actualString
        } else {
            postMsgLbl.attributedText = Constants.truncateContent(actualString)
        }

        // Notify the table view to update the cell's height
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func configureConnectedStatus(dataMaper: DashboardItem)-> ButtonStatus {
        if dataMaper.isConnected! == "not_connected" {
            //Not Connected
            isConnectedBtn.setTitle("Connect", for: .normal)
            return .createConnect
        }
        if dataMaper.isConnected! == "not_connected"  && dataMaper.isReceiver == "false" {
            //Not Connected
            isConnectedBtn.setTitle("Connect", for: .normal)
            return .createConnect
        }
        else if dataMaper.isConnected! == "pending" && dataMaper.isReceiver == "false" {
            //Pending
            isConnectedBtn.setTitle("Pending", for: .normal)
            return .none
        }
        else if dataMaper.isConnected! == "pending" && dataMaper.isReceiver == "true" {
            //Accept
            isConnectedBtn.setTitle("Accept", for: .normal)
            return .accept
        }
        else if dataMaper.isConnected! == "active" {
            //Connected
            isConnectedBtn.setTitle("Connected", for: .normal)
            return .connected
        }
        //isConnectedBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        isConnectedBtn.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        isConnectedBtn.applyGradient(colors: [UIColor.clear.cgColor,UIColor.clear.cgColor])
        return .none
    }
    
    override func prepareForReuse() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension HomeVideo {
    @IBAction func like_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .like)
    }
    
    @IBAction func comment_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .comment)
    }
    
    @IBAction func share_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .share)
    }
}

extension HomeVideo: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

enum ButtonStatus {
    case createConnect ,none ,accept ,connected
}
extension HomeVideo: EditDeleteViewDelegate {
    
   @objc func openMoreOption(){
       
       print(isMoreViewSelected)
       
       if isMoreViewSelected == true{
//           configurePostView()
          EditDeleteHandler.sharedInstance.showMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = false
           print(isMoreViewSelected)
       } else {
           //editPostView?.removeFromSuperview()
           EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = true
       }
  
   }
    
//   private func configurePostView() {
//
//    editPostView = EditDeleteHandler.sharedInstance.createEditDeleteMenu(content: contentView, moreOption: moreOption, caller: HomeVideo.self, isMyComment: true, buttonType: .post)
//    editPostView?.delegate = self
//
//   }
    
    func delegateAction(_ navigator: EditDeleteView, type: OptionType) {
//        if type == .editPost{
//            delegate?.actionType(sender: moreOption, action: .edit)
//
//        }
//        else{
//            delegate?.actionType(sender: moreOption, action: .delete)
//        }
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
        isMoreViewSelected = true
    }
}
