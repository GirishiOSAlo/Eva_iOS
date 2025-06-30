//
//  NewsDetailsTVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class NewsDetailsTVC: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsSourceImgView: UIImageView!
    
    @IBOutlet weak var newsSourceTitle: UILabel!
    @IBOutlet weak var newsTimeLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var visitNewsBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
//    var news: DashboardItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        newsImageView.layer.cornerRadius = 12
        newsSourceImgView.layer.cornerRadius = newsSourceImgView.layer.bounds.width/2
        visitNewsBtn.layer.cornerRadius = 18
    }
    
    func uiData(dataMaper: RelatedNewsData) {
        newsImageView.sd_setImage(with: URL(string: dataMaper.image ?? ""))
        newsSourceImgView.sd_setImage(with: URL(string: dataMaper.newsSource?.image ?? ""))
        newsTimeLbl.text = dataMaper.title
        newsSourceTitle.text = dataMaper.newsSource?.name
        newsTimeLbl.text = dataMaper.createdDate
        
        dataMaper.isNewsSave == 1 ? saveBtn.setImage(UIImage(named: "save_selected"), for: .normal) : saveBtn.setImage(UIImage(named: "save"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func visitNewsTapped(_ sender: UIButton) {
        
    }
}

extension NewsDetailsTVC: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
