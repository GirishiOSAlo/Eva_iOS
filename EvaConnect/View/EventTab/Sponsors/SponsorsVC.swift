//
//  SponsorsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SponsorsVC: UIViewController, XIBed {

    @IBOutlet weak var listCollectionVw: UICollectionView!
    
    struct Sponsor {
        let name: String
        let desc: String
    }
    var sponsorsData: [List] = []
    
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
extension SponsorsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sponsorsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: SponsorsCVC.ReuseId, for: indexPath) as! SponsorsCVC
        
        let sponsor = self.sponsorsData[indexPath.row]
        cell.profileImgHeight.constant = 120.0
        cell.nameLbl.text = sponsor.sponsorName
        cell.subLbl.text = sponsor.description
        if  sponsor.logo != nil {
            cell.profileImgVw.sd_setImage(with: URL(string: (sponsor.logo)!), placeholderImage: #imageLiteral(resourceName: "eventPlaceholder"), options: .progressiveLoad, completed: .none)
        } else {
            cell.profileImgVw.image = #imageLiteral(resourceName: "eventPlaceholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sponsor = self.sponsorsData[indexPath.row]
        let nameLblHeight = self.heightForView(text: sponsor.sponsorName ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
        let subLblHeight = self.heightForView(text: sponsor.description ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
        let totalHeight = nameLblHeight + subLblHeight + 216.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
}
