//
//  Deprecated.swift
//  EvaConnect
//
//  Created by usama on 14/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class DeprecatedChat: UIViewController {
    
    var mediaImages: [UIImage] = [] {
        didSet {
            mediaCollectionView.isHidden = !(mediaImages.count > 0)
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.layer.borderColor = AppColors.border.cgColor
            sendButton.layer.borderWidth = 1.0
            sendButton.layer.cornerRadius = 10.0
            sendButton.setTitleColor(AppColors.textColor, for: .normal)
        }
    }

    @IBOutlet weak var browseFilesView: UIView! {
        didSet {
            browseFilesView.backgroundColor = AppColors.evaBackground
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mediaCollectionView: UICollectionView! {
        didSet {
            mediaCollectionView.dataSource = self
            mediaCollectionView.delegate = self
            mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            mediaCollectionView.backgroundColor = AppColors.evaBackground
        }
    }
}



extension DeprecatedChat: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPickerCell", for: indexPath) as? MediaPickerCell {
            
            cell.selectedPhoto.image = mediaImages[indexPath.row]
//            cell.delegate = self
            cell.removeButton.tag = indexPath.row
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension DeprecatedChat: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 51, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}


class Deprecated {
//    func downloadingFile(downloadUrl: String) {
//        Alamofire.request("\(downloadUrl)").downloadProgress(closure : { (progress) in
//            print(progress.fractionCompleted)
//            IHProgressHUD.show(progress: CGFloat(progress.fractionCompleted))
//        }).responseData{ (response) in
//
//            let file = self.jobApplicantDetail?.applicationAttachment!
//            let fileNameWithoutExtension = file!.fileName()
//            if let data = response.result.value {
//
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let videoURL = documentsURL.appendingPathComponent("\(fileNameWithoutExtension).pdf")
//                do {
//                    try data.write(to: videoURL)
//                    print(videoURL)
//
//                } catch {
//                    print("Something went wrong!")
//                }
//            }
//        }
//    }
}
