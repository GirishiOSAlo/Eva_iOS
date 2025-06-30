//
//  PopupTableCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 06/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class PopupTableCell: BaseCellClass {

    @IBOutlet weak var titleName: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        static var nib: UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    }
    extension PopupTableCell: Dequeueable {
        static func id() -> String {
            return String(describing: self)
        }
        
        static func hasNib() -> Bool {
            return true
        }
    }
