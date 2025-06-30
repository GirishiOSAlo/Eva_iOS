//
//  UIFont.swift
//  EvaConnect
//
//  Created by usama on 14/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UIFont {

    private enum FontSize {
        static let size: CGFloat = 13.0
    }

    convenience init(defaultFontStyle: DefaultFontStyle = .regular, textStyle: UIFont.TextStyle = UIFont.TextStyle.headline, size: CGFloat = FontSize.size) {

        if #available(iOS 11.0, *) {
            let customFont = UIFont(name: defaultFontStyle.fontName, size: size)!
            let font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont, maximumPointSize: size)
            self.init(descriptor: font.fontDescriptor, size: 0)
        } else {

            var fontDes = UIFontDescriptor(name: defaultFontStyle.fontName, size: size)
            fontDes = fontDes.addingAttributes([UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.AttributeName.textStyle: textStyle]])
            self.init(descriptor: fontDes, size: 0)
        }
    }

    enum DefaultFontStyle: String {
        case regular
        case black
        case light
        case boldItalic
        case thin
        case mediumItalic
        case medium
        case bold
        case blackItalic
        case italic
        case thinItalic
//        case bold
//        case boldItalic
//        case heavy
//        case heavyItalic
//        case light
//        case lightItalic
//        case medium
//        case mediumItalic
//        case regular
//        case regularItalic
//        case semiBold
//        case semiBoldItalic


        var fontName: String {
            return "NunitoSans-\(self.rawValue.capitalized)"
//            return "SF-Pro-Text-\(self.rawValue.capitalized)"
        }
    }

    static func + (left: UIFont, right: CGFloat) -> UIFont {
        return left.withSize(left.pointSize + right)
    }

    static func - (left: UIFont, right: CGFloat) -> UIFont {
        return left.withSize(left.pointSize - right)
    }

}
