//
//  CommentCell.swift
//  EvaConnect
//
//  Created by Metis on 14/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
class CommentCell: BaseCellClass {
    
   //MARK: OutLets
    @IBOutlet weak var mainUIView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var goback: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mainLikeView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var moreOption: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var goToProfileBtn: UIButton!
    
    
    
    
    var isMyPost: Bool = false
    var isMyComment: Bool = false
    
    var commentMode: CommentType = .otherComment {
        didSet {
            if commentMode == .otherComment {
                if isMyPost == true {
                    
                    if myUserDefaults.userId == comment.user.id {
                        
                        isMyComment = true
                        moreOption.isHidden = false
                        moreOption.addTarget(self, action: #selector(openMoreOption), for: .touchUpInside)
                    } else {
                        isMyComment = false
                        moreOption.isHidden = false
                        moreOption.addTarget(self, action: #selector(openMoreOption), for: .touchUpInside)
                    }
                } else {
                   
                    if myUserDefaults.userId == comment.user.id {
                        
                        isMyComment = true
                        moreOption.isHidden = false
                        moreOption.addTarget(self, action: #selector(openMoreOption), for: .touchUpInside)
                    }
       
                    
                }
                
                if comment.isCommentLike == 1 {
                    likeImgView.image = #imageLiteral(resourceName: "like_selected")
                } else {
                    likeImgView.image = #imageLiteral(resourceName: "LikeComment")
                }
                
                likeCountLbl.text = "\(comment.likeCount ?? 0)"

                print(comment.content?.decodeEmoji ?? "")
                let msgLabel = comment.content?.decodeEmoji.trimmingCharacters(in: .whitespacesAndNewlines)
                msgLbl.text = msgLabel
                userNameLbl.text = comment.user.firstName
                dayLbl.text = "\(comment.createdDate ?? "")"//"\(comment.time) | \(comment.createdDatetime.dateOnly())"
                if !(comment.user.userImage?.isEmpty ?? false ) {
                    profileImage!.sd_setImage(with: URL(string: comment.user.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .continueInBackground, completed: .none)
                } else {
                    profileImage!.image = #imageLiteral(resourceName: "noImage")
                }
            }
            else {
                guard let newsComment = newsComment else {
                    return
                }
                if myUserDefaults.userId == newsComment.user?.id ?? 0 {
                    //applyBtn.isHidden = true
                    moreOption.isHidden = false
                    moreOption.addTarget(self, action: #selector(openMoreOption), for: .touchUpInside)
                } else {
                    //applyBtn.isHidden = false
                    moreOption.isHidden = true
                    EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
                }
                if newsComment.isCommentLike == 1 {
                    likeImgView.image = #imageLiteral(resourceName: "like_selected")
                } else {
                    likeImgView.image = #imageLiteral(resourceName: "LikeComment")
                }
                
                likeCountLbl.text = "\(newsComment.likeCount ?? 0)"
                
//                mainUIView.backgroundColor = UIColor(hex: "#F8F6F8")
                msgLbl.text = newsComment.content?.decodeEmoji
                userNameLbl.text = newsComment.user?.firstName ?? ""
                dayLbl.text = "\(newsComment.createdDate ?? "")"//"\(newsComment.time) | \(newsComment.createdDatetime.dateOnly())"
                if !(newsComment.user?.userImage?.isEmpty ?? false) {
                    profileImage!.sd_setImage(with: URL(string: newsComment.user!.userImage!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .continueInBackground, completed: .none)
                } else {
                    profileImage!.image = #imageLiteral(resourceName: "noImage")
                }
            }
        }
    }
    
    var newsComment: NewsComment?
    var comment: Comments!
    
    var delegate: PostActionable?
    var editPostView: EditDeleteView?
    var isMoreViewSelected = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        makeImageRound(view: profileImage)
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())

    }
    
    func initUI() {
        mainUIView.layer.cornerRadius = 8
//        userNameLbl.font = UIFont(defaultFontStyle: .bold, size: 14.0)
//        userNameLbl.textColor = AppColors.textColor
//        msgLbl.textColor = AppColors.textColor
//        msgLbl.font = UIFont(defaultFontStyle: .regular, size: 14.0)
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
    }
    
    
}
extension CommentCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
extension CommentCell: EditDeleteViewDelegate {
    
   @objc func openMoreOption(){
       
       print(isMoreViewSelected)
       
       if isMoreViewSelected == true{
           configurePostView()
           EditDeleteHandler.sharedInstance.showMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = false
           print(isMoreViewSelected)
       } else {
          
           EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = true
       }
   
   }
    
   private func configurePostView() {
    editPostView = EditDeleteHandler.sharedInstance.createEditDeleteMenu(content: contentView, moreOption: moreOption, caller: CommentCell.self, isMyComment: isMyComment, buttonType: .comment)
    
    //createMenuView(content: contentView,moreOption: moreOption,caller: HomeUrl.self)
    editPostView?.delegate = self
   }
    
    func delegateAction(_ navigator: EditDeleteView, type: OptionType) {
        if type == .editPost {
            delegate?.actionType(sender: moreOption, action: .edit)
            
        } else {
            delegate?.actionType(sender: moreOption, action: .delete)
        }
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
        isMoreViewSelected = true
    }
    
  
}
enum CommentType {
    case newsComment
    case otherComment
}
