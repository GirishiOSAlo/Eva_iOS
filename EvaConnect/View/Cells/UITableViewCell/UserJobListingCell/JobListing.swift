//
//  JobListing.swift
//  EvaConnect
//
//  Created by Metis on 05/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class JobListing: BaseCellClass {
    
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var openJobBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var jobContentLbl: UILabel!
    @IBOutlet weak var commnetBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet var boderView: UIView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
        makeImageRound(view: profileImg,ConnerByHeight : false)
        giveButtonCorner(actionBtn: openJobBtn,setClipsBound: false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension JobListing: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

