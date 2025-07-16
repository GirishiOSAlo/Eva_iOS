//
//  TrendingNewsDetailsCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 06/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class TrendingNewsDetailsCVC: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subDetailsVw: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryLblWidth: NSLayoutConstraint!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var lineBaseVwWidth: NSLayoutConstraint!
    
    @IBOutlet weak var likeImageVw: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var detailNavigateBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    func initUI() {
        imgVw.layer.cornerRadius = 12.0
    }
    
    func setData(obj: NewsTrendingList) {
        if obj.newsSource?.image != nil {
            self.imgVw.sd_setImage(with: URL(string: obj.newsSource?.image ?? ""), placeholderImage: UIImage(named: "noPhoto"), options: .progressiveLoad, completed: .none)
        } else {
            self.imgVw.image = UIImage(named: "noPhoto")
        }
        
        self.titleLbl.text = obj.title ?? "--"
        self.categoryLbl.text = obj.newsSource?.name ?? ""
        self.dateTimeLbl.text = obj.createdDatetime ?? ""
        
        self.likeCountLbl.text = "\(obj.likeCount ?? 0)"
        self.commentCountLbl.text = "\(obj.commentCount ?? 0)"
        self.shareCountLbl.text = "\(obj.shareCount ?? 0)"
        
        if obj.isNewsLike == 1 {
            self.likeImageVw.image = UIImage(named: "like_selected")
        } else {
            self.likeImageVw.image = UIImage(named: "ic_like")
        }
        
        //--> Category label width managed...
        let totalWidth = self.subDetailsVw.frame.size.width/2 - 10
        
        let label = UILabel()
        label.text = obj.newsSource?.name ?? ""
        label.font = UIFont(name: Myfonts.bold, size: 14.0)
        let labelWidth = label.intrinsicContentSize.width
        
        if labelWidth > totalWidth {
            self.categoryLblWidth.constant = totalWidth
        } else {
            self.categoryLblWidth.constant = labelWidth
        }
        
        //--> Horizontal line view hide managed...
        if self.categoryLbl.text == "" {
            self.lineBaseVwWidth.constant = 0.0
        } else {
            self.lineBaseVwWidth.constant = 10.0
        }
    }
}
