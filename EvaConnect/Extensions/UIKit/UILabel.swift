//
//  UILabel.swift
//  EvaConnect
//
//  Created by Metis on 30/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setAttibutedString(strings: [String], colors: [UIColor], font: UIFont = UIFont(defaultFontStyle: .regular, size: 12.0)) {
        
        let initalTextAttributes: [NSAttributedString.Key: Any] = [ .foregroundColor: colors[0], .font: font]
        
        let intialText = NSAttributedString(string: strings[0], attributes: initalTextAttributes)
        
        let finalTextAttirbutes: [NSAttributedString.Key: Any] = [ .foregroundColor: colors[1], .font: font]
        
        let finalText = NSAttributedString(string: strings[1], attributes: finalTextAttirbutes)
        
        let attributedString = NSMutableAttributedString(attributedString: intialText)
        attributedString.append(finalText)
        self.attributedText = attributedString
    }
    
    func makingAttributeMultiple(getText1: String,getColor1: UIColor, getText2: String, getColor2: UIColor,getText3: String, getColor3: UIColor) -> NSAttributedString {
        let textColor1 = [ NSAttributedString.Key.foregroundColor: getColor1 ]
        let myTextAtt1 = NSAttributedString(string: getText1, attributes: textColor1)
        let textColor2 = [ NSAttributedString.Key.foregroundColor: getColor2]
        let myTextAtt2 = NSAttributedString(string: getText2, attributes: textColor2)
        let textColor3 = [ NSAttributedString.Key.foregroundColor: getColor3 ]
        let myTextAtt3 = NSAttributedString(string: getText3, attributes: textColor3)
        // set attributed text on a UILabel
        let attributedText = NSMutableAttributedString()
        attributedText.append(myTextAtt1)
        attributedText.append(myTextAtt2)
        attributedText.append(myTextAtt3)
        return attributedText
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        
        let readMoreText: String = trailingText + moreText
        
        if self.visibleTextLength == 0 { return }
        
        let lengthForVisibleString: Int = self.visibleTextLength
        
        if let myText = self.text {
            
            let mutableString: String = myText
            
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")
            
            let readMoreLength: Int = (readMoreText.count)
            
            guard let safeTrimmedString = trimmedString else { return }
            
            if safeTrimmedString.count <= readMoreLength { return }
            
            print("this number \(safeTrimmedString.count) should never be less\n")
            print("then this number \(readMoreLength)")
            
            // "safeTrimmedString.count - readMoreLength" should never be less then the readMoreLength because it'll be a negative value and will crash
            let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText
            
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var visibleTextLength: Int {
        
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        if let myText = self.text {
            
            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
            
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }
        
        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
    }
    
}
