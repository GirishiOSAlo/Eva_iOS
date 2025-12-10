//
//  CompaniesEmployeeVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class CompaniesEmployeeVC: UIViewController, XIBed {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.noRecordLbl.isHidden = true
        noRecordLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        searchUiView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
    }
}

extension CompaniesEmployeeVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTextField.text ?? ""
        print("Search Text :: \(searchStr)")
    }
}
