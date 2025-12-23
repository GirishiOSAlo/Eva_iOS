//
//  CompaniesEmployeeVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class CompaniesEmployeeVC: UIViewController, XIBed {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var delegateHeaderLbl: UILabel!
    @IBOutlet weak var employeeListTblVw: UITableView!
    var companyName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.noRecordLbl.isHidden = true
        noRecordLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        searchUiView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
        
        self.titleLbl.font = UIFont(name: Myfonts.semiBold, size: 16)
        self.delegateHeaderLbl.font = UIFont(name: Myfonts.semiBold, size: 12)
        self.titleLbl.text = self.companyName

        employeeListTblVw.delegate = self
        employeeListTblVw.dataSource = self
        employeeListTblVw.registerCell(withType: DelegatesTableCell.self)
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
    
    @objc func viewProfileTapped(sender: UIButton) {
//        let obj = delegateData[sender.tag]
//        let vc = StoryboardRouter.othersProfileVC()
//        vc.profileID = obj.id ?? 0
//        vc.eventID = self.eventId
//        vc.eventAttendeesStatus = self.eventAttendeesStatus
//        vc.eventDetail = self.eventDetail
//        vc.isComeFromDelegate = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompaniesEmployeeVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTextField.text ?? ""
        print("Search Text :: \(searchStr)")
    }
}

extension CompaniesEmployeeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeListTblVw.dequeueReusableCell(withIdentifier: DelegatesTableCell.id(), for: indexPath) as! DelegatesTableCell
//        let delegate = delegateData[indexPath.row]
//        cell.setData(obj: delegate)
        cell.viewProfileBtn.tag = indexPath.row
        cell.viewProfileBtn.addTarget(self, action: #selector(self.viewProfileTapped(sender:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 120
        //let obj = self.delegateData[indexPath.row]
        let width = self.view.frame.width - 252.0
        let nameLblHeight = self.heightForView(text: "Name", font: UIFont(name: Myfonts.bold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let designationLblHeight = self.heightForView(text: "Position", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let companyLblHeight = self.heightForView(text: "Company", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let totalHeight = nameLblHeight + designationLblHeight + companyLblHeight + 58.0
        return totalHeight
    }
}
