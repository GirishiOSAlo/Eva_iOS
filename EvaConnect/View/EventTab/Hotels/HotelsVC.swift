//
//  HotelsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HotelsVC: UIViewController, XIBed {

    @IBOutlet weak var listCollectionVw: UICollectionView!
    
    struct Hotel {
        let name: String
        let desc: String
    }
    var hotelsData: [EventHotel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    func setupUI() {
        self.registerCell()
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: SponsorsCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}

//MARK: UICollection Delegate & DataSource....
extension HotelsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotelsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: SponsorsCVC.ReuseId, for: indexPath) as! SponsorsCVC
        
        let hotel = self.hotelsData[indexPath.row]
        cell.profileImgHeight.constant = 160.0
//        if hotel.floorplanImage != nil {
//            cell.venueMapImgView.sd_setImage(with: URL(string: venueObj.floorplanImage ?? ""), placeholderImage: #imageLiteral(resourceName: "eventPlaceholder"), options: .progressiveLoad, completed: .none)
//        }
//        else {
//            cell.venueMapImgView.image = #imageLiteral(resourceName: "eventPlaceholder")
//        }
        cell.nameLbl.text = hotel.hotelname
        cell.subLbl.text = hotel.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hotel = self.hotelsData[indexPath.row]
        let nameLblHeight = self.heightForView(text: hotel.hotelname ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
        let subLblHeight = self.heightForView(text: hotel.description ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
        let totalHeight = nameLblHeight + subLblHeight + 256.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
}
