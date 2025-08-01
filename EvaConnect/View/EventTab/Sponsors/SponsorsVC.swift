//
//  SponsorsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SponsorsVC: UIViewController, XIBed {

    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var collectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var listCollectionVw: UICollectionView!
    var sponsorsList: [CommonEventMetaData] = []
    var eventId = 0
    var selectedIndex: Int?
    var currentPage = 1
    var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    func setupUI() {
        self.registerCell()
        updateCollectionHeigth()
        fetchSponsorsList(page: currentPage)
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
        for (i,sponsor) in self.sponsorsList.enumerated() {
            //let sponsor = self.sponsorsList[indexPath.row]
            let nameLblHeight = self.heightForView(text: sponsor.firstName ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
            let subLblHeight = self.heightForView(text: sponsor.companyName ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            finalHeight = nameLblHeight + subLblHeight + 216.0
        }
        self.collectionVwHeight.constant = finalHeight
    }
}

extension SponsorsVC {
    func fetchSponsorsList(page: Int) {
        let parameters: AFParameters = [ "event_id": eventId,
                                         "page": page,
                                         "user_type": 5] //user_type == 5: sponsors
        showActivity()
        NetworkManagerr.request(EndPoints.eventDropDwnList , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let sponsorsDetail = try decoder.decode(CommonEventModel.self, from: response.data!)
                    
                    if !(sponsorsDetail.error ?? false) {
                        self.sponsorsList = sponsorsDetail.data?.data ?? []
                        self.listCollectionVw.reloadData()
                        self.lastPage = sponsorsDetail.data?.lastPage ?? 1
                        self.updateCollectionHeigth()
                    } else {
                        self.presentAlert("Error","\(sponsorsDetail.message ?? "")")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

//MARK: UICollection Delegate & DataSource....
extension SponsorsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sponsorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: SponsorsCVC.ReuseId, for: indexPath) as! SponsorsCVC
        
        let sponsor = self.sponsorsList[indexPath.row]
        cell.profileImgHeight.constant = 120.0
        cell.nameLbl.text = sponsor.firstName ?? ""
        cell.subLbl.text = sponsor.companyName ?? ""
        if let imageUrl = sponsor.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            cell.profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
        } else {
            cell.profileImgVw.image = UIImage(named: "eventPlaceholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sponsor = self.sponsorsList[indexPath.row]
        let nameLblHeight = self.heightForView(text: sponsor.firstName ?? "", font: UIFont(name: Myfonts.semiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 104.0)
        let subLblHeight = self.heightForView(text: sponsor.companyName ?? "", font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
        let totalHeight = nameLblHeight + subLblHeight + 216.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
}
