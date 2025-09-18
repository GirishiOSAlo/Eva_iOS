//
//  CustomTabView.swift
//  MintoakBase
//
//  Created by Chaitanya Soni on 15/04/21.
//  Copyright © 2021 Chaitanya Soni. All rights reserved.
//

import UIKit

enum CustomTabViewState {
    case selected
    case unselected
}

protocol CustomTabSelectDelegate: AnyObject {
    func didSelectTab(tab: CustomTabView)
}

@IBDesignable class CustomTabView: UIView, NibLoadable {
    
    weak var delegate: CustomTabSelectDelegate?
    
    var state: CustomTabViewState = .unselected {
        didSet {
            let isStateSelected = state == .selected
            backgroundImageView.isHidden = !isStateSelected
            
            if isStateSelected {
//                label.textColor = UIColor(hex: "#FFFFFF") //AppSettings.shared.appColors.brandColor.primaryColor
                self.imageView.image = UIImage(named: selectedImageName)
            } else {
//                label.textColor = UIColor(hex: "#707070") //AppSettings.shared.appColors.textColor.secondaryColor
                self.imageView.image = UIImage(named: imageName)
            }
            
            
        }
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBInspectable var backgroundImageName: String = "" {
        didSet {
            self.backgroundImageView.image = UIImage(named: backgroundImageName)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var imageName: String = "" {
        didSet {
            self.imageView.image = UIImage(named: imageName)
        }
    }
    @IBInspectable var selectedImageName: String = "" {
        didSet {
            self.imageView.image = UIImage(named: selectedImageName)
        }
    }
    
    
    @IBOutlet private weak var label: UILabel!
    @IBInspectable var text: String = "" {
        didSet {
            label.text = text//.localize()
        }
    }
    
    @IBOutlet weak var badgeMainVw: UIView! {
        didSet {
            badgeMainVw.backgroundColor = .red
            badgeMainVw.clipsToBounds = true
            badgeMainVw.isHidden = true
            badgeMainVw.layer.cornerRadius = badgeMainVw.frame.height / 2
        }
    }
    
    @IBOutlet weak var badgeLabel: UILabel! {
        didSet {
            badgeLabel.textColor = .white
            badgeLabel.font = UIFont(name: Myfonts.semiBold, size: 5)
            badgeLabel.textAlignment = .center
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        setupFromNib()
//        setStyle()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        self.addGestureRecognizer(tap)
    }
    
//    func setStyle() {
//        label.font = .systemFont(ofSize: 15) //AppSettings.shared.appFonts.montserratRegular.withSize(11)
//        label.textColor = UIColor(hex: "#707070") //AppSettings.shared.appColors.textColor.secondaryColor
//    }
        
    func setBadge(count: Int) {
        if count > 0 {
            badgeMainVw.isHidden = false
            badgeLabel.text = count > 99 ? "99+" : "\(count)"
        } else {
            badgeMainVw.isHidden = true
            badgeLabel.text = nil
        }
    }
    
    @objc func tap() {
        delegate?.didSelectTab(tab: self)
    }
}
