//
//  VenueMapVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 22/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class VenueMapVC: UIViewController, XIBed {

    @IBOutlet weak var venueMapTableView: UITableView!
    var VenueList: [EventVenu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        venueMapTableView.dataSource = self
        venueMapTableView.delegate = self
        venueMapTableView.registerCell(withType: VenueMapCell.self)
    }
}

extension VenueMapVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VenueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = venueMapTableView.dequeueReusableCell(withIdentifier: VenueMapCell.id(), for: indexPath) as! VenueMapCell
        let venueObj = VenueList[indexPath.row]
        if venueObj.floorplanImage != nil {
            cell.venueMapImgView.sd_setImage(with: URL(string: venueObj.floorplanImage ?? ""), placeholderImage: #imageLiteral(resourceName: "eventPlaceholder"), options: .progressiveLoad, completed: .none)
        }
        else {
            cell.venueMapImgView.image = #imageLiteral(resourceName: "eventPlaceholder")
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let image = imgArray[indexPath]
//        if image != nil {
//            let imgString = image!
//            let vc = DownloadChatImgVC.instantiate(imageString: imgString)
//            vc.modalPresentationStyle = .fullScreen
//            vc.isFromHomeVc = true
//            vc.completion = {
//                
//            }
//            self.navigationController?.present(vc, animated: true)
//            print("Selected:", imgString)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
