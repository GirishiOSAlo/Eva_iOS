//
//  ApplicantCell.swift
//  EvaConnect
//
//  Created by Metis on 07/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ApplicantCell: BaseCellClass {
    //MARK:OutLets
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var openViewBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet var boderView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.nextButtonColor)
        makeImageRound2(view: profileImg,setBoader: true)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ApplicantCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
