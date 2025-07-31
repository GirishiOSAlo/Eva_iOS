//
//  NewHomeImage.swift
//  EvaConnect
//
//  Created by Metis on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

enum HomeCellAcitonType {
    case like, comment, share , article , edit , delete
}

protocol PostActionable {
    func actionType(sender: UIButton, action: HomeCellAcitonType)
}

protocol CollectionViewCellDelegate: AnyObject {
    func didSelectItem(at indexPath: Int, imgArr: [String?])
}

class HomeImage: BaseCellClass {
    
    //MARK: Outlets
    
    @IBOutlet weak var postMsgLbl: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var sector: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareCountLbl: UILabel!
    
    @IBOutlet weak var backGroundView: UIView!
//    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var openProfile: UIView!
    
    @IBOutlet weak var likeShareUiView: UIView!
    @IBOutlet weak var goToProfileBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageNoLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate: PostActionable?
    weak var delegateDidSelect: CollectionViewCellDelegate?
//    var editPostView: EditDeleteView?
    var isMoreViewSelected = true
    var parentViewController: UIViewController?
    
    var timer: Timer!
//   print("Clicked") var images: [InputSource] = []
    let maxCharactersToShow = 100
    var isFullTextVisible = false
    var actualString = ""
    var imageArr: [String?] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func initUI() {
        name.font = UIFont(name: Myfonts.bold, size: 14.0)
        dateLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        postMsgLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        likeCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        commentCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        shareCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        backGroundView.layer.cornerRadius = 20
        pageNoLbl.layer.cornerRadius = pageNoLbl.layer.bounds.height / 2
        pageNoLbl.clipsToBounds = true
        followBtn.layer.cornerRadius = 12
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        imageContainer.makeRoundView(boderColor: Constants.AppColorLiteral.loginByNew ,boderValue: 2.0)
        makeImageRound(view: profileImage)
//        backGroundView.dropShadow()
        self.isUserInteractionEnabled = true
        imageCollection.delegate = self
        imageCollection.dataSource = self
        imageCollection.registerNib(cellNib: PostImageCVC.self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = ""
        dateLbl.text = ""
        self.isUserInteractionEnabled = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: DashboardPostData) {
        let userid = data.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        
        self.name.text = data.user?.firstName ?? data.user?.companyName ?? ""
        self.dateLbl.text = data.createdDate ?? ""
        self.likeCountLbl.text = "\(data.likeCount ?? 0)"
        self.commentCountLbl.text = "\(data.commentCount ?? 0)"
        self.shareCountLbl.text = "\(data.shareCount ?? 0)"
        
        if data.datumPostImage?.count ?? 0 > 0 {
            self.imageArr = data.datumPostImage ?? []
            pageControl.numberOfPages = self.imageArr.count
            pageControl.currentPage = 0
            pageNoLbl.text = "  \((pageControl.currentPage) + 1 )/\(pageControl.numberOfPages)  "
            imageCollection.reloadData()
        }
        
        if data.isPostLike == 1 {
            self.likeImage.image = UIImage(named: "like_selected")
        } else {
            self.likeImage.image = UIImage(named: "ic_like")
        }
        
        if let imageUrl = data.user?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImage.image = UIImage(named: "profile")
        }
        actualString = data.content ?? ""
        configure(with: actualString)
    }
    
    func uiData(dataMaper: DashboardItem) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
           followBtn.isHidden = true
        } else {
            followBtn.isHidden = false
        }
        
        name.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""
        dateLbl.text = dataMaper.createdDate
        
        likeCountLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentCountLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareCountLbl.text = "\(dataMaper.shareCount ?? 0)"
        
        if !dataMaper.postImage!.isEmpty {
//            setImages(imageUrl: dataMaper.postImage!)
            
            self.imageArr = dataMaper.postImage ?? []
            pageControl.numberOfPages = self.imageArr.count
            pageControl.currentPage = 0
            pageNoLbl.text = "  \((pageControl.currentPage) + 1 )/\(pageControl.numberOfPages)  "
            imageCollection.reloadData()
        }
        
        
        
        likeImage.image = dataMaper.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "Like")
        
        if dataMaper.user?.userImage != nil {
            profileImage.sd_setImage(with: URL(string: dataMaper.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
        
//        if dataMaper.content.isNil {
//            postMsgLbl.isHidden = true
//        } else {
//            postMsgLbl.isHidden = false
//
//        }
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
        name.text = dataMaper.userName
        dateLbl.text = dataMaper.createdDatetime
        
        likeCountLbl.text = "\(dataMaper.count?.likeCount ?? "")"
        commentCountLbl.text = "\(dataMaper.count?.commentCount ?? "")"
        shareCountLbl.text = "\(dataMaper.count?.shareCount ?? "")"
        
        if (dataMaper.postImages?.count ?? 0 > 0) {
//            setImages(imageUrl: dataMaper.postImages!)
        }
        
        if dataMaper.userImage != nil {
            profileImage.sd_setImage(with: URL(string: dataMaper.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }

//        if dataMaper.content.isNil {
//            postMsgLbl.isHidden = true
//        }else{
//            postMsgLbl.isHidden = false
//            postMsgLbl.text = dataMaper.content
//        }
        
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
    
//    func configureConnectedStatus(dataMaper: DashboardItem)-> ButtonStatus {
//        if dataMaper.isConnected! == .notConnected {
//            //Not Connected
//            connectBtn.setTitle("Connect", for: .normal)
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
//            return .createConnect
//        }
//        if dataMaper.isConnected! == .notConnected  && dataMaper.isReceiver == false {
//            //Not Connected
//            connectBtn.setTitle("Connect", for: .normal)
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
//            return .createConnect
//        }
//        else if dataMaper.isConnected! == .pending && dataMaper.isReceiver == false {
//            //Pending
//            connectBtn.setTitle("Pending", for: .normal)
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
//            return .none
//        }
//        else if dataMaper.isConnected! == .pending && dataMaper.isReceiver == true {
//            //Accept
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.greenColor, boderValue: 1.0)
//            connectBtn.setTitle("Accept", for: .normal)
//            return .accept
//        }
//        else if dataMaper.isConnected! == .active {
//            //Connected
//            connectBtn.setTitle("Connected", for: .normal)
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
//            return .connected
//        }
//        else{
//            connectBtn.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew ,boderValue: 1.0)
//            connectBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
//            connectBtn.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
//            return .none
//
//        }
//    }
    
//    func setImages(imageUrl: [String?]?) {
//        
//        //ImageSlider Setting
//        imageSlider.pauseTimer()
//        imageSlider.slideshowInterval = 3
//        imageSlider.activityIndicator = DefaultActivityIndicator()
//        imageSlider.contentScaleMode = .scaleAspectFill
//        imageSlider.zoomEnabled = true
//        images.removeAll()
//        for i in (imageUrl!) {
//            if !i.isNil{
//                images.append(SDWebImageSource(url: URL(string: i!)!))
//            }
//        }
//        if !images.isEmpty {
//            imageSlider.setImageInputs(images)
//        }
//        
//    }

}

extension HomeImage {
    
    func likeCommentString(likeCount: Int, commentCount: Int, shareCount: Int) -> String {
        
        switch (likeCount, commentCount) {
        case (0,0):
            return String(format: "%d Like %d Comment %d Share", likeCount, commentCount, shareCount)
            
        case (0, _):
            return String(format: "%d Like %d Comments %d Share", likeCount, commentCount, shareCount)
            
        case (_, 0):
            return String(format: "%d Like %d Comments %d Share", likeCount, commentCount, shareCount)
            
        default:
            return String(format: "%d Like %d Comments %d Share", likeCount, commentCount, shareCount)
            
        }
    }
}

extension HomeImage {
    @IBAction func like_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .like)
    }
    
    @IBAction func comment_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .comment)
    }
    
    @IBAction func share_touchUpInside(_ sender: UIButton) {
        delegate?.actionType(sender: sender, action: .share)
    }
    
    @IBAction func navigateToDetail_touchUpInside(_ sender: UIButton) {
        // delegate?.actionType(sender: sender, action: .comment)
     }
}

extension HomeImage: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
//extension HomeImage: EditDeleteViewDelegate {
//    
//   @objc func openMoreOption(){
//       
//       print(isMoreViewSelected)
//       
//       if isMoreViewSelected == true{
//           configurePostView()
//          EditDeleteHandler.sharedInstance.showMenu(xibOnView: editPostView ?? UIView())
//           isMoreViewSelected = false
//           print(isMoreViewSelected)
//       } else {
//           //editPostView?.removeFromSuperview()
//           EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
//           isMoreViewSelected = true
//       }
//}
//    
//   private func configurePostView() {
//
//    editPostView = EditDeleteHandler.sharedInstance.createEditDeleteMenu(content: contentView, moreOption: moreOption, caller: HomeImage.self, isMyComment: true, buttonType: .post)
//    editPostView?.delegate = self
//    
//   }
//    
//    func delegateAction(_ navigator: EditDeleteView, type: OptionType) {
//        if type == .editPost{
//            delegate?.actionType(sender: moreOption, action: .edit)
//            
//        }
//        else{
//            delegate?.actionType(sender: moreOption, action: .delete)
//        }
//        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
//        isMoreViewSelected = true
//    }
//    
//    
//}

// MARK: - UICollectionViewDelegate
extension HomeImage {
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        pageNoLbl.text = "  \((currentPage) + 1 )/\(pageControl.numberOfPages)  "
    }
}

extension HomeImage : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCVC.ReuseId, for: indexPath) as! PostImageCVC
        

        cell.imageView.contentMode = .scaleAspectFill
        cell.image = imageArr[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateDidSelect?.didSelectItem(at: indexPath.row, imgArr: imageArr)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.imageCollection.frame.size.width), height: (self.imageCollection.frame.size.height))
    }
}
