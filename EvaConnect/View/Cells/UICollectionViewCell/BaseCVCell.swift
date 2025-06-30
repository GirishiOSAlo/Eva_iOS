//
//  BaseCVCell.swift
//  EvaConnect
//
//  Created by Metis on 04/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class BaseCVCell: UICollectionViewCell {
    static var baseCVCell = BaseCVCell()
    
    var selectedBackColor =  #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    var unSelectedBackColor =  #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    var selectedTextColor =  #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1568627451, alpha: 1)
    var unSelectedTextColor =  #colorLiteral(red: 0.7294117647, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
    var textViewPlaceHolderColor =  #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.7764705882, alpha: 1)
    //MARK:setViewShadow
    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
    }
    //MARK:setImageShadow
    func setImageView(view : UIImageView){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = (view.frame.width)/2
        //view.clipsToBounds = true
    }
    func setButton(view:UIButton,ConnerByHeight:Bool?=false){
        view.layer.masksToBounds = false
        //           view.layer.shadowOffset = CGSize(width: 0, height: 0)
        //           view.layer.shadowRadius = 2
        //           view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width:5,height:5);
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
        if ConnerByHeight == true{
            view.layer.cornerRadius = (view.frame.height)/2
        }
        else{
            view.layer.cornerRadius = (view.frame.width)/2
        }
        
    }
    //MARK:setImageShadow
    func makeImageRound(view : UIImageView){
        view.clipsToBounds=true
        view.layer.cornerRadius =  (view.layer.frame.height)/2
    }
    
    //MARK:SetCornerSmallRadius
    func giveButtonCorner(actionBtn:UIButton?=nil,setClipsBound:Bool?=true,backColor:UIColor? = .white,giveShadow:Bool?=false,giveViewShadow:Bool?=false,addViewShadow:UIView?=nil,addImageShadow:Bool?=false,imgView:UIImageView?=nil){
        //for buttom with Shadow
        if giveShadow==true{
            actionBtn?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            actionBtn?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            actionBtn?.layer.shadowOpacity = 1.0
            actionBtn?.layer.shadowRadius = 5.0
            actionBtn?.layer.masksToBounds = false
            actionBtn?.layer.cornerRadius = 4.0
            if setClipsBound == false{
                actionBtn?.clipsToBounds=setClipsBound!
            }
            else{
                actionBtn?.clipsToBounds=setClipsBound!
            }
            
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
            actionBtn?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            actionBtn?.layer.borderWidth = 1
        }
        else{
            actionBtn?.clipsToBounds=true
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
        }
        //for view with Shadow
        if giveViewShadow == true{
            addViewShadow?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            addViewShadow?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            addViewShadow?.layer.shadowRadius = 5.0
            addViewShadow?.layer.masksToBounds = false
            addViewShadow?.clipsToBounds = false
            //actionBtn?.backgroundColor = backColor
            addViewShadow?.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            addViewShadow?.layer.borderWidth = 1
        }
        else{
            
        }
        //for image with Shadow
        if addImageShadow == true{
            imgView?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgView?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgView?.layer.shadowRadius = 5.0
            imgView?.layer.masksToBounds = false
            imgView?.clipsToBounds = false
            imgView?.layer.cornerRadius = (imgView?.frame.width)!/2
            imgView?.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgView?.layer.borderWidth = 1
        }
        else{
            
        }
        
        
    }
    //MARK:SetCornerSmallRadius
    func giveImageCorner(changeImage:UIImageView?=nil){
        
        changeImage?.layer.cornerRadius = (changeImage?.frame.width)!/2
        changeImage?.clipsToBounds=true
    }
    
    
}


