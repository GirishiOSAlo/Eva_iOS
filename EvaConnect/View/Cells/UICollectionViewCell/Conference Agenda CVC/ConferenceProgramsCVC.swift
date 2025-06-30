//
//  ConferenceProgramsCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 23/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferenceProgramsCVC: UICollectionViewCell {

    @IBOutlet weak var baseVw: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var titleLbl_1: UILabel!
    @IBOutlet weak var sessionLbl: UILabel!
    @IBOutlet weak var titleLbl_2: UILabel!
    @IBOutlet weak var sponsorsLbl: UILabel!
    @IBOutlet weak var underlineVw: UIView!
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            dropButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func initUI() {
        timeLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        titleLbl_1.font = UIFont(name: Myfonts.medium, size: 14.0)
        titleLbl_2.font = UIFont(name: Myfonts.medium, size: 14.0)
        sessionLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        sponsorsLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
    }

    func setData(data: ConferenceProgram?) {
        self.timeLbl.text = "\(data?.timeFrom ?? "") - \(data?.timeTo ?? "")"
        self.sessionLbl.text = data?.name ?? ""
        self.sponsorsLbl.text = "--"
    }
    
}
