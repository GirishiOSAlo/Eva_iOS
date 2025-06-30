//
//  VideoCustomView.swift
//  EvaConnect
//
//  Created by Metis on 30/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import AVKit
class VideoCustomView: UIView {
    
    @IBOutlet var MainVideoView: UIView!
    @IBOutlet weak var ContentVideoView: UIView!
    
    var view: UIView!
    var getUrl: String?
    
  
    required init?(coder: NSCoder) {
         super.init(coder: coder)
        MainVideoView = loadViewFromNib()
        addSubview(MainVideoView)
        MainVideoView.frame = bounds
        MainVideoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VideoCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
  
}
