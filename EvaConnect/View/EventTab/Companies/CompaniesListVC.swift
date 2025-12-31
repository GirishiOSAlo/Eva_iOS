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
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchICImgView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var CompanyListTable: UITableView!
    
    let refreshControl = UIRefreshControl()
    var eventId = 0
    var companyListArr: [EventCompanyList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCompanyList(eventID: self.eventId, userID: myUserDefaults.userId, searchTxt: self.searchTextField.text ?? "")
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
            self.searchTextField.text = ""
            self.refreshControl.endRefreshing()
            self.getCompanyList(eventID: self.eventId, userID: myUserDefaults.userId, searchTxt: "")
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

extension CompaniesListVC {
    func getCompanyList(eventID: Int, userID: Int, searchTxt: String) {
        showActivity()

        let url = EndPoints.eventCompanyList
        let params: [String: Any] = [
            "event_id": eventID,
            "id": userID,
            "search": searchTxt
        ]

        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = params.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        let finalURL = urlComponents.url!.absoluteString
        print("finalURL:", finalURL)

        NetworkManagerr.request(finalURL, method: .get) { response in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CompanyDelegateListDataModel.self, from: data)
                if let data = decodedResponse.data {
                    self.companyListArr = data.companies ?? []
                    if (self.companyListArr.count) > 0 {
                        self.noRecordLbl.isHidden = true
                        self.CompanyListTable.isHidden = false
                        DispatchQueue.main.async {
                            self.CompanyListTable.reloadData()
                        }
                    } else {
                        self.noRecordLbl.isHidden = false
                        self.CompanyListTable.isHidden = true
                    }
                } else {
                    print("Error ::", decodedResponse.message ?? "No message")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }

}

extension CompaniesListVC: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTextField.text ?? ""
        DispatchQueue.main.async {
            self.companyListArr = []
            self.CompanyListTable.reloadData()
            self.getCompanyList(eventID: self.eventId, userID: myUserDefaults.userId, searchTxt: searchStr)
        }
    }
}

extension CompaniesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CompanyListTable.dequeueReusableCell(withIdentifier: CompaniesListTableViewCell.id(), for: indexPath) as! CompaniesListTableViewCell
        cell.nameLbl.text = self.companyListArr[indexPath.row].companyName ?? "--"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 60
        let obj = self.companyListArr[indexPath.row].companyName ?? "--"
        let width = self.view.frame.width - 90.0
        let nameLblHeight = self.heightForView(text: obj, font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: width)
        let totalHeight = nameLblHeight + 50.0
        return totalHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CompaniesEmployeeVC.instantiate()
        vc.companyName = self.companyListArr[indexPath.row].companyName ?? "--"
        vc.companyDelegates = self.companyListArr[indexPath.row].delegates ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
