//
//  EventDelegatesTblCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class EventDelegatesTblCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var titleLabel: HeadingLabel!
    @IBOutlet weak var subTitleLabel: HeadingThreeLabel!
    @IBOutlet weak var viewProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImgVw.layer.cornerRadius = self.profileImgVw.frame.size.height/2
        statusView.layer.cornerRadius = self.statusView.frame.size.height/2
        viewProfileBtn.layer.cornerRadius = self.viewProfileBtn.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
