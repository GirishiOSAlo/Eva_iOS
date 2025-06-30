//
//  ShareView.swift
//  EvaConnect
//
//  Created by Metis on 05/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

typealias ShareViewActionBlock = (_ selectedButton: ShareViewAction) -> Void

enum ShareViewAction: String {
    case connection, whatsApp
}

class ShareView: UIView {
        
    public var actionBlock: ShareViewActionBlock?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    @IBAction func shareWithConnection_touchUpInside(_ sender: UIButton) {
        actionBlock?(.connection)
    }
    
    @IBAction func whatsApp_touchUpInside(_ sender: UIButton) {
        actionBlock?(.whatsApp)
    }
}

extension ShareView {
    override var description: String {
        return String(describing: self)
    }
}
