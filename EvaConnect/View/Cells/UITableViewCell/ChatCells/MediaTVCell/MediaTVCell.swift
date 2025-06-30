//
//  MediaCell.swift
//  EvaConnect
//
//  Created by usama on 15/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol SelectionCVDocumentActionable: class {
    func selectedDocument(url: URL)
}

class MediaTVCell: UITableViewCell {

    let columns: CGFloat = 2.0
    let inset: CGFloat = 3.5
    let spacing: CGFloat = 3.5
    
    var delegate: SelectionCVDocumentActionable?
    var selectedRow: Int?
    
    @IBOutlet weak var collectionView: UICollectionView!

    var chatImages: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }
    
    func initUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(cellNib: MediaCVCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
           
            collectionView.frame = CGRect.init(origin: .zero, size: CGSize(width: targetSize.width, height: collectionView.frame.height - inset ))
           
           let absoluteHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
           
           let absoluteWidth =  collectionView.collectionViewLayout.collectionViewContentSize.width
           
           collectionView.reloadData()
           
           return CGSize(width: absoluteWidth, height: absoluteHeight)
       }
}


extension MediaTVCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCVCell.ReuseId, for: indexPath) as? MediaCVCell {
            
            cell.delegate = self
            cell.chatImage = chatImages[indexPath.item]
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: chatImages[indexPath.row]) {
            delegate?.selectedDocument(url: url)
        }
    }
}

extension MediaTVCell: SelectionCVDocumentActionable {
    func selectedDocument(url: URL) {
//        if !url.containsImage {
            delegate?.selectedDocument(url: url)
//        }
    }
}

extension MediaTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int((collectionView.frame.width * 0.45) - (inset + spacing))
        let height = Int(collectionView.frame.height - inset)
              
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}


extension MediaTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

