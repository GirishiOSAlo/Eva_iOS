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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.registerCell()
        updateCollectionHeigth()
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: VenueCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    func updateCollectionHeigth() {
        self.collectionVwHeight.constant = CGFloat(self.venueList.count) * 250.0
    }
}

//MARK: UICollection Delegate & DataSource....
extension VenueMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.venueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: VenueCVC.ReuseId, for: indexPath) as! VenueCVC
        
        let venue = self.venueList[indexPath.row]

        if let imageUrl = venue.floorplanImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
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
