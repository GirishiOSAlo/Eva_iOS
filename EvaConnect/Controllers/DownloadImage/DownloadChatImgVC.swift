//
//  DownloadChatImgVC.swift
//  Divine
//
//  Created by Pranay Barua on 22/09/22.
//

import UIKit

class DownloadChatImgVC: UIViewController, XIBed {
    static func instantiate(images: [String?], at: Int) -> Self {
        let vc = Self.instantiate()
        vc.imageArr = images
        vc.at = at
        return vc
    }

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pageNoLbl: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var imageArr: [String?] = []
    var at = 0
    var currentPage = 0
    var downloadImage = UIImage()
    var isFromHomeVc = false
    
    var completion: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        downloadButton.isHidden = isFromHomeVc
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
        imageCollection.registerNib(cellNib: PostImageCVC.self)
        
//        if self.imageArr.count > 1 {
//            self.currentPage = self.at
//            self.pageNoLbl.text = "  \((self.currentPage) + 1 )/\(self.imageArr.count)  "
//        } else {
//            self.pageNoLbl.text = ""
//        }
        
        if self.imageArr.count > 1 {
            self.currentPage = self.at
            self.pageNoLbl.text = "  \((self.currentPage) + 1 )/\(self.imageArr.count)  "
            
            // 💡 FIX: Scroll the collection view to the initial 'at' index
            if self.at > 0 && self.at < self.imageArr.count {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: self.at, section: 0)
                    self.imageCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
            }
        } else {
            self.pageNoLbl.text = ""
        }
    }
    
    func downloadImage(urlString: String){
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, err in
            if data != nil, err == nil {
                self.downloadImage = UIImage(data: data!)!
//                self.view.makeToast("Saving Image!!")
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: self.downloadImage)
                imageSaver.completion = {
                    self.completion?()
                    self.dismiss(animated: true)
                }
            }
        }
        dataTask.resume()
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func downloadBtnDidTap(_ sender: UIButton) {
        self.downloadImage(urlString: self.imageArr[self.currentPage] ?? "")
    }
    
}

// MARK: - UICollectionViewDelegate
extension DownloadChatImgVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        self.currentPage = Int(scrollView.contentOffset.x / pageWidth)
        self.pageNoLbl.text = "  \((self.currentPage) + 1 )/\(self.imageArr.count)  "
    }
}

extension DownloadChatImgVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCVC.ReuseId, for: indexPath) as! PostImageCVC
        cell.image = imageArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.imageCollection.frame.size.width), height: (self.imageCollection.frame.size.height))
    }
}
