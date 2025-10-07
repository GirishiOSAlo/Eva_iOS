//
//  HomePostTVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 06/10/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

class HomePostTVC: BaseCellClass {
    
    var delegate: PostActionable?
    weak var delegateDidSelect: CollectionViewCellDelegate?
    
    @IBOutlet weak var bgVw: UIView!
    @IBOutlet weak var imageMainVw: UIView!
    @IBOutlet weak var videoMainView: UIView!
    @IBOutlet weak var docMainVw: UIView!
    
    @IBOutlet weak var imageVwHeight: NSLayoutConstraint! //240.0
    @IBOutlet weak var videoVwHeight: NSLayoutConstraint! //210.0
    @IBOutlet weak var docVwHeight: NSLayoutConstraint! //80.0
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var connectionNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var goToProfileBtn: UIButton!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pageNoLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlHeight: NSLayoutConstraint!
    @IBOutlet weak var postMsgLbl: UILabel!
    var imageArr: [String?] = []
    var isFullTextVisible = false
    var actualString = ""
    
    
    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet weak var openVideoBtn: UIButton!
    
    @IBOutlet weak var docImgUiView: UIView!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var documentSizeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var openArticleBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI() {
        self.bgVw.layer.cornerRadius = 20.0
        connectionNameLbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        dateLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        followBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        makeImageRound(view: profileImage)
        followBtn.layer.cornerRadius = 12.0
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
        
        postMsgLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        likeCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        commentCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        shareCountLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        pageNoLbl.layer.cornerRadius = pageNoLbl.layer.bounds.height / 2
        pageNoLbl.clipsToBounds = true
        self.isUserInteractionEnabled = true
        imageCollection.delegate = self
        imageCollection.dataSource = self
        imageCollection.registerNib(cellNib: PostImageCVC.self)
                
    }
    
    
    func uiData(dataMaper: DashboardItem, type: String) {
        let userid = dataMaper.user?.id ?? 0
        if userid == myUserDefaults.userId {
            //followBtn.isHidden = true
            followBtnWidth.constant = 0.0
            reportBtn.isHidden = true
        } else {
            reportBtn.isHidden = false
            if dataMaper.isConnected == "connected" || dataMaper.isConnected == "active" {
                //followBtn.isHidden = true
                followBtnWidth.constant = 0.0
            } else {
                //followBtn.isHidden = false
                followBtnWidth.constant = 97.0
            }
        }
        connectionNameLbl.text = dataMaper.user?.firstName ?? dataMaper.user?.companyName ?? ""
        dateLbl.text = dataMaper.createdDate
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
        
        likeCountLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentCountLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareCountLbl.text = "\(dataMaper.shareCount ?? 0)"
        
        
        likeImage.image = dataMaper.isPostLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "Like")
        
        self.imageVwHeight.constant = 0.0
        self.videoVwHeight.constant = 0.0
        self.docVwHeight.constant = 0.0
        
        actualString = dataMaper.content ?? ""
        configure(with: actualString)
        
        if type == "video" {
            self.videoVwHeight.constant = 210.0
        }
        else if type == "document" {
            self.docVwHeight.constant = 80.0
            documentName.text = dataMaper.documentFileName ?? "No Name"
            documentSizeLbl.text = dataMaper.documentSize ?? "0 kB"
        }
        else if type == "image" {
            self.imageArr = dataMaper.datumPostImage ?? []
            imageCollection.reloadData()

            if self.imageArr.count > 1 {
                pageNoLbl.isHidden = false
                pageControl.numberOfPages = self.imageArr.count
                pageControl.currentPage = 0
                pageNoLbl.text = "  \((pageControl.currentPage) + 1 )/\(pageControl.numberOfPages)  "
                imageCollection.reloadData()
            } else {
                pageNoLbl.isHidden = true
            }
            
            if dataMaper.datumPostImage!.count == 0 || dataMaper.datumPostImage!.count == 1 {
                self.imageVwHeight.constant = 210.0
                self.pageControlHeight.constant = 0.0
            } else {
                self.imageVwHeight.constant = 240.0
                self.pageControlHeight.constant = 30.0 //30 is page control view...
            }
        } else {
            print("text cell")
        }
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


extension HomePostTVC: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}


extension HomePostTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         let pageWidth = scrollView.frame.size.width
         let currentPage = Int(scrollView.contentOffset.x / pageWidth)
         pageControl.currentPage = currentPage
         pageNoLbl.text = "  \((currentPage) + 1 )/\(pageControl.numberOfPages)  "
     }
}
