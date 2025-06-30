//
//  DownloadChatImgVC.swift
//  Divine
//
//  Created by Pranay Barua on 22/09/22.
//

import UIKit

class DownloadChatImgVC: UIViewController, XIBed {
    static func instantiate(imageString: String) -> Self {
        let vc = Self.instantiate()
        vc.imageString = imageString
        return vc
    }

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    var imageString: String = ""
    var downloadImage = UIImage()
    var isFromHomeVc = false
    
    var completion: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        downloadButton.isHidden = isFromHomeVc
        mainImage.contentMode = .scaleAspectFit
        
//        mainImage.sd_setImage(with: URL(string: imageString))
        
        mainImage.sd_setImage(with: URL(string: imageString))
//        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
    }
    
    private func setZoomScale() {
        guard let image = mainImage.image else { return }
        
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
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
        self.downloadImage(urlString: imageString)
    }
    
    private func resetZoomScale() {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }

}

extension DownloadChatImgVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mainImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Called while the scroll view is zooming
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // Called when the zooming has ended
        print("Zooming ended. Final scale: \(scale)")
        
//        mainImage.sd_setImage(with: URL(string: imageString))
//        resetZoomScale()
    }
    
}
