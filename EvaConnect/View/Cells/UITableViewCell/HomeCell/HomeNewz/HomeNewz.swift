//
//  HomeNewz.swift
//  EvaConnect
//
//  Created by Metis on 03/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
import ImageSlideshow
//import URLEmbeddedView
import Kingfisher

class HomeNewz: BaseCellClass, WKUIDelegate {
    
    //MARK: Outlets

//    @IBOutlet weak var shareCountBtn: UIButton!
////    @IBOutlet weak var newsImageHeightConstant: NSLayoutConstraint!
//    @IBOutlet weak var commentValueLbl: UILabel!
//    @IBOutlet weak var likeValueLbl: UILabel!
//    @IBOutlet weak var timeLbl: UILabel!
//    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var openURl: UIButton!
    @IBOutlet weak var urlImage: UIImageView!
//    @IBOutlet weak var mainLikeView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet var boderView: UIView!
    @IBOutlet weak var newzTitle: UILabel!
    @IBOutlet weak var newzShortDetail: UILabel!
    @IBOutlet weak var newzName: UILabel!
    
    @IBOutlet weak var saveNewsImgView: UIImageView!
    @IBOutlet weak var saveNewsBtn: UIButton!
    //new
    @IBOutlet weak var timeWhenPost: UILabel!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var goToProfileBtn: UIButton!
    @IBOutlet weak var detailNavigateBtn: UIButton!
    
//    let embeddedView = URLEmbeddedView()
    var checkForMultipleImages : Bool = false
    var imageArray=[String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor, boderValue: 1.0)
        makeImageRound(view: profileImage)
//        openURl.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor, boderValue: 1.0)
        (newzName as? HeadingTwoBold)?.textColor = .black
        
        imgView.layer.cornerRadius = 20
        urlImage.layer.cornerRadius = 20
        //Constants.setUpperCornerRadius(uiView: urlImage, radius: 20)
        imgView.dropShadow()
//        setCardView(view: imgView)
        
        // likeBtn.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 11.0)
        // connectionCompanyLbl.textColor = Constants.AppColorLiteral.loginColor
    }
    
    func uiData(dataMaper: HomeNewsData) {
        timeWhenPost.text = dataMaper.createdDatetime
        newzTitle.text = dataMaper.newsSource?.name
        newzName.text = dataMaper.newsSource?.name
        
        likeCountLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentCountLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareCountLbl.text = "\(dataMaper.shareCount ?? 0)"

        if dataMaper.isNewsLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        } else {
            likeImage.image = #imageLiteral(resourceName: "Like")
        }
        
        if dataMaper.isNewsSave == 1 {
            saveNewsImgView.image = #imageLiteral(resourceName: "save_selected")
        } else {
            saveNewsImgView.image = #imageLiteral(resourceName: "save")
        }
        
        let htmlString = dataMaper.content
        let cleanString = htmlString?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        newzShortDetail.text = dataMaper.content
        
        if let imageUrl = dataMaper.newsSource?.image,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "noPhoto"))
        } else {
            profileImage.image = UIImage(named: "noPhoto")
        }

        if let imageUrl = dataMaper.newsImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
        } else {
            profileImage.image = UIImage(named: "eventPlaceholder")
        }
    }
    
    func setNewsData(dataMaper: HomeNewsData) {
        if let imageUrl = dataMaper.newsSource?.image,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImage.image = UIImage(named: "profile")
        }

        newzName.text = (dataMaper.newsSource?.name?.isEmpty ?? true) ? "--" : dataMaper.newsSource?.name
        timeWhenPost.text = (dataMaper.createdDatetime?.isEmpty ?? true) ? "--" : dataMaper.createdDatetime
        
        if let imageUrl = dataMaper.newsImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            urlImage.image = UIImage(named: "profile")
        }
        
        newzShortDetail.text = dataMaper.title ?? "--"
        
        likeCountLbl.text = "\(dataMaper.likeCount ?? 0)"
        commentCountLbl.text = "\(dataMaper.commentCount ?? 0)"
        shareCountLbl.text = "\(dataMaper.shareCount ?? 0)"

        if dataMaper.isNewsLike == 1 {
            likeImage.image = UIImage(named: "like_selected")
        } else {
            likeImage.image = UIImage(named: "ic_like")
        }
                
        if dataMaper.isNewsSave == 1 {
            saveNewsImgView.image = UIImage(named: "save_selected")
        } else {
            saveNewsImgView.image = UIImage(named: "save")
        }
    }
    
    func setData(obj: RelatedNewsData) {
        let newsSource = obj.newsSource
        profileImage.kf.setImage(with: URL(string: newsSource?.image ?? ""))
        newzName.text = newsSource?.name ?? ""
        timeWhenPost.text = obj.createdDatetime ?? ""
        
        urlImage.kf.setImage(with: URL(string: obj.image ?? ""))
        newzShortDetail.text = obj.title ?? ""
        
        likeCountLbl.text = "\(obj.likeCount ?? 0)"
        commentCountLbl.text = "\(obj.commentCount ?? 0)"
        shareCountLbl.text = "\(obj.shareCount ?? 0)"
        
        if obj.isNewsLike == 1 {
            likeImage.image = UIImage(named: "like_selected")
        } else {
            likeImage.image = UIImage(named: "ic_like")
        }
        
        if obj.isNewsSave == 1 {
            saveNewsImgView.image = UIImage(named: "save_selected")
        } else {
            saveNewsImgView.image = UIImage(named: "save")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension HomeNewz: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
