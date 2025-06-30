//
//  AttachmentPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 27/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class AttachmentPopupVC: UIViewController, XIBed {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var cameraLbl: UILabel!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var galleryLbl: UILabel!
    @IBOutlet weak var docBtn: UIButton!
    @IBOutlet weak var docLbl: UILabel!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var audioLbl: UILabel!
    
    var postType: attachmentType = .image
    
    var completion: ((attachmentType)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI(){
        Constants.setUpperCornerRadius(uiView: mainView, radius: 35)
        slideView.layer.cornerRadius = 20
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.completion?(.camera)
    }
    
    @IBAction func galleryTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.completion?(.image)
    }
    
    @IBAction func docTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.completion?(.doc)
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.completion?(.audio)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
