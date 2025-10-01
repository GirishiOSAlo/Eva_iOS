//
//  ReschedulePopupVw.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 29/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

protocol MeetingDetailsDelegate: AnyObject {
    func reload()
}

class ReschedulePopupVw: BaseVC, XIBed {

    weak var delegate: MeetingDetailsDelegate?
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet var baseViewCollection: [UIView]!
    @IBOutlet var detilsTitleLbllCollection: [UILabel]!
    @IBOutlet weak var rescheduleBtn: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var starttimeTextField: UITextField!
    @IBOutlet weak var endtimeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    var placeholderLabel : UILabel!
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    var meetingID = 0
    
    var eventDetail: NewEventDetailsData?
    var dashboardEvent: DashboardEventData?
    var isComeFromDashboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.roundCorners([.topRight, .topLeft], radius: 35.0)
    }
    
    func setupUI() {
        self.successPopupVw.isHidden = true
        self.setupTextView()
        self.setupSuccessPopup()
        headingLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        rescheduleBtn.cornerRadius = 14.0
        for baseView in baseViewCollection {
            baseView.applyBorderWithRadius(color: UIColor(hex: "#C3CCDF"), value: 1, radius: 8)
        }
        for lbl in detilsTitleLbllCollection {
            lbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
                
        self.dateTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.starttimeTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.endtimeTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.noteTextView.font = UIFont(name: Myfonts.regular, size: 14.0)
    }
    
    func setupSuccessPopup() {
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 22)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
    }
    
    func setupTextView() {
        noteTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write you reason here..."
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        placeholderLabel.sizeToFit()
        noteTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(hex: "#8C8C8C", alpha: 1.0)
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
        self.dismiss(animated: true) {
            self.delegate?.reload()
        }
    }

    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onDatePickerBtnTap(_ sender: UIButton) {
        datePickerSet()
        self.dateTextField.becomeFirstResponder()
    }
    
    @IBAction func onStartTimePickerBtnTap(_ sender: UIButton) {
        startTimePickerSet()
        self.starttimeTextField.becomeFirstResponder()
    }
    
    @IBAction func onEndTimePickerBtnTap(_ sender: UIButton) {
        if self.starttimeTextField.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a start time.")
        } else {
            endTimePickerSet()
            self.endtimeTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func onRescheduleBtnTap(_ sender: UIButton) {
        if self.dateTextField.text == "" {
            self.presentAlert("Please select a date.")
        }
        else if self.starttimeTextField.text == "" {
            self.presentAlert("Please select a start time.")
        }
        else if self.endtimeTextField.text == "" {
            self.presentAlert("Please select an end time.")
        }
        else {
            self.rescheduleMeeting()
        }
    }
}

extension ReschedulePopupVw {
    func rescheduleMeeting() {
        let url = EndPoints.rescheduleEventMeeting
        let parameters = [
            "rescheduleMeetingid": "\(self.meetingID)",
            "date": self.dateTextField.text ?? "",
            "starttime": self.starttimeTextField.text ?? "",
            "endtime": self.endtimeTextField.text ?? "",
            "description": self.noteTextView.text ?? "" ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let rescheduleRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(rescheduleRoot.error) {
                    print("Success")
                    self.successPopupVw.isHidden = false
                    self.titlePopupLbl.text = rescheduleRoot.message
                    self.addAnimation()
                } else {
                    print("Error :: \(rescheduleRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

extension ReschedulePopupVw {
    func datePickerSet() {
        var eventStartDateStr = ""
        var eventEndDateStr = ""
        if isComeFromDashboard {
            eventStartDateStr = self.dashboardEvent?.startDate ?? ""
            eventEndDateStr = self.dashboardEvent?.endDate ?? ""
        } else {
            eventStartDateStr = self.eventDetail?.startDate ?? ""
            eventEndDateStr = self.eventDetail?.endDate ?? ""
        }

        // Date formatter to convert string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Convert strings to Date
        let eventStartDate = dateFormatter.date(from: eventStartDateStr)
        let eventEndDate = dateFormatter.date(from: eventEndDateStr)

        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        // Set min and max dates if conversion is successful
        if let start = eventStartDate {
            datePicker.minimumDate = start
            datePicker.date = start // Set picker to start from start date
        }
        if let end = eventEndDate {
            datePicker.maximumDate = end
        }

        // Toolbar setup
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.dateTextField.inputView = datePicker
        self.dateTextField.inputAccessoryView = toolbar
    }

    func startTimePickerSet() {
        var eventStartTimeStr = ""
        var eventEndTimeStr = ""
        if isComeFromDashboard {
            eventStartTimeStr = self.dashboardEvent?.startTime ?? ""
            eventEndTimeStr = self.dashboardEvent?.endTime ?? ""
        } else {
            eventStartTimeStr = self.eventDetail?.startTime ?? ""
            eventEndTimeStr = self.eventDetail?.endTime ?? ""
        }
        print("Start Time : \(eventStartTimeStr) & EndTime : \(eventEndTimeStr)")

        // Date formatter for time only
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // Adjust if your format is different
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Get today's date components
        let calendar = Calendar.current
        let now = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)

        // Convert strings to Date objects (applying today's date)
        var minTime: Date?
        var maxTime: Date?
        
        if let startTime = timeFormatter.date(from: eventStartTimeStr),
           let startComponents = calendar.dateComponents([.hour, .minute], from: startTime) as DateComponents? {
            var combinedStart = todayComponents
            combinedStart.hour = startComponents.hour
            combinedStart.minute = startComponents.minute
            minTime = calendar.date(from: combinedStart)
        }

        if let endTime = timeFormatter.date(from: eventEndTimeStr),
           let endComponents = calendar.dateComponents([.hour, .minute], from: endTime) as DateComponents? {
            var combinedEnd = todayComponents
            combinedEnd.hour = endComponents.hour
            combinedEnd.minute = endComponents.minute
            maxTime = calendar.date(from: combinedEnd)
        }

        // Setup picker
        startTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            startTimePicker.preferredDatePickerStyle = .wheels
        }
        // Force 24-hour format
        startTimePicker.locale = Locale(identifier: "en_GB")

        // Apply min and max time (as full Date objects)
        if let min = minTime {
            startTimePicker.minimumDate = min
            startTimePicker.date = min
        }
        if let max = maxTime {
            startTimePicker.maximumDate = max
        }

        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.starttimeTextField.inputView = startTimePicker
        self.starttimeTextField.inputAccessoryView = toolbar
    }

    func endTimePickerSet() {
        let eventStartTimeStr = self.starttimeTextField.text ?? ""
        var eventEndTimeStr = ""
        if isComeFromDashboard {
            //eventStartTimeStr = self.starttimeTextField.text ?? ""
            eventEndTimeStr = self.dashboardEvent?.endTime ?? ""
        } else {
            //eventStartTimeStr = self.starttimeTextField.text ?? ""
            eventEndTimeStr = self.eventDetail?.endTime ?? ""
        }

        // Date formatter for time only
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // Change to "hh:mm a" if your time includes AM/PM
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Get today’s date components
        let calendar = Calendar.current
        let now = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)

        // Convert startTime string to Date
        var minTime: Date?
        var maxTime: Date?

        if let startTime = timeFormatter.date(from: eventStartTimeStr) {
            let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
            var combinedStart = todayComponents
            combinedStart.hour = startComponents.hour
            combinedStart.minute = startComponents.minute
            if let baseTime = calendar.date(from: combinedStart) {
                minTime = calendar.date(byAdding: .minute, value: 15, to: baseTime)
            }
        }

        if let endTime = timeFormatter.date(from: eventEndTimeStr) {
            let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
            var combinedEnd = todayComponents
            combinedEnd.hour = endComponents.hour
            combinedEnd.minute = endComponents.minute
            maxTime = calendar.date(from: combinedEnd)
        }

        // Setup the picker
        endTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            endTimePicker.preferredDatePickerStyle = .wheels
        }
        // Force 24-hour format
        endTimePicker.locale = Locale(identifier: "en_GB")

        // Set min and max time
        if let min = minTime {
            endTimePicker.minimumDate = min
            endTimePicker.date = min
        }
        if let max = maxTime {
            endTimePicker.maximumDate = max
        }

        // Setup toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.endtimeTextField.inputView = endTimePicker
        self.endtimeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneStartDatePicker() {
        self.dateTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneStartTimePicker() {
        self.starttimeTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        self.starttimeTextField.text = formatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneEndTimePicker() {
        self.endtimeTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        self.endtimeTextField.text = formatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}

extension ReschedulePopupVw : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
