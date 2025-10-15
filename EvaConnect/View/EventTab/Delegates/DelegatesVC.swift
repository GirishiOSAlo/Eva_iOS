//
//  DelegatesVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class DelegatesVC: UIViewController, XIBed {
    
    static func instantiate(eventId: Int, eventAttendeesStatus: String) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        vc.eventAttendeesStatus = eventAttendeesStatus
        return vc
    }

    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var delegateListTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    
    var delegateData: [CommonEventMetaData] = []
    var eventDetail: NewEventDetailsData?
    var eventId = 0
    var eventAttendeesStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.noRecordLbl.isHidden = true
        noRecordLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        searchUiView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        delegateListTable.delegate = self
        delegateListTable.dataSource = self
        delegateListTable.registerCell(withType: DelegatesTableCell.self)
        fetchDelegateList()
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

extension DelegatesVC {
    func fetchDelegateList() {
        let parameters: AFParameters = [ "event_id": eventId,
                                         "page": 1,
                                         "user_type": 4] // "user_type": 4 = Delegates
        showActivity()
        NetworkManagerr.request(EndPoints.eventDropDwnList , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let DelegateDetail = try decoder.decode(CommonEventModel.self, from: response.data!)
                    
                    if !(DelegateDetail.error ?? false) {
                        self.delegateData = DelegateDetail.data?.data ?? []
                        self.delegateListTable.reloadData()
                        if self.delegateData.count > 0 {
                            self.noRecordLbl.isHidden = true
                        } else {
                            self.noRecordLbl.isHidden = false
                        }
                    } else {
                        self.presentAlert("Error","\(DelegateDetail.message ?? "")")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func viewProfileTapped(sender: UIButton) {
        let obj = delegateData[sender.tag]
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = obj.id ?? 0
        vc.eventID = self.eventId
        vc.eventAttendeesStatus = self.eventAttendeesStatus
        vc.eventDetail = self.eventDetail
        vc.isComeFromDelegate = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DelegatesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = delegateListTable.dequeueReusableCell(withIdentifier: DelegatesTableCell.id(), for: indexPath) as! DelegatesTableCell
        let delegate = delegateData[indexPath.row]
        cell.setData(obj: delegate)
        
        cell.viewProfileBtn.tag = indexPath.row
        cell.viewProfileBtn.addTarget(self, action: #selector(self.viewProfileTapped(sender:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 120
        let obj = self.delegateData[indexPath.row]
        let width = self.view.frame.width - 252.0
        let nameLblHeight = self.heightForView(text: obj.firstName ?? "", font: UIFont(name: Myfonts.bold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let designationLblHeight = self.heightForView(text: obj.designation ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let companyLblHeight = self.heightForView(text: obj.companyName ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let totalHeight = nameLblHeight + designationLblHeight + companyLblHeight + 58.0
        return totalHeight
    }
}
