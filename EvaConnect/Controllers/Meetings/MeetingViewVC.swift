//
//  MeetingViewVC.swift
//  EvaConnect
//
//  Created by usama on 04/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class MeetingViewVC: BaseVC {

    // MARK: Outlets

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dateTime: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var areYouAttending: UILabel!
    
    @IBOutlet weak var attending: UIButton!
    @IBOutlet weak var notAttending: UIButton!
    @IBOutlet weak var modify: UIButton!

    @IBOutlet weak var updated: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var meetingId: Int!
    var meetingDetail: MeetingDetail?
    var navigationType: EventNavigationType = .notifications
    private var viewerType: ViewerType = .invited
    var participants: [Participants] = []
    weak var delegate: DismissViewDelegate? = nil

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        areYouAttending.isHidden = true
        attending.isHidden = true
        notAttending.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUI()
        isSeparatorHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.dismissView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InviteConnectionVC {
            destination.invitationType = .attendees
            destination.navigationType = navigationType
            destination.delegate = self
        }
    }
}

extension MeetingViewVC {
    
    func initUI() {
        
        name.font =  UIFont(defaultFontStyle: .bold, size: 22.0)
        nameLbl.font =  UIFont(defaultFontStyle: .bold, size: 22.0)
        dateTime.font = UIFont(defaultFontStyle: .bold, size: 13)
        
        notAttending.backgroundColor = AppColors.border
        attending.backgroundColor = AppColors.evaBlue
        modify.backgroundColor = AppColors.evaBlue

        updated.isHidden = true
        
        attending.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 11.0)
        notAttending.titleLabel?.font = UIFont(defaultFontStyle: .regular, size: 11.0)
        updated.font = UIFont(defaultFontStyle: .bold, size: 9.0)
        updated.textColor = AppColors.aquaGreen
        
        if #available(iOS 13.0, *) {
            attending.layer.cornerCurve = .continuous
            notAttending.layer.cornerCurve = .continuous
            
        } else {
            view.roundCorners(view: attending, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
            view.roundCorners(view: notAttending, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.registerNib(cellNib: AddParticipantCell.self)
        getMeetingDetail()
    }
    
    func updateLayout() {
        
//        if let detail = meetingDetail {
//
//            name.text = detail.
//            nameLbl.text = detail.name
//            location.text = detail.address
//            details.text = detail.content
//
//            if detail.userID == LoggedUserDetails.shared.user!.id {
//                name.isUserInteractionEnabled = true
//                dateTime.isUserInteractionEnabled = true
//                location.isUserInteractionEnabled = true
//                details.isUserInteractionEnabled = true
//
//                modify.isHidden = false
//
//                viewerType = .creator
//
//            } else {
//                modify.isHidden = true
//            }
//
//            if detail.status == AttendeeStatus.going.rawValue {
//                attending.isHidden = true
//                notAttending.isHidden = true
//            }
//
//
//            dateTime.text = String(format: "%@-%@ | %@-%@", detail.startDate.standardDate(), detail.endDate.standardDate(),
//                                   detail.startTime.in12HourFormat(isUTC: true), detail.endTime.in12HourFormat(isUTC: true))
//
//            if detail.attendees.count > 0 {
//                participants = detail.attendees.compactMap({ convertAttendeeToPartcipant(attendee: $0) })
//                collectionView.dataSource = self
//                collectionView.reloadData()
//            }
//        }
        
        areYouAttending.isHidden = true
        attending.isHidden = true
        notAttending.isHidden = true
    }
    
    func getMeetingDetail() {
        
        let url = EndPoints.meetingDetail + String(format: "%d/", meetingId)
        
        NetworkManagerr.request(url) { (response) in
            
            if response.result.isSuccess {
                do {
                    let decoder = JSONDecoder()
                    let meetingDetail = try decoder.decode(MeetingDetailRoot.self, from: response.data!)
                    
                    if meetingDetail.data?.count ?? 0 > 0 {
                        self.meetingDetail = meetingDetail.data?[0]
                        self.updateLayout()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateAttendeeStatus(status: AttendeeStatus, completion: @escaping () -> Void) {
        if let detail = meetingDetail {
            let parameters: AFParameters = ["user_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
//                                            "meeting_id": detail.id,
                                            "status": "active",
                                            "attendance_status": status.rawValue,
                                            "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                            "modified_datetime": "2020-02-27 00:00" ]
            
            NetworkManagerr.request(EndPoints.meetingAttendeeStatusUpdate, method: .patch, parameters: parameters) { (response) in
                
                if response.result.isSuccess {
                    let decoder = JSONDecoder()
                    let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
                    
                    if let generic = generic {
                        if !generic.error && generic.message == "Update Record Successful." {
                            self.presentAlertWithAction(title: "Success", message: "Added to calendar events") {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MeetingViewVC {
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attending_touchUpInside(_ sender: UIButton) {
        updateAttendeeStatus(status: .going) {
            self.attending.alpha = 0.20
            self.updated.isHidden = false
        }
    }
    
    @IBAction func notAttending_touchUpInside(_ sender: UIButton) {
        updateAttendeeStatus(status: .notGoing) {
            self.attending.alpha = 0.20
            self.updated.isHidden = false
        }
    }
    
    @IBAction func modify_touchUpInside(_ sender: UIButton) {
        guard let detail = meetingDetail else { return }
        let vc = StoryboardRouter.createMeeting()
        vc.meetingDetail = meetingDetail
        vc.mode = .edit
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MeetingViewVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell {
//            cell.participant = participants[indexPath.row]
            cell.showCross = false
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension MeetingViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset: CGFloat = 3
        let width = collectionView.frame.width * 0.25
        let height = collectionView.frame.height

        return CGSize(width: width - inset, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}

extension MeetingViewVC: AddParticipantActionable {

    func tappedCell() {
        
        performSegue(withIdentifier: Constants.Segues.inviteConnections, sender: nil)
    }
}

extension MeetingViewVC: ConnectionsProvidable {
    func updateConnections(connections: [User]) {
//        let participants = connections.compactMap { convertUserToParticipant(connection: $0) }
//        self.participants = participants
//        collectionView.reloadData()
    }
}
