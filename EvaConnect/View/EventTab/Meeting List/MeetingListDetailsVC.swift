//
//  MeetingListDetailsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 19/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

class MeetingListDetailsVC: UIViewController, XIBed, MeetingDetailsCellDelegate {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var categoryCollectionVw: UICollectionView!
    var categorySelectedIndex = 0
    var categoryList = ["Requested by You","Requested by Other","With Colleagues","Pending Meetings","Cancelled Meetings","Rescheduled Meetings"]
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    var expandedIndexPath: IndexPath?
    var animationView: LottieAnimationView!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.successPopupVw.isHidden = true
        self.headingLbl.font = UIFont(name: Myfonts.semiBold, size: 14.0)
        self.registerCell()
        self.setupSuccessPopup()
    }
    
    func setupSuccessPopup() {
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 22)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
    }
    
    func registerCell() {
        categoryCollectionVw.registerNib(cellNib: MeetingDetailsCategoryCVC.self)
        categoryCollectionVw.delegate = self
        categoryCollectionVw.dataSource = self
        
        listCollectionVw.registerNib(cellNib: MeetingDetailsCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    func didTapDropdownButton(in cell: MeetingDetailsCVC) {
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
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animationView.center = animationContainerView.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
}


//MARK: UICollection Delegate & DataSource....
extension MeetingListDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.categoryCollectionVw:
            return self.categoryList.count
            
        case self.listCollectionVw:
            return 5
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.categoryCollectionVw:
            let cell = self.categoryCollectionVw.dequeueReusableCell(withReuseIdentifier: MeetingDetailsCategoryCVC.ReuseId, for: indexPath) as! MeetingDetailsCategoryCVC
            
            cell.titleLbl.text = self.categoryList[indexPath.row]
            
            if indexPath.row == self.categorySelectedIndex {
                let selectedColor = UIColor(hex: "#4D76CD", alpha: 1.0)
                cell.baseView.applyBorderWithRadius(color: selectedColor, value: 1.0, radius: 12.0)
                cell.baseView.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.05)
                cell.titleLbl.textColor = selectedColor
            }
            else {
                var unselectColor = UIColor(hex: "#707070", alpha: 0.5)
                cell.baseView.applyBorderWithRadius(color: unselectColor, value: 1.0, radius: 12.0)
                cell.baseView.backgroundColor = UIColor.clear
                cell.titleLbl.textColor = unselectColor
            }
            
            return cell
            
        case self.listCollectionVw:
            let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: MeetingDetailsCVC.ReuseId, for: indexPath) as! MeetingDetailsCVC
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
            
            if self.categorySelectedIndex % 2 == 0 { //Even Number...
                cell.joinMeetingBtn.isHidden = false
            } else { //Odd Number...
                cell.joinMeetingBtn.isHidden = true
            }
            
            cell.rescheduleBtn.tag = indexPath.row
            cell.rescheduleBtn.addTarget(self, action: #selector(openRescheduleVw(sender:)), for: .touchUpInside)
            cell.joinMeetingBtn.tag = indexPath.row
            cell.joinMeetingBtn.addTarget(self, action: #selector(joinMeeting(sender:)), for: .touchUpInside)
            cell.cancelMeetingBtn.tag = indexPath.row
            cell.cancelMeetingBtn.addTarget(self, action: #selector(cancelMeeting(sender:)), for: .touchUpInside)

            return cell
                        
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.categoryCollectionVw:
            let label = UILabel(frame: CGRect.zero)
            label.text = self.categoryList[indexPath.row]
            label.sizeToFit()

            let width = label.frame.width + 25.0
            return CGSize(width: width, height: self.categoryCollectionVw.frame.size.height)
            
        case self.listCollectionVw:
            if indexPath == expandedIndexPath {  //--> Expanded height...
                let cellHeight = 307.0 //(6*45 + 32 top & bottom)
                return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
            } else {  //--> Normal height...
                let cellHeight = 167.0 //(3*45 + 32 top & bottom)
                return CGSize(width: self.listCollectionVw.frame.size.width, height: cellHeight)
            }
            
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case categoryCollectionVw:
            self.categorySelectedIndex = indexPath.row
            self.categoryCollectionVw.reloadData()
            
            if (indexPath.row == 0) { //Requested by You...
            }
            else if (indexPath.row == 1) { //Requested by Other...
            }
            else if (indexPath.row == 2) { //With Colleagues...
            }
            else if (indexPath.row == 3) { //Pending Meetings...
            }
            else if (indexPath.row == 4) { //Cancelled Meetings...
            }
            else if (indexPath.row == 5) { //Rescheduled Meetings
            }
            
            self.listCollectionVw.reloadData()
            
        default: break
        }
    }
    
    @objc func openRescheduleVw(sender: UIButton) {
        let vc = ReschedulePopupVw.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc func joinMeeting(sender: UIButton) {
        self.successPopupVw.isHidden = false
        self.addAnimation()
    }
    
    @objc func cancelMeeting(sender: UIButton) {
        showCustomAlert(title: "Are you sure you want to Cancel this Meeting?", doneTitle: "Confirm", on: self.view) {
            print("Confirmed")
            // Add your action logic here
        }
    }
}
