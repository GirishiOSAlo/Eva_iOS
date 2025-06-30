//
//  SceneDelegate.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        NavigationManager.rootViewController(window: window)
        let urlinfo = connectionOptions.urlContexts
        if !urlinfo.first.isNil {
            let token = UserDefaults.standard.value(forKey: "UserToken")
            if let url = urlinfo.first?.url {
                if !token.isNil {
                    NavigationManager.shared.openController(objectID: Int(url.lastPathComponent)!, objectType: url.host!, userId: url.valueOf("uid"))
                }
            }
        }
        
        if let url = connectionOptions.userActivities.first?.webpageURL {
            print(url)
            
            // Get URL components from the incoming user activity.
            guard let userActivity = connectionOptions.userActivities.first,
                  userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                  let incomingURL = userActivity.webpageURL
            else { return }
            DispatchQueue.main.async {
                print("Dynamic link host: \(incomingURL.host ?? "")")
                print("Dyanmic link url: \(incomingURL)")
                let urlString = incomingURL.absoluteString
                if let range = urlString.range(of: "aviationconnect.com") {
                    let endPoints = String(urlString[range.upperBound...])
                    print(endPoints)
                    self.deepLinkNavigation(endPoints: endPoints)
                    return
                }
                return
            }
        }

    }

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        let token = UserDefaults.standard.value(forKey: "UserToken")
//        if let url = URLContexts.first?.url{
//            if !token.isNil{
//                NavigationManager.shared.openController(objectID: Int(url.lastPathComponent)!, objectType: url.host!, userId: url.valueOf("uid"))
//            }
//        }
//
//        if let openURLContext = URLContexts.first {
//
//            ApplicationDelegate.shared.application(UIApplication.shared, open:
//                openURLContext.url, sourceApplication:
//                openURLContext.options.sourceApplication, annotation:
//                openURLContext.options.annotation)
//        }
        guard let url = URLContexts.first?.url else {
            return
        }
        print("URL :: \(url)")
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                // Handle deep link URL and navigate to the corresponding content
                print("Dynamic link host: \(url.host ?? "")")
                print("Dyanmic link url: \(url)")
//                print("Dynamic link match type: \(dynamicLink.matchType.rawValue)")
                //https://www.divinetalk.in/wallet
                let urlString = url.absoluteString
                if let range = urlString.range(of: "aviationconnect.com") {
                    let endPoints = String(urlString[range.upperBound...])
                    print(endPoints)
                    self.deepLinkNavigation(endPoints: endPoints)
                    return
                }
                return
            }
            guard let url = userActivity.webpageURL, let host = url.host else {
                return
            }
        }
    }
    
    func deepLinkNavigation(endPoints: String) {
        if (endPoints.contains("/") == true) {
            let split = endPoints.split(separator: "/")
            print("Split ==> \(split)")
            
            if split.count == 2 {
                let deepLinkData:[String: String] = ["param1": String(split[0]),
                                                     "param2": String(split[1])]
                NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
            } else if split.count == 3 {
                let deepLinkData:[String: String] = ["param1": String(split[0]),
                                                     "param2": String(split[1]),
                                                     "param3": String(split[2])]
                NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
            }
            
        } 
//        else {
//            let deepLinkData:[String: String] = ["param1": endPoints]
//            NotificationCenter.default.post(name: NSNotification.Name("DeepLinkingCall"), object: nil, userInfo: deepLinkData)
//        }
    }
   
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Url_____\(url)")
        return true
    }
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
    }
}

