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
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
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
}
