//
//  VenueMapViewVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

class VenueMapViewVC: UIViewController, XIBed {
    
    var selectedVeneuMapUrl: String!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var venueImgVw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        setupZooming()
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDownloadBtn(_ sender: UIButton) {
        let imageURL = self.selectedVeneuMapUrl ?? "" // random image
        showActivity()
        downloadAndSaveImage(from: imageURL)
    }
    
    func setupUI() {
        if let imageUrl = selectedVeneuMapUrl,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.venueImgVw.kf.setImage(with: url, placeholder: UIImage(named: "noPhoto"))
        } else {
            self.venueImgVw.image = UIImage(named: "noPhoto")
        }
    }
    
    // MARK: - Setup Zooming
    func setupZooming() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Step 1: Download Image
    func downloadAndSaveImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.hideActivity()
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    self.saveImageToGallery(image)
                }
            } else {
                print("❌ Failed to download image")
                DispatchQueue.main.async {
                    self.presentAlert("Download Failed", "Unable to load image data.")
                }
            }
        }.resume()
    }
    
    // MARK: - Step 2: Save to Gallery with Permission
    func saveImageToGallery(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError), nil)
                
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                }
                
            case .notDetermined:
                print("⚠️ Waiting for user to grant permission...")
                
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Step 3: Handle Save Result
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("❌ Save error:", error.localizedDescription)
            DispatchQueue.main.async {
                self.presentAlert("Download Failed", "Unable to load image data.")
            }
        } else {
            print("✅ Image saved successfully to Photos!")
            self.presentAlert("Image Saved", "Your image has been saved to your Photos library.")
        }
    }
    
    // Alert to guide user to Settings
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Permission Needed",
            message: "Please allow photo access in Settings to save images.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension VenueMapViewVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return venueImgVw
    }
}
