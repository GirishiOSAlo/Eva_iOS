//
//  SearchTagCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/3/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

class SearchTagCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    var item: (tag: SearchTags, selected: Bool)! {
        didSet {
            nameLbl.text = item.tag.rawValue
            nameLbl.textColor = UIColor(named: item.selected ? "TagSelected" : "TagUnSelected")
        }
    }
    
}
