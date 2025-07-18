//
//  MeetingDetailVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 13/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class MeetingDetailVC: UIViewController {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBarTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescLabel: UILabel!
    
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var dateTimeHeadingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsHeadingLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTxtLbl: HeadingLabel!
    @IBOutlet weak var locationLbl: HeadingLabel!
    
    @IBOutlet weak var gmeetView: UIView!
    @IBOutlet weak var gmeetTxtLbl: HeadingLabel!
    @IBOutlet weak var gmeetLinkLbl: HeadingLabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var invitecCollectionView: UIView!
    @IBOutlet weak var InvitedCollectionTxtLbl: HeadingLabel!
    @IBOutlet weak var invitedCollection: UICollectionView!
    
    @IBOutlet weak var bottomBtnsView: UIView!
    @IBOutlet weak var rescheduleBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bottomBtnStackHeight: NSLayoutConstraint!
    
    var meetingId = 0
    var isReschedule = false
    var isCancelTapped = false
    var isViewed = false
    var isAccepted = false
    var gmeetId = ""
    var attendees : [UserConnection] = [] {
        didSet {
            invitedCollection.reloadData()
        }
    }
    
    let application = UIApplication.shared
    var meetingDetailElement: MeetingDetail?
    var connections: [UserConnection] = []
    var invitedIds: [Int] = []
    var invitedEmail: [String] = []
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "466463211660-e9e7lu8nkr3boka6kg7msu2rn9mi5hi5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
       setupUI()
    }
    
    func setupUI(){
        shareBtn.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        invitedCollection.delegate = self
        invitedCollection.dataSource = self
        invitedCollection.registerNib(cellNib: AddParticipantCell.self)
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 15
        let layout = LeftAlignedCollectionViewFlowLayout()
        invitedCollection.collectionViewLayout = layout
        rescheduleBtn.layer.cornerRadius = 20
        cancelBtn.layer.cornerRadius = 20
        
        gmeetLinkLbl.textColor = .blue
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        gmeetView.isUserInteractionEnabled = true
        gmeetView.addGestureRecognizer(tapGesture)
    }
    
    func updateUI(data: MeetingDetail){
        titleDescLabel.text = data.title
        dateLabel.text = data.createdDate
        timeLabel.text = data.startTime
        detailsLabel.text = data.details
        gmeetView.isHidden = false
        gmeetLinkLbl.text = data.gmeetLink
        isReschedule = data.isCreatedByUser ?? false
        isViewed = data.isViewed ?? false
        locationView.isHidden = true
        gmeetId = data.gMeetId ?? ""
        self.connections = data.users ?? []
        
        self.invitedIds =  connections.compactMap { $0.id }
        self.invitedEmail = connections.compactMap { $0.email }
        
        if isViewed {
            bottomBtnsView.isHidden = true
            bottomBtnStackHeight.constant = 0
        } else {
            bottomBtnsView.isHidden = false
            bottomBtnStackHeight.constant = 50
        }
        
        if isReschedule {
            rescheduleBtn.setTitle("Reschedule", for: .normal)
            cancelBtn.setTitle("Cancel", for: .normal)
        } else {
            rescheduleBtn.setTitle("Accept", for: .normal)
            cancelBtn.setTitle("Decline", for: .normal)
        }
        
        
        let existingUsers: [UserConnection] = data.users ?? []
        var mutableAttendeesArray = existingUsers
        if mutableAttendeesArray.count > 0 {
            mutableAttendeesArray.indices.forEach { index in
                print(index)
                mutableAttendeesArray[index].isSelected = true
                print("IsSelected: ", mutableAttendeesArray[index].isSelected)
            }
            attendees = mutableAttendeesArray
        }

//        if attendees.count > 0 {
//            for attendee in existingUsers {
//                if let index = attendees.firstIndex(where: { $0.id == attendee.id }) {
//                    // Update isSelected in connectionUsers based on passedConnections
//                    attendees[index].isSelected = attendee.isSelected
//                }
//            }
//        } else {
//            attendees = existingUsers
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        fetchNoteDetails(filter: "online")
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func rescheduleBtnTapped(_ sender: UIButton) {
        if isReschedule {
            let vc = StoryboardRouter.createMeeting()
            vc.meetingDetailsData = self.meetingDetailElement
            //vc.attendees = self.attendees
            vc.isReschedule = true
            vc.meetingId = meetingId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            isAccepted.toggle()
            respondToInvitation(eventId: gmeetId, emailAddress: LoggedUserDetails.shared.user?.email ?? "", responseStatus: "accepted") { success in
                if success {
                    print("Invitation response updated successfully.")
                    self.acceptMeeting()
                } else {
                    print("Failed to update invitation response.")
                }
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        if isReschedule {
            isCancelTapped.toggle()
            deleteEvent(eventId: gmeetId) { success, error in
                if success {
                    print("Event deleted successfully")
                    self.cancelMeeting(filter: "cancel")
                } else if let error = error {
                    print("Failed to delete event: \(error.localizedDescription)")
                }
            }
        } else {
            isAccepted.toggle()
            respondToInvitation(eventId: gmeetId, emailAddress: LoggedUserDetails.shared.user?.email ?? "", responseStatus: "declined") { success in
                if success {
                    let vc = DeclinePopupVC.instantiate()
                    vc.meetingID = self.meetingId
                    vc.completion = {
                        self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
                    }
                    self.navigationController?.present(vc, animated: true)
                    print("Invitation response updated successfully.")
//                    self.fetchNoteDetails(filter: "online")
                } else {
                    print("Failed to update invitation response.")
                }
            }
        }
    }

    @IBAction func meetingShareTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.objectId = self.meetingId
        vc.type = .meet
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @objc func labelTapped() {
        let wholeLink = gmeetLinkLbl.text
        
        let gmeetOnly = wholeLink?.replacingOccurrences(of: "https://meet.google.com/", with: "")
        // Now, requestIdOnly contains only the requestId
        print("Google: \(gmeetOnly ?? "")")
        
        if let url = URL(string: "googlemeet://\(gmeetOnly ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                UIApplication.shared.open(url as URL, options: [:]) { (success) in
                    if success {
                        print("Messenger accessed successfully")
                    } else {
                        print("Error accessing Messenger")
                    }
                }
            } else {
//                // Open in Safari if the app is not available
//                url = URL(string: wholeLink ?? "https://meet.google.com/") ?? ""
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                let webURL = NSURL(string: wholeLink ?? "https://meet.google.com/")!
                application.open(webURL as URL)
            }
        }
    }
}

 //MARK: API calls
extension MeetingDetailVC {
    
    func fetchNoteDetails(filter: String){
        showActivity()
        let params = ["filter": filter] as [String: Any]
        let url = "\(EndPoints.meetingDetail)/\(meetingId)"
        NetworkManagerr.request(url, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingRoot = try jsonDecoder.decode(MeetingDetailRoot.self, from: response.data!)
                
                if !(meetingRoot.error!) && ((meetingRoot.data?.count ?? 0) > 0){
                    if let data = meetingRoot.data?[0] {
                        self.meetingDetailElement = data
                        self.updateUI(data: data)
                    }
                } else {
                    self.presentAlert("Failure", meetingRoot.message, nil) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func cancelMeeting(filter: String){
        showActivity()
        let params = ["filter": filter,
                      "meeting_id": meetingId] as [String: Any]
        let url = "\(EndPoints.rescheduleCancelMeeting)"
        NetworkManagerr.request(url, method: .patch, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !(root.error) {
                    self.presentAlert("Success", root.message, nil) {
                        self.self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.presentAlert("Failure", root.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func deleteEvent(eventId: String, completion: @escaping (Bool, Error?) -> Void) {
        let service = GTLRCalendarService()
        
        // Ensure the user is signed in and has a valid access token
        if let authentication = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            service.authorizer = authentication.fetcherAuthorizer()
        } else {
            GIDSignIn.sharedInstance().signIn()
            print("User is not authenticated.")
            completion(false, nil)
            return
        }
        
        // Create the delete query
        let query = GTLRCalendarQuery_EventsDelete.query(withCalendarId: "primary", eventId: eventId)
        
        // Execute the delete query
        service.executeQuery(query) { (ticket, object, error) in
            if let error = error {
                print("Error deleting event: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Event deleted successfully.")
                completion(true, nil)
            }
        }
    }
    
    func respondToInvitation(eventId: String, emailAddress: String, responseStatus: String, completion: @escaping (Bool) -> Void) {
        let service = GTLRCalendarService()
        
        // Ensure the user is signed in and has a valid access token
        if let authentication = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            service.authorizer = authentication.fetcherAuthorizer()
        } else {
            print("User is not authenticated.")
            GIDSignIn.sharedInstance().signIn()
            completion(false)
            return
        }
        
        // Fetch the event from the calendar
        let getEventQuery = GTLRCalendarQuery_EventsGet.query(withCalendarId: "primary", eventId: eventId)
        
        service.executeQuery(getEventQuery) { (ticket, eventObject, error) in
            if let error = error {
                print("Error fetching event: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let event = eventObject as? GTLRCalendar_Event else {
                print("Event not found.")
                completion(false)
                return
            }
            
            var attendees = event.attendees ?? []
            var attendeeFound = false
            
            // Update the attendee's response status if found
            for attendee in attendees {
                if attendee.email == emailAddress {
                    attendee.responseStatus = responseStatus
                    attendeeFound = true
                    break
                }
            }
            
            // If the attendee is not found, add them
            if !attendeeFound {
                let newAttendee = GTLRCalendar_EventAttendee()
                newAttendee.email = emailAddress
                newAttendee.responseStatus = responseStatus
                attendees.append(newAttendee)
            }
            
            // Set the updated attendees list
            event.attendees = attendees
            
            // Update the event with the new attendee information
            let patchEventQuery = GTLRCalendarQuery_EventsPatch.query(withObject: event, calendarId: "primary", eventId: eventId)
            
            service.executeQuery(patchEventQuery) { (ticket, updatedEventObject, error) in
                if let error = error {
                    print("Error updating event: \(error.localizedDescription)")
                    completion(false)
                } else {
                    
                    print("Invitation response updated successfully.")
                    completion(true)
                }
            }
        }
    }
    
    func acceptMeeting() {
        let parameters = ["filter": "accept",
                          "attending_user": "\(LoggedUserDetails.shared.user?.id ?? 0)",
                          "meeting_id": self.meetingId,
                          "reason": ""] as [String : Any]
        
        NetworkManagerr.request(EndPoints.acceptMeetingPopup, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let meetingRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if meetingRoot.error == false {
                    
                        self.showToast(message: "Accepted Invitation")
                        self.dismiss(animated: true)
                        print(meetingRoot.message )
                        self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
                    } else {
                        print(meetingRoot.message )
                    }
                    print(meetingRoot.message )
                } catch {
                    //
                }
            }
        }
    }

}

extension MeetingDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        attendees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell else {
            return UICollectionViewCell()
        }
        cell.connection = attendees[indexPath.row]
        cell.showCross = false
//        cell.connection = connections[indexPath.item]
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
//        if indexPath.row == attendees.count {
//            print("Invite")
//            tappedCell()
//        }else {
//            print("Remove")
//            removeParticipant(indexPath)
//        }
    }
    
    
//    private func removeParticipant(_ indexPath: IndexPath) {
//        let alert = UIAlertController(title: Constants.Label.removeParticipantTitle, message: Constants.Label.removeParticipantMessage, style: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
//            self.connections.remove(at: indexPath.item)
//            self.collectionView.deleteItems(at: [indexPath])
//        }))
//        present(alert, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.invitedCollection.frame.size.width/2 - 10), height: 61)
    }
}

extension MeetingDetailVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            self.presentAlert("Authentication Error", "\(error.localizedDescription)") //(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            if isReschedule {
                if isCancelTapped {
                    deleteEvent(eventId: gmeetId) { success, error in
                        if success {
                            print("Event deleted successfully")
                            self.cancelMeeting(filter: "cancel")
                        } else if let error = error {
                            print("Failed to delete event: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                if isAccepted {
                    respondToInvitation(eventId: gmeetId, emailAddress: LoggedUserDetails.shared.user?.email ?? "", responseStatus: "accepted") { success in
                        if success {
                            print("Invitation response updated successfully.")
                            self.navigationController?.popToViewController(ofClass: DashboardTabbarVC.self)
                        } else {
                            print("Failed to update invitation response.")
                        }
                    }
                } else {
                    respondToInvitation(eventId: gmeetId, emailAddress: LoggedUserDetails.shared.user?.email ?? "", responseStatus: "declined") { success in
                        if success {
                            let vc = DeclinePopupVC.instantiate()
                            vc.meetingID = self.meetingId
                            self.navigationController?.present(vc, animated: true)
                            print("Invitation response updated successfully.")
                        } else {
                            print("Failed to update invitation response.")
                        }
                    }
                }
            }
        }
    }
}
