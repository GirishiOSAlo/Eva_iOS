//
//  ShareTableViewCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 06/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: SelectionCellActionable?
    
    var connection: UserConnection! {
        
        didSet {
            print("user", connection.firstName ?? "") //, connection.lastName)
            namelabel.text = connection.firstName.stringValue //+ " " + connection.lastName.stringValue
            
            let company = !connection.companyName.isNilOrEmpty ? "\(connection.companyName.stringValue)" : "\(connection.designation.stringValue)"
            
            companyLabel.text = company
            
            
            if !connection.userImage.isNil {
                profileImgView.sd_setImage(with: URL(string: connection.userImage!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .continueInBackground, completed: .none)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgView.roundOnly()
    }

    @IBAction func selectUserTapped(_ sender: UIButton) {
        delegate?.selectedButton(sender: sender, completion: {
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
