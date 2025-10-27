//
//  CreateMeetingVC.swift
//  EvaConnect
//
//  Created by usama on 22/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
import GoogleSignIn
import GoogleAPIClientForREST
import Lottie

class CreateMeetingVC: BaseVC, WKNavigationDelegate {

    @IBOutlet weak var headerTitleLbl: HeadingLabel!
    @IBOutlet var titleLblCollection: [UILabel]!
    @IBOutlet weak var selectEvent: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var selecMeetingtLocationTF: UITextField!
    @IBOutlet weak var videoConfLinkTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var descTVHeight: NSLayoutConstraint!
    @IBOutlet weak var createMeeting: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var CollectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var createLink: UIButton!
    @IBOutlet weak var selectLocationBtn: UIButton!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var animationView: LottieAnimationView!
    
//    var connections: [UserConnection] = []
//    var attendees: [UserConnection] = []
    var connections: [AttendeesList] = []
    var attendees: [AttendeesList] = []
    var meetingDetailsData: MeetingDetail?
    private var connectionAdded = false
    var invitedIds: [Int] = []
    var invitedEmail: [String] = []
    var isReschedule = false
    var isCancelTapeed = false
    var isGmail = false
    var meetingId = 0
    var eventID: Int?
    var webView: WKWebView!
    var selectedMeetingLocationId = 0
    var otherUserID = 0
    
    var eventDetails: [CreateEventMeetingDetailsData] = []
    var eventDetail: NewEventDetailsData?
    var eventLocations: [EventLocation] = []
    var attendeesList: [AttendeesList] = []
    var currentEventList: [EventListData] = []
    
    var startDatePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
        
    var meetingDetail: MeetingDetail?
    var mode: PostLoadingMode = .create
    private var dateTime = (startDate: "", startTime: "", endDate: "", endTime: "")
    var gMeetLink: String = ""
    var gMeetId: String = ""
    var isComeFromDelegate = false
    
    var eventStartDate = ""
    var eventEndDate = ""
    var eventStartTime = ""
    var eventEndTime = ""
    var isComeFromSideMenu = false
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "466463211660-e9e7lu8nkr3boka6kg7msu2rn9mi5hi5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if self.eventID == 0 {
            self.isComeFromSideMenu = true
            self.fetchCurrentEventData()
        } else {
            self.fetchCreateMeetingDetails()
            if self.isComeFromDelegate {
                self.selectEvent.text = self.eventDetail?.name ?? ""
            } else {
                self.selectEvent.text = self.eventDetails[0].name ?? ""
            }
        }
        
        for lbl in titleLblCollection {
            lbl.font = UIFont(name: Myfonts.bold, size: 14.0)
            lbl.textColor = UIColor(hex: "#000000", alpha: 1.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !connectionAdded { initUI() }
        connectionAdded = false
//        if isReschedule {
//            guard let meetingDetailElement = meetingDetailsData else { return }
//            name.text = meetingDetailElement.title
//            startDate.text = meetingDetailElement.startDate
//            startTime.text = meetingDetailElement.startTime
//            gMeetLink = meetingDetailElement.gmeetLink ?? ""
//            gMeetId = meetingDetailElement.gMeetId ?? ""
//            videoConfLinkTF.text = gMeetLink
//            
//            self.connections = meetingDetailElement.users ?? []
//            
//            self.invitedIds =  connections.compactMap { $0.id }
//            self.invitedEmail = connections.compactMap { $0.email }
//            
//            descriptionTV.textColor = .black
//            descriptionTV.text = meetingDetailElement.details
////            self.attendees = meetingDetailsData?.users ?? []
//            collectionView.reloadData()
//            
//        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeholderLabel.frame = self.descriptionTV.frame
        placeholderLabel.sizeToFit()
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
        self.navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            self.CollectionViewHeightConst.constant = self.collectionView.contentSize.height == 0 ? 100 : self.collectionView.contentSize.height
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InviteConnectionVC {
            destination.invitationType = .attendees
            self.definesPresentationContext = true
            destination.modalPresentationStyle = .currentContext
            destination.delegate = self
        }
    }
    
    @IBAction func createLinkTapped(_ sender: Any) {
//        createGMeetAPICall()
    }
    
    @IBAction func onDatePickerBtnTap(_ sender: UIButton) {
        if self.selectEvent.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a event.")
        } else {
            startDatePickerSet()
            self.startDate.becomeFirstResponder()
        }
    }
    
    @IBAction func onStartTimePickerBtnTap(_ sender: UIButton) {
        if self.selectEvent.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a event.")
        } else {
            startTimePickerSet()
            self.startTime.becomeFirstResponder()
        }
    }
    
    @IBAction func onEndTimePickerBtnTap(_ sender: UIButton) {
        if self.selectEvent.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a event.")
        }
        else if self.startTime.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a start time.")
        }
        else {
            endTimePickerSet()
            self.endTime.becomeFirstResponder()
        }
    }
    
    @IBAction func SelectLoactionBtnTapped(_ sender: UIButton) {
        if self.selectEvent.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "First select a event.")
        } else {
            if self.eventLocations.count == 0 {
                self.makeAlert(titleMsg: "Error", messageData: "Location data is empty")
            } else {
                let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                popupvc.activeDataType = .locationRoom
                popupvc.eventLocations = self.eventLocations
                popupvc.completion = { passedAns, passedId in
                    self.selecMeetingtLocationTF.text = passedAns
                    self.selectedMeetingLocationId = passedId
                }
                self.navigationController?.present(popupvc, animated: true)
            }
        }
    }
    
    @IBAction func selectEventBtnTapped(_ sender: UIButton) {
        if self.isComeFromSideMenu {
            if self.currentEventList.count == 0 {
                self.makeAlert(titleMsg: "Alert", messageData: "Event list not found.")
            } else {
                let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
                popupvc.modalPresentationStyle = .overFullScreen
                popupvc.activeDataType = .currentEvent
                popupvc.currentEventList = self.currentEventList
//                popupvc.completion = { passedAns, passedId in
//                    self.selectEvent.text = passedAns
//                    self.eventID = passedId
//                }
                popupvc.eventCompletion = { selectedEvent in
                    self.selectEvent.text = selectedEvent.name ?? ""
                    self.eventID = selectedEvent.id ?? 0
                    self.eventStartDate = selectedEvent.startDate ?? ""
                    self.eventEndDate = selectedEvent.endDate ?? ""
                    self.eventStartTime = selectedEvent.startTime ?? ""
                    self.eventEndTime = selectedEvent.endTime ?? ""
                    
                    self.fetchCreateMeetingDetails()
                }
                self.navigationController?.present(popupvc, animated: true)
            }
        } else {
            var selectedEvent:[String] = []
            if self.isComeFromDelegate {
                selectedEvent = [self.eventDetail?.name ?? ""]
            } else {
                selectedEvent = [self.eventDetails[0].name ?? ""]
            }
            let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
            popupvc.modalPresentationStyle = .overFullScreen
            popupvc.activeDataType = .string
            popupvc.stringArray = selectedEvent
            popupvc.completion = { passedAns, passedId in
                self.selectEvent.text = passedAns
                //self.selectedEventId = passedId
            }
            self.navigationController?.present(popupvc, animated: true)
        }
    }
}

extension CreateMeetingVC {
    func fetchCreateMeetingDetails() {
        let url = EndPoints.createEventMeetingDetails
        let eventValue: Any = (self.eventID ?? 0) == 0 ? "" : (self.eventID ?? 0)
        
        let parameters = [
            "event_id": eventValue,
            "user_id": myUserDefaults.userId] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingDetails = try jsonDecoder.decode(CreateEventMeetingDetailsDataModel.self, from: response.data!)
                if !(meetingDetails.error ?? false) {
                    self.eventDetails = meetingDetails.data ?? []
                    if self.eventDetails.count > 0 {
                        self.eventLocations = self.eventDetails[0].eventLocations ?? []
                        self.attendeesList = self.eventDetails[0].attendeesList ?? []
                    } else { print("Event Details Not Found.") }
                    
                } else {
                    print("Error :: \(meetingDetails.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func fetchCurrentEventData() {
        let parameters = [
            "filter": "current",
        ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.homeFilterEvents,method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let currentEventRoot = try jsonDecoder.decode(EventListDataModel.self, from: response.data!)
                if !(currentEventRoot.error ?? false) {
                    self.currentEventList = currentEventRoot.data ?? []
                    self.fetchCreateMeetingDetails()
                } else {
                    self.presentAlert("Failure", currentEventRoot.message, nil)
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func createEventMeeting() {
        //date chage :- "dd-mm-yyyy" to "yyyy-mm-dd"
        let startDoneDate = startDate.text ?? ""
        var backendSendStartDate = ""
        if let backendDate = startDoneDate.convertedDate(from: "dd-MM-yyyy", to: "yyyy-MM-dd") {
            backendSendStartDate = backendDate
        }
        
        
        var requestedID = ""
        var invitedUserId:[Int] = []
        
        if self.isComeFromSideMenu {
            requestedID = "\(self.invitedIds[0])"
            if !invitedIds.isEmpty {
                invitedIds.removeFirst()
                invitedUserId = invitedIds
            }
        } else {
            requestedID = "\(self.otherUserID)"
            invitedUserId = self.invitedIds
        }
        
        let url = EndPoints.createEventMeetings
        let parameters = [
            "event_id": "\(eventID)",
            "title": name.text ?? "",
            "date": backendSendStartDate,
            "start_time": startTime.text ?? "",
            "end_time": endTime.text ?? "",
            "description": descriptionTV.text ?? "",
            "location_id": selectedMeetingLocationId,
            "requested_to_id": requestedID,
            "invited_user_ids": invitedUserId ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let networkEventRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(networkEventRoot.error) {
                    print("Success")
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                } else {
                    self.presentAlert("Error",networkEventRoot.message)
                    print("Error :: \(networkEventRoot.message)")
                }
            } catch {
                self.presentAlert("Error",error.localizedDescription)
                print("Error:: ", error)
            }
        }
    }
}

extension CreateMeetingVC {
    
    func initUI() {
        self.successPopupVw.isHidden = true
        videoConfLinkTF.isUserInteractionEnabled = false
        headerTitleLbl.text = mode == .create ? "Create a meeting" : "Edit a meeting"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        descriptionTV.delegate = self
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        collectionView.registerNib(cellNib: AddParticipantCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.reloadData()
        
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 22)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
    }
    
    
//    func parseDate(from dateString: String) -> Date? {
//        let formats = [
//            "yyyy-MM-dd",
//            "dd-MMM-yyyy",
//            "dd-MM-yyyy",
//            "MM/dd/yyyy",
//            "yyyy/MM/dd",
//            "dd MMM yyyy",
//            "MMM dd, yyyy",
//            "yyyyMMdd",
//            "yyyy-MM-dd'T'HH:mm:ss",
//            "yyyy-MM-dd HH:mm:ss"
//            // Add more formats as needed
//        ]
//        
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//
//        for format in formats {
//            formatter.dateFormat = format
//            if let date = formatter.date(from: dateString) {
//                return date
//            }
//        }
//        return nil // No matching format found
//    }
    
    func startDatePickerSet() {
        var eventStartDateStr = ""
        var eventEndDateStr = ""

        // 1️⃣ Get event start & end date strings
        if self.eventDetails.isEmpty {
            eventStartDateStr = self.eventStartDate
            eventEndDateStr = self.eventEndDate
        } else {
            eventStartDateStr = self.eventDetails[0].startDate ?? ""
            eventEndDateStr = self.eventDetails[0].endDate ?? ""
        }
        
        // 2️⃣ Convert strings to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let eventStartDate = DateUtils.parseDate(from: eventStartDateStr),
              let eventEndDate = DateUtils.parseDate(from: eventEndDateStr) else {
            print("❌ Could not parse event date range properly")
            return
        }

        // 3️⃣ Determine min date (today if event started, else event start)
        let today = Calendar.current.startOfDay(for: Date())
        let minDate = max(today, eventStartDate)   // 👉 if today > start, picker starts from today
        let maxDate = eventEndDate

        // 4️⃣ Configure UIDatePicker
        startDatePicker.minimumDate = minDate
        startDatePicker.maximumDate = maxDate
        startDatePicker.date = minDate
        startDatePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }

        // 5️⃣ Toolbar setup
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        // 6️⃣ Assign picker & toolbar to text field
        self.startDate.inputView = startDatePicker
        self.startDate.inputAccessoryView = toolbar
    }

//    func startDatePickerSet() {
//        var eventStartDateStr = ""
//        var eventEndDateStr = ""
//        if self.eventDetails.count == 0 {
//            eventStartDateStr = self.eventStartDate
//            eventEndDateStr = self.eventEndDate
//        } else {
//            eventStartDateStr = self.eventDetails[0].startDate ?? ""
//            eventEndDateStr = self.eventDetails[0].endDate ?? ""
//        }
//        
//        // Date formatter to convert string to Date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        // Convert strings to Date
//        // Set min and max dates if conversion is successful
//        if let startParsedDate = DateUtils.parseDate(from: eventStartDateStr) {
//            print("✅ Parsed Start Date: \(startParsedDate)")
//            startDatePicker.minimumDate = startParsedDate
//            startDatePicker.date = startParsedDate
//        } else {
//            print("❌ Could not parse start date from input: \(eventStartDateStr)")
//        }
//        
//        if let endParsedDate = DateUtils.parseDate(from: eventEndDateStr) {
//            print("✅ Parsed End Date: \(endParsedDate)")
//            startDatePicker.maximumDate = endParsedDate
//        } else {
//            print("❌ Could not parse end date from input: \(eventEndDateStr)")
//        }
//
//        startDatePicker.datePickerMode = .date
//        if #available(iOS 13.4, *) {
//            startDatePicker.preferredDatePickerStyle = .wheels
//        }
//
//        // Toolbar setup
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
//        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
//        toolbar.tintColor = UIColor(hex: "#000000")
//
//        self.startDate.inputView = startDatePicker
//        self.startDate.inputAccessoryView = toolbar
//        
//        
//    }

    
    func startTimePickerSet() {
        var eventStartTimeStr = ""
        var eventEndTimeStr = ""
        
        if self.eventDetails.count == 0 {
            eventStartTimeStr = self.eventStartTime
            eventEndTimeStr = self.eventEndTime
        } else {
            eventStartTimeStr = self.eventDetails[0].startTime ?? ""
            eventEndTimeStr = self.eventDetails[0].endTime ?? ""
        }

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

        self.startTime.inputView = startTimePicker
        self.startTime.inputAccessoryView = toolbar
    }

    
    func endTimePickerSet() {
        let eventStartTimeStr = self.startTime.text ?? ""
        var eventEndTimeStr = ""
        
        if self.eventDetails.count == 0 {
            //eventStartTimeStr = self.eventStartTime
            eventEndTimeStr = self.eventEndTime
        } else {
            //eventStartTimeStr = self.eventDetails[0].startTime ?? ""
            eventEndTimeStr = self.eventDetails[0].endTime ?? ""
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

        self.endTime.inputView = endTimePicker
        self.endTime.inputAccessoryView = toolbar
    }

    
    @objc func doneStartDatePicker() {
        self.startDate.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //startDate.text = formatter.string(from: startDatePicker.date)
        let startDoneDate = formatter.string(from: startDatePicker.date)
        startDate.text = startDoneDate.convertedDate(from: "yyyy-MM-dd", to: "dd-MM-yyyy")
        self.view.endEditing(true)
    }
    @objc func doneStartTimePicker() {
        self.startTime.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        startTime.text = formatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneEndTimePicker() {
        self.endTime.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        endTime.text = formatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func meetingButton(_ sender: UIButton) {
        if self.selectEvent.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "Please select a event.")
        }
        else if self.name.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "Please enter the title.")
        }
        else if self.startDate.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "Please select a start date.")
        }
        else if self.startTime.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "Please select a start time.")
        }
        else if self.endTime.text == "" {
            self.makeAlert(titleMsg: "Error", messageData: "Please select an end time.")
        }
        else if self.invitedIds.count == 0 {
            self.makeAlert(titleMsg: "Error", messageData: "Please invite people.")
        } else {
            self.createEventMeeting()
        }
        
//        guard !invitedIds.isEmpty else {
//            self.presentAlert("Alert", "You need to add at least one attendee before creating the meeting")
//            return
//        }
//        
//        GIDSignIn.sharedInstance().signIn()
    }
}

extension CreateMeetingVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        placeholderLabel.isHidden = !textView.text.isEmpty
//        if textView.contentSize.height >= 100 {
//            descriptionTV.isScrollEnabled = true
//        }
//        else {
//            textView.frame.size.height = textView.contentSize.height
//            descriptionTV.isScrollEnabled = false
//        }
        
        var maxHeight = textView.font!.lineHeight * 7
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        //print("Max : \(maxHeight), Estimate : \(estimatedSize)")
        
        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
            placeholderLabel.isHidden = !textView.text.isEmpty
            if estimatedSize.height < 40.0 {
                self.descTVHeight.constant = 40.0
            } else {
                descTVHeight.constant = estimatedSize.height
            }
        } else {
            textView.isScrollEnabled = true
            if textView == descriptionTV {
                descTVHeight.constant = maxHeight
            } else {
                descTVHeight.constant = maxHeight
            }
        }
    }
}

extension CreateMeetingVC {
    func createMeetingAPICall(meetId: String) {
        
        let parameters = [
            "calendar_meeting_id": meetId,
           "title": name.text ?? "",
           "content": descriptionTV.text ?? "",
           "start_date": dateTime.startDate,
           "start_time": dateTime.startTime,
           "end_time": dateTime.endTime,
           "status": "active",
           "attendees": self.invitedIds,
           "meeting_link": gMeetLink
           ] as [String: Any]
        
        let url = EndPoints.createMeetings
        
//                if let meetingDetail = meetingDetail {
//                    url = "\(EndPoints.meetingDetail)\(meetingDetail.id)/"
//                    parameters["modified_by_id"] = LoggedUserDetails.shared.user?.id
//                    parameters["modified_datetime"] = Date().toString(formatter: .standardDateWithTime)
//                    parameters["meeting_id"] = meetingDetail.id
//                    parameters["id"] = meetingDetail.id
//                }
        
        
//        self.createEvent(summary: self.name.text ?? "", startDate: self.dateTime.startDate, startTime: self.dateTime.startTime, emails: self.invitedEmail) { gmeetiD in
//            print("Done creating meet, id - \(gmeetiD ?? "")")
//            
//            let requestIdOnly = self.gMeetLink.replacingOccurrences(of: "https://meet.google.com/", with: "")
//            // Now, requestIdOnly contains only the requestId
//            print("Google: \(requestIdOnly)")
//            
//            self.updateEvent(eventId: gmeetiD ?? "", summary: "Girish Reschedule Meet", startDate: self.dateTime.startDate, startTime: self.dateTime.startTime, email: self.invitedEmail, requestIdOnly: requestIdOnly) { updatedEventId in
//                print("Done Update Event ID :: \(updatedEventId ?? "")")
//            }
//        }
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            let jsonDecoder = JSONDecoder()
            guard let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from:response.data!) else {
                self.presentAlert("Failure", "Something went wrong", nil)
                return
            }

            if !genericResponse.error { //, genericResponse.message == "Creation Successful." || genericResponse.message == "Update Record Successful." {
//                        self.presentAlertWithAction(title: "Success", message: self.meetingDetail.isNil ? "Meeting Created" : "Meeting Updated") {
//                            self.navigationController?.popViewController(animated: true)
//                        }
                self.presentAlert("Success", genericResponse.message, nil){
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.presentAlert("Failure", genericResponse.message, nil)
            }
        }
    }

    func updateEvent(eventId: String, summary: String, startDate: String, startTime: String, email: [String], requestIdOnly: String, completion: @escaping (String?) -> Void) {
        // Run the task asynchronously using async-await
        Task {
            do {
                
                // Retrieve the event
                let query = GTLRCalendarQuery_EventsGet.query(withCalendarId: "primary", eventId: eventId)
                service.executeQuery(query) { [self] (ticket, eventObject, error) in
                    guard let event = eventObject as? GTLRCalendar_Event, error == nil else {
                        print("Error retrieving event: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                        return
                    }
                    
                    // Update event summary
                    event.summary = summary
                    
                    // Parse the start date and time
                    let startdateTimeBoth = "\(startDate) \(startTime)"
                    //                    let dateFormatter = DateFormatter()
                    //                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                    //                    guard let startDate = dateFormatter.date(from: startdateTimeBoth) else {
                    //                        completion(nil)
                    //                        return
                    //                    }
                    
                    let cleanedDateString = startdateTimeBoth.replacingOccurrences(of: "([0-9]+)(st|nd|rd|th)", with: "$1", options: .regularExpression)

                    // Create a DateFormatter to parse the original date string
                    let inputDateFormatter = DateFormatter()
                    inputDateFormatter.dateFormat = "d MMMM yyyy hh:mm a"
                    
                    if let date = inputDateFormatter.date(from: cleanedDateString) {
                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "yyyy-MM-dd"
                        let outputString = outputFormatter.string(from: date)
                        print(outputString) // Output: 2024-08-14 06:55 PM
                        
                        // Set the start date and time
                        let startDateTime = GTLRDateTime(date: date)
                        event.start = GTLRCalendar_EventDateTime()
                        event.start?.dateTime = startDateTime
                        
                        // Calculate the end date and time (30 minutes later)
                        let endDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
                        let endDateTime = GTLRDateTime(date: endDate)
                        event.end = GTLRCalendar_EventDateTime()
                        event.end?.dateTime = endDateTime
                        
                        // Set up Google Meet conference if it doesn't exist
                        if event.conferenceData == nil {
                            let conferenceData = GTLRCalendar_ConferenceData()
                            let request = GTLRCalendar_CreateConferenceRequest()
                            let solutionKey = GTLRCalendar_ConferenceSolutionKey()
                            solutionKey.type = "hangoutsMeet"
                            request.conferenceSolutionKey = solutionKey
                            request.requestId = requestIdOnly
                            conferenceData.createRequest = request
                            event.conferenceData = conferenceData
                        } 
                        
//                        else {
//                            let conferenceData = GTLRCalendar_ConferenceData()
//                            let request = GTLRCalendar_CreateConferenceRequest()
//                            let solutionKey = GTLRCalendar_ConferenceSolutionKey()
//                            solutionKey.type = "hangoutsMeet"
//                            request.conferenceSolutionKey = solutionKey
//                            request.requestId = requestIdOnly
//                            conferenceData.createRequest = request
//                            event.conferenceData = conferenceData
//                        }
                        
                        // Add attendees
                        let attendees = email.map { email in
                            let attendee = GTLRCalendar_EventAttendee()
                            attendee.email = email
                            return attendee
                        }
                        event.attendees = attendees
                        
                        // Set reminders
                        let emailReminder = GTLRCalendar_EventReminder()
                        emailReminder.method = "email"
                        emailReminder.minutes = NSNumber(value: 24 * 60)
                        
                        let popupReminder = GTLRCalendar_EventReminder()
                        popupReminder.method = "popup"
                        popupReminder.minutes = NSNumber(value: 10)
                        
                        // Create reminders
                        let reminders = event.reminders
                        reminders?.useDefault = true
                        let eventReminder = GTLRCalendar_EventReminder()
                        event.reminders = reminders
                        
                        // Update the event
                        let updateQuery = GTLRCalendarQuery_EventsUpdate.query(withObject: event, calendarId: "primary", eventId: eventId)
                        updateQuery.conferenceDataVersion = 1
                        updateQuery.sendNotifications = true
                        
                        self.service.executeQuery(updateQuery) { (ticket, updatedEventObject, updateError) in
                            if let updateError = updateError {
                                print("Error updating event: \(updateError.localizedDescription)")
                                completion(nil)
                                return
                            }
                            
                            guard let updatedEvent = updatedEventObject as? GTLRCalendar_Event else {
                                print("Failed to cast updated event object")
                                completion(nil)
                                return
                            }
                            
                            let updatedEventId = updatedEvent.identifier
                            completion(updatedEventId)
                        }
                        
                        
                    } else {
                        print("Invalid input string")
                        return
                    }
                    
                }
            }
        }
    }
    
    func createGMeetAPICall(){
        let parameters = [
           "summary": "summary9",
           "description": descriptionTV.text ?? "test",
           "start_datetime": "2024-02-25 15:30:00",
           "meeting_link": ""] //\(dateTime.startDate) \(dateTime.startTime)"]
            as [String: Any]

        let url = EndPoints.createGMeet

        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            
            let apiResponseData: Data = response.data!
            if let apiResponseString = String(data: apiResponseData, encoding: .utf8) {
                print("API Response as String: \(apiResponseString)")
                
                // Create WKWebView
                self.webView = WKWebView(frame: self.view.bounds)
                self.view.addSubview(self.webView)
                
                    
                       // Load a website or HTML content
                    self.webView.loadHTMLString(apiResponseString, baseURL: nil)
                       
                       // Add a close button
                       let closeButton = UIButton(type: .system)
                       closeButton.setTitle("Close", for: .normal)
                closeButton.addTarget(self, action: #selector(self.closeWebView), for: .touchUpInside)
                       closeButton.frame = CGRect(x: 16, y: 32, width: 60, height: 30)
                self.view.addSubview(closeButton)
                
                
            } else {
                print("Failed to convert API response data to string.")
            }
//            let jsonDecoder = JSONDecoder()
//            guard let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from:response.data!) else {
//                self.presentAlert("Failure", "Something went wrong", nil)
//                return
//            }
//
//            if !genericResponse.error {
//                self.isGmail = true
//                self.presentAlert("Success", genericResponse.message, nil) {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            } else {
//                self.presentAlert("Failure", genericResponse.message, nil)
//            }
        }
    }
    
    @objc func closeWebView() {
        self.dismiss(animated: true, completion: nil)
        }
    
    func rescheduleAPICall(){
        
        let attendeeIds = attendees.map { $0.id }
        // attendeeIds is an array of Int? (Optional Int)
        // If some Attendee objects have a nil id, you may want to use compactMap to filter out nil values
        let validAttendeeIds = attendeeIds.compactMap { $0 }
        
        let parameters = [
            "filter": "reschedule",
            "meeting_id": meetingId,
           "title": name.text ?? "",
           "content": descriptionTV.text ?? "",
           "start_date": dateTime.startDate,
           "start_time": dateTime.startTime,
           "end_time": "15:00:00",
            "address": "",
            "city": "",
            "video_link": "",
            "meeting_link": gMeetLink,
           "attendees": validAttendeeIds
           ] as [String: Any]
        
        let url = EndPoints.rescheduleCancelMeeting
        
//                if let meetingDetail = meetingDetail {
//                    url = "\(EndPoints.meetingDetail)\(meetingDetail.id)/"
//                    parameters["modified_by_id"] = LoggedUserDetails.shared.user?.id
//                    parameters["modified_datetime"] = Date().toString(formatter: .standardDateWithTime)
//                    parameters["meeting_id"] = meetingDetail.id
//                    parameters["id"] = meetingDetail.id
//                }
        showActivity()
        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
            self.hideActivity()
            let jsonDecoder = JSONDecoder()
            guard let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from:response.data!) else {
                self.presentAlert("Failure", "Something went wrong", nil)
                return
            }

            if !genericResponse.error { //, genericResponse.message == "Creation Successful." || genericResponse.message == "Update Record Successful." {
//                        self.presentAlertWithAction(title: "Success", message: self.meetingDetail.isNil ? "Meeting Created" : "Meeting Updated") {
//                            self.navigationController?.popViewController(animated: true)
//                        }
                self.presentAlert("Success", genericResponse.message, nil){
                    if let navigationController = self.navigationController {
                        for viewController in navigationController.viewControllers {
                            // Find ViewController A in the navigation stack
                            if let vc = viewController as? CalendarVC {
                                // Pop to ViewController A
                                navigationController.popToViewController(vc, animated: true)
                                break
                            }
                        }
                    }
                }
            } else {
                self.presentAlert("Failure", genericResponse.message, nil)
            }
        }
    }
}


extension CreateMeetingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.isReschedule ? attendees.count + 1 : connections.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell else {
            return UICollectionViewCell()
        }
        if isReschedule {
            if indexPath.row == self.attendees.count {
            cell.defaultUI()
            return cell
            } else {
                //cell.connection = attendees[indexPath.row]
                cell.attendees = attendees[indexPath.row]
                cell.showCross = false
                return cell
            }
        } else {
            if indexPath.row == self.connections.count {
                cell.defaultUI()
                
                return cell
            } else {
                cell.attendees = connections[indexPath.row]
                cell.showCross = true
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isReschedule {
            if indexPath.row == self.attendees.count {
                print("Invite")
                reschduleTappedCell()
            } else {
                print("Remove")
                removeParticipant(indexPath)
            }
        } else {
//            if indexPath.row == connections.count {
            if indexPath.row == connections.count {
                print("Invite")
                tappedCell()
            }else {
                print("Remove")
                removeParticipant(indexPath)
            }
        }
    }
    
    private func removeParticipant(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: Constants.Label.removeParticipantTitle, message: Constants.Label.removeParticipantMessage, style: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            if self.attendees.count > 0 {
                self.attendees.remove(at: indexPath.item)
            } else {
                self.connections.remove(at: indexPath.item)
                self.invitedIds = self.connections.compactMap { $0.id }
                //self.invitedEmail = self.connections.compactMap { $0.email }
            }
            self.collectionView.deleteItems(at: [indexPath])
        }))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width/2.3), height: 81.0)
    }
}

extension CreateMeetingVC: AddParticipantActionable {

    func tappedCell() {
        let storyboard = UIStoryboard(name: "Meetings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
        vc.attendeesList = attendeesList
        
        vc.completion = { ids, users in
            self.connections = users
            self.invitedIds =  ids.compactMap { $0 }
            
            let totalcount = self.connections.count + 1
            if totalcount % 2 == 0 { //Even Number
                self.CollectionViewHeightConst.constant = CGFloat(totalcount/2) * 81.0
            } else { //Odd Number
                self.CollectionViewHeightConst.constant = (CGFloat(totalcount/2) * 81.0) + 81.0
            }

            self.collectionView.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    func reschduleTappedCell() {
        let storyboard = UIStoryboard(name: "Meetings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
        
        //vc.passedConnections = isReschedule ? attendees : connections
        vc.attendeesList = isReschedule ? attendees : connections
        vc.completion = { ids, users in
            self.connections = users
            self.invitedIds = ids.compactMap { $0 }
            //self.invitedEmail = users.compactMap { $0.email }
            self.collectionView.reloadData()
        }
        self.present(vc, animated: true)
    }
}

extension CreateMeetingVC: ConnectionsProvidable {
    func updateConnections(connections: [User]) {
//        self.connections = connections.map({ (user: $0, type: .invited) })
//        self.connections.append((user: User(id: -1, firstName: "Add Participants", email: "", uniqueCode: nil, lastName: "", username: "", dateOfBirth: nil, userImage: nil, city: nil,
//                                            country: nil, bioData: nil, type: nil, status: nil, address: nil, companyName: nil, field: nil, designation: nil, isConnected: nil,
//                                            isReceiver: nil, isOnline: nil, lastOnlineDateTime: nil, connectionID: nil, isNotifications: nil), type: .creator))
        collectionView.reloadData()
    }
}

extension CreateMeetingVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                  withError error: Error!) {
            if let error = error {
                self.presentAlert("Authentication Error", "\(error.localizedDescription)") //(title: "Authentication Error", message: error.localizedDescription)
                self.service.authorizer = nil
            } else {
                self.service.authorizer = user.authentication.fetcherAuthorizer()
                if !(startDate.text.isNilOrEmpty) && !(startTime.text.isNilOrEmpty) && !(descriptionTV.text.isNilOrEmpty) {
                    if LoggedUserDetails.shared.user != nil {
                        if isReschedule {
                            
                            let requestIdOnly = self.gMeetLink.replacingOccurrences(of: "https://meet.google.com/", with: "")
                            // Now, requestIdOnly contains only the requestId
                            print("Google: \(requestIdOnly)")

                            self.updateEvent(eventId: gMeetId, summary: self.name.text ?? "", startDate: startDate.text ?? "", startTime: startTime.text ?? "", email: self.invitedEmail, requestIdOnly: requestIdOnly) { updatedEventId in
                                print("Done Update Event ID :: \(updatedEventId ?? "")")
                                self.rescheduleAPICall()
                            }
                        } else {
        //                    if isGmail {
        //                        createMeetingAPICall()
        //                    } else {
        //                        createGMeetAPICall()
        //                    }
                            self.createEvent(summary: self.name.text ?? "", startDate: self.dateTime.startDate, startTime: self.dateTime.startTime, emails: self.invitedEmail) { gmeetiD in
                                print("Done creating meet, id - \(gmeetiD ?? "")")
                                self.createMeetingAPICall(meetId: gmeetiD ?? "")
//                                let requestIdOnly = self.gMeetLink.replacingOccurrences(of: "https://meet.google.com/", with: "")
//                                // Now, requestIdOnly contains only the requestId
//                                print("Google: \(requestIdOnly)")
//                                
//                                self.updateEvent(eventId: gmeetiD ?? "", summary: "Girish Reschedule Meet", startDate: self.dateTime.startDate, startTime: self.dateTime.startTime, email: self.invitedEmail, requestIdOnly: requestIdOnly) { updatedEventId in
//                                    print("Done Update Event ID :: \(updatedEventId ?? "")")
//                                }
                            }
                        }
                     }
                } else {
                    makeAlert(titleMsg: "Error", messageData: "Please fill all the fields")
                }
            }
        }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
////            showAlert(title: "Authentication Error", message: error.localizedDescription)
//            self.service.authorizer = nil
//        } else {
//            self.service.authorizer = user.authentication.fetcherAuthorizer()
//            addEventoToGoogleCalendar(summary: "summary9", description: "description", startTime: "25/02/2020 09:00", endTime: "25/02/2020 10:00")
//        }
//    }
}

extension CreateMeetingVC {
    // Create an event to the Google Calendar's user
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
        let calendarEvent = GTLRCalendar_Event()
        
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let startDate = dateFormatter.date(from: startTime)
        let endDate = dateFormatter.date(from: endTime)
        
        guard let toBuildDateStart = startDate else {
            print("Error getting start date")
            return
        }
        guard let toBuildDateEnd = endDate else {
            print("Error getting end date")
            return
        }
        calendarEvent.start = buildDate(date: toBuildDateStart)
        calendarEvent.end = buildDate(date: toBuildDateEnd)
        
        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
        
        service.executeQuery(insertQuery) { (ticket, object, error) in
            if error == nil {
                print("Event inserted")
                self.navigationController?.popViewController(animated: true)
            } else {
                print(error)
            }
        }
    }
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    
    func createEvent(summary : String, startDate : String, startTime : String, emails: [String], completion: @escaping (String?) -> Void) {
        // Initialize Google Calendar API service
        let service = GTLRCalendarService()
        // Configure the service with the OAuth token
        //        service.authorizer = GIDSignIn.sharedInstance()?.currentUser?.authentication?.accessToken
        
        if let authentication = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            service.authorizer = authentication.fetcherAuthorizer()
            let event = GTLRCalendar_Event()
            event.summary = summary
            
            let startdateTimeBoth = "\(startDate) \(startTime)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            guard let startDate = dateFormatter.date(from: startdateTimeBoth) else {
                completion(nil)
                return
            }
            
            // Set the start date and time
            let startDateTime = GTLRDateTime(date: startDate)
            event.start = GTLRCalendar_EventDateTime()
            event.start?.dateTime = startDateTime
            
            // Calculate the end date and time (30 minutes later)
            let endDate = Calendar.current.date(byAdding: .minute, value: 30, to: startDate)!
            let endDateTime = GTLRDateTime(date: endDate)
            event.end = GTLRCalendar_EventDateTime()
            event.end?.dateTime = endDateTime
            
            // Create conference data
            let conferenceData = GTLRCalendar_ConferenceData()
            let conferenceRequest = GTLRCalendar_CreateConferenceRequest()
            conferenceRequest.conferenceSolutionKey = GTLRCalendar_ConferenceSolutionKey()
            conferenceRequest.conferenceSolutionKey?.type = "hangoutsMeet"
            conferenceRequest.requestId = UUID().uuidString
            conferenceData.createRequest = conferenceRequest
            event.conferenceData = conferenceData
            
            
            // Create attendees
            
            //            var AllAttendees : [GTLRCalendar_EventAttendee] = []
            let attendees = emails.map { email in
                let attendeeDetails = GTLRCalendar_EventAttendee()
                attendeeDetails.email = email
                attendeeDetails.additionalGuests = (emails.count) as NSNumber
                return attendeeDetails
            }
            
            //            let attendees = emails.map { email in
            //                    let attendee = GTLRCalendar_EventAttendee()
            //                    attendee.email = email
            //                    return attendee
            //                }
            
            event.attendees = attendees
            
            // Create reminders
            let reminders = event.reminders
            reminders?.useDefault = true
            let eventReminder = GTLRCalendar_EventReminder()
            //            reminders?.overrides = [
            //                eventReminder.method?
            //                eventReminder.minutes
            //            ]
            event.reminders = reminders
            
            // Insert the event into the calendar
            let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
            query.conferenceDataVersion = 1
            query.sendNotifications = true
            
            service.executeQuery(query) { ticket, object, error in
                if let error = error {
                    print("Error creating event: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let createdEvent = object as? GTLRCalendar_Event {
                    let eventId = createdEvent.identifier
                    self.gMeetLink = createdEvent.hangoutLink ?? ""
                    completion(eventId)
                } else {
                    completion(nil)
                }
            }
            
        } else {
            print("Error: Authentication object is nil")
            completion(nil)
            return
        }
    }
}
