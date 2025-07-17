//
//  VenueMapVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 22/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class VenueMapVC: UIViewController, XIBed {

    @IBOutlet weak var collectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var listCollectionVw: UICollectionView!
    var venueList: [EventVenu] = []
    var forPlanImages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.registerCell()
        if venueList.count > 0 {
            self.forPlanImages = venueList[0].floorplanImage ?? []
        }
        
        updateCollectionHeigth()
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: VenueCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    func updateCollectionHeigth() {
        self.collectionVwHeight.constant = CGFloat(self.forPlanImages.count) * 250.0
    }
}

//MARK: UICollection Delegate & DataSource....
extension VenueMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forPlanImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: VenueCVC.ReuseId, for: indexPath) as! VenueCVC
        
        let venueImg = self.forPlanImages[indexPath.row]
        if !venueImg.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: venueImg),
           UIApplication.shared.canOpenURL(url) {
            cell.venueImgVw.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
        } else {
            cell.venueImgVw.image = UIImage(named: "eventPlaceholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.listCollectionVw.frame.size.width, height: 250.0)
    }
}
