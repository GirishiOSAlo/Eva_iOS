//
//  ConnectionViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 07/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController, XIBed {
    
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchBaseVw: UIView!
    
    @IBOutlet weak var searchTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSearchBtnTapped(_ sender: UIButton) {
        self.searchTxtField.text = ""
        self.searchMainView.isHidden = false
    }
    
    @IBAction func searchCCloseBtnTapped(_ sender: UIButton) {
        self.searchTxtField.text = ""
        self.searchMainView.isHidden = true
    }
    
    func setupUI() {
        self.searchMainView.isHidden = true
        self.searchBaseVw.layer.cornerRadius = 8
        self.searchBaseVw.layer.borderColor = UIColor(hex: "#837A88").cgColor
        self.searchBaseVw.layer.borderWidth = 1
        self.searchMainView.isHidden = true
        self.searchTxtField.delegate = self
        self.searchTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
}

//MARK: TextField Delegates
extension ConnectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        print(textfield.text)
    }
}
