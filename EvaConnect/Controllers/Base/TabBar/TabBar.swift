//
//  Tabbar.swift
//  EvaConnect
//
//  Created by Metis on 16/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

let tabBarMessagesItemIndex = 2

class TabBar: UITabBarController {
    
    let tabBarImages1 = [UIImage(named: "Home")!, UIImage(named: "Connection")!, UIImage(named: "Post")!, UIImage(named: "Message")!, UIImage(named: "Profile")!]
    let tabBarImages2 = [UIImage(named: "SelectedHome")!, UIImage(named: "SelectedConnection")!, UIImage(named: "SelectedPost")!,
                         UIImage(named: "SelectedMessage")!, UIImage(named: "SelectedProfile")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        delegate = self
        setupTabBar()
    }

    override func viewWillLayoutSubviews() {
        tabbarImagesSetup()
    }
    
    func setupTabBar() {
        
        let home = UIStoryboard(storyboard: .home).instantiateViewController(withIdentifier: "HomeNavigation")
         
        let ConnectionStory = UIStoryboard(name: "Connection", bundle: nil)
        let connection = ConnectionStory.instantiateViewController(withIdentifier: "ConnectionVCNav")
        
        let chatList = UIStoryboard(storyboard: .chat).instantiateViewController(withIdentifier: "ChatNavigation")
        
        let profile = UIStoryboard(storyboard: .profile).instantiateViewController(withIdentifier: "ProfileVCNav")
        
        let post = UINavigationController(rootViewController: UIStoryboard(storyboard: .post).instantiateViewController(withIdentifier: "PostVC"))
        
        viewControllers = [home, connection, post, chatList, profile]
//        updateTabBarView()
    }
    
    private func tabbarImagesSetup() {
        for index in 0..<tabBarImages1.count {
            tabBar.items?[index].image = tabBarImages1[index].withRenderingMode(.alwaysOriginal)
            tabBar.items?[index].selectedImage = tabBarImages2[index].withRenderingMode(.alwaysOriginal)
            tabBar.items?[index].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
//    func refreshUserNotificationCounters() {
//        updateMessageNotificationCounter()
//    }
    
//    private func updateMessageNotificationCounter() {
//        EvaNotificationHandler.shared.numberOfUnreadMessages { [weak self] (count) in
//            guard let strongSelf = self else { return }
//            if strongSelf.selectedIndex != tabBarMessagesItemIndex {
//                self?.updateMessagesNotificationItemBadgeValue(count)
//            }
//        }
//    }
    
    func updateMessagesNotificationItemBadgeValue(_ badgeValue: Int?) {
        guard let badgeValue = badgeValue, badgeValue > 0 else {
            tabBar.items![tabBarMessagesItemIndex].badgeValue = nil
            return
        }
       tabBar.items![tabBarMessagesItemIndex].badgeValue = String(badgeValue)
    }
}

extension TabBar: UITabBarControllerDelegate {
     
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
