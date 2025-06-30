////
////  EventViewVC.swift
////  EvaConnect
////
////  Created by usama on 05/06/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import UIKit
//
enum EventNavigationType {
    case dialog, notifications
}
//
//class EventViewVC: BaseVC {
//
//    // MARK: Properties
//
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var eventImage: UIImageView!
//    @IBOutlet weak var dateTime: UITextField!
//    @IBOutlet weak var name: UITextField!
//    @IBOutlet weak var createdBy: UITextField!
//
//    @IBOutlet weak var location: UITextField!
//    @IBOutlet weak var eventType: UITextField!
//    @IBOutlet weak var details: UITextView!
//    @IBOutlet weak var editIcon: UIImageView!
//
//    @IBOutlet weak var accept: UIButton!
//    @IBOutlet weak var register: UIButton!
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var eventId: Int!
//    var eventDetails: EventDetail?
//    var navigationType: EventNavigationType = .notifications
//    private var viewerType: ViewerType = .invited
//    var participants: [Participants] = []
//    let types = ["Public", "Private"]
//    var imageChanged = false
//    weak var delegate: DismissViewDelegate? = nil
//    
//    lazy var eventTypePicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.delegate = self
//        picker.dataSource = self
//        return picker
//    }()
//
//    // MARK: Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addObservers()
//    }
//  
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        initUI()
//        isSeparatorHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        delegate?.dismissView()
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? InviteConnectionVC {
//            destination.invitationType = .attendees
//            destination.navigationType = navigationType
//            destination.delegate = self
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    func addObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(callUpdateAPI), name: NSNotification.Name(rawValue: "callUpdateApi"), object: nil)
//    }
//    
//    @objc func callUpdateAPI(){
//        self.getEventDetail()
//    }
//}
//
//extension EventViewVC { 
//    
//    func initUI() {
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        register.backgroundColor = AppColors.darkBlue
//        
//        name.font = UIFont(defaultFontStyle: .bold, size: 22.0)
//        
//        if #available(iOS 13.0, *) {
//            accept.layer.cornerCurve = .continuous
//            register.layer.cornerCurve = .continuous
//
//        } else {
//            
////            let roundPath = UIBezierPath(
////                roundedRect: bounds,
////                byRoundingCorners: [.topLeft, .topRight],
////                cornerRadii: CGSize(width: 10, height: 10)
////            )
//            
//            view.roundCorners(view: accept, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
//            view.roundCorners(view: register, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
//        }
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery(_:)))
//        eventImage.addGestureRecognizer(tapGesture)
//        eventType.inputView = eventTypePicker
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        collectionView.registerNib(cellNib: AddParticipantCell.self)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
//           // Code you want to be delayed
//            self.getEventDetail()
//        }
//    }
//    
//    func setLayout() {
//        
//        if let details = eventDetails {
//            
//            if details.userID == LoggedUserDetails.shared.user!.id {
//                name.isUserInteractionEnabled = true
//                dateTime.isUserInteractionEnabled = true
//                location.isUserInteractionEnabled = true
//                self.details.isUserInteractionEnabled = true
//                eventType.isUserInteractionEnabled = true
//                eventImage.isUserInteractionEnabled = true
//                picker.delegate = self
//                viewerType = .creator
//                register.isHidden = true
//                accept.setTitle("Edit", for: .normal)
//                accept.backgroundColor = .clear
//                accept.setTitleColor(AppColors.appColor, for: .normal)
//                accept.applyBorderWithRadius(color: AppColors.appColor)
//                accept.isHidden = false
//                //editIcon.isHidden = false
//                changeAcceptButtonLayout()
//            }
//            
//            name.text = details.name
//            createdBy.text = "Created by \(details.createdByUser ?? "")"
//            
//            if let images = details.eventImage, images.count > 0, let url = URL(string: images[0] ?? "") {
//                eventImage.kf.setImage(with: url)
//            }
//            
//            dateTime.text = String(format: "%@ %@ | %@ %@", details.startDate ?? "", details.endDate ?? "", details.startTime?.in12HourFormat() ?? "", details.endTime?.in12HourFormat() ?? "")
//            location.text = details.address
//            self.details.text = details.content.stringValue
//            eventType.text = details.isPrivate == 1 ? "Private" : "Open to the public"
//            
////            if details.attendees?.count ?? 0 > 0 {
////                participants = details.attendees?.compactMap({ convertAttendeeToPartcipant(attendee: $0) })
////                collectionView.reloadData()
////            }
//        }
//    }
//    
//    @objc func openGallery(_ sender: UITapGestureRecognizer) {
//        openGalleryImageOnly()
//    }
//    
//    func getEventDetail() {
//                
//        let parameters: AFParameters = [ "user_id": LoggedUserDetails.shared.user!.id,
//                                         "event_id": eventId! ]
//        showActivity()
//        NetworkManagerr.request(EndPoints.eventDetail , method: .post, parameters: parameters) { (response) in
//            
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let eventDetail = try decoder.decode(EventDetailRoot.self, from: response.data!)
//                    
//                    if eventDetail.data.count > 0 {
//                        self.eventDetails = eventDetail.data[0]
//                        self.setLayout()
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//    
//    func postAttendeeStatus(details: EventDetail) {
//        let parameters: AFParameters = ["user_id": LoggedUserDetails.shared.user!.id,
//                                        "event_id": details.id,
//                                        "status": "active",
//                                        "attendance_status": "Going",
//                                        "modified_by_id": LoggedUserDetails.shared.user!.id,
//                                        "modified_datetime": "2020-02-27 00:00" ]
//        
//        NetworkManagerr.request(EndPoints.eventAttendeeStatusUpdate, method: .patch, parameters: parameters) { (response) in
//            
//            if response.result.isSuccess {
//                let decoder = JSONDecoder()
//                let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
//                
//                if let generic = generic {
//                    if !generic.error && generic.message == "Update Record Successful." {
//                        self.presentAlertWithAction(title: "Success", message: "Added to calendar events") {
//                            self.editIcon.isHidden = true
//                            self.accept.backgroundColor = AppColors.evaBlue
//                            self.accept.setTitle("Interested", for: .normal)
//
//                        }
//                    }
//                }
//            }
//        }
//    }
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
//        if self.details.text != details.content {
//            parameters["content"] = self.details.text!
//        }
//        
//        let partcipantIds = participants.compactMap({ $0.id })
////        if partcipantIds != details.attendees.compactMap({ $0.id }) {
////            parameters["attendees"] = partcipantIds
////        }
//        
//        var images: [UIImage] = []
//        if imageChanged {
//            images.append(eventImage.image!)
//        }
//        
//        let url  = EndPoints.eventDetail + "\(details.id ?? 0)/"
//        
//        NetworkManagerr.requestWithImages(url, images: images, imageName: "event_image", method: .patch, parameters: parameters) { (response, error) in
//            
//            if let response = response {
//                
//                if response.result.isSuccess {
//                    let decoder = JSONDecoder()
//                    let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
//                    
//                    if let generic = generic {
//                        if !generic.error && generic.message == "Update Record Successful." {
//                            self.presentAlertWithAction(title: "Success", message: "Event Details Updated") {
//                                self.accept.backgroundColor = AppColors.evaBlue
//                                self.accept.setImage(UIImage(), for: .normal)
//                                self.accept.setTitle("Updated", for: .normal)
//                                self.accept.isUserInteractionEnabled = false
//                                
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
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
//    
//    private func changeAcceptButtonLayout() {
//        
//        accept.translatesAutoresizingMaskIntoConstraints = false
//        editIcon.translatesAutoresizingMaskIntoConstraints = false
//        accept.removeFromSuperview()
//        editIcon.removeFromSuperview()
//        
//        headerView.addSubview(accept)
//        headerView.addSubview(editIcon)
//        
//        NSLayoutConstraint.activate([
//            headerView.trailingAnchor.constraint(equalTo: accept.trailingAnchor, constant: 20),
//            headerView.centerYAnchor.constraint(equalTo: accept.centerYAnchor),
//            accept.widthAnchor.constraint(equalToConstant: 120),
//            accept.heightAnchor.constraint(equalToConstant: 40),
//            
//            editIcon.centerYAnchor.constraint(equalTo: accept.centerYAnchor),
//            accept.leadingAnchor.constraint(equalTo: editIcon.leadingAnchor, constant: -10)
//        ])
//    }
//}
//
//extension EventViewVC {
//    
//    @IBAction func back_touchUpInside(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func accept_touchUpInside(_ sender: UIButton) {
//        
//        if let details = eventDetails {
//            
//            switch viewerType {
//            case .invited:
//                postAttendeeStatus(details: details)
//            default:
////                navigateToCreateEvent()
////                if name.text !=  details.name || location.text != details.address || self.details.text != details.content || imageChanged {
////
////                    modifyEventDetails(details: details)
////                }
//                break
//            }
//        }
//    }
//    
//    @IBAction func register_touchUpInside(_ sender: UIButton) {
//        
//      }
//    
////    func navigateToCreateEvent(){
////        let event =  StoryboardRouter.createEvent()
////        event.eventId = eventDetails!.id
////        event.mode = .edit
////        navigationController?.pushViewController(event, animated: true)
////    }
//}
//
//extension EventViewVC: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if let _ = eventDetails {
//              switch viewerType {
//              case .invited:
//                  return participants.count
//              default:
//                  return participants.count + 1
//              }
//          }
//          
//          return participants.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell {
//            
////            switch viewerType {
////            case .invited:
////                cell.participant = participants[indexPath.row]
////            default:
////                cell.delegate = self
////                if indexPath.row != participants.count {
////                    cell.participant = participants[indexPath.row]
////                } else {
////                    cell.addGestures()
////                }
////            }
//            
//            return cell
//        }
//        
//        return UICollectionViewCell()
//    }
//}
//
//extension EventViewVC: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let inset: CGFloat = 3
//        let width = collectionView.frame.width * 0.25
//        let height = collectionView.frame.height
//
//        return CGSize(width: width - inset, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 5
//    }
//}
//
//extension EventViewVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
//extension EventViewVC: AddParticipantActionable {
//
//    func tappedCell() {
//        performSegue(withIdentifier: Constants.Segues.inviteConnections, sender: nil)
//    }
//}
//
//extension EventViewVC: ConnectionsProvidable {
//    func updateConnections(connections: [User]) {
////        let participants = connections.compactMap { convertUserToParticipant(connection: $0) }
////        self.participants = participants
////        collectionView.reloadData()
//    }
//}
//
//extension EventViewVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let editImage = info[.editedImage] as? UIImage
//        var orignalImage = info[.originalImage] as? UIImage
//        if editImage != orignalImage {
//            orignalImage = editImage
//        }
//        eventImage.image = orignalImage
//        imageChanged = true
//        picker.dismiss(animated: true, completion: nil)
//        
//    }
//}
