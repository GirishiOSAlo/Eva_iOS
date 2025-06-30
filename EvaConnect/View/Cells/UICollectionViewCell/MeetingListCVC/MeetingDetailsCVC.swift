//
//  MeetingDetailsCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol MeetingDetailsCellDelegate: AnyObject {
    func didTapDropdownButton(in cell: MeetingDetailsCVC)
}

class MeetingDetailsCVC: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var underlineVw: UIView!
    @IBOutlet weak var dropBtn: UIButton!

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet var detilsTitleLbllCollection: [UILabel]!
    @IBOutlet weak var meetingWithLbl: UILabel!
    @IBOutlet weak var colleaguesLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var rescheduleBtn: UIButton!
    @IBOutlet weak var joinMeetingBtn: UIButton!
    @IBOutlet weak var cancelMeetingBtn: UIButton!
    
    @IBOutlet weak var locationBaseVw: UIView!
    @IBOutlet weak var buttonBaseVw: UIView!
    @IBOutlet weak var cancelBtnBaseVw: UIView!
    
    
    weak var delegate: MeetingDetailsCellDelegate?
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            dropBtn.setImage(UIImage(named: imageName), for: .normal)
            locationBaseVw.isHidden = isExpanded ? false : true
            buttonBaseVw.isHidden = isExpanded ? false : true
            cancelBtnBaseVw.isHidden = isExpanded ? false : true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initUi()
    }

    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        delegate?.didTapDropdownButton(in: self)
    }
        
    func initUi() {
        dateLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        timeLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        
        for lbl in detilsTitleLbllCollection {
            lbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        }
        meetingWithLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        colleaguesLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        locationLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        messageBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        rescheduleBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        joinMeetingBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        cancelMeetingBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        
        messageBtn.cornerRadius = 12.0
        rescheduleBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD", alpha: 1.0), value: 1.0, radius: 12.0)
        cancelMeetingBtn.cornerRadius = 12.0
        joinMeetingBtn.cornerRadius = 12.0
    }
}
