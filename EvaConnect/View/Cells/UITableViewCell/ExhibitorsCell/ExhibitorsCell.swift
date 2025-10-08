//
//  ExhibitorsCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 16/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ExhibitorsCell: UITableViewCell {

    @IBOutlet weak var CompanyNameHeadingLabel: UILabel!
    @IBOutlet weak var DrpDwnBtn: UIButton!
    @IBOutlet weak var compImgView: UIImageView!
    @IBOutlet weak var compNameLable: UILabel!
    
    @IBOutlet weak var sponsorTypeHeadingLable: UILabel!
    @IBOutlet weak var sponsorTypeLable: UILabel!
    
    @IBOutlet weak var countryHeadingLable: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    
    @IBOutlet weak var membersHeadingLable: UILabel!
    @IBOutlet weak var membersNoLable: UILabel!
    
    @IBOutlet weak var standNoHeadingLable: UILabel!
    @IBOutlet weak var standNoLable: UILabel!

    var isExpanded: Bool = false {
        didSet {
            let imageName = isExpanded ? "ic_fillDropUp" : "ic_fillDropDown"
            DrpDwnBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }
    
    func setLayout() {
        compImgView.layer.cornerRadius = compImgView.layer.bounds.width/2
        CompanyNameHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        CompanyNameHeadingLabel.textColor = UIColor(hex: "#030229")
        
        compNameLable.font = UIFont(name: Myfonts.medium, size: 14)
        compNameLable.textColor = UIColor(hex: "#030229").withAlphaComponent(0.7)
        
        sponsorTypeHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        sponsorTypeHeadingLable.textColor = UIColor(hex: "#030229")
        
        CompanyNameHeadingLabel.font = UIFont(name: Myfonts.medium, size: 14)
        CompanyNameHeadingLabel.textColor = UIColor(hex: "#030229")
        
        sponsorTypeLable.font = UIFont(name: Myfonts.medium, size: 14)
        sponsorTypeLable.textColor = UIColor(hex: "#030229").withAlphaComponent(0.7)
        
        countryHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        countryHeadingLable.textColor = UIColor(hex: "#030229")
        
        countryLable.font = UIFont(name: Myfonts.medium, size: 14)
        countryLable.textColor = UIColor(hex: "#030229").withAlphaComponent(0.7)
        
        membersHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        membersHeadingLable.textColor = UIColor(hex: "#030229")
        
        membersNoLable.font = UIFont(name: Myfonts.medium, size: 14)
        membersNoLable.textColor = UIColor(hex: "#030229").withAlphaComponent(0.7)
        
        standNoHeadingLable.font = UIFont(name: Myfonts.medium, size: 14)
        standNoHeadingLable.textColor = UIColor(hex: "#030229")
        
        standNoLable.font = UIFont(name: Myfonts.medium, size: 14)
        standNoLable.textColor = UIColor(hex: "#030229").withAlphaComponent(0.7)
        
    }
    
    func setUpData(data: CommonEventMetaData) {
        if let imageUrl = data.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            compImgView.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            compImgView.image = UIImage(named: "profile")
        }
        
        compNameLable.text = (data.firstName?.isEmpty ?? true) ? "--" : data.firstName
        sponsorTypeLable.text = "--"
        countryLable.text = (data.country?.isEmpty ?? true) ? "--" : data.country
        membersNoLable.text = "--"
        standNoLable.text = (data.location?.isEmpty ?? true) ? "--" : data.location
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ExhibitorsCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
