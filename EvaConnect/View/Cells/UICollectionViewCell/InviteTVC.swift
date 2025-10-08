//
//  InviteTVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class InviteTVC: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    
    weak var delegate: SelectionCellActionable?
    
//    var connection: UserConnection! {
//        
//        didSet {
//            print("user", connection.firstName ?? "") //, connection.lastName)
//            nameLbl.text = connection.firstName.stringValue //+ " " + connection.lastName.stringValue
//            
//            let company = !connection.companyName.isNilOrEmpty ? "\(connection.companyName.stringValue)" : "\(connection.designation.stringValue)"
//            
//            subLbl.text = company
//            
//            
//            if !connection.userImage.isNil {
//                imgVw.sd_setImage(with: URL(string: connection.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
//            }
//        }
//    }
    
    var Attendees: AttendeesList! {
        
        didSet {
            print("user", Attendees.name ?? "") //, connection.lastName)
            nameLbl.text = Attendees.name.stringValue //+ " " + connection.lastName.stringValue
            subLbl.text = Attendees.companyName ?? ""
            
            if !Attendees.userImage.isNil {
                imgVw.sd_setImage(with: URL(string: Attendees.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func initUI() {
        imgVw.layer.cornerRadius = imgVw.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inviteUserTapped(_ sender: UIButton) {
        delegate?.selectedButton(sender: sender, completion: {
        })
    }

}
