////
////  EventCommentVC.swift
////  EvaConnect
////
////  Created by Metis on 17/03/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//
//import UIKit
//import Alamofire
//import AVKit
//
//@IBDesignable
//class EventCommentVC: BaseVC, BusinessSectorPopUpDismiss, RegionPopUpDismiss, EventDelegateFilterDismiss {
//    
//    
//    // MARK: OutLets
//    @IBOutlet weak var navBarTitle: HeadingLabel!
//    @IBOutlet weak var eventHideContainerView: UIView!
//    @IBOutlet weak var dateTimeLabel: UILabel!
//    @IBOutlet weak var registerBtn: UIButton!
//    @IBOutlet weak var userIntrestedImageView: UIImageView!
//    @IBOutlet weak var favBtn: UIButton!
//    
//    @IBOutlet weak var bgRoundView: UIView!
//    @IBOutlet weak var eventPostImage: UIImageView!
//    
//    @IBOutlet weak var eventCreatedBy: UILabel!
//    @IBOutlet weak var name: UITextField!
//    @IBOutlet weak var location: UILabel!
////    @IBOutlet weak var dateTime: UILabel!
//    @IBOutlet weak var addCommentBtn: UIButton!
//
//    @IBOutlet weak var commentTV: UITextView!
//    @IBOutlet weak var eventImage: UIImageView!
//    @IBOutlet weak var likeValueLbl: UILabel!
//    @IBOutlet weak var commentValueLbl: UILabel!
//    @IBOutlet weak var likeBtn: UIButton!
//    @IBOutlet weak var commentBtn: UIButton!
//    @IBOutlet weak var shareBtn: UIButton!
//    @IBOutlet weak var eventDescription: UITextView!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var likeImage: UIImageView!
//    @IBOutlet weak var interrestedBtn: UIButton!
//    @IBOutlet weak var invitedPepleCollection: UICollectionView!
//    
//    @IBOutlet weak var invitedPeopleCollectionHeight: NSLayoutConstraint!
//    @IBOutlet weak var invitedLbl: UILabel!
////    @IBOutlet weak var eventType: UITextField!
////    @IBOutlet weak var eventViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var bottom_imgvw_1: UIImageView!
//    @IBOutlet weak var bottom_imgvw_2: UIImageView!
//    @IBOutlet weak var bottom_imgvw_3: UIImageView!
//    @IBOutlet weak var joinedCountLbl: UILabel!
//    
//    @IBOutlet weak var saveEventImgView: UIImageView!
//    @IBOutlet weak var saveEventBtn: UIButton!
//    @IBOutlet weak var liveFloorplanBtn: UIButton!
//    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
//    @IBOutlet weak var exhobitorsCollectionView: UICollectionView!
//   
//    @IBOutlet weak var buttonBaseView: UIView!
//    @IBOutlet weak var detailsButton: UIButton!
//    @IBOutlet weak var agendaButton: UIButton!
//    @IBOutlet weak var galleryButton: UIButton!
//    @IBOutlet weak var delegatesButton: UIButton!
//
//    @IBOutlet weak var detailsScrollView: UIScrollView!
//    @IBOutlet weak var bottomButtonView: UIView!
//    @IBOutlet weak var agendaMainView: UIView!
//    @IBOutlet weak var delegatesMainView: UIView!
//    
//    @IBOutlet weak var delegateFilterMainVw: UIView!
//    @IBOutlet weak var delegateFilterBtn: UIButton!
//    @IBOutlet weak var delegateSearchMainVw: UIView!
//    @IBOutlet weak var delegateSearchTextField: UITextField!
//    @IBOutlet weak var delegatesTableView: UITableView!
//    
//    @IBOutlet weak var noDelegatesLabel: UILabel!
//    @IBOutlet weak var filterAgendaCollectionVw: UICollectionView!
//    var filterAgendaList: [AgendaDatum] = []//["ACHL","ASA","ULD Care","airfreight pharma"]
//    var galleryCatArr: [String] = ["Photo","Videos","Presentation"]
//    var activeFilter: [String] = []
//    private var selectedTabFilterIndex = 0
//    
//    @IBOutlet weak var agendaListTblVw: UITableView!
//    @IBOutlet weak var downloadPdfBtn: UIButton!
//    @IBOutlet weak var photoCollectionView: UICollectionView!
//    
//    @IBOutlet weak var buttonBaseViewHeightConst: NSLayoutConstraint!
//    @IBOutlet weak var buttonBaseViewTopConst: NSLayoutConstraint!
//    
//    
//    // MARK:- Variables
////    var eventId: Int!
////    var userId: Int!
////    var comments: [Comments] = []
////    var eventDetail: EventDetail?
////    var invitedPeople: [InvitedPeople] = [] {
////        didSet {
////            invitedPepleCollection.reloadData()
////        }
////    }
////    
////    var downloadPDFLink = ""
////    
////    var AgendaList: [AgendaData] = [] {
////        didSet {
////            agendaListTblVw.reloadData()
////        }
////    }
//    
////    var Agenda: [AgendaData] = [] {
////        didSet {
////            agendaListTblVw.reloadData()
////        }
////    }
//    
////    var agenda = false
////    
////    var galleryObj: GalleryDataClass?
////    var galleryArr: [GalleryDataClass] = [] 
////    {
////        didSet {
////            photoCollectionView.reloadData()
////        }
////    }
////    weak var delegate: RefreshUpdateable?
////    var textIsOk = true
////    var attendeeList: [UserConnection] = []
////    var participants: [(attendee: Participants, type: ViewerType)] = []
////    private var viewerType: ViewerType = .invited
////    var imageChanged = false
////    var mode: PostLoadingMode = .create
////    var senderButton = UIButton()
////    var isMyPost = false
////    private var isFav = false
////    private var favEventId: Int? = nil
////    private var favEventCreated = false
////    
////    var registrationLink : String?
////    
////    var ImgUrlString = ""
////    
////    var eventDelegateListArr: [EventDelegateList] = []
////    var searchEventDelegateArr: [EventDelegateList] = []
////    
////    var eventDelegateFilterArr: [EventDelegateFilterList] = []
////    var isFilter = false
////    
////    var jobSectorList = ["Commercial Aviation", "General-Business Aviation", "Air Cargo"]
////    var selectedBusinessSector = ""
////    var isGalleryEnable = false
////    var selectedTab = 0
////    var isFirstTime = true
////    
////    var countryList = ["Africa", "Asia", "Central Asia", "Europe", "Latin America", "Middle East", "North America", "Oceania", "South Asia", "Southest Asia", "Western Asia"]
////    var selectedRegion = ""
////    
////    var isEventSaved = false
////    var isEventLiked = false
////    
////    var selectedFilter = ""
////    var documentInteractionController: UIDocumentInteractionController!
////    
//    // MARK:- LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        if LoggedUserDetails.shared.user?.isCompany ?? false { favBtn.isHidden = true }
////        invitedPepleCollection.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
////        NotificationCenter.default
////                          .addObserver(self,
////                                       selector: #selector(clearDataCalled),
////                         name: NSNotification.Name ("ClearData"), object: nil)
//        //addObservers()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        setTableViewContentHeight()
//    }
//    func addObservers(){
//        NotificationCenter.default.addObserver(self, selector: #selector(callUpdateAPI), name: NSNotification.Name(rawValue: "callUpdateApi"), object: nil)
//    }
//    
//    @objc func clearDataCalled(_ notification: NSNotification) {
//        self.selectedBusinessSector = ""
//        self.selectedRegion = ""
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if(keyPath == "contentSize"){
//            self.invitedPeopleCollectionHeight.constant = self.invitedPepleCollection.contentSize.height == 0 ? 100 : self.invitedPepleCollection.contentSize.height
//        }
//    }
//    
//    func setFilterButtons(button: UIButton){
//        button.backgroundColor = UIColor.clear
//        button.setTitleColor(UIColor(hex: "#707070"), for: .normal)
//    }
//    
//    @objc func callUpdateAPI(){
//        fetchEventDetail()
//        //getAllComments()
//        setLayout()
//        isSeparatorHidden = true
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.buttonBaseViewHeightConst.constant = 32
//        self.buttonBaseViewTopConst.constant = 21
//        self.buttonBaseView.isHidden = false
//        fetchEventDetail()
//        //getAllComments()
//        setLayout()
//        isSeparatorHidden = true
//        switch selectedTab {
//        case 1:
//            self.onHeaderBtnTapped(self.galleryButton)
//        case 3:
//            self.onHeaderBtnTapped(self.delegatesButton)
//        default:
//            break
//        }
//    }
//    
//    func setTableViewContentHeight(){
//        tableViewHeightConstraint.constant = tableView.contentSize.height
//    }
//    
//    @IBAction func saveBtnTapped(_ sender: UIButton) {
//        
//        let param: AFParameters = [ "id": eventId ?? 0]
//        
//        view.isUserInteractionEnabled = false
//        
//        ApiCallerClass.saveEventServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
//            let data = dataRespose as? NSDictionary
//            let error = data?["error"] as? Int
//            self.hideActivity()
//            if error == 0 {
//                print("Event saved!!")
//                self.fetchEventDetail()
//            }
//            else {
//                print("Event error!!",error as Any)
//
//            }
//        })
//        { (error) in
//            self.hideActivity()
//            self.view.isUserInteractionEnabled = true
//        }
//    }
//    
//    @IBAction func favBtnTapped(_ sender: UIButton) {
//        guard let eventDetail = eventDetail else { return }
//        let url = EndPoints.eventSave
//        let params: AFParameters = ["status": "active", "user_id": LoggedUserDetails.shared.user!.id ?? 0, "event_id": eventDetail.id, "is_favourite": !isFav]
////        if let id = favEventId, favEventCreated {
////            params["id"] = id
////            params["event_id"] = id
////            params["user_id"] = nil
////        }
//        showActivity()
//        favBtn.isUserInteractionEnabled.toggle()
//        NetworkManagerr.request(url, method: favEventCreated ? .patch : .post, parameters: params) { [weak self] (result: Result<EventFavouriteResponse>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            self.favBtn.isUserInteractionEnabled.toggle()
//            switch result {
//            case .success(let data):
//                if !data.error {
//                    self.isFav.toggle()
//                    self.favBtn.setImage(UIImage(named: self.isFav ? "ic_star_selected" : "ic_star"), for: .normal)
//                    self.favEventId = data.data?.id
//                    self.favEventCreated.toggle()
//                } else {
//                    self.presentAlert("Error", data.message.capitalized, nil)
//                }
//            case .failure(let error):
//                self.presentAlert("Error", nil, error)
//            }
//        }
//    }
//    
//    @IBAction func downPdfTapped(_ sender: UIButton) {
//        if downloadPDFLink != "" {
//            self.showActivity()
//            download(url: URL(string: downloadPDFLink)!, type: "pdf")
//        } else {
//            presentAlert("Error", "File Missing.")
//        }
//    }
//    
//    private func checkIsEventFavourite() {
//        guard let eventDetail = eventDetail else { return }
//        let params: Parameters = ["user_id": "\(LoggedUserDetails.shared.user!.id)", "status": "active", "event_id": "\(eventDetail.id)"]
//        guard let url = params.getURL(EndPoints.eventSave) else { return }
//        showActivity()
//        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[EventFavourite]>>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let rsl):
//                if rsl.error {
//                    self.presentAlert("Error", rsl.message, nil)
//                } else if let last = rsl.data.last {
//                    self.isFav = last.isFavourite ?? false
//                    self.favEventId = last.id
//                    self.favBtn.setImage(UIImage(named: self.isFav ? "ic_star_selected" : "ic_star"), for: .normal)
//                    self.favEventCreated = true
//                }
//            case .failure(let err):
//                self.presentAlert("Error", nil, err)
//            }
//            
////            self.getEventIntrestedStatus()
//        }
//    }
//    
//    private func getEventIntrestedStatus() {
//        guard let eventDetail = eventDetail else { return }
//        let params: AFParameters = ["event_id": "\(eventDetail.id)", "user_id": "\(LoggedUserDetails.shared.user!.id)"]
//        guard let url = params.getURL(EndPoints.eventIntrestedStatus) else { return }
//        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[DashboardItem]>>) in
//            guard let self = self else { return }
//            self.hideActivity()
//            switch result {
//            case .success(let t):
//                if t.message.lowercased() == "attendee fetched" {
//                    self.registerBtn.setTitle("Unregister", for: .normal)
//                    self.userIntrestedImageView.isHidden = false
//                } else {
//                    self.registerBtn.setTitle("Register Now", for: .normal)
//                    self.userIntrestedImageView.isHidden = true
//                }
//            case .failure(let error):
//                self.presentAlert("Error", nil, error)
//            }
//        }
//    }
//    
//    @IBAction func onHeaderBtnTapped(_ sender: UIButton) {
//        self.setFilterButtons(button: detailsButton)
//        self.setFilterButtons(button: agendaButton)
//        self.setFilterButtons(button: galleryButton)
//        self.setFilterButtons(button: delegatesButton)
//        
//        
//        if sender.tag == 11 {   //Details Button...
//            self.detailsButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//            self.detailsButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//            self.setFilterButtons(button: agendaButton)
//            self.setFilterButtons(button: delegatesButton)
//            
//            self.detailsScrollView.isHidden = false
//            self.bottomButtonView.isHidden = !isIndivisualUser
//            self.agendaMainView.isHidden = true
//            self.delegatesMainView.isHidden = true
//            
//            self.filterAgendaCollectionVw.reloadData()
//            self.selectedTab = 0
//
//        }
//        else if sender.tag == 12 {   //Agenda Button...
//            self.setFilterButtons(button: detailsButton)
//            self.agendaButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//            self.agendaButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//            self.setFilterButtons(button: delegatesButton)
//            
//            self.detailsScrollView.isHidden = true
//            self.bottomButtonView.isHidden = true
//            self.agendaMainView.isHidden = false
//            self.photoCollectionView.isHidden = true
//            self.agendaListTblVw.isHidden = false
//            self.delegatesMainView.isHidden = true
//            if filterAgendaList.count > 0 {
//                self.selectedTabFilterIndex = 0
//                self.fetchAgendaList()
//            } else {
//                fetchAgenda()
//            }
//            
//            self.selectedTab = 2
//        }
//        else if sender.tag == 13 {   //Delegates Button...
//            self.setFilterButtons(button: detailsButton)
//            self.setFilterButtons(button: agendaButton)
//            self.delegatesButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//            self.delegatesButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//            
//            self.detailsScrollView.isHidden = true
//            self.bottomButtonView.isHidden = true
//            self.agendaMainView.isHidden = true
//            self.delegatesMainView.isHidden = false
//            
//            self.isFilter = false
//            self.fetchEventDelegateList()
//            self.selectedTab = 3
//        }
//        else if sender.tag == 14 {   //Gallery Button...
//            self.setFilterButtons(button: detailsButton)
//            self.setFilterButtons(button: delegatesButton)
//            self.galleryButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//            self.galleryButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//            
//            self.detailsScrollView.isHidden = true
//            self.bottomButtonView.isHidden = true
//            self.agendaMainView.isHidden = false
//            self.photoCollectionView.isHidden = false
//            self.agendaListTblVw.isHidden = true
//            self.delegatesMainView.isHidden = true
//            self.selectedTab = 1
//            
//            
//            if isFirstTime {
//                isFirstTime = false
//                selectedFilter = "Photo"
//                selectedFilter = activeFilter[0]
//                fetchGalleryDetail(fileType: "image")
//            }
//        }
//    }
//    
//    @IBAction func onDelegatesFilterBtnTapped(_ sender: UIButton) {
//        print("Delegates Search Btn Tapped.")
//        let popupvc = EventDelegateSearchPopupVC(nibName: "EventDelegateSearchPopupVC", bundle: nil)
//        popupvc.completion = { type in
//            //Type = 0 Job Sector  &&   Type = 1 Region
//            let vc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
//            popupvc.modalPresentationStyle = .overFullScreen
//            if type == 0 {
//                vc.stringArray = self.jobSectorList
//                vc.businessSectorDismissDelegate = self
//                vc.isRegion = false
//            } else {
//                vc.stringArray = self.countryList
//                vc.regionDismissDelegate = self
//                vc.isRegion = true
//            }
//            vc.isComeFromEventDelegate = true
//            self.navigationController?.present(vc, animated: true)
//        }
//        popupvc.businessSector = self.selectedBusinessSector
//        popupvc.region = self.selectedRegion
//        popupvc.eventId = self.eventId
//        popupvc.EventDelegateFilterDismissDelegate = self
//        self.navigationController?.present(popupvc, animated: true)
//    }
//    
//    //==> Job Sector Delegate Method......
//    func openDelegateFilterPopup(businessSector: String) {
////        let popupvc = EventDelegateSearchPopupVC(nibName: "EventDelegateSearchPopupVC", bundle: nil)
////        popupvc.businessSector = businessSector
////        self.navigationController?.present(popupvc, animated: true)
//        self.selectedBusinessSector = businessSector
//        self.onDelegatesFilterBtnTapped(self.delegateFilterBtn)
//    }
//    
//    //==> Region Delegate Method......
//    func openRegionDelegateFilterPopup(region: String) {
//        self.selectedRegion = region
//        self.onDelegatesFilterBtnTapped(self.delegateFilterBtn)
//    }
//}
//
//// MARK: IBAction
//extension EventCommentVC {
//    
////    @IBAction func addComment(_ sender: Any) {
////        view.isUserInteractionEnabled = false
////        commentTV.resignFirstResponder()
////        if self.textIsOk != true || commentTV.text.count > 0 {
////            if mode == .edit {
////                self.updateComment(content: commentTV!.text!, sender: senderButton)
////            } else {
////                 self.view.isUserInteractionEnabled = true
////                addComments(postId: eventId!, text: commentTV.text) { (success, error) in
////
////                    if let _ = success {
////
////                        self.fetchEventDetail()
////                        self.comments.removeAll()
////                        self.getAllComments()
////                        //self.commentTV.text = ""
////                        self.commentTV.textColor = .lightGray
////                        self.commentTV.text = Constants.Chat.reply
////
////                    }
////
////                    if let error = error {
////                        self.presentAlert("Failure", nil, error)
////                    }
////                }
////            }
////
////
////        } else {
////            view.isUserInteractionEnabled = true
////            self.makeAlert(messageData: "Field is Empty")
////        }
////    }
//    
////    @IBAction func back_touchUpInside(_ sender: UIButton) {
////        navigationController?.popViewController(animated: true)
////        self.navigationController?.isNavigationBarHidden = false
////    }
////    
////    
////    @IBAction func liveFloorPlnTapped(_ sender: UIButton) {
////        
////        if ImgUrlString == "" {
////            presentAlert("Alert!","Floor Plan not available")
////        } else {
////            let vc = DownloadChatImgVC.instantiate(imageString: ImgUrlString)
////            vc.completion = {
////                self.ImgUrlString == ""
////                self.showToast(message: "Image Saved!!")
////            }
////            self.navigationController?.present(vc, animated: true)
////        }
////    }
////    
////    @IBAction func attendingEvent(_ sender: UIButton) {
////        
//////        if attentendingBtn.title(for: .normal) == "✓ Interested" {
//////            addRemoveAttendie()
//////            return
//////        }
//////        if InterrestedBtn.backgroundColor == UIColor(hex: "#4D76CD") {
//////            addRemoveAttendie()
//////            return
//////        }
////        
//////        if let details = eventDetail {
//////            switch viewerType {
//////            case .invited:
//////                updateEventStatus()
//////            default:
//////                navigateToCreateEvent(eventId: details.id ?? 0)
//////            }
//////        }
////        if !agenda {
////            
////            openArticle()
////        } else {
////            likeEvents(postId: eventId, status: "active", action: isEventLiked ? "unlike" : "like")
////        }
//////        showActivity()
////    }
////    
////    private func likeEvents(postId: Int, status: String, action: String) {
////        let param: AFParameters = [ "id": postId,
////                                    "created_by_id":  LoggedUserDetails.shared.user?.id ?? 0,
////                                    "status": status,
////                                    "action": action ]
////        
////        view.isUserInteractionEnabled = false
////        
////        ApiCallerClass.likeEventsServiceFunc(usertoken: LoggedUserDetails.shared.token!,para: param, success: { (dataRespose) in
////            let data = dataRespose as? NSDictionary
////            let error = data?["error"] as? Int
////            self.hideActivity()
////            if error == 0 {
////                self.fetchEventDetail()
////            }
////            else {
////                
////            }
////        })
////        { (error) in
////            self.hideActivity()
////            self.view.isUserInteractionEnabled = true
////        }
////        
////    }
////    
////    func addRemoveAttendie() {
////        guard let eventDetail = eventDetail else { return }
////        let isGoing = registerBtn.title(for: .normal) == "Register Now"
////        let params: AFParameters = ["user_id": LoggedUserDetails.shared.user!.id, "event_id": eventDetail.id, "status": "active",
////                                    "attendance_status": isGoing ? "Going" : "Not Going"]
////        showActivity()
////        NetworkManagerr.request(EndPoints.addAttendee, method: .post, parameters: params) { [weak self] (result: Result<Wrapper<[Int]>>) in
////            guard let self = self else { return }
////            switch result {
////            case .success(let t):
////                if t.message == "Creation Successful." {
////                    self.registerBtn.setTitle("Unregister", for: .normal)
////                    self.userIntrestedImageView.isHidden = false
////                } else {
////                    self.registerBtn.setTitle("Register Now", for: .normal)
////                    self.userIntrestedImageView.isHidden = true
////                }
////                
////                self.participants.removeAll()
////                self.invitedPepleCollection.reloadData()
////                
////                self.presentAlert(t.error ? "Error" : "Success", t.message, nil) { [weak self] in
////                    self?.fetchEventDetail()
////                }
////            case .failure(let error):
////                self.presentAlert("Error", nil, error)
////            }
////        }
////    }
//    
//    func navigateToCreateEvent(eventId: Int) {
////        let event =  StoryboardRouter.createEvent()
////        event.eventId = eventId
////        event.mode = .edit
////        event.imageChanged = true
////        navigationController?.pushViewController(event, animated: true)
//    }
//    
//    //Filter Data Set......
////    func eventDelegateFilterData(filterArr: [EventDelegateFilterList], isFilter: Bool) {
////        self.isFilter = isFilter
////        self.eventDelegateFilterArr = filterArr
////        if self.isFilter {
////            if self.eventDelegateFilterArr.count >= 1 {
////                noDelegatesLabel.isHidden = true
////            } else {
////                noDelegatesLabel.isHidden = false
////            }
////        } else {
////            if self.searchEventDelegateArr.count >= 1 {
////                noDelegatesLabel.isHidden = true
////            } else {
////                noDelegatesLabel.isHidden = false
////            }
////        }
////        
////        self.delegatesTableView.reloadData()
////    }
//
//}
//
//// MARK: UI updates
//extension EventCommentVC: UITextViewDelegate {
//    
//    func setLayout() {
//        self.navigationController?.isNavigationBarHidden = true
//        self.noDelegatesLabel.isHidden = true
//        self.filterAgendaCollectionVw.delegate = self
//        self.filterAgendaCollectionVw.dataSource = self
//        self.agendaListTblVw.delegate = self
//        self.agendaListTblVw.dataSource = self
//        self.photoCollectionView.delegate = self
//        self.photoCollectionView.dataSource = self
//        self.delegatesTableView.delegate = self
//        self.delegatesTableView.dataSource = self
//        self.delegateSearchTextField.delegate = self
//        
//        self.delegateSearchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
//        
//        self.buttonBaseView.layer.cornerRadius = 8
//        self.detailsButton.layer.cornerRadius = 8
//        self.agendaButton.layer.cornerRadius = 8
//        self.galleryButton.layer.cornerRadius = 8
//        self.delegatesButton.layer.cornerRadius = 8
//        
//        self.downloadPdfBtn.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
//        self.downloadPdfBtn.layer.borderWidth = 1.0
//        self.downloadPdfBtn.layer.cornerRadius = self.downloadPdfBtn.frame.size.height/2
//        
//        self.detailsButton.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.2)
//        self.detailsButton.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//        self.setFilterButtons(button: agendaButton)
//        self.setFilterButtons(button: galleryButton)
//        self.setFilterButtons(button: delegatesButton)
//        
//        self.galleryButton.isHidden = !isGalleryEnable
//        self.agendaButton.isHidden = isGalleryEnable
//        self.saveEventBtn.isHidden = !isIndivisualUser
//        self.saveEventImgView.isHidden = !isIndivisualUser
//        self.detailsScrollView.isHidden = false
//        self.bottomButtonView.isHidden = !isIndivisualUser
//        self.agendaMainView.isHidden = true
//        self.delegatesMainView.isHidden = true
//        
//        if isGalleryEnable {
//            activeFilter = galleryCatArr
//        } 
////        else {
////            activeFilter = filterAgendaList
////        }
//
//        tableView.dataSource = self
//        tableView.delegate = self
//        invitedPepleCollection.delegate = self
//        invitedPepleCollection.dataSource = self
//        
//        sponsorsCollectionView.delegate = self
//        sponsorsCollectionView.dataSource = self
//        exhobitorsCollectionView.delegate = self
//        exhobitorsCollectionView.dataSource = self
//        
//        self.delegateSearchMainVw.layer.borderWidth = 0.5
//        self.delegateSearchMainVw.layer.borderColor = UIColor(hex: "#837A88").cgColor
//        self.delegateSearchMainVw.layer.cornerRadius = 8.0
//        
//        self.delegateFilterMainVw.layer.borderWidth = 1.0
//        self.delegateFilterMainVw.layer.borderColor = UIColor(hex: "#4D76CD").cgColor
//        self.delegateFilterMainVw.layer.cornerRadius = self.delegateFilterMainVw.frame.size.height/2
//
//        commentTV.textColor = .lightGray
//        commentTV.text = Constants.Chat.reply
//        
//        self.bgRoundView.layer.cornerRadius = 13.0
//        self.eventImage.layer.cornerRadius = 13.0
//                
//        registerBtn.layer.cornerRadius = self.registerBtn.frame.size.height/2
//        liveFloorplanBtn.layer.cornerRadius = self.liveFloorplanBtn.frame.size.height/2
//        bottom_imgvw_1.layer.cornerRadius = self.bottom_imgvw_1.frame.size.height/2
//        bottom_imgvw_2.layer.cornerRadius = self.bottom_imgvw_2.frame.size.height/2
//        bottom_imgvw_3.layer.cornerRadius = self.bottom_imgvw_3.frame.size.height/2
//
////        name.font = UIFont(defaultFontStyle: .bold, size: 22.0)
//        
////        eventCreatedBy.font = UIFont(defaultFontStyle: .light, size: 10.0)
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery(_:)))
//        eventImage.addGestureRecognizer(tapGesture)
//
//        likeBtn.addTarget(self, action: #selector(eventLikePost(sender:)), for:.touchUpInside)
//        shareBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
//        commentTV.delegate = self
//        tableView.registerCell(withType: CommentCell.self)
//        tableView.backgroundView = UIView()
//        tableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
//        interrestedBtn.roundOnly()
//        invitedPepleCollection.registerNib(cellNib: AddParticipantCell.self)
////        attendees.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//    }
//    
//    @objc func openGallery(_ sender: UITapGestureRecognizer) {
//         openGalleryImageOnly()
//     }
//     
//    @objc func searchTextFieldDidChange(_ textField: UITextField) {
//        if self.eventDelegateListArr.count > 0 {
//            let searchStr = self.delegateSearchTextField.text ?? ""
//            if searchStr.elementsEqual("") {
//                self.searchEventDelegateArr = self.eventDelegateListArr
//            } else {
//                self.searchEventDelegateArr = self.eventDelegateListArr.filter {
//                    let name = "\($0.firstName ?? "") \($0.lastName ?? "")"
//                    return name.lowercased().contains(searchStr.lowercased()) }
//            }
//            self.delegatesTableView.reloadData()
//        }
//    }
//
//    
//    func setUIData(eventDetail: EventDetail) {
//        
//    
////        if eventDetail.userID == LoggedUserDetails.shared.user!.id {
//            //name.isUserInteractionEnabled = true
//            //dateTime.isUserInteractionEnabled = true
//            //location.isUserInteractionEnabled = true
//            //eventDescription.isUserInteractionEnabled = true
//            //eventType.isUserInteractionEnabled = true
//            //eventImage.isUserInteractionEnabled = true
//            
////            if dataMaper.isEventLike == 1 {
////                interrestedBtn.setTitle("✓ Interested", for: .normal)
////                interrestedBtn.backgroundColor = AppColors.appBlue
////                interrestedBtn.setTitleColor(.white, for: .normal)
////            } else {
////                self.interrestedBtn.cornerRadius = self.interrestedBtn.frame.size.height/2
////                self.interrestedBtn.layer.borderWidth = 1
////                self.interrestedBtn.layer.borderColor = AppColors.appBlue.cgColor
////                interrestedBtn.setTitleColor(AppColors.appBlue, for: .normal)
////                self.interrestedBtn.setTitle(" Interested", for: .normal)
////            }
//            
////            interrestedBtn.setTitle("Edit", for: .normal)
////            interrestedBtn.setTitleColor(AppColors.appColor, for: .normal)
////            interrestedBtn.backgroundColor = .clear
////            interrestedBtn.applyBorderWithRadius(color: AppColors.appColor, radius: 10)
////            registerBtn.isHidden = true
////            viewerType = .creator
////        } else {
////            if eventDetail.isAttending.isNil || eventDetail.isAttending != "Going" {
////                interrestedBtn.setTitle("✓ Interested", for: .normal)
////                interrestedBtn.backgroundColor = UIColor.white
////                interrestedBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
////                interrestedBtn.isUserInteractionEnabled = false
////            } else {
////                interrestedBtn.setTitle("✓ Interested", for: .normal)
//////                attentendingBtn.backgroundColor = Constants.AppColorLiteral.loginByNew
////                interrestedBtn.backgroundColor = UIColor(hex: "#4D76CD")
////                interrestedBtn.setTitleColor(.white, for: .normal)
////                interrestedBtn.isUserInteractionEnabled = true
////            }
////
////            registerBtn.isHidden = false
////            favBtn.isHidden = LoggedUserDetails.shared.user?.isCompany ?? false
////        }
//        
//        if eventDetail.isNewsSave == 1 {
//            saveEventImgView.image = #imageLiteral(resourceName: "save_selected")
//        } else {
//            saveEventImgView.image = #imageLiteral(resourceName: "save")
//        }
//        
//        if eventDetail.isEventLike == 1 {
//            interrestedBtn.setTitle("✓ Interested", for: .normal)
//            interrestedBtn.backgroundColor = AppColors.appBlue
//            interrestedBtn.setTitleColor(.white, for: .normal)
//        } else {
//            self.interrestedBtn.cornerRadius = self.interrestedBtn.frame.size.height/2
//            self.interrestedBtn.layer.borderWidth = 1
//            self.interrestedBtn.layer.borderColor = AppColors.appBlue.cgColor
//            interrestedBtn.setTitleColor(AppColors.appBlue, for: .normal)
//            interrestedBtn.backgroundColor = .white
//            self.interrestedBtn.setTitle(" Interested", for: .normal)
//        }
//        navBarTitle.text = eventDetail.name
//        eventCreatedBy.text = "Created by \(eventDetail.createdByUser ?? "")"
//        name.text = eventDetail.name
//        dateTimeLabel.text = "\(eventDetail.startDate ?? "") | \(eventDetail.startTime ?? "") - \(eventDetail.endTime ?? "")"
//
//        location.text = eventDetail.address
//        eventDescription.text = eventDetail.content
//        
//        bottom_imgvw_1.roundOnly()
//        bottom_imgvw_2.roundOnly()
//        bottom_imgvw_3.roundOnly()
//        
//        joinedCountLbl.text = "\(eventDetail.interestedUsersCount ?? "") Joined"
//        bottom_imgvw_1.sd_setImage(with: URL(string: (eventDetail.interestedUsers?[0].userImageURL)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//        bottom_imgvw_2.sd_setImage(with: URL(string: (eventDetail.interestedUsers?[1].userImageURL)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//        bottom_imgvw_3.sd_setImage(with: URL(string: (eventDetail.interestedUsers?[2].userImageURL)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//        
//        if  eventDetail.tempImage != nil {
//            eventPostImage.sd_setImage(with: URL(string: (eventDetail.tempImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//        } else {
//            eventPostImage.image = #imageLiteral(resourceName: "demoNewsImg")
//        }
//
//        myPost(detail: eventDetail)
//    }
//    func myPost(detail: EventDetail?) {
//        
//        guard let detail = detail else {
//            
//            return
//        }
//        if myUserDefaults.userId == detail.userID {
//            isMyPost = true
//        }
//        else {
//            isMyPost = false
//        }
//    }
//    
//    func showPDF(at: URL) {
//        self.hideActivity()
//        documentInteractionController = UIDocumentInteractionController(url: at)
//        documentInteractionController.delegate = self
//        DispatchQueue.main.async { [self] in
//            documentInteractionController.presentPreview(animated: true)
//        }
//    }
//    
//    func download(url: URL, type: String) {
//        let task = URLSession.shared.downloadTask(with: url) { (localURL, response, error) in
//            // Check for errors
//            guard error == nil else {
//                self.hideActivity()
//                print("Error downloading PDF: \(error!.localizedDescription)")
//                return
//            }
//
//            // Check if the response status code indicates success
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                // Handle the downloaded file
//                if let localURL = localURL {
//                    // Move the file to a destination of your choice
//                    let currentDate = Date()
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd-MMM-yyyy_HH:mm:ss"
//                    let formattedDateString = dateFormatter.string(from: currentDate)
//                    let path = "Aviation_\(formattedDateString).\(type)"
//                    let destinationURL = self.getDocumentsDirectory().appendingPathComponent(path)
//                    print("destinationURL:",destinationURL)
//                    do {
//                        try FileManager.default.moveItem(at: localURL, to: destinationURL)
//                        print("PDF downloaded and saved at: \(destinationURL)")
//                        self.showPDF(at: destinationURL)
//                    } catch {
//                        self.hideActivity()
//                        print("Error moving PDF file: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//        task.resume()
//        }
//    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//}
//
//// MARK: Network Calls
//extension EventCommentVC {
//    
////    func addComments(postId: Int, text: String, completion: @escaping (Bool?, Error?) -> Void) {
////
////        let parameters: AFParameters = [ "event_id": postId,
////                                         "created_by_id" :  LoggedUserDetails.shared.user!.id,
////                                         "status": "active",
////                                         "content": text.encodeEmoji ]
////
////        NetworkManagerr.request(EndPoints.addEventComment, method: .post, parameters: parameters) { (response) in
////            self.view.isUserInteractionEnabled = true
////            if response.result.isSuccess {
////                do {
////                    let jsonDecoder = JSONDecoder()
////                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
////
////                    if !genericResponse.error {
////                        self.commentTV.text = ""
////                        completion(true, nil)
////                    }
////                } catch {
////                    completion(nil, response.result.error)
////                }
////            } else {
////                completion(nil, response.result.error)
////            }
////        }
////    }
//    
//    func fetchEventDetail() {
//        let parameters: AFParameters = [ "id": eventId ?? 0]
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
//                    if !eventDetail.error, eventDetail.data.count > 0 {
//                        self.eventDetail = eventDetail.data[0]
//                        self.isEventLiked = self.eventDetail?.isEventLike == 1 ? true : false
//                        self.setUIData(eventDetail: eventDetail.data[0])
//                        self.ImgUrlString = eventDetail.data[0].floorPlan ?? ""
//                        self.registrationLink = eventDetail.data[0].registrationLink
//                        self.agenda = eventDetail.data[0].agenda == 1 ? true : false
//                        if self.agenda {
//                            self.buttonBaseViewHeightConst.constant = 32
//                            self.buttonBaseViewTopConst.constant = 21
//                            self.buttonBaseView.isHidden = false
//                            self.liveFloorplanBtn.isHidden = false
//                            if !self.isGalleryEnable {
//                                self.fetchAgenda()
//                            }
//                        } else {
//                            self.buttonBaseViewHeightConst.constant = 0
//                            self.buttonBaseViewTopConst.constant = 0
//                            self.buttonBaseView.isHidden = true
//                            self.liveFloorplanBtn.isHidden = true
//                        }
//                        self.fetchInvitedPeople()
//                        if LoggedUserDetails.shared.user?.isUser ?? false { //self.checkIsEventFavourite()
//                            
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//    
//    func fetchInvitedPeople() {
//        let parameters: AFParameters = [ "event_id": eventId ?? 0]
//        showActivity()
//        NetworkManagerr.request(EndPoints.invitedByYou, method: .post, parameters: parameters) { (response) in
//            
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let invitedPeopleRoot = try decoder.decode(InvitedPeopleDataModel.self, from: response.data!)
//                    
//                    if !(invitedPeopleRoot.error ?? false), invitedPeopleRoot.data?.count ?? 0 > 0 {
//                        self.invitedPeople = invitedPeopleRoot.data ?? []
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//    
//    func fetchAgenda() {
//        let parameters: AFParameters = ["event_id": self.eventId ?? 0]
//        showActivity()
//        NetworkManagerr.request(EndPoints.agenda, method: .post, parameters: parameters) { (response) in
//            
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let agendaRoot = try decoder.decode(AgendaListDataModel.self, from: response.data!)
//                    
//                    if !(agendaRoot.error ?? false), agendaRoot.data?.count ?? 0 > 0 {
//                        self.filterAgendaList = agendaRoot.data ?? []
//                        self.filterAgendaCollectionVw.reloadData()
//                    } else {
//                        self.presentAlert("Error:", agendaRoot.message)
//                    }
//                } catch {
//                    print("Error:", error)
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    func fetchAgendaList() {
////        var type = ""
////        switch selectedTabFilterIndex {
////        case 0:
////            type = "achl"
////        case 1:
////            type = "asa"
////        case 2:
////            type = "uldcare"
////        case 3:
////            type = "airfreightpharma"
////        default:
////            break
////        }
//        var type = filterAgendaList[selectedTabFilterIndex].agendaType
//        let parameters: AFParameters = [ "eventid": eventId ?? 0,
//                                         "adendatype": type ?? ""]
//        showActivity()
//        NetworkManagerr.request(EndPoints.agendaList, method: .post, parameters: parameters) { (response) in
//            
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let agendaRoot = try decoder.decode(AgendaDataModel.self, from: response.data!)
//                    
//                    if !(agendaRoot.error ?? false), agendaRoot.data?.count ?? 0 > 0 {
//                        self.AgendaList = agendaRoot.data ?? []
//                        
//                    } else {
//                        self.presentAlert("Error:", agendaRoot.message)
//                    }
//                } catch {
//                    print("Error:", error)
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    func fetchGalleryDetail(fileType: String) {
//        let parameters: AFParameters = [ "eventid": eventId ?? 0,
//                                         "filetype": fileType]
//        showActivity()
//        NetworkManagerr.request(EndPoints.gallerylist, method: .post, parameters: parameters) { (response) in
//            
//            self.hideActivity()
//            if response.result.isSuccess {
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let galleryRoot = try decoder.decode(GalleryDataModel.self, from: response.data!)
//                    
//                    if !(galleryRoot.error ?? false), galleryRoot.data?.count ?? 0 > 0 {
////                        self.galleryObj = galleryRoot.data?[0]
////                        let urlString = self.galleryObj?.file ?? ""
////                        self.galleryArr = urlString.components(separatedBy: ",")
//                        self.galleryArr.removeAll()
//                        self.galleryArr = galleryRoot.data ?? []
//                        self.photoCollectionView.reloadData()
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//        
//    func fetchEventDelegateList() {
//        let parameters: AFParameters = [ "event_id": self.eventId ?? 0]
//        showActivity()
//        NetworkManagerr.request(EndPoints.eventDelegateList, method: .post, parameters: parameters) { (response) in
//            self.hideActivity()
//            do {
//                let decoder = JSONDecoder()
//                let eventDelegate = try decoder.decode(EventDelegateListResponse.self, from: response.data!)
//                print("Event Delegate List :: \(eventDelegate.data?.count ?? 0)")
//                
//                if eventDelegate.data?.count ?? 0 > 0 {
//                    self.eventDelegateListArr = eventDelegate.data!
//                    self.searchEventDelegateArr = self.eventDelegateListArr
//                    self.delegatesTableView.reloadData()
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//  
//    
////    func getAllComments() {
////
////        let parameters: AFParameters = [ "event_id" : eventId! ]
////        showActivity()
////        NetworkManagerr.request(EndPoints.getEventCommentByFilterId, method: .post, parameters: parameters) { (response) in
////
////            self.hideActivity()
////            if response.result.isSuccess {
////
////                do {
////                    let jsonDecoder = JSONDecoder()
////                    let commentsRoot = try jsonDecoder.decode(CommentDetailRoot.self, from: response.data!)
////
////                    if commentsRoot.data.count > 0 {
////                        //self.tableView.isHidden = false
////                        self.fetchEventDetail()
////                        self.comments.removeAll()
////                        self.comments.append(contentsOf: commentsRoot.data)
////                        self.tableView.reloadData()
////                    }
////                    else {
////                           // self.tableView.isHidden = true
////                    }
////                }
////                catch {
////                    self.presentAlert("Failure", nil, response.result.error)
////                }
////            } else {
////                self.presentAlert("Failure", nil, response.result.error)
////            }
////        }
////    }
////    func updateComment(content: String, sender: UIButton) {
////        let commentId = comments[sender.tag].id
////        let parameters: AFParameters = [ "content": content,
////                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
////                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
////        let url = "\(EndPoints.updateEventComment)\(commentId)/"
////        NetworkManagerr.request(url, method: .patch, parameters: parameters) { (response) in
////            self.view.isUserInteractionEnabled = true
////            if response.result.isSuccess {
////                let data = response.result.value as? NSDictionary
////                let error = data?["error"] as? Int
////                //IHProgressHUD.dismiss()
////                self.view.isUserInteractionEnabled = true
////                if error == 0 {
////                    self.getAllComments()
////                    self.view.isUserInteractionEnabled = true
////                    self.commentTV.textColor = .lightGray
////                    self.commentTV.text = Constants.Chat.reply
////                }
////                else {
////                    // self.makeAlert(messageData:data?["message"] as! String)
////                    self.view.isUserInteractionEnabled = true
////                }
////
////            } else {
////                //self.makeAlert(messageData:response.data?["message"] as! String)
////            }
////        }
////    }
////    func deleteComment(content: String, sender: UIButton) {
////        let commentId = comments[sender.tag].id
////
////        let url = "\(EndPoints.deleteEventComment)\(commentId)/"
////        let parameters: AFParameters = [ "status":"deleted",
////                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
////                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
////
////        NetworkManagerr.request(url,method: .delete, parameters: parameters) { (response) in
////            self.view.isUserInteractionEnabled = true
////            if response.result.isSuccess {
////                let data = response.result.value as? NSDictionary
////                let error = data?["error"] as? Int
////                //IHProgressHUD.dismiss()
////                self.view.isUserInteractionEnabled = true
////                if error == 0 {
////                    self.getAllComments()
////                    self.mode = .create
////                    self.commentTV.text = ""
////                    self.view.isUserInteractionEnabled = true
////                }
////                else {
////                    // self.makeAlert(messageData:data?["message"] as! String)
////                    self.view.isUserInteractionEnabled = true
////                }
////
////            } else {
////                //self.makeAlert(messageData:response.data?["message"] as! String)
////            }
////        }
////    }
//    
//    func likeEventPost(postId: Int,
//                       status: String,
//                       action: String) {
//        let parameters: AFParameters = [  "event_id" : postId,
//                                          "created_by_id" : LoggedUserDetails.shared.user?.id ?? 0,
//                                          "status": status,
//                                          "action": action ]
//        showActivity()
//        NetworkManagerr.request(EndPoints.eventLikePost, method: .post, parameters: parameters) { (response) in
//            self.hideActivity()
//            self.view.isUserInteractionEnabled = true
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
//                    if !genericResponse.error {
//                        self.fetchEventDetail()
//                        // completion(true, nil)
//                    }
//                } catch {
//                    self.presentAlert("Failure", nil, response.error)
//                }
//            }
//        }
//    }
//    
//    
////    func updateEventAttendingStatus() {
////
////        let parameters: AFParameters = [ "user_id": LoggedUserDetails.shared.user!.id,
////                                         "event_id": eventId!,
////                                         "status": "active",
////                                         "attendance_status": "Going",
////                                         "os": "ios",
////                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
////                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
////
////        showActivity()
////        NetworkManagerr.request(EndPoints.eventAttendeeStatusUpdate, method: .patch, parameters: parameters) { (response) in
////            self.hideActivity()
////            if response.result.isSuccess {
////                do {
////                    let jsonDecoder = JSONDecoder()
////                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
////
////                    if !genericResponse.error {
////                        self.fetchEventDetail()
////                    }
////
////                } catch {
////                    self.presentAlert("Failure", nil, response.error)
////                }
////            } else {
////                self.presentAlert("Failure", nil, response.error)
////            }
////        }
////    }
//    
////    func modifyEventDetails(details: EventDetail) {
////        var parameters: AFParameters = ["modified_by_id": LoggedUserDetails.shared.user!.id,
////                                        "modified_datetime": "2020-02-27 00:00" ]
////
////        if name.text !=  details.name {
////            parameters["name"] = name.text!
////        }
////
////        let (isUpdated, isPrivate) = eventTypeUpdate()
////        if isUpdated {
////            parameters["is_private"] = isPrivate!
////        }
////
////        if location.text != details.address {
////            parameters["address"] = location.text!
////        }
////
////        if self.eventDescription.text != details.content {
////            parameters["content"] = self.eventDescription.text!
////        }
////
////        let partcipantIds = participants.compactMap({ $0.attendee.id })
//////        if partcipantIds != details.attendees.compactMap({ $0.id }) {
//////            parameters["attendees"] = partcipantIds
//////        }
////
////        var images: [UIImage] = []
////        if imageChanged {
////            images.append(eventImage.image!)
////        }
////
////        let url  = EndPoints.eventDetail + "\(details.id)/"
////
////        NetworkManagerr.requestWithImages(url, images: images, imageName: "event_image", method: .patch, parameters: parameters) { (response, error) in
////
////            if let response = response {
////
////                if response.result.isSuccess {
////                    let decoder = JSONDecoder()
////                    let generic = try? decoder.decode(GenericResponse.self, from: response.data!)
////
////                    if let generic = generic {
////                        if !generic.error && generic.message == "Update Record Successful." {
////                            self.presentAlertWithAction(title: "Success", message: "Event Details Updated") {
////                                self.attentendingBtn.backgroundColor = AppColors.evaBlue
////                                self.attentendingBtn.setImage(UIImage(), for: .normal)
////                                self.attentendingBtn.setTitle("Updated", for: .normal)
////                                self.attentendingBtn.isUserInteractionEnabled = false
////
////                            }
////                        }
////                    }
////                }
////            }
////        }
////    }
//
//    func eventTypeUpdate() -> (Bool, String?) {
//          
////          switch (eventDetail!.isPrivate, eventDescription.text!) {
////          case (0, "Public"), (0, "Open to the public"):
////              return (false, nil)
////          case (1, "Public"), (1, "Open to the public"):
////              return (true, "0")
////          case (0, "Private"):
////              return (true, "1")
////          default:
//              return (false, nil)
////          }
//      }
//}
//
//// MARK: - Document Interaction Controller Delegate methods -
//extension EventCommentVC: UIDocumentInteractionControllerDelegate {
//    
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        self
//     }
//    
//    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
//        documentInteractionController = nil
//    }
//    
//}
//
////MARK: TEXTVIEW DELEGATES
//extension EventCommentVC: UITextFieldDelegate {
//    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if commentTV.text.count > 0  && commentTV.text.count != 0 && !commentTV.text.isEmpty{
//            self.textIsOk = false
//        } else {
//            self.textIsOk = true
//        }
//        return true
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if commentTV.textColor == .lightGray {
//            commentTV.text = nil
//            commentTV.textColor = .black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if commentTV.text.isEmpty {
//            commentTV.text = Constants.Chat.reply
//            commentTV.textColor = UIColor.lightGray
//        }
//    }
//}
//
////MARK: TABLEVIEW DELEGATES
//extension EventCommentVC: UITableViewDataSource, UITableViewDelegate {
// 
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (tableView == self.agendaListTblVw) {
//            return AgendaList.count
//        }
//        else if (tableView == self.delegatesTableView) {
//            if self.isFilter {
//                return self.eventDelegateFilterArr.count
//            } else {
//                return self.searchEventDelegateArr.count
//            }
//        }
//        else {
//            return comments.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (tableView == self.agendaListTblVw) {
//            let height = (10 * 40.0) + 100.0
//            return height
//        }
//        else if (tableView == self.delegatesTableView) {
//            return 100
//        }
//        else {
//            return 200
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if (tableView == self.agendaListTblVw) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EventAgendaTimeTblCell", for: indexPath) as! EventAgendaTimeTblCell
//            let obj = AgendaList[indexPath.row]
//            cell.baseView.layer.cornerRadius = 13.0
//            cell.mainDayLbl.text = "Day \(obj.day ?? 0)"
//            cell.dateLbl.text = "\(obj.date ?? "")"
//            self.downloadPDFLink = obj.downloadLink ?? ""
//            if let data = obj.dayRelatedData {
//                cell.dayData = data
//            }
//            return cell
//        }
//        else if (tableView == self.delegatesTableView) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDelegatesTblCell", for: indexPath) as! EventDelegatesTblCell
//            cell.baseView.layer.cornerRadius = 13.0
//            
//            if self.isFilter {
//                let obj = self.eventDelegateFilterArr[indexPath.row]
//                
//                let imgUrl = obj.userImageURL ?? ""
//                if imgUrl.elementsEqual("") {
//                    cell.profileImgVw.image = UIImage(named: "profile")
//                } else {
//                    cell.profileImgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//                }
//                cell.titleLabel.text = "\(obj.firstName ?? "") \(obj.lastName ?? "")"
//                cell.subTitleLabel.text = "\(obj.designation ?? "") | \(obj.companyName ?? "")"
//
//                let isOnline = obj.isOnline ?? false
//                if isOnline {
//                    cell.statusView.isHidden = false
//                } else {
//                    cell.statusView.isHidden = true
//                }
//                cell.viewProfileBtn.tag = indexPath.row
//                cell.viewProfileBtn.addTarget(self, action: #selector(viewProfileBtnTapped(sender:)), for: .touchUpInside)
//            }
//            else {
//                let obj = self.searchEventDelegateArr[indexPath.row]
//                let imgUrl = obj.userImageURL ?? ""
//                if imgUrl.elementsEqual("") {
//                    cell.profileImgVw.image = UIImage(named: "profile")
//                } else {
//                    cell.profileImgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
//                }
//                
//                cell.titleLabel.text = "\(obj.firstName ?? "") \(obj.lastName ?? "")"
//                cell.subTitleLabel.text = "\(obj.designation ?? "") | \(obj.companyName ?? "")"
//                
//                let isOnline = obj.isOnline ?? false
//                if isOnline {
//                    cell.statusView.isHidden = false
//                } else {
//                    cell.statusView.isHidden = true
//                }
//                cell.viewProfileBtn.tag = indexPath.row
//                cell.viewProfileBtn.addTarget(self, action: #selector(viewProfileBtnTapped(sender:)), for: .touchUpInside)
//            }
//            return cell
//        }
//        else {
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id(), for: indexPath) as! CommentCell
//            cell.comment = comments[indexPath.row]
//            cell.isMyPost = isMyPost
//            cell.commentMode = .otherComment
//            cell.delegate = self
//            cell.moreOption.tag = indexPath.row
//            cell.goToProfileBtn.tag = indexPath.row
//            
//            cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileTapped(_:)), for: .touchUpInside)
//            return cell
//        }
//    }
//    
//    @objc private func viewProfileBtnTapped(sender: UIButton) {
//        if isIndivisualUser {
//            let vc = StoryboardRouter.eventDelegateProfileVC()
//            
//            if self.isFilter {
//                let obj = self.eventDelegateFilterArr[sender.tag]
//                vc.eventId = self.eventId
//                vc.companyName = obj.companyName ?? ""
//                vc.companyId = obj.companyId ?? ""
//                vc.userId = obj.id ?? 0
//            } else {
//                let obj = self.searchEventDelegateArr[sender.tag]
//                vc.eventId = self.eventId
//                vc.companyName = obj.companyName ?? ""
//                vc.companyId = obj.companyId ?? ""
//                vc.userId = obj.id ?? 0
//            }
//            vc.completion = { selectedTab in
//                self.selectedTab = selectedTab
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let obj = self.searchEventDelegateArr[sender.tag]
//            let vc = StoryboardRouter.othersProfileVC()
//            vc.isFrom = 2
//            vc.profileID = obj.id ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    @objc func openArticle() {
//        if let urlString = registrationLink, let url = URL(string: urlString), urlString.isValidEmail {
//            let webVC = WebVC(url: url)
//            present(webVC, animated: true, completion: nil)
//        }
//    }
//    
//}
//
////MARK: Custom Action
//extension EventCommentVC {
//    
//    @objc func eventLikePost(sender: UIButton) {
//       
//        if eventDetail?.isEventLike != nil && eventDetail?.isEventLike != 0{
//            likeEventPost(postId: eventDetail?.id ?? 0, status:"pending", action: "unlike")
//        } else {
//            likeEventPost(postId: eventDetail?.id ?? 0, status:"pending", action: "like")
//        }
//    }
//
//    
//    @objc func updateEventStatus() {
//        view.isUserInteractionEnabled = true
////        updateEventAttendingStatus()
//    }
//    
//    @objc func goToProfileTapped(_ sender: UIButton) {
//        let vc = StoryboardRouter.othersProfileVC()
//        let comment = comments[sender.tag]
//        vc.profileID = comment.user.id
//        vc.isFrom = 0
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//// MARK: COLLECTIONVIEW DELEGATES
//extension EventCommentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    //MARK: CollectionView Delegates
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if (collectionView == self.filterAgendaCollectionVw) {
//            if isGalleryEnable{
//                return self.activeFilter.count
//            } else {
//                return self.filterAgendaList.count
//            }
//        }
//        else if (collectionView == self.sponsorsCollectionView) {
//            return 13
//        }
//        else if (collectionView == self.exhobitorsCollectionView) {
//            return 13
//        } else if (collectionView == self.photoCollectionView) {
//            return galleryArr.count
//        }
//        else {
//            //participants.count
//            return invitedPeople.count + 1 
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if (collectionView == self.filterAgendaCollectionVw) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailTabsCell", for: indexPath) as! EventDetailTabsCell
//            
//            cell.layer.cornerRadius = cell.frame.size.height/2
//            cell.layer.borderWidth = 1.0
//            if isGalleryEnable{
//                cell.titleLbl.text = self.activeFilter[indexPath.row]
//            } else {
//                cell.titleLbl.text = self.filterAgendaList[indexPath.row].agendaType
//            }
//            
//            if selectedTabFilterIndex == indexPath.row {
//                cell.titleLbl.textColor = UIColor(hex: "#4D76CD")
//                cell.backgroundColor = UIColor(hex: "#4D76CD",alpha: 0.10)
//                cell.borderColor = UIColor(hex: "#4D76CD",alpha: 1)
//            } else {
//                cell.titleLbl.textColor = UIColor(hex: "#707070",alpha: 0.50)
//                cell.backgroundColor = UIColor.clear
//                cell.borderColor = UIColor(hex: "#707070",alpha: 0.20)
//            }
//            return cell
//        }
//       else if (collectionView == self.sponsorsCollectionView) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorsCollectionCell", for: indexPath) as! SponsorsCollectionCell
//            cell.layer.cornerRadius = cell.frame.size.width/2
//           // Set the background image
//           let backgroundImage = UIImage(named: "sponsors")!
//           let imageSize = CGSize(width: 40, height: 40)
//           cell.setBackgroundImage(image: backgroundImage, size: imageSize)
////           cell.setBackgroundImage(image: backgroundImage)
//            return cell
//        }
//        else if (collectionView == self.exhobitorsCollectionView) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorsCollectionCell", for: indexPath) as! SponsorsCollectionCell
//            // Set the background image
//            let backgroundImage = UIImage(named: "exibitors")!
//            let imageSize = CGSize(width: 40, height: 40)  // Adjust the size as needed
//            cell.setBackgroundImage(image: backgroundImage, size: imageSize)
//            cell.layer.cornerRadius = cell.frame.size.width/2
//            return cell
//        }
//        else if (collectionView == self.photoCollectionView) {
//                
//            let obj = galleryArr[indexPath.row]
//                switch selectedTabFilterIndex {
//                case 0: //Photos selected
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCVCell.ReuseId, for: indexPath) as! GalleryCVCell
////                    cell.photoView.image = UIImage(named: "demoNewsImg")
//                    cell.photoView.isHidden = false
//                    cell.videoParentView.isHidden = true
//                    cell.playImgView.isHidden = true
//                    cell.presentationVw.isHidden = true
//                    
//                    let imgStr = self.galleryArr[indexPath.row].file ?? ""
//                    cell.photoView.sd_setImage(with: URL(string: imgStr), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
//                    return cell
//                case 1: //Videos selected
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCVCell.ReuseId, for: indexPath) as! GalleryCVCell
//                    
////                    cell.backgroundColor = UIColor.lightGray
//                    cell.photoView.isHidden = true
//                    cell.videoParentView.isHidden = false
//                    cell.playImgView.isHidden = false
//                    cell.presentationVw.isHidden = true
//                    
//                    if let videoURL = URL(string: obj.file ?? "") {
//                        cell.indicatorView.isHidden = false
//                        cell.indicatorView.startAnimating()
//                        
//                        generateThumbnail(for: videoURL) { thumbnail in
//                            if let thumbnail = thumbnail {
//                                // Use the thumbnail image
//                                cell.indicatorView.stopAnimating()
//                                cell.indicatorView.isHidden = true
//                                print("Thumbnail generated successfully!")
//                                cell.videoThumbImg.image = thumbnail
//                            } else {
//                                // Handle error
//                                cell.indicatorView.stopAnimating()
//                                cell.indicatorView.isHidden = true
//                                cell.videoThumbImg.image = UIImage(named: "noImage")
//                                print("Error generating thumbnail.")
//                            }
//                        }
//                    } else {
//                        cell.videoThumbImg.image = UIImage(named: "noImage")
//                        print("Video file not found.")
//                    }
//                    
//                    //let videoStr = self.galleryArr[indexPath.row].file ?? ""
//                    //cell.videoView.backgroundColor = .black
//                    //cell.videoView.configure(url: videoStr,ratio: .resize)
//                    //cell.videoView.stop()
//                    
//                    return cell
//                case 2: //Presentation selected
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCVCell.ReuseId, for: indexPath) as! GalleryCVCell
////                    cell.photoView.image = UIImage(named: "demoNewsImg")
//                    //cell.photoView.sd_setImage(with: URL(string: obj), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
//                    cell.photoView.isHidden = true
//                    cell.videoParentView.isHidden = true
//                    cell.playImgView.isHidden = true
//                    cell.presentationVw.isHidden = false
//                    
//                    let obj = self.galleryArr[indexPath.row]
//                    cell.presentationImgVw.sd_setImage(with: URL(string: obj.thumbnail ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
//                    cell.presentationTitleLbl.text = obj.title ?? ""
//                    
//                    return cell
//                default:
//                    break
//                }
//                
//        }
//        else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddParticipantCell.ReuseId, for: indexPath) as? AddParticipantCell else {
//                return UICollectionViewCell()
//            }
//            if indexPath.row == self.invitedPeople.count {
//                cell.defaultUI()
//                return cell
//            } else {
//                cell.invitedPeople = invitedPeople[indexPath.row]
//                cell.showCross = false
//                return cell
//            }
//            
//        }
//        return UICollectionViewCell()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if (collectionView == self.filterAgendaCollectionVw) {
//            let label = UILabel(frame: CGRect.zero)
//            if agenda && !isGalleryEnable {
//                label.text = filterAgendaList[indexPath.item].agendaType
//            } else {
//                label.text = activeFilter[indexPath.item]
//            }
//            
//            label.sizeToFit()
//            var width = label.frame.width + 30
//            var height = (self.filterAgendaCollectionVw.frame.size.height - 4)
//            
//            if width < ((self.filterAgendaCollectionVw.frame.size.width/4) - 8) {
//                width = ((self.filterAgendaCollectionVw.frame.size.width/4) - 8)
//            }
//            return CGSize(width: width, height: height)
//        }
//        else if (collectionView == self.sponsorsCollectionView) {
//            let width = (self.sponsorsCollectionView.frame.size.width / 7) - 13
//            return CGSize(width: width, height: width)
//        }
//        else if (collectionView == self.exhobitorsCollectionView) {
//            let width = (self.exhobitorsCollectionView.frame.size.width / 7) - 13
//            return CGSize(width: width, height: width)
//        }
//        else if (collectionView == self.photoCollectionView) {
//            switch selectedTabFilterIndex {
//            case 0: //Photos
//                let width = (self.photoCollectionView.frame.size.width / 2) - 5
//                return CGSize(width: width, height: 114)
//
//            case 1: //Videos
//                let width = (self.photoCollectionView.frame.size.width / 2) - 5
//                return CGSize(width: width, height: 114)
//
//            case 2: //Presentation
//                let width = (self.photoCollectionView.frame.size.width) - 10
//                return CGSize(width: width, height: 170)
//
//            default:
//                return CGSize(width: 0, height: 0)
//            }
//        }
//        else {
//            //        let inset: CGFloat = 3
//            //        let width = view.frame.width * 0.25
//            //        let height = collectionView.frame.height
//            //        return CGSize(width: width - inset, height: height)
//            return CGSize(width: (self.invitedPepleCollection.frame.size.width/2) - 13, height: 70)
//        }
//
//    }
// 
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (collectionView == self.filterAgendaCollectionVw) {
//            self.selectedTabFilterIndex = indexPath.row
//            
//            if isGalleryEnable {
//                switch activeFilter[indexPath.item] {
//                case "Photo":
//                    selectedFilter = activeFilter[indexPath.item]
//                    fetchGalleryDetail(fileType: "image")
//                case "Videos":
//                    selectedFilter = activeFilter[indexPath.item]
//                    fetchGalleryDetail(fileType: "video")
//                case "Presentation":
//                    selectedFilter = activeFilter[indexPath.item]
//                    fetchGalleryDetail(fileType: "ppt")
//                default:
//                    fetchAgendaList()
//                    print("Agenda")
//                    
//                }
//            }
//            self.filterAgendaCollectionVw.reloadData()
//            //self.photoCollectionView.reloadData()
//        } else if (collectionView == self.photoCollectionView) {
//            self.isFirstTime = false
//            if self.selectedFilter.elementsEqual("Photo") {
//                let vc = StoryboardRouter.mediaPlayerVC()
//                vc.type = .image
//                vc.galleryArr = self.galleryArr
//                vc.selectedIndex = indexPath.row
//                vc.selectedTab = 1
//                vc.completion = { selectedTab in
//                    
//                    self.selectedTab = selectedTab
//                }
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            else if self.selectedFilter.elementsEqual("Videos") {
//                let vc = StoryboardRouter.mediaPlayerVC()
//                vc.type = .video
//                vc.galleryArr = self.galleryArr
//                vc.selectedTab = 1
//                vc.selectedIndex = indexPath.row
//                vc.completion = { selectedTab in
//                    
//                    self.selectedTab = selectedTab
//                }
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            else if self.selectedFilter.elementsEqual("Presentation") {
//                //fetchGalleryDetail(fileType: "ppt")
//                let str = galleryArr[indexPath.row].file ?? ""
//                self.openArticle(str: str)
//            }
//            else {
//                print("Agenda")
//            }
//        }
//        else if (collectionView == self.invitedPepleCollection) {
//            if indexPath.row == invitedPeople.count {
//                print("Invite")
//                handleShare()
//            } else {
//                print("Remove")
////                removeParticipant(indexPath)
//            }
//        }
//        else {
//            if participants[indexPath.item].type == .creator { tappedCell() }
//        }
//    }
//    
//    @objc func openArticle(str: String) {
//        let url = URL(string: str)!
//        let webVC = WebVC(url: url)
//        present(webVC, animated: true, completion: nil)
//    }
//}
//
//extension EventCommentVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
//    }
//}
//
//extension EventCommentVC: ConnectionsProvidable {
//    func updateConnections(connections: [User]) {
////        let participants = connections.compactMap { convertUserToParticipant(connection: $0) }
////        self.participants = participants.map({ (attendee: $0, type: .invited) })
////        invitedPepleCollection.reloadData()
//    }
//}
//
//extension EventCommentVC: AddParticipantActionable {
//
//    func tappedCell() {
//        let inviteConnections = StoryboardRouter.inviteConnections()
//        inviteConnections.invitationType = .attendees
//        inviteConnections.delegate = self
//        self.navigationController?.pushViewController(inviteConnections, animated: true)
//    }
//}
//extension EventCommentVC: PostActionable {
//    
//    func actionType(sender: UIButton, action: HomeCellAcitonType) {
//        
//       
//        
//        switch action {
//        case .edit:
//            commentTV.becomeFirstResponder()
//            commentTV.text = comments[sender.tag].content
//            mode = .edit
//            senderButton = sender
//        break
//        case .delete:
//            let alert = UIAlertController(title: "Delete", message: "Do you want to Delete this Comment", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
////                self.deleteComment(content: "", sender: sender)
//            }))
//            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        break
//        default:
//        break
//        }
//        
//    }
//    
//    
//}
//extension EventCommentVC {
//    
//    @objc func handleShare(){
////        guard let eventDetails = eventDetail else {
////            return
////        }
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
//        vc.objectId = self.eventId
//        vc.type = .event
//        vc.completion = {
//            self.fetchInvitedPeople()
//        }
//        vc.modalPresentationStyle = .popover
//        self.present(vc, animated: true)
////        openShareVC(id: eventDetails.id ?? 0, type: .event)
//    }
//    
//    func generateThumbnail(for videoURL: URL, completion: @escaping (UIImage?) -> Void) {
//        DispatchQueue.global().async {
//            let asset = AVURLAsset(url: videoURL)
//            let generator = AVAssetImageGenerator(asset: asset)
//            generator.appliesPreferredTrackTransform = true
//
//            // Seek to the middle of the video for the thumbnail
//            let time = CMTime(seconds: asset.duration.seconds / 2, preferredTimescale: 1)
//            
//            do {
//                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
//                let thumbnail = UIImage(cgImage: cgImage)
//                DispatchQueue.main.async {
//                    completion(thumbnail)
//                }
//            } catch {
//                print("Error generating thumbnail: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            }
//        }
//    }
//}
//
////Sponsors & Exhibitors Collection Cell Class.....
//class SponsorsCollectionCell: UICollectionViewCell
//{
//    func setBackgroundImage(image: UIImage, size: CGSize) {
//            let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFill
//            imageView.frame.size = size
//            imageView.layer.cornerRadius = size.width / 2
//            imageView.clipsToBounds = true
//            self.backgroundView = imageView
//    }
//}
