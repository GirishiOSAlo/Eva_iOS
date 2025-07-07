//
//  HelpPageVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HelpPageVC: UIViewController, XIBed {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var inputBaseVw: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var textView : UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
        self.setupTextView()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        inputBaseVw.applyBorderWithRadius(color: UIColor(hex: "#C3CCDF"), value: 1.0, radius: 14.0)
        submitBtn.layer.cornerRadius = 14.0
        submitBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        
        headerLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        linkLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        descriptionLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        // Add gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        linkLbl.isUserInteractionEnabled = true
        linkLbl.addGestureRecognizer(tapGesture)
    }
    
    func setupTextView() {
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write you message here..."
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(hex: "#C3CCDF", alpha: 1.0)
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func labelTapped() {
        print("Link was tapped!")
    }
    
    @IBAction func onSubmitBtnTap(_ sender: UIButton) {
        print("Submit Btn Tap")
        let desc = self.textView.text ?? ""
        if desc.elementsEqual("") {
            print("TextView Text empty...")
        } else {
            self.helpSubmit(with: self.textView.text)
        }
    }
}

extension HelpPageVC {
    func helpSubmit(with: String) {
        let url = EndPoints.help
        let parameters = ["descriptions": with] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let helpRoot = try jsonDecoder.decode(HelpDataModel.self, from: response.data!)
                if !(helpRoot.error ?? false) {
                    self.textView.text = ""
                    self.textView.resignFirstResponder()
                    self.presentAlert("Help Submit Successfully")
                } else {
                    print("Error :: \(helpRoot.message ?? "")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
}

extension HelpPageVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
