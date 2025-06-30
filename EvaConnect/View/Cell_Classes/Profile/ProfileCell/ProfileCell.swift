//
//  ProfileCell.swift
//  EvaConnect
//
//  Created by Metis on 13/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ProfileCell: BaseCellClass {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
