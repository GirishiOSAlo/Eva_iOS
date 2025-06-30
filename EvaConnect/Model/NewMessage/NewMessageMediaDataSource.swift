//
//  NewMessageMediaDataSource.swift
//  EvaConnect
//
//  Created by usama on 03/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class NewMessageMediaDataSource: NSObject, UICollectionViewDataSource {
    
    var chosenImages: [UIImage] = []
    
    override init() {
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chosenImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPickerCell", for: indexPath) as? MediaPickerCell {
            
            cell.selectedPhoto.image = chosenImages[indexPath.row]
            cell.delegate = self
            cell.removeButton.tag = indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
}

extension NewMessageMediaDataSource: SelectionCellActionable {
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        chosenImages.remove(at: sender.tag)
        NotificationCenter.default.post(Notification(name: .refreshMediaCollection))
        completion()
    }
}
