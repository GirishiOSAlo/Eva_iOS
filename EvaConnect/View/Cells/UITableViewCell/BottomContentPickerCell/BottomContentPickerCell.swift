//
//  BottomContentPickerCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/4/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

class BottomContentPickerCell: UITableViewCell {

    @IBOutlet weak var pickerLbl: UILabel!
    @IBOutlet weak var pickerImageView: UIImageView!
    
    var content: ((title: String, type: BottomContentPicker.BottomContentType))! {
        didSet {
            pickerLbl.text = content.title
            pickerImageView.image = UIImage(named: content.type.rawValue)
        }
    }
}

extension BottomContentPickerCell: Dequeueable {
    static func id() -> String { String(describing: self) }
    static func hasNib() -> Bool { true }
}
