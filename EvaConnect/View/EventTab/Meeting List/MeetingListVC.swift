//
//  MeetingListVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 16/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class MeetingListVC: UIViewController, XIBed, MeetingListCellDelegate {

    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchField: UITextField!

    @IBOutlet weak var dateMainView: UIView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    @IBOutlet weak var listCollectionVwHeight: NSLayoutConstraint!
    var expandedIndexPath: IndexPath?
    var isFromDate:Bool = false
    var fromDate: Date?
    var toDate: Date?
    
    var delegateMeetingsList: [Delegatemeeting] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    func setupUI() {
        self.isFromDate = false
        self.fromLbl.text = "From"
        self.toLbl.text = "To"
        
        self.searchMainView.layer.cornerRadius = 8.0
        self.searchMainView.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8.0)
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.dateMainView.cornerRadius = 8.0
        self.fromLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.toLbl.font = UIFont(name: Myfonts.medium, size: 12.0)
        self.registerCell()
        self.setupCollectionHeight()
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: MeetingListCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }

    @objc func textFieldDidChange(_ textfield: UITextField) {
        print(self.searchField.text ?? "")
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
    
    func setupCollectionHeight() {
        self.listCollectionVwHeight.constant = 0.0
        var totalCellHeight = 0.0
        for (index, event) in delegateMeetingsList.enumerated() {
            let nameLblHeight = self.heightForView(text: event.meetingNotes ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 113.0)
            
            // Default collapsed cell height
            let cellHeight = nameLblHeight + 85.0
            
            // Check if this is the expanded cell
            if let expanded = expandedIndexPath, expanded.row == index {
                totalCellHeight = totalCellHeight + cellHeight + 241.0
            } else {
                totalCellHeight = totalCellHeight + cellHeight
            }
        }
        self.listCollectionVwHeight.constant = totalCellHeight
    }
    
    func didTapDropdownButton(in cell: MeetingListCVC) {
        guard let indexPath = listCollectionVw.indexPath(for: cell) else { return }
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        if let previous = expandedIndexPath, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        // Update the expandedIndexPath
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil // collapse
        } else {
            expandedIndexPath = indexPath // expand new
        }
        
        // Animate height and layout changes
        listCollectionVw.performBatchUpdates {
            listCollectionVw.reloadItems(at: indexPathsToReload)
            self.setupCollectionHeight()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func onFromDateBtnTap(_ sender: UIButton) {
        self.isFromDate = true
        self.openDatePicker()
    }
    
    @IBAction func onToDateBtnTap(_ sender: UIButton) {
        guard fromDate != nil else {
            showAlert(message: "Please select a From Date first.")
            return
        }
        self.isFromDate = false
        self.openDatePicker()
    }
    
    func openDatePicker() {
        let pickerVC = DatePickerSheetViewController()
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.pickerMode = .date

        // Restrict "To Date" to only after "From Date"
        if !isFromDate, let from = fromDate {
            pickerVC.minimumDate = from
        }

        if #available(iOS 15.0, *) {
            if let sheet = pickerVC.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        } else {
            pickerVC.modalPresentationStyle = .formSheet
        }

        pickerVC.onDateSelected = { [weak self] date in
            guard let self = self else { return }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium

            if self.isFromDate {
                self.fromDate = date
                self.fromLbl.text = formatter.string(from: date)

                // Reset toDate if it's before new fromDate
                if let to = self.toDate, to < date {
                    self.toDate = nil
                    self.toLbl.text = ""
                }
            } else {
                self.toDate = date
                self.toLbl.text = formatter.string(from: date)
            }
        }

        present(pickerVC, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Action", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didTapDetailsButton(in cell: MeetingListCVC) {
        guard let indexPath = listCollectionVw.indexPath(for: cell) else { return }
        let event = delegateMeetingsList[indexPath.row]
        print("Details button tapped for event: \(event.meetingNotes ?? "")")
        
        let vc = MeetingListDetailsVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UICollection Delegate & DataSource....
extension MeetingListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegateMeetingsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: MeetingListCVC.ReuseId, for: indexPath) as! MeetingListCVC
                
        cell.baseView.layer.cornerRadius = 0
        cell.baseView.layer.maskedCorners = []
        
        let isFirst = indexPath.item == 0
        let isLast = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        cell.baseView.layer.cornerRadius = 16.0 // or any radius
        cell.baseView.clipsToBounds = true
        
        if isFirst && isLast {
            // Only one item
            cell.baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                               .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.underlineVw.isHidden = true
        } else if isFirst {
            // First item: top corners
            cell.baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.underlineVw.isHidden = false
        } else if isLast {
            // Last item: bottom corners
            cell.baseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.underlineVw.isHidden = true
        }
        
        cell.delegate = self
        cell.isExpanded = (indexPath == expandedIndexPath)
        
        let event = delegateMeetingsList[indexPath.row]
        cell.eventNameLbl.text = event.meetingNotes
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let event = delegateMeetingsList[indexPath.row]
        let nameLblHeight = self.heightForView(text: event.meetingNotes ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 113.0)
        let height = nameLblHeight + 85.0
        
        if indexPath == expandedIndexPath {  //--> Expanded height...
            let cellHeight = height + 241.0 //258.0
            return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
        } else {  //--> Normal height...
            let cellHeight = height
            return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
        }
    }
}
