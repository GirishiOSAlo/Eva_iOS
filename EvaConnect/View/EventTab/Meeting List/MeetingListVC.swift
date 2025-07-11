//
//  MeetingListVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 16/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class MeetingListVC: UIViewController, XIBed, EventMeetingListCellDelegate {

    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    @IBOutlet weak var listCollectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllLabel: UILabel!
    var expandedIndexPath: IndexPath?
    var delegateMeetingsList: [Delegatemeeting] = []
    
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    func setupUI() {
        self.registerCell()
        self.setupCollectionHeight()
        
        let text = "View all"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#4D76CD", alpha: 1.0),
            .font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        viewAllLabel.attributedText = attributedString
        
        viewAllLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllTapped))
        viewAllLabel.addGestureRecognizer(tapGesture)
    }
    
    func registerCell() {
        listCollectionVw.registerNib(cellNib: EventMeetingCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
        
    @objc func viewAllTapped() {
        print("View All tapped")
        let vc = MeetingListDetailsVC.instantiate()
        vc.eventId = self.eventId
        self.navigationController?.pushViewController(vc, animated: true)
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
            let nameHeight = self.heightForView(text: event.meetingNotes ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 113.0)
            let meetingWithHeight = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)
            let colleaguesHeight = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)
            let locationHeight = self.heightForView(text: event.location ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)

            let cellHeight = nameHeight + meetingWithHeight + colleaguesHeight + locationHeight + 206.0
            
            // Check if this is the expanded cell
            if let expanded = expandedIndexPath, expanded.row == index {
                totalCellHeight = totalCellHeight + cellHeight
            } else {
                let collapseHeight = meetingWithHeight + colleaguesHeight + locationHeight + 106.0
                let finalHeight = cellHeight - collapseHeight
                totalCellHeight = totalCellHeight + finalHeight
            }
        }
        self.listCollectionVwHeight.constant = totalCellHeight
    }
    
    func didTapDropdownButton(in cell: EventMeetingCVC) {
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
}

//MARK: UICollection Delegate & DataSource....
extension MeetingListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegateMeetingsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: EventMeetingCVC.ReuseId, for: indexPath) as! EventMeetingCVC
                
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
        
        let event = delegateMeetingsList[indexPath.row]
        cell.eventNameLbl.text = event.meetingNotes ?? "--"
        cell.dateLbl.text = event.startDay ?? "--"
        cell.timeLbl.text = "\(event.startTime ?? "--") - \(event.endTime ?? "--")"
        cell.meetingWithLbl.text = "--"
        cell.colleaguesLbl.text = "--"
        cell.locationLbl.text = event.location ?? "--"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let event = delegateMeetingsList[indexPath.row]
        let nameHeight = self.heightForView(text: event.meetingNotes ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 113.0)
        let meetingWithHeight = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)
        let colleaguesHeight = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)
        let locationHeight = self.heightForView(text: event.location ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 72.0)

        let finalHeight = nameHeight + meetingWithHeight + colleaguesHeight + locationHeight + 206.0
        
        if indexPath == expandedIndexPath {  //--> Expanded height...
            let cellHeight = finalHeight
            return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
        } else {  //--> Normal height...
            let collapseHeight = meetingWithHeight + colleaguesHeight + locationHeight + 106.0
            let cellHeight = finalHeight - collapseHeight
            return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
        }
    }
}
