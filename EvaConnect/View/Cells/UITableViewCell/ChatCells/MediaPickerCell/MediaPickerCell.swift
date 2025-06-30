//
//  MediaPickerCell.swift
//  EvaConnect
//
//  Created by usama on 02/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit


class MediaPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var selectedPhoto: UIImageView!
    
    weak var delegate: SelectionCellActionable?
    
    var mediaAttachment: ChatVC.MediaAttachment! {
        didSet {
            if mediaAttachment.type == .image {
                selectedPhoto.image = mediaAttachment.image
            } else {
                if #available(iOS 13.0, *) {
                    selectedPhoto.image = UIImage(systemName: "doc.text")
                } else {
                    selectedPhoto.image = UIImage(named: "documentss")
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeButton_touchUpInside(_ sender: UIButton) {
        delegate?.selectedButton(sender: sender, completion: {
            
        })
    }
}
