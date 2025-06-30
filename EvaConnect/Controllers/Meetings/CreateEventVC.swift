////
////  CreateEventVC.swift
////  EvaConnect
////
////  Created by usama on 27/05/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class CreateEventVC: BaseVC {
//
//    @IBOutlet weak var titleLbl: HeadingLabel!
//    @IBOutlet weak var name: UITextField!
//    @IBOutlet weak var startDate: UITextField!
//    @IBOutlet weak var startTime: UITextField!
//    @IBOutlet weak var endDate: UITextField!
//    @IBOutlet weak var endTime: UITextField!
//    @IBOutlet weak var location: UITextField!
//    @IBOutlet weak var registrationLink: UITextField!
//    @IBOutlet weak var detailsTV: UITextView!
//    @IBOutlet weak var eventType: UITextField!
//    @IBOutlet weak var createEvent: UIButton!
//
//    @IBOutlet weak var coverImage: UIImageView!
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    var connections: [(user: User, type: ViewerType)] = []
//    private var connectionAdded = false
//    
//    var coverImageGesture: UITapGestureRecognizer!
//    var imagePicker = UIImagePickerController()
//    let types = ["Public", "Private"]
//    var startDateString: String!
//    var endDateString: String!
//    var eventDetails: EventDetail?
//    var eventId: Int? = nil
//    var mode: PostLoadingMode = .create
//    var imageChanged = false
//    var isViewControllerPresented: Bool = false
//   
//    
//    lazy var datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.setValidation()
//        datePicker.addTarget(self, action: #selector(datePicker_valueChanged(_:)), for: .valueChanged)
//        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
//        return datePicker
//     }()
//    
//    lazy var timePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .time
//        datePicker.minuteInterval = 5
//        datePicker.addTarget(self, action: #selector(timePicker_valueChanged(_:)), for: .valueChanged)
//        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
//        return datePicker
//    }()
//    
//    lazy var eventTypePicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.delegate = self
//        picker.dataSource = self
//        return picker
//    }()
//    
//    private var dateTime = (startDate: "", startTime: "", endDate: "", endTime: "")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initUI()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        //connections.removeAll()
//        //eventDetails = nil
//        //eventId = nil
//    }
//    
////    deinit {
////        print("controller dismiss")
////    }
////    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if isBeingPresented{
//            isViewControllerPresented = true
//        }
//        else{
//            isViewControllerPresented = false
//        }
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//          if let destination = segue.destination as? InviteConnectionVC {
//              destination.invitationType = .attendees
//              destination.delegate = self
//          }
//      }
//}
//
//extension CreateEventVC {
//    
//    func initUI() {
//        detailsTV.delegate = self
//        detailsTV.text = "Details"
////
//        let toolBar = toolBarAccessory()
//        startDate.inputView = datePicker
//        startDate.inputAccessoryView = toolBar
//        endDate.inputView = datePicker
//        endDate.inputAccessoryView = toolBar
//        startTime.inputView = timePicker
//        startTime.inputAccessoryView = toolBar
//        endTime.inputView = timePicker
//        endTime.inputAccessoryView = toolBar
//        
//        eventType.inputView = eventTypePicker
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.registerNib(cellNib: AddParticipantCell.self)
////        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        coverImage.backgroundColor = AppColors.lightGrey
//        coverImageGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
//        coverImage.addGestureRecognizer(coverImageGesture)
//        imagePickerSetup()
//        handleUI(mode: mode)
//    }
//    
//    func handleUI(mode: PostLoadingMode) {
//        
//        if mode == .edit {
////            getEventDetail()
//            startDate.delegate = self
//            endDate.delegate = self
//            startTime.delegate = self
//            endTime.delegate = self
//            titleLbl.text = "Edit an event"
//        } else {
//            connections.append((user: User(id: -1, firstName: "Add Participants", email: "", uniqueCode: nil, lastName: "", username: "", dateOfBirth: nil, userImage: nil, city: nil,
//                                           country: nil, bioData: nil, type: nil, status: nil, address: nil, companyName: nil, field: nil, designation: nil, isConnected: nil,
//                                           isReceiver: nil, isOnline: nil, lastOnlineDateTime: nil, connectionID: nil, isNotifications: nil), type: .creator))
//            collectionView.reloadData()
//        }
//    }
//    
////    func loadEventDetail(){
////
////        guard let details = eventDetails else {
////            return
////        }
////
////        if details.userID == LoggedUserDetails.shared.user!.id {
////            name.isUserInteractionEnabled = true
////            //dateTime.isUserInteractionEnabled = true
////            location.isUserInteractionEnabled = true
////            //self.details.isUserInteractionEnabled = true
////            eventType.isUserInteractionEnabled = true
////           // eventImage.isUserInteractionEnabled = true
////            picker.delegate = self
////            //viewerType = .creator
////            //register.isHidden = true
////            createEvent.setTitle("Update Event", for: .normal)
////            //editIcon.isHidden = false
////        }
////
////        createEvent.isHidden = false
////        name.text = details.name
////        eventType.text = "Created by \(details.user?.firstName ?? "")"
////
////        if let images = details.eventImage, images.count > 0, let url = URL(string: images[0] ?? "") {
////            coverImage.kf.setImage(with: url)
////        }
////
////        startDate.text = details.startDate?.date(formatter: .apiBodyUTC)?.toString(formatter: .standardEuropeanDate)
////        startTime.text = details.startTime?.in12HourFormat() ?? ""
////
////        endDate.text = details.endDate?.date(formatter: .apiBodyUTC)?.toString(formatter: .standardEuropeanDate)
////        endTime.text = details.endTime?.in12HourFormat()
////
//////        dateTime = (startDate: details.startDate, startTime: details.startTime, endDate: details.endDate, endTime: details.endTime)
////
////        registrationLink.text = details.registrationLink
////
////        //dateTime.text = String(format: "%@ %@ | %@ %@", details.startDate, details.endDate, details.startTime.in12HourFormat(), details.endTime.in12HourFormat())
////        location.text = details.address
////        self.detailsTV.text = details.content.stringValue
////        eventType.text = details.isPrivate == 1 ? "Private" : "Open to the public"
////
//////        connections = details.attendees.compactMap({ (user: convertAttendeeToPartcipant(attendee: $0), type: .invited) })
////        connections.append((user: User(id: -1, firstName: "Add Participants", email: "", uniqueCode: nil, lastName: "", username: "", dateOfBirth: nil, userImage: nil, city: nil,
////                                       country: nil, bioData: nil, type: nil, status: nil, address: nil, companyName: nil, field: nil, designation: nil, isConnected: nil,
////                                       isReceiver: nil, isOnline: nil, lastOnlineDateTime: nil, connectionID: nil, isNotifications: nil), type: .creator))
////       // participants = details.attendees.compactMap({ convertAttendeeToPartcipant(attendee: $0) })
////        collectionView.reloadData()
////    }
//    
////    private func convertAttendeeToPartcipant(attendee: Attendee) -> User {
////        
////        return User(id: mode == .create ? attendee.id : attendee.userID, firstName: attendee.user.firstName ?? "", email: attendee.user.email ?? "", uniqueCode: attendee.user.uniqueCode,
////                    lastName: attendee.user.lastName, username: attendee.user.username ?? "", dateOfBirth: attendee.user.dateOfBirth,
////                    userImage: attendee.user.userImage, city: attendee.user.city, country: attendee.user.country, bioData: attendee.user.bioData,
////                    type: attendee.user.type, status: attendee.user.status ?? "", address: attendee.user.status, companyName: attendee.user.companyName,
////                    field: attendee.user.field, designation: attendee.user.designation, isConnected: attendee.user.isConnected?.rawValue,
////                    isReceiver: attendee.user.isReceiver == "true", isOnline: nil, lastOnlineDateTime: nil,
////                    connectionID: attendee.user.connectionID, isNotifications: attendee.user.is_notifications)
////    }
//    
//    func toolBarAccessory() -> UIToolbar {
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
//        toolBar.setItems([space, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        toolBar.sizeToFit()
//        return toolBar
//    }
//    
//    @objc func onClickDoneButton() {
//        
//        if startDate.isFirstResponder {
//            startDate.text = datePicker.date.toString(formatter: .standardEuropeanDate)
//            dateTime.startDate = datePicker.date.toString(formatter: .apiBodyUTC)
//            startDate.resignFirstResponder()
//        } else if endDate.isFirstResponder {
//            endDate.text = datePicker.date.toString(formatter: .standardEuropeanDate)
//            dateTime.endDate = datePicker.date.toString(formatter: .apiBodyUTC)
//            endDate.resignFirstResponder()
//            
//        } else if startTime.isFirstResponder {
//            startTime.text = timePicker.date.toString(formatter: .timeOnly)
//            dateTime.startTime = timePicker.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//            startTime.resignFirstResponder()
//        }  else {
//            endTime.text = timePicker.date.toString(formatter: .timeOnly)
//            dateTime.endTime = timePicker.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//            endTime.resignFirstResponder()
//        }
//    }
//    
//    func imagePickerSetup() {
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//    }
//    
//    func handleTimePicker(sender: UIDatePicker) {
//        
//        let todayMinutes = calculateInputMinutes(sender: Date())
//        if startTime.isFirstResponder {
//            
//            if !startDate.text.isNilOrEmpty,
//                let startDate = startDate.text?.date(formatter: .standardEuropeanDate),
//                let todayDate = Date().toString(formatter: .standardEuropeanDate).date(formatter: .standardEuropeanDate),
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
//                startTime.text = sender.date.toString(formatter: .timeOnly)
//                dateTime.startTime = sender.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
//            }
//        } else {
//            
//            guard let startDatee = startDate.text?.date(formatter: .standardEuropeanDate) else { return }
//            guard let endDate = endDate.text?.date(formatter: .standardEuropeanDate) else { return }
//            
//            let difference = endDate.days(from: startDatee)
//            
//            if difference == 0 {
//                
//                
//                let startTimeAndDateString = String(format: "%@ %@", self.startDate.text!, self.startTime.text!)
//                let startTimeAndDate = startTimeAndDateString.date(formatter: .combinedDateAndTime)
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
//                if let todayDate = Date().toString(formatter: .standardEuropeanDate).date(formatter: .standardEuropeanDate),
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
//    
//    func calculateInputMinutes(sender: Date) -> Int {
//        
//        let components = Calendar.current.dateComponents([.hour, .minute], from: sender)
//        return (components.hour! * 60) + components.minute!
//    }
//    
//    @objc func tappedImage(_ sender: UITapGestureRecognizer) {
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
//    
//    @objc func datePicker_valueChanged(_ sender: UIDatePicker) {
//        
//        if startDate.isFirstResponder {
//            startDate.text = sender.date.toString(formatter: .standardEuropeanDate)
//            startDateString = sender.date.toString(formatter: .apiBodyUTC)
//            dateTime.startDate = sender.date.toString(formatter: .apiBodyUTC)
//        } else {
//            
//            guard let startDate = startDate.text?.date(formatter: .standardEuropeanDate) else {
//                return
//            }
//            guard let endDate = sender.date.toString(formatter: .standardEuropeanDate).date(formatter: .standardEuropeanDate) else {
//                return
//            }
//            
//            if endDate.days(from: startDate) >= 0 {
//                self.endDate.text = sender.date.toString(formatter: .standardEuropeanDate)
//                endDateString = sender.date.toString(formatter: .apiBodyUTC)
//                dateTime.endDate = sender.date.toString(formatter: .apiBodyUTC)
//            } else {
//                self.presentAlert("Time Selection Problem", "End date should be greater than start date", nil)
//            }
//        }
//    }
//    
//    @objc func timePicker_valueChanged(_ sender: UIDatePicker) {
//        handleTimePicker(sender: sender)
//    }
//    
//    @IBAction func back_touchUpInside(_ sender: UIButton) {
//        if isViewControllerPresented{
//            self.dismiss(animated: true, completion: nil)
//        }
//        else{
//            navigationController?.popViewController(animated: true)
//        }
//        
//     }
//    
//    @IBAction func createEvent_touchUpInside(_ sender: UIButton) {
//        
//        if connections.isEmpty {
//            presentAlert("Attendies Required", "Please add some attendies", nil)
//            return
//        }
//        
//        if !imageChanged {
//            presentAlert("Image Required", "Please attach image", nil)
//            return
//        }
//        
//        if !(name.text.isNilOrEmpty) && !(startDate.text.isNilOrEmpty) && !(endDate.text.isNilOrEmpty) && !(startTime.text.isNilOrEmpty) && !(endTime.text.isNilOrEmpty) && !(location.text.isNilOrEmpty) && !(detailsTV.text.isNilOrEmpty) && !(registrationLink.text.isNilOrEmpty) {
//            mode == .edit ? modifyEventDetails(details: eventDetails!) : createEventCall()
//        } else {
//            makeAlert(titleMsg: "Error", messageData: "Please fill all the fields")
//        }
//    }
//    
//    func createEventCall() {
//
//        if let user = LoggedUserDetails.shared.user {
//
//            let ids = connections.compactMap({ $0.user.id }).filter({ $0 != -1 })
//            var parameter =  [ "user_id" : user.id,
//                               "name":  name.text!,
//                               "content": detailsTV.text!,
//                               "created_by_id": user.id,
//                               "status" : "active",
//                               "address": location.text!,
//                               "start_date": dateTime.startDate,
//                               "end_date": dateTime.endDate,
//                               "start_time" : dateTime.startTime,
//                               "end_time" : dateTime.endTime,
//                               "event_start_datetime": "\(dateTime.startDate) \(dateTime.startTime)",
//                               "event_end_datetime": "\(dateTime.endDate) \(dateTime.endTime)",
//                               "registration_link" : registrationLink.text!,
//                               "is_private": eventType.text == "Public" ? 0 : 1,
//                ] as [String: Any]
//            
//            if connections.count > 0 {
//                parameter["attendees"] = ids
//            }
//            let coverImage = self.coverImage.image
//            
//            print("event parameter", parameter)
//            showActivity()
//            Alamofire.upload(multipartFormData: { (multiFormData) in
//                
//                if let image = coverImage {
//                    let imageData = image.jpegData(compressionQuality: 0.8)
//                    multiFormData.append(imageData!, withName: "event_image", fileName: "image.jpg", mimeType: "image/png")
//                }
//                
//                for (key, value) in parameter {
//                    
//                    if key == "attendees" {
//                        for id in ids {
//                            multiFormData.append("\(id)".data(using: String.Encoding.utf8)!, withName: "attendees")
//                        }
//                    } else {
//                        multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                        
//                    }
//                }
//            }, to: EndPoints.createEvent, method: .post, headers: SharedHeaders.headers) { (result) in
//                
//                switch result {
//                case .success(let successfulResponse, _, _):
//                    
//                    successfulResponse.responseJSON { (response) in
//                        
//                        self.hideActivity()
//                        let jsonDecoder = JSONDecoder()
//                        let genericResponse = try! jsonDecoder.decode(GenericResponse.self, from:response.data!)
//                        
//                        if !genericResponse.error {
//                            self.presentAlertWithAction(title: "Success", message: "Event Created") {
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        } else {
//                            self.presentAlert("Failure", genericResponse.message, nil)
//                        }
//                    }
//                    
//                case .failure(let error):
//                    
//                    self.presentAlert("Failure", nil, error)
//                    
//                }
//            }
//        }
//    }
//    
////    func getEventDetail() {
////
////        let parameters: AFParameters = [ "user_id": LoggedUserDetails.shared.user!.id,
////                                         "event_id": eventId! ]
////        showActivity()
////        NetworkManagerr.request(EndPoints.eventDetail , method: .post, parameters: parameters) { (response) in
////
////            self.hideActivity()
////            if response.result.isSuccess {
////
////                do {
////                    let decoder = JSONDecoder()
////                    let eventDetail = try decoder.decode(EventDetailRoot.self, from: response.data!)
////
////                    if eventDetail.data.count > 0 {
////                        self.eventDetails = eventDetail.data[0]
////                        self.loadEventDetail()
////                    }
////                } catch {
////                    print(error)
////                }
////            }
////        }
////    }
//    
//    func modifyEventDetails(details: EventDetail) {
//        var parameters: AFParameters = ["modified_by_id": LoggedUserDetails.shared.user!.id,
//                                        "modified_datetime": "2020-02-27 00:00" ]
//        
//        if name.text !=  details.name {
//            parameters["name"] = name.text!
//        }
//        
//        let (isUpdated, isPrivate) = eventTypeUpdate()
//        if isUpdated {
//            parameters["is_private"] = isPrivate!
//        }
//        
//        if location.text != details.address {
//            parameters["address"] = location.text!
//        }
//        
//        if endDateString != details.endDate {
//            parameters["end_date"] = dateTime.endDate
//        }
//        if startDateString !=  details.startDate {
//            parameters["start_date"] = dateTime.startDate
//        }
//        if self.endTime.text! !=  details.endTime {
//            parameters["end_time"] = dateTime.endTime
//        }
//        if self.startTime.text! !=  details.startTime {
//            parameters["start_time"] = dateTime.startTime
//        }
//        
//        parameters["event_start_datetime"] = "\(dateTime.startDate) \(dateTime.startTime)"
//        parameters["event_end_datetime"] = "\(dateTime.endDate) \(dateTime.endTime)"
//        parameters["user_id"] = LoggedUserDetails.shared.user?.id ?? -1
//        parameters["status"] = "active"
//       
//        if self.registrationLink.text! !=  details.registrationLink {
//            parameters["registration_link"] = self.registrationLink.text!
//        }
//        
//        parameters["attendees"] = connections.compactMap({ $0.user.id }).filter({ $0 != -1 })
//        
////        let partcipantIds = participants.compactMap({ $0.id })
////        if partcipantIds != details.attendees.compactMap({ $0.id }) {
////            parameters["attendees"] = partcipantIds
////        }
////        var parameter =  [ "user_id" : user.id,
////                           "name":  name.text!,
////                           "content": detailsTV.text!,
////                           "created_by_id": user.id,
////                           "status" : "active",
////                           "address": location.text!,
////                           "start_date": startDateString!,
////                           "end_date": endDateString!,
////                           "start_time" : startTime.text!.in24hourFormat(),
////                           "end_time" : endTime.text!.in24hourFormat(),
////                           "registration_link" : registrationLink.text!,
////                           "is_private": eventType.text == "Public" ? 0 : 1,
////            ]
//        var images: [UIImage] = []
//        if imageChanged, let image = coverImage.image {
//            images.append(image)
//        }
//        
//        let url  = EndPoints.eventDetail + "\(details.id)/"
//        showActivity()
//        NetworkManagerr.requestWithImages(url, images: images, imageName: "event_image", method: .patch, parameters: parameters) { (response, error) in
//            self.hideActivity()
//            if let response = response {
//                
//                if response.result.isSuccess {
//                    let decoder = JSONDecoder()
//                    let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
//                    
//                    if let generic = generic {
//                        if !generic.error && generic.message == "Update Record Successful." {
//                            self.presentAlertWithAction(title: "Success", message: generic.message) {
//                               // self.delegate?.refresh(homeStatus: true)
//                                self.navigationController?.popViewController(animated: true)
//                                //NotificationCenter.default.post(name: NSNotification.Name.init("callUpdateApi"), object: nil)
//                               // self.navigationController?.popViewController(animated: true)
//                            }
////                            self.presentAlertWithAction(title: "Success", message: "Event Details Updated") {
////                               // self.accept.backgroundColor = AppColors.evaBlue
////                                //self.accept.setImage(UIImage(), for: .normal)
////                                //self.accept.setTitle("Updated", for: .normal)
////                                //self.accept.isUserInteractionEnabled = false
////
////                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func eventTypeUpdate() -> (Bool, Int?) {
//        
//        switch (eventDetails!.isPrivate, eventType.text!) {
//        case (0, "Public"), (0, "Open to the public"):
//            return (false, nil)
//        case (1, "Public"), (1, "Open to the public"):
//            return (true, 0)
//        case (0, "Private"):
//            return (true, 1)
//        default:
//            return (false, nil)
//        }
//    }
//}
//
//extension CreateEventVC: UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if mode == .edit {
//            guard let detail = eventDetails else {
//                return
//            }
//            if textField == startDate {
//                datePicker.minimumDate = detail.startDate?.date(formatter: .apiBody)
//            }
//            else if textField == endDate {
//                datePicker.minimumDate = detail.endDate?.date(formatter: .apiBody)
//            }
//            else if textField == startTime {
//                timePicker.minimumDate = detail.startTime?.date(formatter: .apiBody)
//            }
//            else if textField == endTime {
//                timePicker.minimumDate = detail.endTime?.date(formatter: .apiBody)
//            }
//        }
//        
//    }
//}
//
//extension CreateEventVC: UITextViewDelegate {
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        
//        if textView.textColor == AppColors.lightBg {
//            textView.text = nil
//            textView.textColor = AppColors.textColor2
//        }
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.contentSize.height >= 100 {
//            detailsTV.isScrollEnabled = true
//        }
//        else {
//            textView.frame.size.height = textView.contentSize.height
//            detailsTV.isScrollEnabled = false
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.textColor = AppColors.lightBg
//            textView.text = "Details"
//        }
//    }
//}
//
//extension CreateEventVC: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        connections.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell else {
//            return UICollectionViewCell()
//        }
////        cell.connection = connections[indexPath.item]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if connections[indexPath.item].type == .creator { tappedCell() }
//        else { removeParticipant(indexPath) }
//    }
//    
//    private func removeParticipant(_ indexPath: IndexPath) {
//        let alert = UIAlertController(title: Constants.Label.removeParticipantTitle, message: Constants.Label.removeParticipantMessage, style: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
//            self.connections.remove(at: indexPath.item)
//            self.collectionView.deleteItems(at: [indexPath])
//        }))
//        present(alert, animated: true)
//    }
//    
//}
//
//extension CreateEventVC: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let inset: CGFloat = 3
//        let width = collectionView.frame.width * 0.25
//        let height = collectionView.frame.height
//
//
//        return CGSize(width: width - inset, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 5
//    }
//}
//
//extension CreateEventVC: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        2
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        types[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        eventType.text = types[row]
//    }
//}
//
//extension CreateEventVC: AddParticipantActionable {
//    
//    func tappedCell() {
//        performSegue(withIdentifier: Constants.Segues.inviteConnections, sender: nil)
//        connectionAdded = true
//    }
//}
//
//extension CreateEventVC: ConnectionsProvidable {
//    func updateConnections(connections: [User]) {
//        self.connections = connections.map({ (user: $0, type: .invited) })
//        self.connections.append((user: User(id: -1, firstName: "Add Participants", email: "", uniqueCode: nil, lastName: "", username: "", dateOfBirth: nil, userImage: nil, city: nil,
//                                            country: nil, bioData: nil, type: nil, status: nil, address: nil, companyName: nil, field: nil, designation: nil, isConnected: nil,
//                                            isReceiver: nil, isOnline: nil, lastOnlineDateTime: nil, connectionID: nil, isNotifications: nil), type: .creator))
//        collectionView.reloadData()
//    }
//}
//
//extension CreateEventVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let editImage = info[.editedImage] as? UIImage
//        var orignalImage = info[.originalImage] as? UIImage
//        if editImage != orignalImage {
//            orignalImage = editImage
//        }
//        coverImage.image = orignalImage
//        imageChanged = true
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
