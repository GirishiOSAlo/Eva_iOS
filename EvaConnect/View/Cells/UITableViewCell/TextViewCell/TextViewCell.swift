//
//  TextViewCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/3/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

protocol TextViewCellDelegate: AnyObject {
    func updateTextViewHeight(_ text: String, _ height: CGFloat)
    func textViewLinkDetector(_ url: URL?)
}

class TextViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    weak var delegate: TextViewCellDelegate? = nil
    
    var text: String! {
        didSet {
            textView.text = text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.layer.cornerRadius = 13
        textView.linkTextAttributes = [ .foregroundColor: UIColor.systemBlue ]
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textViewTapped)))
    }
    
}

extension TextViewCell: UITextViewDelegate {
    
    @objc private func textViewTapped() {
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = textView.sizeThatFits(.init(width: fixedWidth, height: .greatestFiniteMagnitude))
        delegate?.updateTextViewHeight(textView.text, newSize.height)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hex: "#000000", alpha: 0.4) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trim.isEmpty {
            textView.text = "What do you want to talk about ?"
            textView.textColor = UIColor(hex: "#000000", alpha: 0.4)
        }
        
        delegate?.textViewLinkDetector(textView.text.link)
        textView.isEditable = false
    }
    
}

extension TextViewCell: Dequeueable {
    static func id() -> String { String(describing: self) }
    static func hasNib() -> Bool { true }
}
