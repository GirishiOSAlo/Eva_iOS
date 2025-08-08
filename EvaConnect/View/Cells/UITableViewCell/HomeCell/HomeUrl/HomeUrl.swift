
//  HomeUrl.swift
//  EvaConnect
//
//  Created by Metis on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
//import IHProgressHUD
//import URLEmbeddedView

class HomeUrl: BaseCellClass {
    
    //MARK: Outlets
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var commentValueLbl: UILabel!
    @IBOutlet weak var likeValueLbl: UILabel!
    @IBOutlet weak var connectionNameLbl: UILabel!
    @IBOutlet weak var shareValueLbl: UILabel!
    @IBOutlet weak var docImgUiView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var agoLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var urlText: UILabel!
    @IBOutlet weak var openArticleBtn: UIButton!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var documentSizeLbl: UILabel!
    @IBOutlet weak var likeShareUiView: UIView!
    @IBOutlet weak var goToProfileBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate: PostActionable?
    var isMoreViewSelected = true
    var didTapURL: ((URL) -> Void)? = nil
    
    let maxCharactersToShow = 100
    var isFullTextVisible = false
    var actualString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        connectionNameLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        timeLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        urlText.font = UIFont(name: Myfonts.regular, size: 14.0)
        likeValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        commentValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        shareValueLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        followBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1, radius: 12)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        boderView.makeRoundView(boderColor: UIColor(hex: "#5894DD") ,boderValue: 1.5) 
        makeImageRound(view: profileImage)
        mainView.layer.cornerRadius = 20.0
        mainView.clipsToBounds = true
//        mainView.dropShadow()
        documentName.font = UIFont(name: Myfonts.semiBold, size: 16)
        documentSizeLbl.font = UIFont(name: Myfonts.regular, size: 14)
        urlText.font = UIFont(name: Myfonts.regular, size: 14)
    }
    
    func uiData(homePost: DashboardItem) {
        let userid = homePost.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        connectionNameLbl.text = homePost.user?.firstName ?? homePost.user?.companyName ?? ""

        agoLbl.text = homePost.createdDatetime
        likeValueLbl.text = "\(homePost.likeCount ?? 0)"
        commentValueLbl.text = "\(homePost.commentCount ?? 0)"
        shareValueLbl.text = "\(homePost.shareCount ?? 0)"
        
        if let imageUrl = homePost.user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImage.image = UIImage(named: "profile")
        }

        if homePost.isPostLike == 1 {
            self.likeImage.image = UIImage(named: "like_selected")
        } else {
            self.likeImage.image = UIImage(named: "ic_like")
        }
        
        documentName.text = "No Name"
        documentSizeLbl.text = "0 kB"
        
        actualString = homePost.content ?? ""
        configure(with: actualString)
    }
    
    func setData(dataMaper: DashboardPostData) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        
        connectionNameLbl.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""

        agoLbl.text = dataMaper.createdDatetime
        likeValueLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentValueLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareValueLbl.text = "\(dataMaper.shareCount ?? 0)"
        
        if let imageUrl = dataMaper.user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImage.image = UIImage(named: "profile")
        }
        
        if dataMaper.isPostLike == 1 {
            self.likeImage.image = UIImage(named: "like_selected")
        } else {
            self.likeImage.image = UIImage(named: "ic_like")
        }
        
        let docName = dataMaper.documentFileName ?? ""
        if docName == "" {
            documentName.text = "No Name"
        } else {
            documentName.text = dataMaper.postDocument
        }
        //documentName.text = dataMaper.postDocument ?? "No Name"
        documentSizeLbl.text = "\(dataMaper.documentSize ?? "0") kB"
        
        actualString = dataMaper.content ?? ""
        configure(with: actualString)
    }
    
    func uiData(post: SearchPost) {
        let userid = Int(post.userID ?? "")
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        connectionNameLbl.text = post.userName
        agoLbl.text = post.createdDatetime//!.components(separatedBy: " ").last ?? "" : "at \(time)"


        if post.userImage != nil {
            profileImage.sd_setImage(with: URL(string: post.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
        
        urlText.text = "\(post.content ?? "")"
        documentName.text = post.fileDocumentName ?? "No Name"
        documentSizeLbl.text = "\(post.postDocumentSize ?? "")kB"
    }
    
    func configure(with content: String) {
        urlText.attributedText = Constants.truncateContent(content)

        // Add tap gesture recognizer to the label
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        urlText.isUserInteractionEnabled = true
        urlText.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func labelTapped() {
        isFullTextVisible.toggle()
        if isFullTextVisible {
            urlText.text = actualString
        } else {
            urlText.attributedText = Constants.truncateContent(actualString)
        }

        // Notify the table view to update the cell's height
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}

extension HomeUrl {
    
    @IBAction func like_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .like)
    }
    
    @IBAction func comment_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .comment)
    }
    
    @IBAction func share_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .share)
    }
    @IBAction func article_touchUpInside(_ sender: UIButton) {
         delegate?.actionType(sender: sender, action: .article)
     }
    
}


extension HomeUrl: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

//extension HomeUrl: WKUIDelegate {
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//    }
//
//}

//extension HomeUrl: EditDeleteViewDelegate {
    
//   @objc func openMoreOption(){
//
//       print(isMoreViewSelected)
//
//       if isMoreViewSelected == true{
////           configurePostView()
//           EditDeleteHandler.sharedInstance.showMenu(xibOnView: editPostView ?? UIView())
//           isMoreViewSelected = false
//           print(isMoreViewSelected)
//       } else {
//           //editPostView?.removeFromSuperview()
//           EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
//           isMoreViewSelected = true
//       }
//
//   }
    
//   private func configurePostView() {
//
//    editPostView = EditDeleteHandler.sharedInstance.createEditDeleteMenu(content: contentView, moreOption: moreOption, caller: HomeUrl.self, isMyComment: true, buttonType: .post)
//    editPostView?.delegate = self
//   }
    
//    func delegateAction(_ navigator: EditDeleteView, type: OptionType) {
////        if type == .editPost{
////            delegate?.actionType(sender: moreOption, action: .edit)
////
////        }
////        else{
////            delegate?.actionType(sender: moreOption, action: .delete)
////        }
//        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
//        isMoreViewSelected = true
//    }
    
//}
