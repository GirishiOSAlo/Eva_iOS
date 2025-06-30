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
//import GTMSessionFetcher

class CreateMeetingVC: BaseVC, WKNavigationDelegate {

    @IBOutlet weak var headerTitleLbl: HeadingLabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var startDate: UITextField!
//    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
//    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var videoConfLinkTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var createMeeting: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var CollectionViewHeightConst: NSLayoutConstraint!
//    @IBOutlet weak var collectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var createLink: UIButton!
    @IBOutlet weak var selectLocationBtn: UIButton!
    
//    var connections: [(user: User, type: ViewerType)] = []
    var connections: [UserConnection] = []
    var attendees: [UserConnection] = []
    var meetingDetailsData: MeetingDetail?
    private var connectionAdded = false
    var invitedIds: [Int] = []
    var invitedEmail: [String] = []
    var isReschedule = false
    var isCancelTapeed = false
    var isGmail = false
    var meetingId = 0
    var webView: WKWebView!
    
    var locationsArr = ["Meeting Room 1", "Meeting Room 2", "Meeting Room 3"]
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(datePicker_valueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 5
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
//        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.addTarget(self, action: #selector(timePicker_valueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    var meetingDetail: MeetingDetail?
    var mode: PostLoadingMode = .create
    private var dateTime = (startDate: "", startTime: "", endDate: "", endTime: "")
    var gMeetLink: String = ""
    var gMeetId: String = ""
    
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "466463211660-e9e7lu8nkr3boka6kg7msu2rn9mi5hi5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !connectionAdded { initUI() }
        connectionAdded = false
        if isReschedule {
            guard let meetingDetailElement = meetingDetailsData else { return }
            name.text = meetingDetailElement.title
            startDate.text = meetingDetailElement.startDate
            startTime.text = meetingDetailElement.startTime
            gMeetLink = meetingDetailElement.gmeetLink ?? ""
            gMeetId = meetingDetailElement.gMeetId ?? ""
            videoConfLinkTF.text = gMeetLink
            
            self.connections = meetingDetailElement.users ?? []
            
            self.invitedIds =  connections.compactMap { $0.id }
            self.invitedEmail = connections.compactMap { $0.email }
            
            descriptionTV.textColor = .black
            descriptionTV.text = meetingDetailElement.details
//            self.attendees = meetingDetailsData?.users ?? []
            collectionView.reloadData()
            
        }
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
        self.startDate.becomeFirstResponder()
    }
    
    @IBAction func onTimePickerBtnTap(_ sender: UIButton) {
        self.startTime.becomeFirstResponder()
    }
    @IBAction func SelectLoactionBtnTapped(_ sender: UIButton) {
        let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
        popupvc.modalPresentationStyle = .overFullScreen
        popupvc.activeDataType = .string
        popupvc.stringArray = self.locationsArr
        popupvc.completion = { passedAns, passedId in
        }
        self.navigationController?.present(popupvc, animated: true)
    }
}

extension CreateMeetingVC {
    
    func initUI() {
        
        videoConfLinkTF.isUserInteractionEnabled = false
        headerTitleLbl.text = mode == .create ? "Create a meeting" : "Edit a meeting"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        descriptionTV.delegate = self
        descriptionTV.textColor = AppColors.lightBg
        descriptionTV.text = "Describe your Note..."
        
        let toolBar = toolBarAccessory()
        startDate.inputView = datePicker
        startDate.inputAccessoryView = toolBar
//        endDate.inputView = datePicker
//        endDate.inputAccessoryView = toolBar
        startTime.inputView = timePicker
        startTime.inputAccessoryView = toolBar
//        endTime.inputView = timePicker
//        endTime.inputAccessoryView = toolBar
        
        collectionView.registerNib(cellNib: AddParticipantCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
//        if let detail = meetingDetail {
//            name.text = detail.name
//            startDate.text = detail.startDate
//            endDate.text = detail.endDate
//            startTime.text = detail.startTime.in12HourFormat(isUTC: true)
//            endTime.text = detail.endTime.in12HourFormat(isUTC: true)
//            location.text = detail.address
//            descriptionTV.text = detail.content
//            descriptionTV.textColor = .black
//            createMeeting.setTitle("Update", for: .normal)
//            
//            dateTime = (startDate: detail.startDate, startTime: detail.startTime, endDate: detail.endDate, endTime: detail.endTime)
//            connections = detail.attendees.compactMap({ (user: convertAttendeeToUser(attendee: $0), type: .invited) })
//        }
        
//        connections.append((user: User(id: -1, firstName: "Add Participants", email: "", uniqueCode: nil, lastName: "", username: "", dateOfBirth: nil, userImage: nil, city: nil,
//                                       country: nil, bioData: nil, type: nil, status: nil, address: nil, companyName: nil, field: nil, designation: nil, isConnected: nil,
//                                       isReceiver: nil, isOnline: nil, lastOnlineDateTime: nil, connectionID: nil, isNotifications: nil), type: .creator))
//        collectionVwHeight.constant = CGFloat(connections.count) * 61.0
        collectionView.reloadData()
    }
    
    func toolBarAccessory() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func onClickDoneButton() {
        
        if startDate.isFirstResponder {
            startDate.text = datePicker.date.toString(formatter: .apiBody)
            dateTime.startDate = datePicker.date.toString(formatter: .apiBodyUTC)
            startDate.resignFirstResponder()
        }
//        else if endDate.isFirstResponder {
//            endDate.text = datePicker.date.toString(formatter: .apiBody)
//            dateTime.endDate = datePicker.date.toString(formatter: .apiBodyUTC)
//            endDate.resignFirstResponder()
//            
//        }
        else if startTime.isFirstResponder {
            startTime.text = timePicker.date.toString(formatter: .timeOnly)
//            dateTime.startTime = timePicker.date.toString(formatter: .timeOnlyUTC).in12HourFormat()
            dateTime.startTime = timePicker.date.toString(formatter: .timeOnly)
            
            //Select time to next 1hr time.....
            var components = DateComponents()
            components.hour = 1
            let oneHourBefore = Calendar.current.date(byAdding: components, to: timePicker.date)
            dateTime.endTime = oneHourBefore!.toString(formatter: .timeOnly)
            
            startTime.resignFirstResponder()
        }  else {
//            endTime.text = timePicker.date.toString(formatter: .timeOnly)
            dateTime.endTime = timePicker.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//            endTime.resignFirstResponder()
        }
    }
    
//    func handleTimePicker(sender: UIDatePicker) {
//        
//        let todayMinutes = calculateInputMinutes(sender: Date())
//        if startTime.isFirstResponder {
//            
//            if !startDate.text.isNilOrEmpty,
//                let startDate = startDate.text?.date(formatter: .apiBody),
//                let todayDate = Date().toString(formatter: .apiBody).date(formatter: .apiBody),
//                startDate.days(from: todayDate) <= 0 {
//                
//                let startDateMinutes = calculateInputMinutes(sender: sender.date)
//                if todayMinutes - startDateMinutes < 0 {
//                    startTime.text = sender.date.toString(formatter: .timeOnly)
//                    dateTime.startTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//                } else {
//                    self.presentAlert("Time Selection Problem", "You cannot select the Past time", nil)
//                }
//            } else {
//                
//                startTime.text = sender.date.toString(formatter: .timeOnly)
//                dateTime.startTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//            }
//        } else {
//            
//            guard let startDatee = startDate.text?.date(formatter: .apiBody) else { return }
////            guard let endDate = endDate.text?.date(formatter: .apiBody) else { return }
//            
//            let difference = endDate.days(from: startDatee)
//            
//            if difference == 0 {
//                
//                
//                let startTimeAndDateString = String(format: "%@ %@", self.startDate.text!, self.startTime.text!)
//                let startTimeAndDate = startTimeAndDateString.date(formatter: .combinedStandardDateAndTime)
//                let startDateMinutes = calculateInputMinutes(sender: startTimeAndDate!)
//                let endDateMinutes = calculateInputMinutes(sender: sender.date)
//                
//                if startDateMinutes - endDateMinutes < 0 {
//                    endTime.text = sender.date.toString(formatter: .timeOnly)
//                    dateTime.endTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//                } else {
//                    self.presentAlert("Time Selection Problem", "You cannot select the Past time", nil)
//                }
//                
//            } else {
//                if let todayDate = Date().toString(formatter: .apiBody).date(formatter: .apiBody),
//                    endDate.days(from: todayDate) <= 0 {
//                    
//                    let endDateMinutes = calculateInputMinutes(sender: sender.date)
//                    if todayMinutes - endDateMinutes < 0 {
//                        endTime.text = sender.date.toString(formatter: .timeOnly)
//                        dateTime.endTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//                    } else {
//                        self.presentAlert("Time Selection Problem", "You cannot select the Past time", nil)
//                    }
//                } else {
//                    endTime.text = sender.date.toString(formatter: .timeOnly)
//                    dateTime.endTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//                }
//            }
//        }
//    }
    
    func calculateInputMinutes(sender: Date) -> Int {
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender)
        return (components.hour! * 60) + components.minute!
    }
    
    @objc func datePicker_valueChanged(_ sender: UIDatePicker) {
        if startDate.isFirstResponder {
            startDate.text = sender.date.toString(formatter: .apiBody)
            dateTime.startDate = sender.date.toString(formatter: .apiBodyUTC)
        } else {
//            
//            guard let startDate = startDate.text?.date(formatter: .apiBody) else {
//                return
//            }
//            guard let endDate = sender.date.toString(formatter: .apiBody).date(formatter: .apiBody) else {
//                return
//            }
//            
//            if endDate.days(from: startDate) >= 0 {
//                self.endDate.text = sender.date.toString(formatter: .apiBody)
//                dateTime.endDate = sender.date.toString(formatter: .apiBodyUTC)
//            } else {
//                self.presentAlert("Time Selection Problem", "End date should be greater than start date", nil)
//            }
        }
    }
    
    @objc func timePicker_valueChanged(_ sender: UIDatePicker) {
        
//        handleTimePicker(sender: sender)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func meetingButton(_ sender: UIButton) {
        
        guard !invitedIds.isEmpty else {
            self.presentAlert("Alert", "You need to add at least one attendee before creating the meeting")
            return
        }
        
        GIDSignIn.sharedInstance().signIn()
    }
}

extension CreateMeetingVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == AppColors.lightBg {
            textView.text = nil
            textView.textColor = AppColors.textColor2
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 100 {
            descriptionTV.isScrollEnabled = true
        }
        else {
            textView.frame.size.height = textView.contentSize.height
            descriptionTV.isScrollEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your Note..."
            textView.textColor = AppColors.lightBg
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
//        let obj = connections[(indexPath.item) + 1]
//        cell.name.text = obj.firstName
//        cell.occupation.text = obj.companyName
        
        if isReschedule {
            if indexPath.row == self.attendees.count {
            cell.defaultUI()
            return cell
            } else {
                cell.connection = attendees[indexPath.row]
                cell.showCross = false
                return cell
            }
        } else {
            if indexPath.row == self.connections.count {
                cell.defaultUI()
                
                return cell
            } else {
                cell.connection = connections[indexPath.row]
                cell.showCross = true
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if connections[indexPath.item].type == .creator { tappedCell() }
//        else { removeParticipant(indexPath) }
        if isReschedule {
            if indexPath.row == self.attendees.count {
                print("Invite")
                reschduleTappedCell()
            } else {
                print("Remove")
                removeParticipant(indexPath)
            }
        } else {
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
                self.invitedEmail = self.connections.compactMap { $0.email }
            }
            self.collectionView.deleteItems(at: [indexPath])
        }))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width/2.3), height: 81.0)
    }
}


//extension CreateMeetingVC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let inset: CGFloat = 2
//        let width = collectionView.frame.width * 0.25
//        let height = collectionView.frame.height
//        return CGSize(width: width - inset, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 5 }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 5 }
//}

extension CreateMeetingVC: AddParticipantActionable {

    func tappedCell() {
//        if descriptionTV.isFirstResponder { descriptionTV.resignFirstResponder() }
//        performSegue(withIdentifier: Constants.Segues.inviteConnections, sender: nil)
//        connectionAdded = true
        let storyboard = UIStoryboard(name: "Meetings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
        vc.passedConnections = connections
        vc.completion = { ids, users in
            self.connections = users
            
            self.invitedIds =  ids.compactMap { $0 }
            self.invitedEmail = users.compactMap { $0.email }
            
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
        
        vc.passedConnections = isReschedule ? attendees : connections
        vc.completion = { ids, users in
            self.connections = users
            self.invitedIds = ids.compactMap { $0 }
            self.invitedEmail = users.compactMap { $0.email }
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
