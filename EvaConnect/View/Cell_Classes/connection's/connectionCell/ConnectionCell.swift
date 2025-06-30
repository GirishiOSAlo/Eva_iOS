//
//  ConnectionCell.swift
//  EvaConnect
//
//  Created by Metis on 04/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ConnectionCell: BaseCellClass {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDesignation: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var isConnectedBtn: UIButton!
    
    @IBOutlet weak var connectedBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeImageRound(view: userImage)
        makeImageRound(view: userImage)
        isConnectedBtn.clipsToBounds=true
        isConnectedBtn.layer.cornerRadius = (isConnectedBtn.layer.frame.height)/2
        //setButton(view: isConnectedBtn, ConnerByHeight: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
