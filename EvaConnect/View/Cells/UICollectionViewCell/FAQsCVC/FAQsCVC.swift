//
//  FAQsCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 09/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol FAQsCellDelegate: AnyObject {
    func didTapDropdownButton(in cell: FAQsCVC)
}

class FAQsCVC: UICollectionViewCell {

    @IBOutlet weak var baseVw: UIView!
    @IBOutlet weak var underlineVw: UIView!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    
    
    weak var delegate: FAQsCellDelegate?
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_dropUp" : "ic_dropDown"
            dropBtn.setImage(UIImage(named: imageName), for: .normal)
            
            answerLbl.isHidden = isExpanded ? false : true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        delegate?.didTapDropdownButton(in: self)
    }
}
