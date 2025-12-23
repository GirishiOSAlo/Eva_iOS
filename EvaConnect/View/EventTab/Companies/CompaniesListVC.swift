//
//  CompaniesListVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class CompaniesListVC: UIViewController ,XIBed {
    
    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        return vc
    }
    
    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var CompanyListTable: UITableView!
    let refreshControl = UIRefreshControl()
    
    var companyListArr = ["Company 1","Company 2","Company 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }

    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.noRecordLbl.isHidden = true
        noRecordLbl.font = UIFont(name: Myfonts.regular, size: 12.0)
        searchUiView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        CompanyListTable.refreshControl = refreshControl
    }
    
    func registerCell() {
        CompanyListTable.delegate = self
        CompanyListTable.dataSource = self
        CompanyListTable.registerCell(withType: CompaniesListTableViewCell.self)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            //Reload here....
        }
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

extension CompaniesListVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTextField.text ?? ""
        print("Search Text :: \(searchStr)")
    }
}

extension CompaniesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CompanyListTable.dequeueReusableCell(withIdentifier: CompaniesListTableViewCell.id(), for: indexPath) as! CompaniesListTableViewCell
        cell.nameLbl.text = self.companyListArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 60
        let obj = self.companyListArr[indexPath.row]
        let width = self.view.frame.width - 90.0
        let nameLblHeight = self.heightForView(text: obj, font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: width)
        let totalHeight = nameLblHeight + 50.0
        return totalHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CompaniesEmployeeVC.instantiate()
        vc.companyName = self.companyListArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
