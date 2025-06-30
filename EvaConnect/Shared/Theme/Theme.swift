//
//  Theme.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol Theme {
    
    func apply(for application: UIApplication)
    func extend()
}

extension Theme {
    
    func apply(for application: UIApplication) {
        
        extend()
        
        UITextField.appearance().with { 
            $0.font = UIFont(defaultFontStyle: .regular, size: 16.0) //14 design Size
            $0.textColor =  AppColors.textColor2
        }
    }
    
    
    func extend() {

        HeadingOneLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 22.0) //20 design Size
            $0.textColor = .black
            $0.adjustsFontForContentSizeCategory = true
        }
        
        NameLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 16.0) //14 design Size
            $0.textColor = .black
        }
        NameRegularLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 16.0) //14 design Size
            $0.textColor = .black
        }

        HeadingTwoLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 15) //13 design Size
            $0.textColor = .black
        }
        
        HeadingTwoBold.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 15) //13 design Size
            $0.textColor = AppColors.lightBg
        }

        HeadingThreeLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 13.0) //11 design Size
            $0.textColor = AppColors.textColor2
        }

        HeadingFourLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 10) //8 design Size
            $0.textColor = .black
        }
        
        HeadingLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 15.0) //13 design Size
            $0.textColor = .black
        }
        
        EditableTextField.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 15) //13 design Size
            $0.textColor = .black
        }
        
        ElevenRegularLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 14.0) //12 design Size
            $0.textColor = Constants.AppColorLiteral.nextButtonColor
        }
        
        ElevenBoldLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 15) //12 design Size
            $0.textColor = Constants.AppColorLiteral.nextButtonColor
        }
        TwelveBoldLabel.appearance().with {
                   $0.font = UIFont(defaultFontStyle: .bold, size: 14) //12 design Size
                   $0.textColor = Constants.AppColorLiteral.nextButtonColor
               }
        PostTimeLabel.appearance().with {
                   $0.font = UIFont(defaultFontStyle: .regular, size: 13) //12 design Size
                   $0.textColor = .black
               }
        LikeCommentButton.appearance().with {
            $0.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 14) //12 design Size
        }
        
        ConnectButton.appearance().with {
            $0.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 14) //12 design Size
        }
        PostContentBoldLabel.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 15) //13 design Size
            $0.textColor = .black
        }
        EditDeleteLbl.appearance().with {
            $0.font = UIFont(defaultFontStyle: .regular, size: 16) //14 design Size
            $0.textColor = AppColors.textColor2
        }
       CalenderMonthHeader.appearance().with {
            $0.font = UIFont(defaultFontStyle: .bold, size: 21.0) //20 design Size
        $0.textColor = .black
        }
    }
}

