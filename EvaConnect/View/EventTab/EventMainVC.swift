//
//  EventMainVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 09/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class EventMainVC: UIViewController, XIBed {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var drpDwnUIView: UIView!
    @IBOutlet weak var drpDwnNameLable: UILabel!
    
    @IBOutlet weak var drpDwnICImgVw: UIImageView!
    
    @IBOutlet weak var drpDwnBtn: UIButton!
    @IBOutlet weak var eventListTable: UITableView!
    
    
    @IBOutlet weak var eventDetailsView: UIView!
    @IBOutlet weak var conferenceAgendaView: UIView!
    @IBOutlet weak var networkingEventView: UIView!
    @IBOutlet weak var delegatesView: UIView!
    @IBOutlet weak var meetingsView: UIView!
    @IBOutlet weak var exhibitorsView: UIView!
    @IBOutlet weak var speakersView: UIView!
    @IBOutlet weak var sponsorsView: UIView!
    @IBOutlet weak var hotelsView: UIView!
    @IBOutlet weak var venueMapView: UIView!
    
    var eventTypeArr = ["Event Details", "Conference Agenda", "Networking Events","Delegates", "Meetings", "Exhibitors","Speakers", "Sponsors", "Hotels", "Venue Map"]
    var isSelected = false
    var eventId = 0
    var eventAttendeesStatus = ""
    var eventDetail: NewEventDetailsData?
    var conferenceAgendaList: [ConferenceAgenda] = []
    var networkingEventList: [EventNetworking] = []
    var delegateMeetingsList: [Delegatemeeting] = []
    var exhibitorsList: [List] = []
    var speakersLists: [List] = []
    var sponsorsList: [List] = []
    var HotelList: [EventHotel] = []
    var VenueList: [EventVenu] = []
    var delegatelists: [List] = []
    
    var dashboardEvent: DashboardEventData?
    var isComeFromDashboard = false
    
    
    lazy var eventDetailsVC: EventDetailsVC = {
        let vc = EventDetailsVC.instantiate(eventId: self.eventId)
        vc.eventDetail = self.eventDetail
//        vc.astrologerArray = self.astrologerArray
//        vc.completion = { tab in
//            self.completion?(tab)
//        }
        return vc
    }()
    
    lazy var delegatesVC: DelegatesVC = {
        let vc = DelegatesVC.instantiate(eventId: self.eventId, eventAttendeesStatus: self.eventAttendeesStatus)
        vc.eventDetail = self.eventDetail
//        vc.delegateData = delegatelists
        return vc
    }()
    
    lazy var conferrenceAgendaVC: ConferrenceAgendaVC = {
        let vc = ConferrenceAgendaVC.instantiate(eventId: self.eventId)
        vc.conferenceAgendaList = self.conferenceAgendaList
        return vc
    }()
    
    lazy var networkingEventsVC: NetworkingEventsVC = {
        let vc = NetworkingEventsVC.instantiate(eventId: self.eventId, eventAttendeesStatus: self.eventAttendeesStatus)
        vc.networkingEventList = self.networkingEventList
        return vc
    }()
    
    lazy var meetingListVC: MeetingListVC = {
        let vc = MeetingListVC.instantiate(eventId: self.eventId)
        vc.delegateMeetingsList = self.delegateMeetingsList
        vc.dashboardEvent = self.dashboardEvent
        vc.eventDetail = self.eventDetail
        vc.isComeFromDashboard = self.isComeFromDashboard
        return vc
    }()
    
    lazy var exhibitorsVC: ExhibitorsVC = {
        let vc = ExhibitorsVC.instantiate(eventId: self.eventId)
//        vc.exhibitorsList = self.exhibitorsList
        return vc
    }()
    
    lazy var speakersVC: SpeakersViewController = {
        let vc = SpeakersViewController.instantiate(eventId: self.eventId)
//        vc.speakersData = self.speakersLists
        return vc
    }()
    
    lazy var sponsorsVC: SponsorsVC = {
        let vc = SponsorsVC.instantiate(eventId: self.eventId)
//        vc.sponsorsData = sponsorsList
        return vc
    }()
    
    lazy var hotelsVC: HotelsVC = {
        let vc = HotelsVC.instantiate()
        vc.hotelsData = HotelList
        return vc
    }()
    
    lazy var venueVC: VenueMapVC = {
        let vc = VenueMapVC.instantiate()
        vc.venueList = VenueList
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchEventDetail()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        headingLabel.font = UIFont(name: Myfonts.semiBold, size: 16)
        drpDwnNameLable.font = UIFont(name: Myfonts.medium, size: 14)
        
        self.drpDwnICImgVw.isHidden = true
        eventListTable.isHidden = true
        eventListTable.dataSource = self
        eventListTable.delegate = self
        eventListTable.registerCells(withTypes: [PopupTableCell.self])
        eventListTable.layer.cornerRadius = 12
        drpDwnUIView.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"),value: 0.5, radius: 12)
        eventListTable.applyShadow()
        
    }
    
    @IBAction func drpDwnBtnTapped(_ sender: UIButton) {
//        self.openDropDown()
        if self.eventDetail?.isPrivate == 0 { //Public...
            self.openDropDown()
        } else { //Private...
            print(self.eventDetail?.eventAttendeesStatus ?? "")
            if self.eventDetail?.eventAttendeesStatus?.lowercased() == "accepted" || self.eventDetail?.eventAttendeesStatus?.lowercased() == "approved" {
                self.openDropDown()
            } else {
                print("user did not requested for event")
            }
        }
    }
    
    func openDropDown() {
        isSelected.toggle()
        if isSelected {
            drpDwnICImgVw.image = UIImage(named: "ic_dropdown_up")
            eventListTable.isHidden = false
        } else {
            drpDwnICImgVw.image = UIImage(named: "ic_dropdown_down")
            eventListTable.isHidden = true
        }
    }
    
    @IBAction func mainBtnBelowTapped(_ sender: UIButton) {
        
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//API calls
extension EventMainVC  {
    func fetchEventDetail() {
        let parameters: AFParameters = [ "id": eventId]
        showActivity()
        NetworkManagerr.request(EndPoints.eventDetail , method: .post, parameters: parameters) { (response) in
            
            self.hideActivity()
            if response.result.isSuccess {
                
                do {
                    let decoder = JSONDecoder()
                    let eventDetail = try decoder.decode(NewEventDetailsModel.self, from: response.data!)
                    
                    if !(eventDetail.error ?? false), ((eventDetail.data?.count ?? 0) > 0) {
                        self.eventDetail = eventDetail.data?[0]
                        self.eventAttendeesStatus = self.eventDetail?.eventAttendeesStatus ?? ""
                        self.conferenceAgendaList = self.eventDetail?.conferenceagenda ?? []
                        self.networkingEventList = self.eventDetail?.eventNetworking ?? []
                        self.delegateMeetingsList = self.eventDetail?.delegatemeetings ?? []
                        self.exhibitorsList = self.eventDetail?.exhibitorslists ?? []
                        self.speakersLists = self.eventDetail?.speakerslists ?? []
                        self.sponsorsList = self.eventDetail?.sponsorslists ?? []
                        self.HotelList = self.eventDetail?.eventHotels ?? []
                        self.VenueList = self.eventDetail?.eventVenu ?? []
                        self.delegatelists = self.eventDetail?.delegatelists ?? []
                        
                        self.addModule(self.eventDetailsVC, to: self.eventDetailsView)
                        self.drpDwnNameLable.text = "Event Details"
                        self.headingLabel.text = self.eventDetail?.name ?? ""
                        
                        self.drpDwnICImgVw.isHidden = true
                        if self.eventDetail?.isPrivate == 0 { //Public...
                            self.drpDwnICImgVw.isHidden = false
                        } else { //Private...
                            print(self.eventDetail?.eventAttendeesStatus ?? "")
                            if self.eventDetail?.eventAttendeesStatus?.lowercased() == "accepted" || self.eventDetail?.eventAttendeesStatus?.lowercased() == "approved" {
                                self.drpDwnICImgVw.isHidden = false
                            } else {
                                print("user did not requested for event")
                                self.drpDwnICImgVw.isHidden = true
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension EventMainVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopupTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.titleName.textColor = UIColor(hex: "#030229", alpha: 0.7)
        cell.titleName.font = UIFont(name: Myfonts.regular, size: 14)
        cell.titleName.text = eventTypeArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = eventTypeArr[indexPath.row]
        switch selected {
        case "Event Details":
            print("Event Details tapped")
            addModule(eventDetailsVC, to: eventDetailsView)
            eventDetailsView.isHidden = false
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Conference Agenda":
            addModule(conferrenceAgendaVC, to: conferenceAgendaView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = false
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Networking Events":
            print("Networking tapped")
            addModule(networkingEventsVC, to: networkingEventView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = false
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Delegates":
            print("Delegates tapped")
            addModule(delegatesVC, to: delegatesView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = false
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Meetings":
            print("Meetings tapped")
            addModule(meetingListVC, to: meetingsView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = false
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Exhibitors":
            print("Exhibitors tapped")
            addModule(exhibitorsVC, to: exhibitorsView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = false
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Speakers":
            print("Speakers tapped")
            addModule(speakersVC, to: speakersView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = false
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Sponsors":
            print("Sponsors tapped")
            addModule(sponsorsVC, to: sponsorsView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = false
            hotelsView.isHidden = true
            venueMapView.isHidden = true
        case "Hotels":
            print("Hotels tapped")
            addModule(hotelsVC, to: hotelsView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = false
            venueMapView.isHidden = true
        case "Venue Map":
            print("Venue Map tapped")
            addModule(venueVC, to: venueMapView)
            eventDetailsView.isHidden = true
            conferenceAgendaView.isHidden = true
            networkingEventView.isHidden = true
            delegatesView.isHidden = true
            meetingsView.isHidden = true
            exhibitorsView.isHidden = true
            speakersView.isHidden = true
            sponsorsView.isHidden = true
            hotelsView.isHidden = true
            venueMapView.isHidden = false
        default:
            print("Nothing tapped")
        }
        eventListTable.isHidden = true
        drpDwnICImgVw.image = UIImage(named: "ic_dropdown_up")
        isSelected = false
        drpDwnNameLable.text = selected
    }
}

extension EventMainVC {
    
//    func addModule(_ vc: UIViewController, to view: UIView) {
//        self.addChild(vc)
//        view.addSubview(vc.view)
//        vc.view.anchor(top: view.topAnchor,
//                       leading: view.leadingAnchor,
//                       bottom: view.bottomAnchor,
//                       trailing: view.trailingAnchor)
//    }
    
    func addModule(_ vc: UIViewController, to containerView: UIView) {
        // Remove all child view controllers first
        for child in children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // Add new child
        self.addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        containerView.layoutIfNeeded()
        vc.didMove(toParent: self)
        print("Added child: \(vc)")
    }
    
}
