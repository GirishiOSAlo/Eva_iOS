//
//  HomeCell.swift
//  EvaConnect
//
//  Created by Metis on 17/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
import ImageSlideshow
//import URLEmbeddedView

class HomeText: BaseCellClass {
    
    //MARK: Outlets
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var commentValueLbl: UILabel!
    @IBOutlet weak var likeValueLbl: UILabel!
    @IBOutlet weak var postMsgLbl: UILabel!
    
    @IBOutlet weak var shareValueLbl: UILabel!
    @IBOutlet weak var connectionNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet var boderView: UIView!
    @IBOutlet weak var isConnectedBtn: UIButton!
    @IBOutlet weak var openProfile: UIView!
    @IBOutlet weak var moreOption: UIButton!
    @IBOutlet weak var likeShareUIView: UIView!
    @IBOutlet weak var goToProfileBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
//    let embeddedView = URLEmbeddedView()
    var checkForMultipleImages : Bool = false
    var imageArray=[String]()
    
    var delegate: PostActionable?
    var isMoreViewSelected = true

    var isExpanded = false
    var expandButtonTapped: (() -> Void)?
    
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
        
        
        followBtn.layer.cornerRadius = 12
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        makeImageRound(view: profileImage)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.loginByNew, boderValue: 2.0)
        isConnectedBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
        
        self.backgroundColor = .clear
        self.detailsView.layer.cornerRadius = 20.0
//        self.detailsView.dropShadow()
    }
    
    override func prepareForReuse() {
        
    }

    func uiData(dataMaper: DashboardItem) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        connectionNameLbl.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""
        dateLbl.text = dataMaper.createdDate
        likeValueLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentValueLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareValueLbl.text = "\(dataMaper.shareCount ?? 0)"
        
        if dataMaper.isPostLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        }
        else {
            likeImage.image = #imageLiteral(resourceName: "Like")
        }
        if dataMaper.user?.userImage != nil {
           profileImage.sd_setImage(with: URL(string: dataMaper.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "eventPlaceholder"), options: .progressiveLoad, completed: .none)
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "noImage")
        }
        actualString = dataMaper.content ?? ""
        configure(with: actualString)
    }
    
    func setData(data: DashboardPostData) {
        let userid = data.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        
        self.connectionNameLbl.text = data.user?.firstName ?? data.user?.companyName ?? ""
        self.dateLbl.text = data.createdDate ?? ""
        self.likeValueLbl.text = "\(data.likeCount ?? 0)"
        self.commentValueLbl.text = "\(data.commentCount ?? 0)"
        self.shareValueLbl.text = "\(data.shareCount ?? 0)"
        
        if data.isPostLike == 1 {
            self.likeImage.image = UIImage(named: "like_selected")
        } else {
            self.likeImage.image = UIImage(named: "ic_like")
        }
        
//        if let imageUrl = data.user?.userImage,
//           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
//           let url = URL(string: imageUrl),
//           UIApplication.shared.canOpenURL(url) {
//            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
//        } else {
//            profileImage.image = UIImage(named: "profile")
//        }
        if data.user?.userImage != nil {
           profileImage.sd_setImage(with: URL(string: data.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
        actualString = data.content ?? ""
        configure(with: actualString)
    }
    
    
    func uiData(dataMaper: SearchPost) {
        let userid = Int(dataMaper.userID ?? "")
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        connectionNameLbl.text = dataMaper.userName ?? ""
        dateLbl.text = dataMaper.createdDatetime
        likeValueLbl.text = "\(dataMaper.count?.likeCount ?? "")"
        commentValueLbl.text = "\(dataMaper.count?.commentCount ?? "")"
        shareValueLbl.text = "\(dataMaper.count?.shareCount ?? "")"

        if dataMaper.userImage != nil {
           profileImage.sd_setImage(with: URL(string: dataMaper.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
        
        postMsgLbl.text = dataMaper.content
        detailsView.layer.cornerRadius = 13
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
}



extension HomeText {
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

extension HomeText: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
