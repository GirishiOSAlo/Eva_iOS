//
//  MediaCVCell.swift
//  EvaConnect
//
//  Created by usama on 15/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

class MediaCVCell: UICollectionViewCell {

    @IBOutlet weak var chatImageView: UIImageView!
    var delegate: SelectionCVDocumentActionable?
    var chatTap: UITapGestureRecognizer!

    var chatImage: String! {
        didSet {
            if let url = URL(string: chatImage), url.containsImage {
                chatImageView.kf.setImage(with: url, placeholder: UIImage(named: "noPhoto"))
                chatImageView.kf.indicatorType = .activity
                layoutIfNeeded()
            } else {
                chatImageView.image = UIImage(named: "documentss")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        chatImageView.addGestureRecognizer(chatTap)
        
        // Initialization code
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectedDocument(url: URL(string: chatImage)!)
    }
}
