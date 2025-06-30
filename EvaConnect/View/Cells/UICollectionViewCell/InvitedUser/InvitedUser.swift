//
//  InvitedUser.swift
//  EvaConnect
//
//  Created by Metis on 18/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

class InvitedUser: UICollectionViewCell {

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    
    var tapGesture: UIGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainer.roundOnly()
             userAvatar.roundOnly()
             imageContainer.layer.borderWidth = 1.0
             imageContainer.layer.borderColor = AppColors.evaBlue.cgColor
    }
     
//    func dataBinding(attendees: Attendee) {
//        let bindData = attendees
//       userAvatar.sd_setImage(with: URL(string: bindData.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
//        nameLbl.text = "\(bindData.userName ?? "") \(bindData.userImage ?? "")"
//        occupationLbl.text = "\(bindData.company ?? "No Designation")"
//        companyLbl.text = "at \(bindData.company ?? "No Company")"
//    }
    
    func addGestures() {
        
//        imageContainer.addGestureRecognizer(tapGesture!)
//        userAvatar.addGestureRecognizer(tapGesture!)
//        name.addGestureRecognizer(tapGesture!)
//        occupation.addGestureRecognizer(tapGesture!)
    }
}
