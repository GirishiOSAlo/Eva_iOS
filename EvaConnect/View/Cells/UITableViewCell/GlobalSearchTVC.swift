//
//  GlobalSearchTVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 06/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class GlobalSearchTVC: UITableViewCell {
    
    @IBOutlet weak var searchResult: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var results: SearchResult! {
        didSet {
            searchResult.text = results.content
            icon.image = UIImage(named: "ic_search")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
