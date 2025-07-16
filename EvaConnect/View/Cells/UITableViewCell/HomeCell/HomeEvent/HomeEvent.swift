//
//  HomeEventCell.swift
//  EvaConnect
//
//  Created by Metis on 16/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol HomeEventDelegate: NSObject {
    func intrestedInEvent(dashboardItem: DashboardItem, event: HomeEvent)
}

class HomeEvent: BaseCellClass {
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var saveImgVw: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var navigateToDetail: UIButton!
    
    @IBOutlet weak var saveEventBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    
    var editPostView: EditDeleteView?
    var delegate: PostActionable?
    var isMoreViewSelected = true
    var dashboardItem: DashboardItem!
    
    var intrestedTapped: ((DashboardItem) -> Void)!
    weak var eventDelegate: HomeEventDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
//        makeImageRound(view: userImage)
        
        EditDeleteHandler.sharedInstance.hideMenu(xibOnView: editPostView ?? UIView())

    }
    
    func initUI() {
        self.baseView.layer.cornerRadius = 20.0
        self.viewDetailsBtn.layer.cornerRadius = 14.0
        
        self.titleLbl.font = UIFont(name: Myfonts.semiBold, size: 14.0)
        self.dateLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.locationLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.timeLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.saveBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
    }
    
    func convertTo12HourFormat(from time24: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: time24) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return nil
    }
    
    func uiData(dataMaper: DashboardItem){
        if let imageUrl = dataMaper.tempImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.imgVW.kf.setImage(with: url, placeholder: UIImage(named: "eventPlaceholder"))
        } else {
            self.imgVW.image = UIImage(named: "eventPlaceholder")
        }
        
        self.titleLbl.text = dataMaper.eventName ?? ""
        self.dateLbl.text = "\(dataMaper.eventStartDate ?? "") - \(dataMaper.eventEndDate ?? "")"
        self.locationLbl.text = "\(dataMaper.eventCity ?? ""), \(dataMaper.eventCountry ?? "")"
        
//        var startTime = ""
//        var endTime = ""
//        if let startTime12 = convertTo12HourFormat(from: "\(dataMaper.startTime ?? "")") {
//            startTime = startTime12
//        }
//        if let endTime12 = convertTo12HourFormat(from: "\(dataMaper.endTime ?? "")") {
//            endTime = endTime12
//        }
        self.timeLbl.text = "\(dataMaper.startTime ?? "") - \(dataMaper.endTime ?? "")"
        
        if dataMaper.isNewsSave == 1 {
            self.saveImgVw.image = UIImage(named: "save_selected")
        } else {
            self.saveImgVw.image = UIImage(named: "save")
        }
        
        if dataMaper.isPrivate == 1 {
            self.privateBtn.isHidden = false
        } else {
            self.privateBtn.isHidden = true
        }
    }
    
    func uiData(dataMaper: SearchEvent){
        self.titleLbl.text = dataMaper.name
        self.locationLbl.text = dataMaper.createdDate
        
        self.dateLbl.text = dataMaper.createdDate //eventStartDate?.standardDate(isUTC: true)
        self.locationLbl.text = dataMaper.address
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func attendingBtnTapped() { eventDelegate?.intrestedInEvent(dashboardItem: dashboardItem, event: self) }
    @objc private func intrestedLblTapped() { intrestedTapped(dashboardItem) }
    
    @IBAction func interrestedBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
    }
}

extension HomeEvent: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
