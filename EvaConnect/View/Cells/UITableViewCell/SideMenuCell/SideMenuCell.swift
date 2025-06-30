//
//  menuCellXib.swift
//  EvaConnect
//
//  Created by Metis on 20/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var imageValue: UIImageView!
    @IBOutlet weak var openVC: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }
    
    func initUI() {
        
        (titleValue as? HeadingTwoLabel)?.font = UIFont(defaultFontStyle: .bold, size: 14.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    var showIcon: Bool = true {
        didSet {
            imageValue.isHidden = !showIcon
        }
    }
    
    var menu: menuStruct? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        guard let menu = menu else {
            titleValue.text = ""
            showIcon = false
            return
        }
        
        imageValue.isHidden = !showIcon
        
        titleValue.text = menu.titleData
        imageValue.image = menu.imageData
    }
}

extension SideMenuCell: Dequeueable {
      static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

extension UITableViewCell {
    static var identifier: String {
        return "\(String(describing: self))"
    }
}
