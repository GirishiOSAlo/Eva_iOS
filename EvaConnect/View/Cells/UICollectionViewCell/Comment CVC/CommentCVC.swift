//
//  CommentCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 13/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol CommentsCellDelegate: AnyObject {
    func didTapDropdownButton(in cell: CommentCVC)
    func didTapReplyLikeButton(replyComment: RepliesComment, isComeFromNews: Bool)
    func didTapReplyDislikeButton(replyComment: RepliesComment, isComeFromNews: Bool)
    func didTapReplyButton(replyComment: RepliesComment, isComeFromNews: Bool)
    //func didTapMoreButton(replyComment: RepliesComment, isComeFromNews: Bool)
    func didTapMoreButton(in cell: CommentCVC, sender: UIButton, replyComment: RepliesComment, isComeFromNews: Bool)
}

class CommentCVC: UICollectionViewCell {

    @IBOutlet weak var treadView: UIView!
    @IBOutlet weak var treadVwWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var treadVericalLine: UIView!
    @IBOutlet weak var treadLineVw: UIView!
    @IBOutlet weak var treadCurveLineVw: UIView!
    @IBOutlet weak var treadCurveLineBaseVw: UIView!
    
    
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var replyBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var viewReplyBtn: UIButton!
    
    weak var delegate: CommentsCellDelegate?
    @IBOutlet weak var insideRepliesCollectionVw: UICollectionView!
    @IBOutlet weak var insideRepliesCollectionVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewReplyBtnVwHeight: NSLayoutConstraint!
    var isComeFromNews:Bool = false
    
    var isExpanded: Bool = false {
        didSet {
            if self.replies.count > 0 {
                let btnTitle = isExpanded ? "Hide Replies" : "View \(self.replies.count) More Replies"
                viewReplyBtn.setTitle(btnTitle, for: .normal)
            } else {
                viewReplyBtn.setTitle("", for: .normal)
            }
        }
    }
    
    var replies: [RepliesComment] = [] {
        didSet {
            insideRepliesCollectionVw.reloadData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        roundCorners(view: self.treadCurveLineVw, corners: [.bottomLeft], radius: 12)
        roundCorners(view: self.treadCurveLineBaseVw, corners: [.bottomLeft], radius: 12)
        
        self.profileImgVw.layer.cornerRadius = self.profileImgVw.frame.size.width / 2
        nameLbl.font = UIFont(name: Myfonts.bold, size: 12.0)
        timeLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        descLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        likeBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 12.0)
        dislikeBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 12.0)
        replyBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 12.0)
        viewReplyBtn.titleLabel?.font = UIFont(name: Myfonts.bold, size: 12.0)
        
        insideRepliesCollectionVw.registerNib(cellNib: CommentCVC.self)
        insideRepliesCollectionVw.delegate = self
        insideRepliesCollectionVw.dataSource = self
    }
        
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        delegate?.didTapDropdownButton(in: self)
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
    
    //--> Reply Comment Like & Dislike...
    @objc func replyLikeTapped(_ sender: UIButton) {
//        if self.isComeFromNews {
            let reply = self.replies[sender.tag]
            delegate?.didTapReplyLikeButton(replyComment: reply, isComeFromNews: self.isComeFromNews)
//        }
    }

    @objc func replyDislikeTapped(_ sender: UIButton) {
//        if self.isComeFromNews {
            let reply = self.replies[sender.tag]
            delegate?.didTapReplyDislikeButton(replyComment: reply, isComeFromNews: self.isComeFromNews)
//        }
    }
    
    @objc func replyTapped(_ sender: UIButton) {
//        if self.isComeFromNews {
            let reply = self.replies[sender.tag]
            delegate?.didTapReplyButton(replyComment: reply, isComeFromNews: self.isComeFromNews)
//        } 
    }
    
    @objc func moreTapped(_ sender: UIButton) {
        let reply = self.replies[sender.tag]
        delegate?.didTapMoreButton(in: self, sender: sender, replyComment: reply, isComeFromNews: self.isComeFromNews)
    }
    
}

//MARK: UICollection Delegate & DataSource....
extension CommentCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.insideRepliesCollectionVw.dequeueReusableCell(withReuseIdentifier: CommentCVC.ReuseId, for: indexPath) as! CommentCVC
        
        cell.viewReplyBtnVwHeight.constant = 0.0
        cell.treadVwWidth.constant = 40.0
        cell.treadVericalLine.isHidden = true
        
//        let isFirst = indexPath.item == 0
//        let isLast = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
//        if isFirst && isLast {
//            // Only one item
//            cell.treadLineVw.isHidden = true
//        } else if isFirst {
//            // First item
//            cell.treadLineVw.isHidden = false
//        } else if isLast {
//            // Last item
//            cell.treadLineVw.isHidden = true
//        } else {
//            cell.treadLineVw.isHidden = false
//        }
        
        if replies.count == 1 {
            cell.treadLineVw.isHidden = true
        } else {
            if indexPath.row == replies.count - 1 {
                cell.treadLineVw.isHidden = true
            } else {
                cell.treadLineVw.isHidden = false
            }
        }
        
        
        let reply = replies[indexPath.row]
        cell.descLbl.text = reply.content
        cell.timeLbl.text = reply.createdDate
        cell.replyBtnWidth.constant = 0.0//45.0
        
        let user = reply.user
        cell.nameLbl.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        if let imageUrl = user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            cell.profileImgVw.image = UIImage(named: "profile")
        }
        
        cell.likeBtn.setTitle("\(reply.likeCount ?? 0)", for: .normal) //Comment Like Count...
        let commentLike = reply.isCommentLike ?? 0
        if commentLike == 1 {
            cell.likeBtn.setImage(UIImage(named: "ic_commentLikeFill"), for: .normal)
        } else {
            cell.likeBtn.setImage(UIImage(named: "ic_commentLike"), for: .normal)
        }
        
        let commentDislike = reply.isCommentDisLike ?? 0
        cell.dislikeBtn.setTitle("\(reply.dislikeCount ?? 0)", for: .normal) //Comment Dislike Count...
        if commentDislike == 1 {
            cell.dislikeBtn.setImage(UIImage(named: "ic_commentDisliikeFill"), for: .normal)
        } else {
            cell.dislikeBtn.setImage(UIImage(named: "ic_commentDislike"), for: .normal)
        }
        
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(replyLikeTapped(_:)), for: .touchUpInside)
        cell.dislikeBtn.tag = indexPath.row
        cell.dislikeBtn.addTarget(self, action: #selector(replyDislikeTapped(_:)), for: .touchUpInside)
        cell.replyBtn.tag = indexPath.row
        cell.replyBtn.addTarget(self, action: #selector(replyTapped(_:)), for: .touchUpInside)
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //-->Normal height
        let reply = replies[indexPath.row]
        let lblHeight = self.heightForView(text: reply.content ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.insideRepliesCollectionVw.frame.width - 184.0)
        let cellHeight = lblHeight + 100.0
        return CGSize(width: self.insideRepliesCollectionVw.frame.size.width, height: cellHeight)
    }
}
