//
//  CommonPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 06/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

protocol BusinessSectorPopUpDismiss: AnyObject {
    func openDelegateFilterPopup(businessSector: String)
}

protocol RegionPopUpDismiss: AnyObject {
    func openRegionDelegateFilterPopup(region: String)
}

enum TableDataType {
    case string
    case sector
    case category
    case company
}

class CommonPopupVC: UIViewController {
    
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var completion: ((String, Int) -> ())? = nil
    var isComeFromEventDelegate = false
    var isRegion = false
    var stringArray : [String] = []
    var sectorsArray : [Sectors] = []
    var categoryArray : [CategoryList] = []
    var companyArray : [Companylist] = []
    weak var businessSectorDismissDelegate: BusinessSectorPopUpDismiss?
    weak var regionDismissDelegate: RegionPopUpDismiss?
    
    var activeDataType: TableDataType = .string
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    
    func setupUI(){
        popupView(uiView: mainView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells(withTypes: [PopupTableCell.self])
        
        let viewHeight = self.view.frame.size.height
        let popupHeight = viewHeight - 250.0
        
//        let tblHeight = stringArray.isEmpty ? (CGFloat(sectorsArray.count * 50)) + 60.0 : (CGFloat(stringArray.count * 50)) + 60.0
        let rowCount: Int
        switch activeDataType {
        case .string:
            rowCount = stringArray.count
        case .sector:
            rowCount = sectorsArray.count
        case .category:
            rowCount = categoryArray.count
        case .company:
            rowCount = companyArray.count
        }
        
        let tblHeight = CGFloat(rowCount * 50) + 40.0
        if tblHeight > popupHeight {
            self.tableViewHeight.constant = popupHeight
        } else {
            self.tableViewHeight.constant = tblHeight
        }
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(dismissTapGesture)

    }

    @IBAction func onCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func dismissDidTap() {
        self.dismiss(animated: true)
    }
}

extension CommonPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stringArray.isEmpty ? sectorsArray.count : stringArray.count
//        return self.stringArray.count?
        switch activeDataType {
        case .string:
            return stringArray.count
        case .sector:
            return sectorsArray.count
        case .category:
            return categoryArray.count
        case .company:
            return companyArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PopupTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        if !stringArray.isEmpty {
//            cell.titleName.text = self.stringArray[indexPath.row]
//            return cell
//        } else {
//            cell.titleName.text = self.sectorsArray[indexPath.row].name
//            return cell
//        }
        switch activeDataType {
        case .string:
            cell.titleName.text = stringArray[indexPath.row]
        case .sector:
            cell.titleName.text = sectorsArray[indexPath.row].name // or whatever property
        case .category:
            cell.titleName.text = categoryArray[indexPath.row].categoryName // adjust as needed
        case .company:
            cell.titleName.text = companyArray[indexPath.row].companyName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !stringArray.isEmpty {
//            let selectedStr = self.stringArray[indexPath.row]
//            
//            if self.isComeFromEventDelegate {
//                self.dismiss(animated: true) {
//                    if self.isRegion {
//                        self.regionDismissDelegate?.openRegionDelegateFilterPopup(region: selectedStr)
//                    } else {
//                        self.businessSectorDismissDelegate?.openDelegateFilterPopup(businessSector: selectedStr)
//                    }
//                }
//            } else {
//                self.dismiss(animated: true)
//                self.completion?(selectedStr, 0)
//            }
//            
//        } else {
//            let selectedID = self.sectorsArray[indexPath.row].id
//            let selectedStr = self.sectorsArray[indexPath.row].name
//            self.dismiss(animated: true)
//            self.completion?(selectedStr,selectedID)
//        }
        switch activeDataType {
            
        case .string:
            let selectedStr = stringArray[indexPath.row]
            
            if isComeFromEventDelegate {
                self.dismiss(animated: true) {
                    if self.isRegion {
                        self.regionDismissDelegate?.openRegionDelegateFilterPopup(region: selectedStr)
                    } else {
                        self.businessSectorDismissDelegate?.openDelegateFilterPopup(businessSector: selectedStr)
                    }
                }
            } else {
                self.dismiss(animated: true)
                self.completion?(selectedStr, 0)
            }
            
        case .sector:
            let selectedID = sectorsArray[indexPath.row].id
            let selectedStr = sectorsArray[indexPath.row].name
            self.dismiss(animated: true)
            self.completion?(selectedStr, selectedID)
            
        case .category:
            let selectedID = categoryArray[indexPath.row].id ?? 0
            let selectedStr = categoryArray[indexPath.row].categoryName ?? ""
            self.dismiss(animated: true)
            self.completion?(selectedStr, selectedID)
        case .company:
            let selectedID = companyArray[indexPath.row].id ?? 0
            let selectedStr = companyArray[indexPath.row].companyName ?? ""
            self.dismiss(animated: true)
            self.completion?(selectedStr, selectedID)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
