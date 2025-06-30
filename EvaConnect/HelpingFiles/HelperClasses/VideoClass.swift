//
//  VideoClass.swift
//  EvaConnect
//
//  Created by Metis on 21/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class VideoClass: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(url: String, ratio: AVLayerVideoGravity = .resizeAspectFill) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            //playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            playerLayer?.videoGravity = ratio
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            print("*****Video Link :\(url)")
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}
