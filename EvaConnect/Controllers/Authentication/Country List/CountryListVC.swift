//
//  CountryListVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 22/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol CountryVCDismiss: AnyObject {
    func selectedCountryObj(country: Country)
}

class CountryListVC: UIViewController {

    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var completion: ((Country) -> Void)? = nil
    weak var CountryVCDismissDelegate: BusinessSectorPopUpDismiss?
    var countries: [Country] = []
    var filteredCountries: [Country] = [] {
        didSet {
            self.tableView.reloadData()
            if filteredCountries.count == 0 {
                noDataFoundLbl.isHidden = false
            } else {
                noDataFoundLbl.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        noDataFoundLbl.isHidden = true
        popupView(uiView: mainView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells(withTypes: [PopupTableCell.self])
        
        searchView.layer.cornerRadius = 15
        //searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        let viewHeight = self.view.frame.size.height
        let popupHeight = viewHeight - 300.0
        
        self.filteredCountries = self.countries
        
        let tblHeight = CGFloat(countries.count * 50) + 40.0
        if tblHeight > popupHeight {
            self.tableViewHeight.constant = popupHeight
        } else {
            self.tableViewHeight.constant = tblHeight
        }
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(dismissTapGesture)

    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        let query = searchTF.text ?? ""
        if query == "" {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    @IBAction func onCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func dismissDidTap() {
        self.dismiss(animated: true)
    }
    
}

extension CountryListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopupTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let country = filteredCountries[indexPath.row]
        cell.titleName.text = country.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryObj = filteredCountries[indexPath.row]
        self.dismiss(animated: true)
        self.completion?(countryObj)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
