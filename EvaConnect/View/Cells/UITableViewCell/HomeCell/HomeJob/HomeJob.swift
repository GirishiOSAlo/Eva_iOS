//
//  HomeJobCell.swift
//  EvaConnect
//
//  Created by Metis on 16/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


import UIKit
import WebKit
import ImageSlideshow
//import URLEmbeddedView

class HomeJob: BaseCellClass {
    
    //MARK: Outlets
    @IBOutlet weak var commentValueLbl: UILabel!
    @IBOutlet weak var likeValueLbl: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var jobCompanyLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var sharedBtn: UIButton!
    @IBOutlet weak var jobContentLbl: UILabel!
    @IBOutlet var boderView: UIView!
    @IBOutlet weak var moreOption: UIButton!
    
    var delegate: PostActionable?
    var editPostView: EditDeleteView?
    var isMoreViewSelected = true
//    let embeddedView = URLEmbeddedView()
    var checkForMultipleImages : Bool = false
    var imageArray = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeImageRound(view: profileImage)
        boderView.layer.cornerRadius = boderView.layer.bounds.width/2
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew , boderValue: 1.0)
        giveButtonCorner(actionBtn: applyBtn,setClipsBound:false,backColor: Constants.AppColorLiteral.signUpNew)
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
    }
    
    func uiData(dataMaper: DashboardItem){
        jobCompanyLbl.attributedText = jobCompanyLbl.makingAttributeMultiple(getText1: "\(dataMaper.jobSector ?? "No Sector") |",
            getColor1: .darkGray,
            getText2: " \(dataMaper.location ?? "No Address") |",
            getColor2: .darkGray,
            getText3: "£ \(dataMaper.salary ?? 0) pa",
            getColor3: .darkGray)
        
        jobTitleLbl.text = "\(dataMaper.jobTitle ?? "") for \(dataMaper.jobNature ?? "")"
        commentValueLbl.text = "\(dataMaper.commentCount ?? 0)"
        likeValueLbl.text = "\(dataMaper.likeCount ?? 0)"
        
        if dataMaper.isJobLike == 1 {
            likeImage.image = #imageLiteral(resourceName: "like_selected")
        }
        else {
            likeImage.image = #imageLiteral(resourceName: "like")
        }
        if myUserDefaults.userId == dataMaper.userID {
            applyBtn.isHidden = true
            moreOption.isHidden = false
            moreOption.addTarget(self, action: #selector(openMoreOption), for: .touchUpInside)
        } else {
            applyBtn.isHidden = false
            moreOption.isHidden = true
            EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
        }
        if dataMaper.isApplied == 1 {
            applyBtn.setTitle("Applied!", for: .normal)
            applyBtn.isUserInteractionEnabled = false
        }else{
            applyBtn.setTitle("Apply", for: .normal)
            applyBtn.isUserInteractionEnabled = true
        }
        profileImage.sd_setImage(with: URL(string: dataMaper.jobImage ?? ""), placeholderImage: #imageLiteral(resourceName: "jobLogoPlaceholder"), options: .progressiveLoad, completed: .none)
        jobContentLbl.text = dataMaper.content
        
    }
    override func prepareForReuse() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      }
    

}
extension HomeJob: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
extension HomeJob: EditDeleteViewDelegate {
    
   @objc func openMoreOption(){
       
       print(isMoreViewSelected)
       
       if isMoreViewSelected == true{
           configurePostView()
          EditDeleteHandler.sharedInstance.showMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = false
           print(isMoreViewSelected)
       } else {
           
           EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
           isMoreViewSelected = true
       }
  
   }
    
   private func configurePostView() {
 
    editPostView = EditDeleteHandler.sharedInstance.createEditDeleteMenu(content: contentView, moreOption: moreOption, caller: HomeJob.self, isMyComment: true, buttonType: .job)
    editPostView?.delegate = self
    
   }
    
    func delegateAction(_ navigator: EditDeleteView, type: OptionType) {
        if type == .editPost{
            delegate?.actionType(sender: moreOption, action: .edit)
            
        }
        else{
            delegate?.actionType(sender: moreOption, action: .delete)
        }
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())
        isMoreViewSelected = true
    }
    
    
}
