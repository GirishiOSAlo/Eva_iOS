//
//  MeetingListDetailsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 19/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

enum MeetingDetailBtnEnum: String {
    case approved
    case cancelled
    case rescheduled
    case pending
}

class MeetingListDetailsVC: UIViewController, XIBed, MeetingDetailsCellDelegate {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var categoryCollectionVw: UICollectionView!
    var categorySelectedIndex = 0
//    var categoryList = ["Requested by You","Requested by Other","With Colleagues","Pending Meetings","Cancelled Meetings","Rescheduled Meetings"]
    var categoryList = ["Approved Meetings","Pending Meetings","Cancelled Meetings","Rescheduled Meetings"]
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    var expandedIndexPath: IndexPath?
    var animationView: LottieAnimationView!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    
    var type: MeetingDetailBtnEnum = .approved
    let refreshControl = UIRefreshControl()
    var acceptedMeetingsList: [EventMeeting] = []
    var pendingMeetingsList: [EventMeeting] = []
    var cancelledMeetingsList: [EventMeeting] = []
    var rescheduledMeetingsList: [EventMeeting] = []
    
    var list: [EventMeeting] = [] {
        didSet {
            if list.count > 0 {
                self.noRecordLbl.isHidden = true
            } else {
                self.noRecordLbl.isHidden = false
            }
        }
    }
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.noRecordLbl.isHidden = true
        self.successPopupVw.isHidden = true
        self.headingLbl.font = UIFont(name: Myfonts.semiBold, size: 14.0)
        self.type = .approved
        self.fetchMeetingData()
        self.registerCell()
        self.setupSuccessPopup()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        listCollectionVw.addSubview(refreshControl) // not required when using UITableViewController
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
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.fetchMeetingData()
        }
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
    
    func updateCategoryCollectionHeader() {
        var acceptedMeetingHeader = ""
        var pendingMeetingHeader = ""
        var cancelMeetingHeader = ""
        var rescheduleMeetingHeader = ""
        
        if (self.acceptedMeetingsList.count) == 0 {
            acceptedMeetingHeader = "Approved Meetings"
        } else {
            acceptedMeetingHeader = "Approved Meetings (\(self.acceptedMeetingsList.count))"
        }
        if (self.pendingMeetingsList.count) == 0 {
            pendingMeetingHeader = "Pending Meetings"
        } else {
            pendingMeetingHeader = "Pending Meetings (\(self.pendingMeetingsList.count))"
        }
        if (self.cancelledMeetingsList.count) == 0 {
            cancelMeetingHeader = "Cancelled Meetings"
        } else {
            cancelMeetingHeader = "Cancelled Meetings (\(self.cancelledMeetingsList.count))"
        }
        if (self.rescheduledMeetingsList.count) == 0 {
            rescheduleMeetingHeader = "Rescheduled Meetings"
        } else {
            rescheduleMeetingHeader = "Rescheduled Meetings (\(self.rescheduledMeetingsList.count))"
        }
        self.categoryList = [acceptedMeetingHeader,pendingMeetingHeader,cancelMeetingHeader,rescheduleMeetingHeader]
        self.categoryCollectionVw.reloadData()
    }
}

extension MeetingListDetailsVC {
    func fetchMeetingData() {
        let url = EndPoints.eventMeetingList
        let parameters = [ "eventid" : self.eventId ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingsRoot = try jsonDecoder.decode(MeetingListDataModel.self, from: response.data!)
                if !(meetingsRoot.error!) {
                    self.acceptedMeetingsList = meetingsRoot.data?.acceptedMeetings ?? []
                    self.pendingMeetingsList = meetingsRoot.data?.pendingMeetings ?? []
                    self.cancelledMeetingsList = meetingsRoot.data?.cancelledMeetings ?? []
                    self.rescheduledMeetingsList = meetingsRoot.data?.rescheduledMeetings ?? []
                    
                    self.updateCategoryCollectionHeader()
                    self.list = self.acceptedMeetingsList
                    self.listCollectionVw.reloadData()
                } else {
                    print("Error :: \(meetingsRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}


//MARK: UICollection Delegate & DataSource....
extension MeetingListDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.categoryCollectionVw:
            return self.categoryList.count
            
        case self.listCollectionVw:
            return self.list.count
            
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
                let unselectColor = UIColor(hex: "#707070", alpha: 0.5)
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
            let obj = self.list[indexPath.row]
            cell.setData(obj: obj)
            
//            if self.categorySelectedIndex % 2 == 0 { //Even Number...
//                cell.joinMeetingBtn.isHidden = false
//            } else { //Odd Number...
//                cell.joinMeetingBtn.isHidden = true
//            }

            cell.joinMeetingBtn.isHidden = false
            cell.cancelMeetingBtn.isHidden = false
            cell.rescheduleBtn.isHidden = false
            cell.messageBtn.isHidden = false
            if self.type == .approved {
                cell.joinMeetingBtn.isHidden = true
            }
            else if self.type == .cancelled {
                cell.joinMeetingBtn.isHidden = true
                cell.cancelMeetingBtn.isHidden = true
            }
            else if self.type == .rescheduled {
                // all button show...
            }
            else if self.type == .pending {
                // all button show...
            }
            
            cell.rescheduleBtn.tag = indexPath.row
            cell.rescheduleBtn.addTarget(self, action: #selector(openRescheduleVw(sender:)), for: .touchUpInside)
            cell.joinMeetingBtn.tag = indexPath.row
            cell.joinMeetingBtn.addTarget(self, action: #selector(joinMeeting(sender:)), for: .touchUpInside)
            cell.cancelMeetingBtn.tag = indexPath.row
            cell.cancelMeetingBtn.addTarget(self, action: #selector(cancelMeeting(sender:)), for: .touchUpInside)
            cell.messageBtn.tag = indexPath.row
            cell.messageBtn.addTarget(self, action: #selector(message(sender:)), for: .touchUpInside)

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
                var cellHeight = 0.0
                if self.type == .cancelled {
                    cellHeight = 262.0 //(-45 button view hidden)
                } else {
                    cellHeight = 307.0 //(6*45 + 32 top & bottom)
                }
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
            
            self.list = []
            if (indexPath.row == 0) { //Approved Meetings...
                self.type = .approved
                self.list = self.acceptedMeetingsList
            }
            else if (indexPath.row == 1) { //Pending Meetings...
                self.type = .pending
                self.list = self.pendingMeetingsList
            }
            else if (indexPath.row == 2) { //Cancelled Meetings...
                self.type = .cancelled
                self.list = self.cancelledMeetingsList
            }
            else if (indexPath.row == 3) { //Rescheduled Meetings
                self.type = .rescheduled
                self.list = self.rescheduledMeetingsList
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
    
    @objc func message(sender: UIButton) {
        //
    }
}
