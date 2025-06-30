//
//  NewsSourceCell.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol NewsImageActionable {
    func tappedImage(newsSourceId: Int, completion: @escaping ((Bool) -> Void))
}

class NewsSourceCell: UICollectionViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var categoryNameLable: UILabel!
    @IBOutlet weak var selectedIconImage: UIImageView!
    var delegate: NewsImageActionable?
    
    var newsSource: NewsSource!
    {
        didSet {
            
            if  newsSource.image != nil {
                newsImage.sd_setImage(with: URL(string: (newsSource.image)!), placeholderImage: #imageLiteral(resourceName: "pictures"), options: .progressiveLoad, completed: .none)
            } else {
                newsImage.image = #imageLiteral(resourceName: "noPhoto")
            }
             
            categoryNameLable.text = newsSource.name

            if newsSource.selected {
//                borderView.layer.borderColor = AppColors.evaBlue.cgColor
//                selectedIconImage.isHidden = false
                borderView.layer.borderColor = AppColors.appBlue.cgColor
                borderView.layer.borderWidth = 2
                selectedIconImage.image = UIImage(named: "selected_Icon")
                selectedIconImage.isHidden = false
            } else {
//                borderView.layer.borderColor = AppColors.border2.cgColor
//                borderView.layer.borderWidth = 1.0
                borderView.layer.borderColor = AppColors.border2.cgColor
                borderView.layer.borderWidth = 0
                selectedIconImage.image = nil
                selectedIconImage.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        let newsImageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        newsImage.addGestureRecognizer(newsImageTap)
//        self.borderView.backgroundColor = UIColor(hex: "E7E9F4")
        selectedIconImage.isHidden = true
    }
    
    override func prepareForReuse() {
        newsImage.image = nil
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        delegate?.tappedImage(newsSourceId: newsImage.tag, completion: { (selected) in
            self.setImageBorder(selected: selected)
        })
    }
    
    private func setImageBorder(selected: Bool) {
        if selected {
            borderView.layer.borderColor = AppColors.appBlue.cgColor
            borderView.layer.borderWidth = 2
            selectedIconImage.image = UIImage(named: "selected_Icon")
            selectedIconImage.isHidden = false
        } else {
            borderView.layer.borderColor = AppColors.border2.cgColor
            borderView.layer.borderWidth = 0
            selectedIconImage.image = nil
            selectedIconImage.isHidden = true
        }
    }
}
