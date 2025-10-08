//
//  HotelsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class HotelsVC: UIViewController, XIBed {

    @IBOutlet weak var collectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var listCollectionVw: UICollectionView!
    var hotelsData: [EventHotel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    func setupUI() {
        self.registerCell()
        updateCollectionHeigth()
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
    
    func updateCollectionHeigth() {
        var finalHeight = 0.0
        for (i,hotel) in self.hotelsData.enumerated() {
            let nameLblHeight = self.heightForView(text: hotel.hotelname ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
            
            var descLblHeight = 0.0
            let desc = hotel.description ?? ""
            if let attributed = desc.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
                let labelWidth = self.view.frame.width - 96.0
                descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: self.view.frame.width - 96.0)
            } else {
                descLblHeight = self.heightForView(text: desc, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
            }
            finalHeight = nameLblHeight + descLblHeight + 256.0
        }
        self.collectionVwHeight.constant = finalHeight
    }
    
    func calculateAttributedLblHeight(attributedText: NSAttributedString, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let boundingRect = attributedText.boundingRect(with: size, options: options, context: nil)
        return ceil(boundingRect.height)
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

        if let imageUrl = hotel.image,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
        } else {
            cell.profileImgVw.image = UIImage(named: "eventPlaceholder")
        }
        cell.nameLbl.text = hotel.hotelname ?? "--"
        cell.subLbl.text = "\(hotel.address ?? "--"), \(hotel.city ?? "--")"
//        let content = hotel.description ?? "--"
//        if let attributed = content.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
//            cell.subLbl.attributedText = attributed
//            cell.subLbl.textAlignment = .center
//        } else {
//            cell.subLbl.text = content
//            cell.subLbl.textAlignment = .center
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hotel = self.hotelsData[indexPath.row]
        let nameLblHeight = self.heightForView(text: hotel.hotelname ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
        
        var descLblHeight = 0.0
        let desc = hotel.description ?? ""
        if let attributed = desc.htmlToAttributedString(withFont: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), color: UIColor(hex: "#848397")) {
            descLblHeight = calculateAttributedLblHeight(attributedText: attributed, width: self.view.frame.width - 96.0)
        } else {
            descLblHeight = self.heightForView(text: desc, font: UIFont(name: Myfonts.regular, size: 14) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 96.0)
        }
        let totalHeight = nameLblHeight + descLblHeight + 256.0
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
}
