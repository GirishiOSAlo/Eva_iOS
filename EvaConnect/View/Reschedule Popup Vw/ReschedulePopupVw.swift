//
//  ReschedulePopupVw.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 29/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ReschedulePopupVw: UIViewController, XIBed {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet var baseViewCollection: [UIView]!
    @IBOutlet var detilsTitleLbllCollection: [UILabel]!
    @IBOutlet weak var rescheduleBtn: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    func setupUI() {
        self.setupTextView()
        baseView.roundCorners([.topRight, .topLeft], radius: 35.0)
        headingLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        rescheduleBtn.cornerRadius = 14.0
        for baseView in baseViewCollection {
            baseView.applyBorderWithRadius(color: UIColor(hex: "#C3CCDF"), value: 1, radius: 8)
        }
        for lbl in detilsTitleLbllCollection {
            lbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
        
        self.dateTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.timeTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.noteTextView.font = UIFont(name: Myfonts.regular, size: 14.0)
    }
    
    func setupTextView() {
        noteTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write you reason here..."
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        placeholderLabel.sizeToFit()
        noteTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(hex: "#8C8C8C", alpha: 1.0)
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
    }

    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ReschedulePopupVw : UITextViewDelegate {
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
