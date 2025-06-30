//
//  ShareCell.swift
//  EvaConnect
//
//  Created by Metis on 05/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ShareCell: BaseCellClass {
    
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var shareDataSource: ShareDataSource! {
        didSet {
            titleName.text = shareDataSource.title
            cellImg.image = shareDataSource.image

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
//    private func updateUI() {
//        
//        guard let menu = menu else {
//            titleName.text = "No Option"
//            //showIcon = false
//            return
//        }
//        titleName.text = menu.title
//        cellImg.image = menu.image
//    }
}
extension ShareCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
