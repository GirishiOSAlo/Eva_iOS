//
//  VenueMapCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 22/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class VenueMapCell: UITableViewCell {

    @IBOutlet weak var contentUiView: UIView!
    @IBOutlet weak var venueMapImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentUiView.layer.cornerRadius = 16
        contentUiView.layer.masksToBounds = true
        
        venueMapImgView.layer.cornerRadius = 16
        venueMapImgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VenueMapCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
