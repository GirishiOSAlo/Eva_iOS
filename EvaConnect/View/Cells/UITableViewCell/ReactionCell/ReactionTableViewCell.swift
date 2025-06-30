//
//  ReactionTableViewCell.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 05/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import ImageSlideshow


class ReactionTableViewCell: BaseCellClass {
    
    @IBOutlet weak var reactionHeaderView: UIView!
    @IBOutlet weak var reactedPersonImgView: UIImageView!
    @IBOutlet weak var reactedPerName: HeadingLabel!
    @IBOutlet weak var reactionLbl: HeadingLabel!
    
    @IBOutlet weak var postedPerImgVw: UIImageView!
    @IBOutlet weak var postTitle: HeadingLabel!
    @IBOutlet weak var postTime: HeadingThreeLabel!
    
    @IBOutlet weak var postImg: ImageSlideshow!
    @IBOutlet weak var postContent: UILabel!
    
    @IBOutlet weak var likeImgVw: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var shareCount: UILabel!
    
    @IBOutlet weak var docImgView: UIView!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var docPostedTimeLbl: UILabel!
    
    @IBOutlet weak var videoView: VideoClass!
    @IBOutlet weak var docView: UIView!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var openVideoBtn: UIButton!
    @IBOutlet weak var descriptionBaseVw: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var openArticleBtn: UIButton!
    @IBOutlet weak var gotoProfileBtn: UIButton!
    

    var images: [InputSource] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        docImgView.roundOnly()
        reactedPersonImgView.roundOnly()
        postedPerImgVw.roundOnly()
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setImages(imageUrl: [String?]?) {
        
        //ImageSlider Setting
        postImg.slideshowInterval = 3
        postImg.activityIndicator = DefaultActivityIndicator()
        postImg.contentScaleMode = .scaleAspectFill
        images.removeAll()
        for i in (imageUrl!) {
            if !i.isNil{
                images.append(SDWebImageSource(url: URL(string: i!)!))
            }
        }
        if !images.isEmpty {
            postImg.setImageInputs(images)
        }
        
    }
    

}

extension ReactionTableViewCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
