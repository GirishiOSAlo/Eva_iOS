//
//  MediaPlayerVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 03/10/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

enum mediaType {
case image
case video
case presentation
}

class MediaPlayerVC: UIViewController {
    
    @IBOutlet weak var navBarLbl: HeadingLabel!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var customBGView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    var player: AVPlayer?
    var avpController = AVPlayerViewController()
    
    var type : mediaType = .image
    var url = ""
    var passedImage: String = ""
    
    var galleryArr: [GalleryDataClass] = [] 
    var selectedIndex: Int!
    var selectedTab = 0
    
    var completion: ((Int) -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaCollectionView.delegate = self
        self.mediaCollectionView.dataSource = self
        self.mediaCollectionView.isPagingEnabled = true
        
        // Configure the layout for horizontal scrolling
        if let layout = mediaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        self.navBarLbl.text = "\(self.selectedIndex + 1)/\(self.galleryArr.count)"
        
        videoView.isHidden = true
        imageView.isHidden = true
        
        // Scroll to a specific index path...
        self.view.layoutIfNeeded()
        self.mediaCollectionView.selectItem(at: IndexPath(row: self.selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        self.mediaCollectionView.reloadData()

    }

//    override func viewWillAppear(_ animated: Bool) {
//        switch type {
//        case .image:
//            videoView.isHidden = true
//            imageView.isHidden = false
//            self.imageView.sd_setImage(with: URL(string: passedImage), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
//            break
//        case .video:
//            videoView.isHidden = false
//            imageView.isHidden = true
//            setupVideoPlayer()
//            break
//        case .presentation:
//            break
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupVideoPlayer(){
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        avpController.videoGravity = .resize
        avpController.player = player
        
        avpController.view.frame.size.width = videoView.frame.size.width
        avpController.view.frame.size.height = videoView.frame.size.height
        self.videoView.addSubview(avpController.view)
        player.play()
//        let videoURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.completion?(1)
        self.navigationController?.popViewController(animated: true)
    }
}

extension MediaPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionCell", for: indexPath) as! MediaCollectionCell

        if type == .image {
            cell.mediaImgVw.isHidden = false
            cell.mediaPlayImgVw.isHidden = true
            cell.playerBaseVw.isHidden = true
        } else {
            cell.mediaImgVw.isHidden = true
            cell.mediaPlayImgVw.isHidden = false
            cell.playerBaseVw.isHidden = false
        }
        //cell.mediaImgVw.image = UIImage(named: "profile")
        let obj = galleryArr[indexPath.row].file ?? ""
        cell.mediaImgVw.sd_setImage(with: URL(string: obj), placeholderImage: #imageLiteral(resourceName: "AvaitionNewLogo"), options: .progressiveLoad, completed: .none)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mediaCollectionView.frame.width - 10, height: self.mediaCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .image {
            print("Image Tapped.")
        } else {
            let VideoURL = galleryArr[indexPath.row].file ?? ""
            
            if let url = URL(string: VideoURL) {
                DispatchQueue.main.async {
                    let player = AVPlayer(url: url)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    self.present(playerController, animated: true) {
                        player.play()
                    }
                }
            }
            
//            DispatchQueue.main.async {
//                Constant.isWatchVideo = false
//                SVProgressHUD.dismiss()
//                let player = AVPlayer(url: documentsURL)
//                let playerController = AVPlayerViewController()
//                playerController.player = player
//                self.present(playerController, animated: true) {
//                    player.play()
//                }
//            }
            
        }
    }
    
    func getCurrentVisibleCellIndexPath() -> IndexPath? {
        guard let collectionView = self.mediaCollectionView else { return nil }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            return indexPath
        }
        
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = getCurrentVisibleCellIndexPath() {
            //print("Currently visible cell index: \(indexPath.row)")
            self.navBarLbl.text = "\(indexPath.row + 1)/\(self.galleryArr.count)"
        }
    }
}
