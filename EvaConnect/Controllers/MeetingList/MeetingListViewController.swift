//
//  MeetingListViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 24/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class MeetingListViewController: UIViewController, XIBed {

    @IBOutlet weak var headingLbl: UILabel!
    
    @IBOutlet weak var searchBaseVw: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var selectDateBaseVw: UIView!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    var fromDatePicker = UIDatePicker()
    var toDatePicker = UIDatePicker()
    var expandedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func setupUI() {
        self.headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.searchBaseVw.applyBorderWithRadius(color: UIColor(hex: "#837A88"), value: 0.5, radius: 8)
        self.searchTF.delegate = self
        self.searchTF.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
        self.selectDateBaseVw.layer.cornerRadius = 8.0
        
        self.registerCell()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        listCollectionVw.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: MeetingListCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.async {
            //self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onFromDateBtnTap(_ sender: UIButton) {
        self.fromDatePickerSet()
        self.fromDateTF.becomeFirstResponder()
    }
    
    @IBAction func onToDateBtnTap(_ sender: UIButton) {
        if fromDateTF.text == "" {
            self.presentAlert("First select from date.")
        } else {
            self.toDatePickerSet()
            self.toDateTF.becomeFirstResponder()
        }
    }
}

extension MeetingListViewController: UITextFieldDelegate {
    @objc func searchTextFieldDidChange(_ textField: UITextField) {
        let searchStr = self.searchTF.text ?? ""
         print("Search Text :: \(searchStr)")
    }
}

extension MeetingListViewController {
    func fromDatePickerSet() {
        // Formatter for display
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Set up UIDatePicker
        fromDatePicker = UIDatePicker()
        fromDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            fromDatePicker.preferredDatePickerStyle = .wheels
        }

        // Set minimum date to today
        let currentDate = Date()
        fromDatePicker.minimumDate = currentDate
        fromDatePicker.date = currentDate // Start at today

        // Setup toolbar with Done and Cancel buttons
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        // Assign inputView and accessoryView to textField
        self.fromDateTF.inputView = fromDatePicker
        self.fromDateTF.inputAccessoryView = toolbar
    }
    
    func toDatePickerSet() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Convert fromDateTF.text to Date
        var minDate = Date() // default to today
        if let fromDateString = self.fromDateTF.text,
           let parsedDate = dateFormatter.date(from: fromDateString) {
            minDate = parsedDate
        }

        // Set up UIDatePicker
        toDatePicker = UIDatePicker()
        toDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            toDatePicker.preferredDatePickerStyle = .wheels
        }

        toDatePicker.minimumDate = minDate
        toDatePicker.date = minDate

        // Setup toolbar with Done and Cancel buttons
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        // Assign inputView and accessoryView to textField
        self.toDateTF.inputView = toDatePicker
        self.toDateTF.inputAccessoryView = toolbar
    }

    
    @objc func doneFromDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let selectedDate = fromDatePicker.date
        self.fromDateTF.text = formatter.string(from: selectedDate)
        self.fromDateTF.resignFirstResponder()
    }
    
    @objc func doneToDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let selectedDate = toDatePicker.date
        self.toDateTF.text = formatter.string(from: selectedDate)
        self.toDateTF.resignFirstResponder()
    }

    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}

extension MeetingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
        cell.isExpanded = (indexPath == expandedIndexPath)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath == expandedIndexPath {  //--> Expanded height...
            return CGSize(width: self.listCollectionVw.frame.size.width, height: 350)
        } else {  //--> Normal height...
            return CGSize(width: self.listCollectionVw.frame.size.width, height: 250)
        }
    }
}

extension MeetingListViewController: MeetingListCellDelegate {
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
            //self.setupCollectionHeight()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
