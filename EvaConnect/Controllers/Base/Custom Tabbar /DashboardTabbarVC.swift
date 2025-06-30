//
//  DashboardTabbarVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 08/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import Foundation

class DashboardTabbarVC: BaseVC, XIBed {
        
    
    lazy var homePageVC: HomePageVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
        return vc
    }()
    
    lazy var homeVC: HomeVC = {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
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
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var tabStackView: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var tabBGImgView: UIImageView!
    
    @IBOutlet weak var homeView: CustomTabView!
    @IBOutlet weak var notifView: CustomTabView!
    @IBOutlet weak var messageView: CustomTabView!
    @IBOutlet weak var profileView: CustomTabView!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var createJobBtn: UIButton!
    
    @IBOutlet weak var createPostBottomConst: NSLayoutConstraint!
    @IBOutlet weak var createJobBottomConst: NSLayoutConstraint!
    
    var tabType = 0  // 0= home 1= profile 2= notification
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        setTabViewssDelegates()
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(deeplinkData),
                         name: NSNotification.Name("DeepLinkingCall"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
      

    func setupUI(){
        
        homeView.imageName = "homeTab"
        notifView.imageName = "notifTab"
        messageView.imageName = "msgTab"
        profileView.imageName = "profileTab"
        
        createJobBtn.layer.cornerRadius = 20
        createPostBtn.layer.cornerRadius = 20
        
        createPostBottomConst.constant = -78
        createPostBtn.alpha = 0
        
        createJobBottomConst.constant = -132
        createPostBtn.alpha = 0
        
        switch tabType {
        case 0:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homePageVC)
        case 1:
            singleSelectTab(tab: profileView)
            showOnContainer(vc: profileVC)
        case 2:
            singleSelectTab(tab: notifView)
            showOnContainer(vc: notifVC)
        case 3:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homeVC)
        default:
            singleSelectTab(tab: homeView)
            showOnContainer(vc: homePageVC)
        }
    }
    
    func setTabViewssDelegates() {
        homeView.delegate = self
        notifView.delegate = self
        messageView.delegate = self
        profileView.delegate = self
    }
    
    @IBAction func addPostTapped(_ sender: UIButton) {
        homeView.state = .unselected
        notifView.state = .unselected
        messageView.state = .unselected
        profileView.state = .unselected
        
//        let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:"HomePageVC") as! HomePageVC
//        navigationController?.pushViewController(vc, animated: true)
                
        if isIndivisualUser {
            let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:
                                                                                "AddPostVC") as! AddPostVC
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if createPostBottomConst.constant == 14 {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                    self?.createPostBottomConst.constant = -68
                    self?.createJobBottomConst.constant = -68
                }) { (_) in
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.createPostBtn.alpha = 0
                        self?.createJobBtn.alpha = 0
                    }) { (_) in }
                }
            }else{
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                    self?.createPostBottomConst.constant = 14
                }) { (_) in
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.createPostBtn.alpha = 1.0
                    }) { (_) in
                        UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       options: .curveEaseOut,
                                       animations: { [weak self] in
                            self?.view.layoutIfNeeded()
                            self?.createJobBottomConst.constant = 10
                        }) { (_) in
                            UIView.animate(withDuration: 0.3,
                                           delay: 0,
                                           options: .curveEaseOut,
                                           animations: { [weak self] in
                                self?.view.layoutIfNeeded()
                                self?.createJobBtn.alpha = 1.0
                            }) { (_) in }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func createPostTapped(_ sender: UIButton) {
        self.addPostTapped(addBtn)
        let vc = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier:"AddPostVC") as! AddPostVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createJobTapped(_ sender: UIButton) {
        self.addPostTapped(addBtn)
        let vc = StoryboardRouter.createEditJobPost()
        vc.roleType = .add
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//extension DashboardTabbarVC {
//    func select(name: String) {
//        if name.elementsEqual("Events") {
//            
//        }
//    }
//}

extension DashboardTabbarVC: CustomTabSelectDelegate {
    func didSelectTab(tab: CustomTabView) {
        if tab == homeView && homeView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: homePageVC)
        } else if tab == notifView && notifView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: notifVC)
        } else if tab == messageView && messageView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: messageVC)
        } else if tab == profileView && profileView.state == .unselected {
            singleSelectTab(tab: tab)
            showOnContainer(vc: profileVC)
        }
    }
    
    func singleSelectTab(tab: CustomTabView) {
        homeView.state = tab == homeView ? .selected : .unselected
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

// MARK: Deeplink Redirection
extension DashboardTabbarVC {
    
    @objc func deeplinkData(_ notification: NSNotification) {
        
        if let endPoint = notification.userInfo?["param1"] as? String {
            
            switch endPoint {
            case "post":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let vc = StoryboardRouter.textPostDetailVC()
                    vc.postId = Int(endpoint2)
                    navigationController?.pushViewController(vc, animated: true)
                    break
                }

            case "event":
//                if let endpoint2 = notification.userInfo?["param2"] as? String {
//                    print(endpoint2)
//                    let vc = StoryboardRouter.eventCommentVC()
//                    vc.eventId = Int(endpoint2)
//                    vc.isGalleryEnable = true
//                    navigationController?.pushViewController(vc, animated: true)
                    break
//                }
            case "passedEvent":
//                if let endpoint2 = notification.userInfo?["param2"] as? String {
//                    print(endpoint2)
//                    let vc = StoryboardRouter.eventCommentVC()
//                    vc.eventId = Int(endpoint2)
//                    vc.isGalleryEnable = false
//                    navigationController?.pushViewController(vc, animated: true)
                    break
//                }
            case "news":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    let vc = StoryboardRouter.openNewsDetail() //openURLVC()
                    vc.newsID = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(vc, animated: true)
                    break
                }
            case "jobs":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let jobListing = StoryboardRouter.userJobListing()
                    jobListing.jobId = Int(endpoint2)
                    navigationController?.pushViewController(jobListing, animated: true)
                    break
                }
            case "job":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let jobListing = StoryboardRouter.userJobListing()
                    jobListing.jobId = Int(endpoint2)
                    navigationController?.pushViewController(jobListing, animated: true)
                    break
                }
            case "meeting":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
                    vc.meetingId = Int(endpoint2) ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case "message":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let chatVC = StoryboardRouter.chat()
                    chatVC.userId = Int(endpoint2) ?? 0
                    navigationController?.pushViewController(chatVC, animated: true)
                }
            case "profile":
                if let endpoint2 = notification.userInfo?["param2"] as? String {
                    print(endpoint2)
                    let vc = StoryboardRouter.othersProfileVC()
                    vc.profileID = Int(endpoint2) ?? 0
                    vc.isFrom = 0
                    navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
                
            }
        }
    }
    
}
