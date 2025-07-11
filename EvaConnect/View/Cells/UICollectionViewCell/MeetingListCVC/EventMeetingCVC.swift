//
//  EventMeetingCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 11/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol EventMeetingListCellDelegate: AnyObject {
    func didTapDropdownButton(in cell: EventMeetingCVC)
}

class EventMeetingCVC: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var underlineVw: UIView!
    @IBOutlet weak var dropBtn: UIButton!
    
    @IBOutlet weak var eventTitleLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var meetingWithTitleLbl: UILabel!
    @IBOutlet weak var meetingWithLbl: UILabel!
    @IBOutlet weak var colleaguesTitleLbl: UILabel!
    @IBOutlet weak var colleaguesLbl: UILabel!
    @IBOutlet weak var locationTitleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    weak var delegate: EventMeetingListCellDelegate?
    
    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            dropBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUi() 
    }
    
    func initUi() {
        eventTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        eventNameLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        dateLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        timeLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        meetingWithTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        meetingWithLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        colleaguesTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        colleaguesLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        locationTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        locationLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
    }
    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        delegate?.didTapDropdownButton(in: self)
    }
}
