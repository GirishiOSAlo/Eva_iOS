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
    var companyDelegates: [CompanyDelegate] = []
    var filteredDelegates: [CompanyDelegate] = []
    
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
        
        self.filteredDelegates = self.companyDelegates
        self.employeeListTblVw.reloadData()
        self.noRecordLbl.isHidden = !self.filteredDelegates.isEmpty
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
        let obj = self.filteredDelegates[sender.tag]
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = obj.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompaniesEmployeeVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTextField.text ?? ""
        print("Search Text :: \(searchStr)")
        
        self.searchDelegates(searchText: searchStr)
        self.noRecordLbl.isHidden = !self.filteredDelegates.isEmpty
        self.employeeListTblVw.reloadData()
    }
    
    func searchDelegates(searchText: String) {
        guard !searchText.isEmpty else {
            filteredDelegates = companyDelegates
            return
        }

        filteredDelegates = companyDelegates.filter {
            ($0.firstName ?? "")
                .lowercased()
                .contains(searchText.lowercased())
        }
        
    }
}

extension CompaniesEmployeeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDelegates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeListTblVw.dequeueReusableCell(withIdentifier: DelegatesTableCell.id(), for: indexPath) as! DelegatesTableCell
        let delegate = self.filteredDelegates[indexPath.row]
        cell.setDelegateData(obj: delegate)
        cell.viewProfileBtn.tag = indexPath.row
        cell.viewProfileBtn.addTarget(self, action: #selector(self.viewProfileTapped(sender:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 120
        let obj = self.filteredDelegates[indexPath.row]
        let width = self.view.frame.width - 252.0
        let nameLblHeight = self.heightForView(text: obj.firstName ?? "", font: UIFont(name: Myfonts.bold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let designationLblHeight = self.heightForView(text: obj.designation ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let companyLblHeight = self.heightForView(text: obj.companyName ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), width: width)
        let totalHeight = nameLblHeight + designationLblHeight + companyLblHeight + 58.0
        return totalHeight
    }
}
