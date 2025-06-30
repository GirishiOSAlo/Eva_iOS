//
//  EditUserProfileCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/28/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class EditUserProfileCell: UITableViewCell {
    
    @IBOutlet weak var editTitleLbl: UILabel!
    
    var title: String! {
        didSet {
            editTitleLbl.text = title
        }
    }
}
