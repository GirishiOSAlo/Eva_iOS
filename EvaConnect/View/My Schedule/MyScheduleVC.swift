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
    @IBOutlet weak var calenderBaseVw: UIView!
        
    let scrollView = UIScrollView()
    let contentView = UIView()
    var eventID = 0
    let pixelsPerMinute: CGFloat = 1.0
    let scheduleStartHour = 1  // Starting at 01:00
    let scheduleEndHour = 25   // Ending at 24:00
    var eventDetail: NewEventDetailsData?
    var isComeFromDelegate = false
    var otherUserID = 0
    
    private var currentDate = Date() {
        didSet {
            updateDateLabel()
        }
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d'th' MMMM yyyy" // You can customize for "20th September 2021"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
        self.setCalenderView()
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
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        dateLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        createMeetingBtn.cornerRadius = 14.0
        createMeetingBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        self.updateDateLabel()
    }
    
    func setCalenderView() {
        self.setupScrollView()
        self.setupTimeSlots()
        self.setupEvents()
    }
    
    
    @IBAction func onPreviousDateBtnTap(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
    }
    
    @IBAction func onNextDateBtnTap(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
}

//MARK:  Date Update on Button click.....
extension MyScheduleVC {
    func updateDateLabel() {
        dateLbl.text = formattedDate(currentDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        // Add suffix to day
        let suffix: String
        switch day {
        case 1, 21, 31: suffix = "st"
        case 2, 22: suffix = "nd"
        case 3, 23: suffix = "rd"
        default: suffix = "th"
        }
        
        let formatted = dateFormatter.string(from: date)
        return formatted.replacingOccurrences(of: "th", with: suffix)
    }
}

//MARK: Calender Meeting view.....
extension MyScheduleVC {
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.calenderBaseVw.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.calenderBaseVw.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.calenderBaseVw.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.calenderBaseVw.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.calenderBaseVw.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupTimeSlots() {
        for hour in scheduleStartHour..<scheduleEndHour {
            let topOffset = CGFloat((hour - scheduleStartHour) * 60) * pixelsPerMinute
            
            // Time Label
            let label = UILabel()
            label.text = String(format: "%02d:00", hour)
            label.font = UIFont(name: Myfonts.regular, size: 11.0)
            label.textColor = UIColor(hex: "#171930", alpha: 0.4)
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topOffset),
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            ])
            
            // Horizontal Line
            let line = UIView()
            line.backgroundColor = UIColor(hex: "#171930", alpha: 0.07)
            line.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(line)
            
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: label.centerYAnchor), // align with text
                line.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
                line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
        
        let totalMinutes = (scheduleEndHour - scheduleStartHour) * 60
        let totalHeight = CGFloat(totalMinutes) * pixelsPerMinute
        contentView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }

    func setupEvents() {
        // Example: Team Standup 09:45 - 10:15
//        addEvent(title: "Team Standup", startHour: 9, startMinute: 45, durationMinutes: 30)
//        addEvent(title: "Client Call", startHour: 11, startMinute: 30, durationMinutes: 45)
//        addEvent(title: "Lunch Break", startHour: 12, startMinute: 45, durationMinutes: 60)
    }

    func addEvent(title: String, startHour: Int, startMinute: Int, durationMinutes: Int) {
        let eventView = UIView()
        eventView.backgroundColor = UIColor(hex: "#EEEEEE")
        eventView.layer.cornerRadius = 9
        eventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventView)

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: Myfonts.regular, size: 12.0)
        titleLabel.textColor = UIColor(hex: "#171930")

        // Time Label
        let endMinutes = startHour * 60 + startMinute + durationMinutes
        let endHour = endMinutes / 60
        let endMinute = endMinutes % 60

        let timeLabel = UILabel()
        timeLabel.text = String(format: "%02d:%02d - %02d:%02d", startHour, startMinute, endHour, endMinute)
        timeLabel.font = UIFont(name: Myfonts.regular, size: 10.0)
        timeLabel.textColor = UIColor(hex: "#171930", alpha: 0.6)

        // Vertical Stack View
        let vStack = UIStackView(arrangedSubviews: [titleLabel, timeLabel])
        vStack.axis = .horizontal
        vStack.spacing = 2
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        eventView.addSubview(vStack)

        // Calculate Y position
        let totalStartMinutes = (startHour * 60 + startMinute) - (scheduleStartHour * 60)
        let yPos = CGFloat(totalStartMinutes) * pixelsPerMinute
        let height = CGFloat(durationMinutes) * pixelsPerMinute

        // Constraints
        NSLayoutConstraint.activate([
            eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yPos),
            eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            eventView.heightAnchor.constraint(equalToConstant: height),

            vStack.centerYAnchor.constraint(equalTo: eventView.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -16)
        ])
    }
}
