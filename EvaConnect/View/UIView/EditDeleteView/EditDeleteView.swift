//
//  EditDeleteView.swift
//  EvaConnect
//
//  Created by Metis on 02/10/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import UIKit

protocol EditDeleteViewDelegate: class {
    func delegateAction(_ navigator: EditDeleteView, type: OptionType)
  
}
@IBDesignable
class EditDeleteView: UIView {
    
    
    @IBOutlet weak var button: UIButton! {
        didSet{
            //button.isEnabled = false
        }
    }
    
    @IBOutlet weak var editLbl: NameRegularLabel!
    @IBOutlet weak var deleteLbl: NameRegularLabel!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var label: UILabel!
    var isMyComment = false
    let xibName = "EditDeleteView"
    var buttonType: ButtonType = .post
    
    var view: UIView!
    
    weak var delegate: EditDeleteViewDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    
        
    }
    func dimissEditDeleteView(){
        
    }
    func changeLabelText(buttonName: ButtonType){
        if isMyComment == false {
            editView.isHidden = true
        } else {
            editView.isHidden = false
        }
        switch buttonType {
        
        case .post:
            editLbl.text = ButtonNames.editPost.rawValue
            deleteLbl.text = ButtonNames.deletePost.rawValue
        case .comment:
            editLbl.text = ButtonNames.editComment.rawValue
            deleteLbl.text = ButtonNames.deleteComment.rawValue
        case .job:
            editLbl.text = ButtonNames.editJob.rawValue
            deleteLbl.text = ButtonNames.deleteJob.rawValue
        case .event:
            editLbl.text = ButtonNames.editEvent.rawValue
            deleteLbl.text = ButtonNames.deleteEvent.rawValue
        case .news:
            break
            
        }
    }
    
    private func configure() {
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
       
        return view
    }
    
    @IBAction func ibAction(_ sender: UIButton) {
       
        
        guard let delegate = delegate else{
            return
        }
        if sender.tag == 0 {
            delegate.delegateAction(self, type: .editPost)
            
        }
        else {
            delegate.delegateAction(self, type: .deletePost)
        }
 }
    
}



enum OptionType{
    case editPost
    case deletePost
}
enum Option {
    case forOtherComment
    case forMyComment
}
enum ButtonType{
    case post
    case job
    case event
    case news
    case comment
}
enum ButtonNames: String {
    case editPost = "Edit Post"
    case deletePost = "Delete Post"
    case editJob = "Edit Job Post"
    case editEvent = "Edit Event Post"
    case editComment = "Edit Comment"
    case deleteJob = "Delete Job Post"
    case deleteEvent = "Delete Event Post"
    case deleteComment = "Delete Comment"
}

