//
//  EventTabbarVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 10/12/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class EventTabbarVC: BaseVC, XIBed {
    
    lazy var eventDetailsPage: EventMainVC = {
        let vc = EventMainVC.instantiate()
        if myUserDefaults.isEventFlow {
            vc.eventId = myUserDefaults.isEventFlowEventID
        }
        return vc
    }()
    
    lazy var notifVC: ChatListVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        vc.dataType = .notifications
        return vc
    }()
        
    lazy var messageVC: ChatListVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        vc.dataType = .chatList
        return vc
    }()

    lazy var profileVC: UserProfileVC = {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        return vc
    }()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var notifView: CustomTabView!
    @IBOutlet weak var messageView: CustomTabView!
    @IBOutlet weak var profileView: CustomTabView!
    @IBOutlet weak var logoutView: CustomTabView!
    @IBOutlet weak var eventDetailsBtn: UIButton!
    
    @IBOutlet weak var LogoutMainVw: UIView!
    @IBOutlet weak var subPopupVw: UIView!
    @IBOutlet weak var popupTitleLbl: UILabel!
    @IBOutlet weak var popupDoneBtn: UIButton!
    @IBOutlet weak var popupCancelBtn: UIButton!
    
    var tabType = 0  // 0= Event Details 1= Notification 2= Chat 3= Profile 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setTabViewssDelegates()
        
        self.LogoutMainVw.isHidden = true
        setupPopupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI(){
        
        notifView.imageName = "notifTab"
        messageView.imageName = "msgTab"
        profileView.imageName = "profileTab"
        logoutView.imageName = "Logout_Event"
        
        switch tabType {
        case 0:
            //singleSelectTab(tab: notifView)
            showOnContainer(vc: eventDetailsPage)
        case 1:
            singleSelectTab(tab: notifView)
            showOnContainer(vc: notifVC)
        case 2:
            singleSelectTab(tab: notifView)
            showOnContainer(vc: notifVC)
        case 3:
            singleSelectTab(tab: profileView)
            showOnContainer(vc: profileVC)
        case 4:
            print("Logout")
        default:
            break
        }
    }
    
    func setupPopupView() {
        self.subPopupVw.cornerRadius = 20.0
        popupTitleLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        popupDoneBtn.cornerRadius = 14.0
        popupDoneBtn.setTitle("Logout", for: .normal)
        popupDoneBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        popupCancelBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 14.0)
        popupCancelBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
    }
    
    func setTabViewssDelegates() {
        notifView.delegate = self
        messageView.delegate = self
        profileView.delegate = self
        logoutView.delegate = self
    }
    
    @IBAction func openEventDetailsTapped(_ sender: UIButton) {
        notifView.state = .unselected
        messageView.state = .unselected
        profileView.state = .unselected
        
        showOnContainer(vc: eventDetailsPage)
    }
    
    @IBAction func onDoneBtn(_ sender: UIButton) {
        self.LogoutMainVw.isHidden = true
        self.logout()
    }
    
    @IBAction func onCancelBtn(_ sender: UIButton) {
        self.LogoutMainVw.isHidden = true
    }
}

extension EventTabbarVC {
    func logout() {
        let url = EndPoints.logout
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: nil) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let rescheduleRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(rescheduleRoot.error) {
                    print("Success Event Logout :: \(rescheduleRoot.message)")
                    UserDefaults.standard.removeObject(forKey: "UserToken")
                    LoggedUserDetails.shared.logoutUser()
                    UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: StoryboardRouter.login())
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                } else {
                    print("Error :: \(rescheduleRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

extension EventTabbarVC: CustomTabSelectDelegate {
    func didSelectTab(tab: CustomTabView) {
        if tab == notifView && notifView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: notifVC)
        } else if tab == messageView && messageView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: messageVC)
        } else if tab == profileView && profileView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: profileVC)
        } else if tab == logoutView {
            print("Logout Tap")
            self.LogoutMainVw.isHidden = false
        } else {
            print("Event Details Page Selected.")
        }
    }
    
    func singleSelectTab(tab: CustomTabView) {
        notifView.state = tab == notifView ? .selected : .unselected
        messageView.state = tab == messageView ? .selected : .unselected
        profileView.state = tab == profileView ? .selected : .unselected
    }
    
    func showOnContainer(vc: UIViewController) {
        container.subviews.forEach({ $0.removeFromSuperview() })
        
        self.addChild(vc)
        container.addSubview(vc.view)
        vc.view.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor)
    }
}
