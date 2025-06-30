//
//  NoInternetVC.swift
//  EvaConnect
//
//  Created by Metis on 26/10/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class NoInternetVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != containerView {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI() {

        okBtn.addLeftBorderWithColor(color: .lightGray, width: 0.5)
        okBtn.addRightBorderWithColor(color: .lightGray, width: 0.5)
        okBtn.addBottomBorderWithColor(color: .lightGray, width: 0.5)
    }
}
