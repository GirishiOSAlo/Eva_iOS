//
//  RecommandConnection.swift
//  EvaConnect
//
//  Created by Metis on 12/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class RecommandConnection: UICollectionViewCell {

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    
    var tapGesture: UIGestureRecognizer?
    
    var recommandedConnection: UserConnection! {
        
        didSet {
            
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainer.roundOnly()
        userAvatar.roundOnly()
        imageContainer.layer.borderWidth = 1.0
        imageContainer.layer.borderColor = AppColors.evaBlue.cgColor

    }
}
