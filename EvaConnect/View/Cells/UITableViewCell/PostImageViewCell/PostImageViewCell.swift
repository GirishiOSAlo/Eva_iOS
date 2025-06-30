//
//  PostImageViewCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/4/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

protocol PostTableViewCellDelegate: AnyObject {
    func didRemoveCell(at index: Int, hasImage: Bool)
}

class PostImageViewCell: UITableViewCell {

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    
    weak var delegate: PostTableViewCellDelegate? = nil
    var mode: PostLoadingMode! {
        didSet {
            removeBtn.isHidden = mode == .edit
        }
    }
    
    var data: (index: Int, url: URL?, image: UIImage?)! {
        didSet {
            videoView.isHidden = true
            if let url = data.url { postImageView.kf.setImage(with: url) }
            else { postImageView.image = data.image! }
//            data.url == nil ? postImageView.image = data.image! : postImageView.kf.setImage(with: data.url)
//          postImageView.loadLocalImage(by: data.url)
        }
    }
    
    var video: (index: Int, thumbnail: UIImage)! {
        didSet {
            videoView.isHidden = false
            postImageView.image = video.thumbnail
        }
    }
    
    @IBAction func removeImageBtnTapped(_ sender: Any) { delegate?.didRemoveCell(at: data?.index ?? video.index, hasImage: data != nil) }
}

extension PostImageViewCell: Dequeueable {
    static func id() -> String { String(describing: self) }
    static func hasNib() -> Bool { true }
}
