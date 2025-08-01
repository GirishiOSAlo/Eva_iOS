//
//  MyScheduleVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 26/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class MyScheduleVC: UIViewController, XIBed {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var createMeetingBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var meetingListCollectionVw: UICollectionView!
    
    
    let refreshControl = UIRefreshControl()
    var eventID = 0
    var eventDetail: NewEventDetailsData?
    var isComeFromDelegate = false
    var otherUserID = 0
    
    var scheduleMeetingDateList: [String] = []
    var scheduleMeetinglist: [ScheduleMeetinglist] = []
    var meetinglist: [scheduleMeeting] = []
    var selectedDateIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreateMeetingBtnTap(_ sender: UIButton) {
        print("Create a Meeting")
        let vc = StoryboardRouter.createMeeting()
        vc.eventID = self.eventID
        vc.otherUserID = self.otherUserID
        vc.eventDetail = self.eventDetail
        vc.isComeFromDelegate = self.isComeFromDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        self.noDataLbl.isHidden = true
        self.noDataLbl.font = UIFont(name: Myfonts.regular, size: 16.0)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        meetingListCollectionVw.addSubview(refreshControl)
        
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        dateLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        createMeetingBtn.cornerRadius = 14.0
        createMeetingBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        self.registerCell()
        self.getScheduleData()
    }
    
    func registerCell() {
        meetingListCollectionVw.registerNib(cellNib: ScheduleMeetingCVC.self)
        meetingListCollectionVw.delegate = self
        meetingListCollectionVw.dataSource = self
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
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.getScheduleData()
        }
    }
    
    @IBAction func onPreviousDateBtnTap(_ sender: UIButton) {
        if self.selectedDateIndex == 0 {
            print("Minimum Date")
        } else {
            self.meetinglist = []
            self.selectedDateIndex = self.selectedDateIndex - 1
            let date = self.scheduleMeetingDateList[self.selectedDateIndex]
            self.filterDataByDate(for: date)
            self.setDateTitleLbl(for: date)
        }
    }
    
    @IBAction func onNextDateBtnTap(_ sender: UIButton) {
        if self.selectedDateIndex == (self.scheduleMeetingDateList.count - 1) {
            print("Maximum Date")
        } else {
            self.meetinglist = []
            self.selectedDateIndex = self.selectedDateIndex + 1
            let date = self.scheduleMeetingDateList[self.selectedDateIndex]
            self.filterDataByDate(for: date)
            self.setDateTitleLbl(for: date)
        }
    }
    
}

//MARK:  Date Update on Button click.....
extension MyScheduleVC {
    func formatDateWithOrdinal(_ input: String, from inputFormat: String = "yyyy-MM-dd") -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = inputFormat

        guard let date = formatter.date(from: input) else {
            return nil
        }

        // Get day component
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)

        // Determine ordinal suffix
        let suffix: String
        switch day {
        case 11, 12, 13:
            suffix = "th"
        default:
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        // Format month and year
        formatter.dateFormat = "MMMM yyyy"
        let monthYear = formatter.string(from: date)

        return "\(day)\(suffix) \(monthYear)"
    }

}

extension MyScheduleVC {
    func getScheduleData() {
        let url = EndPoints.scheduleMeeting
        var parameters: [String: Any]? = nil
        
        if self.isComeFromDelegate {
            parameters = [ "user_id" : myUserDefaults.userId,
                           "event_id" : self.eventID ] as [String: Any]
        } else {
            parameters = [ "user_id" : myUserDefaults.userId ] as [String: Any]
        }
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            self.refreshControl.endRefreshing()
            do {
                let jsonDecoder = JSONDecoder()
                let scheduleRoot = try jsonDecoder.decode(ScheduleMeetingDataModel.self, from: response.data!)
                
                if !(scheduleRoot.error!) {
                    if let data = scheduleRoot.data {
                        self.scheduleMeetingDateList = data.scheduleMeetingDate ?? []
                        self.scheduleMeetinglist = data.scheduleMeetinglist ?? []
                        
                        if self.scheduleMeetingDateList.count > 0 {
                            // Call the filter method for a specific date
                            self.selectedDateIndex = 0
                            let date = self.scheduleMeetingDateList[self.selectedDateIndex]
                            self.filterDataByDate(for: date)
                            self.setDateTitleLbl(for: date)
                        } else {
                            print("Date List Empty.")
                            self.noDataLbl.isHidden = !self.scheduleMeetingDateList.isEmpty
                        }
                    }
                } else {
                    print("Error :: \(scheduleRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func filterDataByDate(for date: String) {
        if let filteredMeeting = scheduleMeetinglist.first(where: { $0.startDay == date }) {
            print("Meetings on \(date):")
            self.meetinglist = filteredMeeting.scheduleDateList ?? []
        } else {
            print("No meetings found on \(date)")
        }
        self.meetingListCollectionVw.reloadData()
        self.noDataLbl.isHidden = !self.meetinglist.isEmpty
    }
    
    func setDateTitleLbl(for date: String) {
        if let formatted = self.formatDateWithOrdinal(date) {
            self.dateLbl.text = formatted  // Output: "30th July 2025"
        } else {
            self.dateLbl.text = "--"
        }
    }
}

extension MyScheduleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.meetingListCollectionVw:
            return self.meetinglist.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.meetingListCollectionVw:
            let cell = self.meetingListCollectionVw.dequeueReusableCell(withReuseIdentifier: ScheduleMeetingCVC.ReuseId, for: indexPath) as! ScheduleMeetingCVC
            
            let meeting = self.meetinglist[indexPath.row]
            cell.setData(obj: meeting)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.meetingListCollectionVw:
            let meeting = self.meetinglist[indexPath.row]
            let contain = meeting.title ?? ""
            let lblHeight = self.heightForView(text: contain, font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 160.0)
            let height = lblHeight + 40.0 + 20.0
            return CGSize(width: collectionView.frame.width, height: height)
                        
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}
