//
//  BaseVC.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Modified by Muhammad Salman Zafar on 24/12/2021.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

@IBDesignable
class BaseVC: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Variables
    static let shared = BaseVC()
    var isMenuShown = false
    var editDeleteVC: EditDeleteView?
    private let locationManager = CLLocationManager()
    var picker = UIImagePickerController()
   // var dismissGesturee: UITapGestureRecognizer!

    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
    
    var searchButton: UIBarButtonItem?
    var hamBurgerButton: UIBarButtonItem?
    var bottomShareSheet: BottomContentPicker!
    var navigationBarSeparator: UIView?
    
    var isSeparatorHidden: Bool = true {
        didSet {
            customNavigation(isSeparatorHidden: isSeparatorHidden)
        }
    }
    
    var notificationsSeen: Bool = false {
         didSet {
            getNotificationCount()
         }
     }
    
    private var slideMenuVC: SlideMenuVC!
    private var slideMenuHidden = false

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // inittUI()
        
        addBaseView()
        setSlideMenuVC()
        customNavigation(isSeparatorHidden: isSeparatorHidden)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    func addBaseView() {
        let superview = UIView()
        superview.translatesAutoresizingMaskIntoConstraints = false
        superview.backgroundColor = UIColor.init(hex: "#F8F6F8")
        //view.addSubview(superview)
        
        self.view.insertSubview(superview, at: 0)
        //self.view.insertSubview(superview, belowSubview: view)

        // Add constraints to make the superview fill the safe area
        NSLayoutConstraint.activate([
            superview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            superview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            superview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            superview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Session Saving
    static func saveUser(user: EvaUser) {

        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: "UserModel")
        }
    }
    
    static func GetUser() -> EvaUser? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "UserModel") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(EvaUser.self, from: savedPerson) {
                return loadedPerson
            } else {
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    //MARK: setViewShadow
    func setCardView(view : UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
    }
    
    func setButton(view: UIButton, ConnerByHeight: Bool = false, setBoader: Bool = false, boderColor: UIColor = .white) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width:1,height:1);
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        if ConnerByHeight == true{
            view.layer.cornerRadius = (view.frame.height)/2
        } else {
            view.layer.cornerRadius = (view.frame.width)/2
        }
    }
    //MARK: setImageShadow
    func makeImageRound(view: UIImageView, setBoader: Bool = false){
        view.clipsToBounds=true
        view.layer.cornerRadius =  (view.layer.frame.height)/2
        if setBoader == true{
            view.layer.borderWidth = 1
            //view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.backgroundColor = .white
            //view.backgroundColor = backColor
            view.layer.borderColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            view.layer.borderWidth = 3
        }
    }

    //MARK: AlertMsg
    func makeAlert(titleMsg:String = "Error",messageData:String){
        let alert = UIAlertController(title: titleMsg, message: messageData, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeAlert2(titleMsg:String?="Success", messageData: String){
        let alert = UIAlertController(title: titleMsg, message: messageData, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func goBackByViewController(){
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func popToRoot(){
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func goBack(){
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: BackAction
    @objc func popVC(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: SetNavigationLeftImage
    

    func setAction(image: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapGesture(gesture:)))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    
    @objc func openGalleryy(video: Bool = false) {
        print("video", video)
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.mediaTypes = video ? ["public.image", "public.movie"] : ["public.image"]
                self.present(self.picker, animated: true, completion: nil)
            } else {
                
                let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alertWarning.show()
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.picker.modalPresentationStyle = .fullScreen
            self.picker.mediaTypes = video ? ["public.image", "public.movie"] : ["public.image"]
            self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGalleryData() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                self.present(self.picker, animated: true, completion: nil)
            }
            else {
                let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alertWarning.show()
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.picker.isEditing = true
            self.picker.modalPresentationStyle = .fullScreen
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setActionForImage(image: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(openGalleryy))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        
    }

    //MARK:SetCornerSmallRadius
    func giveButtonCorner(actionBtn: UIButton? = nil,setClipsBound: Bool = true,backColor: UIColor? = .white,giveShadow: Bool = false,outerLayerColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,addBorder: Bool = false) {
        if !giveShadow {
            actionBtn?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            actionBtn?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            actionBtn?.layer.shadowOpacity = 1.0
            actionBtn?.layer.shadowRadius = 5.0
            actionBtn?.layer.masksToBounds = false
            actionBtn?.layer.cornerRadius = 4.0

            
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
            actionBtn?.layer.borderColor = outerLayerColor?.cgColor
            actionBtn?.layer.borderWidth = 1
        }
        else {
            actionBtn?.clipsToBounds=true
            actionBtn?.clipsToBounds=true
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
            actionBtn?.backgroundColor = backColor
        }
        if !addBorder {
            actionBtn?.layer.cornerRadius =  (actionBtn?.layer.frame.height)!/2
          actionBtn?.layer.borderColor = outerLayerColor?.cgColor
            actionBtn?.layer.borderWidth = 1
        }
        if !setClipsBound {
                      actionBtn?.clipsToBounds=setClipsBound
                  }
                  else{
                      actionBtn?.clipsToBounds=setClipsBound
                  }
    }
    func buttonCustomization(actionBtn: UIButton? =  nil,setClipsBound: Bool = true,backColor: UIColor? =  .white,giveShadow: Bool = false,giveViewShadow: Bool = false,addImageShadow: Bool = false,borderColor: UIColor? = .black,addBorder: Bool = false){
          //for buttom with Shadow
          if !giveShadow {
              actionBtn?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
              actionBtn?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
              actionBtn?.layer.shadowOpacity = 1.0
              actionBtn?.layer.shadowRadius = 5.0
              actionBtn?.layer.masksToBounds = false
              actionBtn?.layer.cornerRadius = 4.0
              if setClipsBound == false{
                  actionBtn?.clipsToBounds=setClipsBound
              }
              else {
                  actionBtn?.clipsToBounds=setClipsBound
              }
            actionBtn?.layer.cornerRadius =  ((actionBtn?.layer.frame.height)!)/2
              actionBtn?.backgroundColor = backColor
              actionBtn?.layer.borderColor = borderColor?.cgColor
              actionBtn?.layer.borderWidth = 1
          }
          else {
              actionBtn?.clipsToBounds=true
            actionBtn?.layer.cornerRadius =  ((actionBtn?.layer.frame.height)!)/2
              actionBtn?.backgroundColor = backColor
          }
          if addBorder == true {
            actionBtn?.layer.cornerRadius =  ((actionBtn?.layer.frame.height)!)/2
              actionBtn?.backgroundColor = backColor
              actionBtn?.layer.borderColor = borderColor?.cgColor
              actionBtn?.layer.borderWidth = 1
          }
    }
}

extension BaseVC {

    func getNotificationCount() {
        if !slideMenuHidden { return }
        if let user = LoggedUserDetails.shared.user {

            let id = user.id
            let endPoint = EndPoints.notificationCount + "\(id)" + "/"
            NetworkManagerr.request(endPoint) { (response) in
                if response.result.isSuccess {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let notificationCountRoot = try jsonDecoder.decode(NotificationCountRoot.self, from: response.data!)

                        let notificationCount = notificationCountRoot.data[0]
                        self.slideMenuVC.notificationsLbl.text = "\(notificationCount.notification_count)"
                        self.slideMenuVC.connectionsLbl.text = "\(notificationCount.connection_count)"
                        
                    } catch {
                            //
                    }
                } else {
                    //
                }
            }
        }
    }
}

    //MARK: Custom Formate Function

func showTimeOnly(date: String) -> String {
    
    if let date = date.date(formatter: .standardDateWithTime) {
        return date.toString(formatter: .standardTimeOnly)
    }
    return ""
}

func calenderTimeOnly(getString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    if !dateFormatter.date(from: getString).isNil {
        let timeVa = dateFormatter.date(from: getString)!
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        let now2 = df.string(from: timeVa)
        return now2
    }
    else {
        return "3 March"
    }
}


func showMonthOnly(getString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
    if !dateFormatter.date(from: getString).isNil {
        let timeVa = dateFormatter.date(from: getString)!
        let df = DateFormatter()
        df.dateFormat = "MMM"
        let now2 = df.string(from: timeVa)
        let df2 = DateFormatter()
        df2.dateFormat = "hh:mm"
        return now2
     }
    else {
        return "3 March"
    }
}

func showDateOnly(getString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
    if !dateFormatter.date(from: getString).isNil {
        let timeVa = dateFormatter.date(from: getString)!
        let df = DateFormatter()
        df.dateFormat = "dd"
        let now2 = df.string(from: timeVa)
        return now2
     }
    else {
        return "3 March"
    }
}

func timeAgo2(_ getDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
    let date3 = dateFormatter.date(from: getDate)
    let calendar = Calendar.current
    let formatter: DateComponentsFormatter = {
        let _formatter = DateComponentsFormatter()
        _formatter.allowedUnits = [.day,.hour,.minute,.second]
        _formatter.unitsStyle = .short
        _formatter.maximumUnitCount = 1
        return _formatter
    }()
    // birthDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: picker.date))!
    let now = calendar.date(from: calendar.dateComponents([.year,.day, .weekOfMonth,.hour,.month,.minute,.second], from: Date()))!
    return  formatter.string(from: date3!, to: now)!
}

//MARK: Opening Gallery & Camera Actions

extension BaseVC {

    func openGalleryVideoOnly() {
        openGallery(source: .savedPhotosAlbum,
                    mediaType: kUTTypeMovie as String,
                    alertMessage: "Error opening up gallery")
    }
    func openGalleryImageOnly() {
        openGallery(source: .photoLibrary,
                    mediaType: kUTTypeImage as String,
                    alertMessage: "Error opening up gallery")
    }

    func openCameraVideoOnly() {

        openGallery(source: .camera,
                    mediaType: kUTTypeMovie as String,
                    alertMessage: "You don't have camera")
    }

    func openCameraImageOnly() {

        openGallery(source: .camera,
                    mediaType: kUTTypeImage as String,
                    alertMessage: "You don't have camera")
    }

    func openGallery(source: UIImagePickerController.SourceType, mediaType: String, alertMessage: String) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            picker.sourceType = source
            picker.allowsEditing = true
            picker.mediaTypes = [mediaType]
            present(self.picker, animated: true, completion: nil)
        }
        else {
            let alertWarning = UIAlertController(title: "Warning", message: alertMessage, preferredStyle: .alert)
            alertWarning.show()
        }
    }
}

//MARK: Custom Navigation
extension BaseVC {
    
    func customNavigation(isSeparatorHidden: Bool = false) {
        if navigationController == nil { return }
//        let hamBurgerImage = UIImage(named: "hamBurger")?.withRenderingMode(.alwaysOriginal)
//        hamBurgerButton = UIBarButtonItem(image: hamBurgerImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(openMenuu(_:)))
//
//        let searchIcon = UIImage(named: "TopSearch")?.withRenderingMode(.alwaysOriginal)
//        searchButton = UIBarButtonItem(image: searchIcon, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(openSearchVC(_:)))
        
        let hamBurgerImage = UIImage(named: "ic_sidemenu")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: hamBurgerImage, style: .plain, target: self, action: #selector(openMenuu(_:)))
        let searchIcon = UIImage(named: "ic_search")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(openSearchVC(_:)))
        

//        if !(self is SearchVC) {
//            self.navigationItem.rightBarButtonItems = [hamBurgerButton!, searchButton!]
//        } else {
//            self.navigationItem.rightBarButtonItem = hamBurgerButton
//        }
        
        if (self is SearchVC) {
            let searchIcon = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: nil)
        }
        
//        addLogo(#imageLiteral(resourceName: "NavLogo"))
        addImageCenterInNavigationBarItem()
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        if let navView = navigationController?.navigationBar.viewWithTag(6) {
            navView.removeFromSuperview()
//            navigationBarSeparator = nil
            
        }
        
            
        if !isSeparatorHidden {
            if !isBeingPresented{
                setNavLeftImage(image:#imageLiteral(resourceName: "NavLogo"))
            }
        }
    }
    
    fileprivate func addLogo(_ image: UIImage) {
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        containView.backgroundColor = .white
        imageview.image = image
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        containView.addSubview(imageview)
        //setAction(image: imageview)
        //
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        imageview.centerXAnchor.constraint(equalTo: containView.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: containView.centerYAnchor).isActive = true
    }
    
    func addImageCenterInNavigationBarItem() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_navLogo")
        //imageView.backgroundColor = .lightGray

        // In order to center the title view image no matter what buttons there are, do not set the
        // image view as title view, because it doesn't work. If there is only one button, the image
        // will not be aligned. Instead, a content view is set as title view, then the image view is
        // added as child of the content view. Finally, using constraints the image view is aligned
        // inside its parent.
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        self.navigationItem.titleView?.backgroundColor = .white
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    
    func setNavLeftImage(image: UIImage, isSeparatorHidden: Bool = false) {
                
        let separator = UIImageView()
        separator.tag = 6
        separator.image = UIImage(named: "separator")
        navigationBarSeparator = separator
        self.navigationController?.navigationBar.addSubview(separator)
        
        separator.withConstraints { (sView) -> [NSLayoutConstraint] in
            return [ sView.alignLeading(self.navigationController?.navigationBar),
                     sView.alignTrailing(self.navigationController?.navigationBar),
                     sView.alignBottom(self.navigationController?.navigationBar, constant: 1),
                     sView.constraintHeight(2.0) ]
        }
     }

    @objc func openMenuu(_ sender: UIBarButtonItem) {
        showSlideMenu()
//        getNotificationCount()
        slideMenuHidden.toggle()
    }
    
    @objc func openSearchVC(_ sender: UIBarButtonItem) {
        let vc = StoryboardRouter.searchVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BaseVC {
    
  
    func openShareVC(id: Int, type: TypePostEnum) {

        let shareVC = StoryboardRouter.sharePostVC()
        shareVC.modalTransitionStyle = .crossDissolve
        shareVC.modalPresentationStyle = .overFullScreen
        shareVC.postId = id
        shareVC.postType = type
        shareVC.delegate = self
        present(shareVC, animated: true, completion: nil)
    }
    
    
    @objc func logOutAlert() {
        didClose()
        showCustomAlert(title: "Are you sure you want to Logout?", doneTitle: "Logout", on: self.view) {
            print("Logout")
            // Add your action logic here
            self.logOut()
        }
//        let alert = UIAlertController(title: "Logout", message: "Do you want to Logout", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//            self.logOut()
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logOut() {
        
        UserDefaults.standard.removeObject(forKey: "UserToken")
        LoggedUserDetails.shared.logoutUser()
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: StoryboardRouter.login())
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    func handleWhatsup(shareValue: String) {
        let title = "EvaLinkShare"
        let shareURLString = shareValue
        
        let activityViewController = UIActivityViewController(activityItems: [title, shareURLString], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [.airDrop,
                                                        .postToFacebook,
                                                        .copyToPasteboard,
                                                        .postToTwitter,
                                                        .mail,
                                                        .assignToContact]
        
        // present the view controller
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        
        } else {
            // Fallback on earlier versions
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

extension BaseVC: SharePostDelegate {
    func selectedSharedType(classType: SharePostVC,type: ShareType, postType: TypePostEnum, postId: Int ){
      
        switch type {
        case .connection:
           // performSegue(withIdentifier: Constants.Segues.inviteConnections, sender: (postId, postType.rawValue))
            
            let inviteConnections = StoryboardRouter.inviteConnections()
            //inviteConnections.invitationType = .attendees
            inviteConnections.objectID = postId
            inviteConnections.type = postType
            inviteConnections.invitationType = .postShare
            //inviteConnections.delegate = self
            self.navigationController?.pushViewController(inviteConnections, animated: true)
        default:
            handleWhatsup(shareValue: "eva://\(postType.rawValue)/\(postId)")
        }
    }
    
    func shareContent(type: BottomContentPicker.BottomContentType, postType: HomeTabs, postId: Int, userId: Int? = nil) {
        let post: TypePostEnum = postType == .jobs ? .job : postType == .events ? .event : postType == .posts ? .post : .news
        switch type {
        case .conversation:
            let inviteConnections = StoryboardRouter.inviteConnections()
            inviteConnections.objectID = postId
            inviteConnections.type = post
            inviteConnections.invitationType = .postShare
            self.navigationController?.pushViewController(inviteConnections, animated: true)
        default:
            let link = postType == .events ? "eva://\(post.rawValue)/\(postId)?uid=\(userId!)" : "eva://\(post.rawValue)/\(postId)"
            handleWhatsup(shareValue: link)
        }
    }
    
}

extension BaseVC: SlideMenuVCDelegate {
    
    private func setSlideMenuVC() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: SlideMenuVC.storyboardIdentifier) as? SlideMenuVC else { return }
        slideMenuVC = vc
        slideMenuVC.delegate = self
    }
    
    private func showSlideMenu() {
        let width = view.frame.width
        slideMenuVC.view.frame = CGRect(x: 0, y: 0, width: width, height: view.frame.height)
        UIApplication.shared.keyWindow?.addSubview(slideMenuVC.view)
        slideMenuVC.contentView.backgroundColor = .clear
        addChild(slideMenuVC)

//        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
//            self.slideMenuVC.view.transform = CGAffineTransform(translationX: width, y: 0)
//        }
//        
//        animator.startAnimation()
//        animator.addCompletion { _ in
//            self.slideMenuVC.contentView.backgroundColor = #colorLiteral(red: 0.3703487515, green: 0.5478902459, blue: 0.8415817618, alpha: 0.2)
//        }
    }
    
    func didSelect(menu: String) {
        didClose()
        
//        switch menu.trim {
//        case "My Activity":
//            //navigateToMyActivity()
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
//            navigationController?.pushViewController(vc, animated: true)
//
//        case "Calender", "Calender and Events":
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//            navigationController?.pushViewController(vc, animated: true)
//        case "Job Listings":
//            let jobList = StoryboardRouter.jobList()
//            navigationController?.pushViewController(jobList, animated: true)
//        case "My Jobs":
//            let companyJobList = StoryboardRouter.companyJobList()
//            navigationController?.pushViewController(companyJobList, animated: true)
//        case "Edit Profile":
//            let editProfile = StoryboardRouter.editProfile()
//            navigationController?.pushViewController(editProfile, animated: true)
//        case "Settings":
//            navigationController?.pushViewController(StoryboardRouter.userSettings(), animated: true)
//        default:
//            break
//        }
        
        switch menu.trim {
        case "Home":
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 0
            self.navigationController?.pushViewController(vc, animated: true)
        case "Events":
            print("Push to Event Screen...")
            Constants.saveEnumToUserDefaults(.events)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
        case "Meetings":
            print("Push to Meetings Screen...")
            let vc = EventMainVC.instantiate()
            vc.isFromSidemenu = true
            navigationController?.pushViewController(vc, animated: true)
        case "News":
            Constants.saveEnumToUserDefaults(.news)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
            print("Push to News Screen...")
        case "Jobs":
            Constants.saveEnumToUserDefaults(.jobs)
            let vc = DashboardTabbarVC.instantiate()
            vc.tabType = 3
            self.navigationController?.pushViewController(vc, animated: true)
            print("Push to Jobs Screen...")
        case "My Schedule":
            print("Push to My Schedule Screen...")
            let vc = MyScheduleVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        case "Blocklist":
            print("Push to Blocklist Screen...")
            let vc = BlockListVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        case "Change Password":
            print("Push to Change Password Screen...")
            let vc = StoryboardRouter.editPasswordVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case "Settings":
            print("Push to Settings Screen...")
            self.navigationController?.pushViewController(StoryboardRouter.userSettings(), animated: true)
        case "FAQs":
            print("Push to FAQs Screen...")
            let vc = FAQsVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        case "Help":
            print("Push to Help Screen...")
            let vc = HelpPageVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    
    
    func didLogout() {
        logOutAlert()
    }
    
    func didClose() {
        if slideMenuVC == nil { return }
        slideMenuHidden.toggle()
        slideMenuVC.contentView.backgroundColor = .clear
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.slideMenuVC.view.transform = .identity
        }
        
        animator.addCompletion { [weak self ](_) in
            guard let self = self else { return }
            self.slideMenuVC.view.removeFromSuperview()
            self.slideMenuVC.removeFromParent()
        }
        
        animator.startAnimation()
    }
    
    func didSearch() {
        
    }
    
    func navigateToNotifiations() {
        guard let navVC = tabBarController?.viewControllers![3] as? UINavigationController,
              let chatListVC = navVC.viewControllers.first as? ChatListVC else { return }
        if tabBarController?.selectedIndex != 3 { tabBarController?.selectedIndex = 3 }
        chatListVC.dataType = .notifications
    }
    
    func navigateToMyActivity() {
        let chatListVC = StoryboardRouter.chatList()
        chatListVC.dataType = .notifications
        chatListVC.isMyActivity = true
        navigationController?.pushViewController(chatListVC, animated: true)
    }
}


extension BaseVC {
    
    func setShareBottomSheetView() {
        bottomShareSheet = BottomContentPicker(contents: [(title: "Share with Connection", type: .conversation),
                                                          (title: "Share to WhatsApp", type: .whatsapp),
                                                          (title: "Share URL Link", type: .link),
                                                          (title: "Share with Other", type: .other) ])
        bottomShareSheet.addConstraint(UIApplication.shared.keyWindow ?? view)
    }
    
}
