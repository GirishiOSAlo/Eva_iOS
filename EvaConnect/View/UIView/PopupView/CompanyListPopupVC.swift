//
//  CompanyListPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 01/02/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit


class CompanyListPopupVC: UIViewController,XIBed {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var mainPopUpView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var activeDataType: TableDataType = .string
    
    var companyList: [CompanyList] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var jobSectorList: [Sectors] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var categoryList: [CategoryData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var completion: ((String,Int) -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCells(withTypes: [PopupTableCell.self])
        popupView(uiView: mainPopUpView)
        searchView.layer.cornerRadius = 15
        tableView.delegate = self
        tableView.dataSource = self
        emptyLabel.isHidden = true
//        companySearchQuery()
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//        searchTF.becomeFirstResponder()
        
        switch activeDataType {
        case .string:
            break
        case .sector:
            self.getSectors()
        case .category:
            self.getCategory()
        case .company:
            self.companySearchQuery()
        case .locationRoom:
            break
        case .currentEvent:
            break
        case .allCategory:
            break
        case .currency:
            break
        }
    }

    @IBAction func onCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: API Calls
extension CompanyListPopupVC {
    
    func companySearchQuery() {
        let param: AFParameters = [
            "company_name" : searchTF.text ?? ""
        ]
        NetworkManagerr.request(EndPoints.companyList, method: .post, parameters: param) { (response) in
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let resResult = try jsonDecoder.decode(ComapnyListDataModel.self, from: response.data!)
                    if resResult.error == false {
                        self.tableView.isHidden = false
                        self.companyList = resResult.data ?? []
                        self.emptyLabel.isHidden = !(self.companyList.count > 0)
                    } else {
                        self.presentAlert("Error", resResult.message){
                        }
                    }
                } catch {
                    self.presentAlert("Error", nil, error) {
                    }
                }
            } else {
                self.presentAlert("Error", nil, response.result.error){
                }
            }
        }
    }
    
    func getSectors() {
        let params = [:] as [String: Any]
        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: params) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let sectors = try jsonDecoder.decode(AllSectorModel.self, from: response.data!)
                self?.tableView.isHidden = false
                self?.jobSectorList = sectors.data
                self?.emptyLabel.isHidden = !(self?.jobSectorList.count ?? 0 > 0)
            } catch {
                
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
    
    func getCategory() {
        let params = [:] as [String: Any]
        NetworkManagerr.request(EndPoints.getCategory, method: .post, parameters: params) { [weak self] (response) in
            do {
                let jsonDecoder = JSONDecoder()
                let category = try jsonDecoder.decode(CategoryDataModel.self, from: response.data!)
                self?.tableView.isHidden = false
                self?.categoryList = category.data ?? []
                self?.emptyLabel.isHidden = !(self?.categoryList.count ?? 0 > 0)
            } catch {
                self?.presentAlert("Failure", nil, response.result.error)
                print(error.localizedDescription)
            }
        }
    }
}

extension CompanyListPopupVC: UITextFieldDelegate {
    
    //MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
//        switch activeDataType {
//        case .string:
//            break
//        case .sector:
//            self.getSectors()
//        case .category:
//            self.getCategory()
//        case .company:
//            self.companySearchQuery()
//        }
    }
}

extension CompanyListPopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return companyList.count
        switch activeDataType {
        case .string:
            return 0
        case .sector:
            return jobSectorList.count
        case .category:
            return categoryList.count
        case .company:
            return companyList.count
        case .locationRoom:
            return 0
        case .currentEvent:
            return 0
        case .allCategory:
            return 0
        case .currency:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopupTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
//        cell.titleName.text = companyList[indexPath.row].companyName
        switch activeDataType {
        case .string:
            break
        case .sector:
            cell.titleName.text = jobSectorList[indexPath.row].name
        case .category:
            cell.titleName.text = categoryList[indexPath.row].categoryName
        case .company:
            cell.titleName.text = companyList[indexPath.row].companyName
        case .locationRoom:
            break
        case .currentEvent:
            break
        case .allCategory:
            break
        case .currency:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = companyList[indexPath.row]
        self.dismiss(animated: true)
//        self.completion?(obj.companyName ?? "", obj.id ?? 0)
        switch activeDataType {
        case .string:
            break
        case .sector:
            let obj = jobSectorList[indexPath.row]
            self.completion?(obj.name, obj.id)
        case .category:
            let obj = categoryList[indexPath.row]
            self.completion?(obj.categoryName ?? "", obj.id ?? 0)
        case .company:
            let obj = companyList[indexPath.row]
            self.completion?(obj.companyName ?? "", obj.id ?? 0)
        case .locationRoom:
            break
        case .currentEvent:
            break
        case .allCategory:
            break
        case .currency:
            break
        }
    }
}

// MARK: - ComapnyListDataModel
struct ComapnyListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [CompanyList]?
}

// MARK: - Datum
struct CompanyList: Codable {
    let id: Int?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
    }
}
