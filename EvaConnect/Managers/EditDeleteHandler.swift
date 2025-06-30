//
//  EditDeleteHandler.swift
//  EvaConnect
//
//  Created by Metis on 27/10/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import UIKit

class EditDeleteHandler {
    static var sharedInstance = EditDeleteHandler()
    
    private init () {}
    
    func createEditDeleteMenu(content: UIView, moreOption: UIButton,caller: Any , isMyComment: Bool , buttonType: ButtonType) -> EditDeleteView {
        
        let width:CGFloat = 180
        let menuView = EditDeleteView()
        menuView.isHidden = true
        menuView.buttonType = buttonType
        menuView.isMyComment = isMyComment
        menuView.changeLabelText(buttonName: menuView.buttonType)
        menuView.layer.borderWidth = 0.5
        menuView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        content.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.trailingAnchor.constraint(equalTo: moreOption.trailingAnchor, constant: -16).isActive = true
        menuView.widthAnchor.constraint(equalToConstant: width).isActive = true
        menuView.topAnchor.constraint(equalTo: moreOption.bottomAnchor, constant: -15).isActive = true
        
        
        return menuView
        
    }
    
    func hideMenu(xibOnView: UIView) {
         UIView.animate(withDuration: Constants.MenuAnimationTime.menuViewAnimationTime, animations: {
             xibOnView.alpha = 0.0
         }) { (finsished) in
             xibOnView.removeFromSuperview()
         }
     }
      func showMenu(xibOnView: UIView) {
         xibOnView.isHidden = false
         UIView.animate(withDuration: Constants.MenuAnimationTime.menuViewAnimationTime) {
             xibOnView.alpha = 1.0
         }
     }
}
