//
//  SceneDelegate.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        var userDefaults = UserDefaults.standard
        let getToken = userDefaults.value(forKey: "UserToken") as? String
        if getToken != nil {
            GotoHome()
        }
        else {
            GotoLogIn()
        }
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if #available(iOS 13.0, *) {
            guard let _ = (scene as? UIWindowScene) else { return }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            DispatchQueue.global().sync {
            PostTypeDetail.shared.getPostDetail(postId: Int(url.lastPathComponent)!)
            }
            
            if url.host == "event" {
                let event =  UIStoryboard(storyboard: .home).instantiateViewController(withClass: EventCommentVC.self)!
                event.getPost = Int(url.lastPathComponent)
                self.window?.rootViewController = event
                self.window?.makeKeyAndVisible()
            }
            else if url.host == "job" {
                let event =  UIStoryboard(storyboard: .home).instantiateViewController(withClass: editJobUserPostVC.self)!
                event.jobId = Int(url.lastPathComponent)
                self.window?.rootViewController = event
                self.window?.makeKeyAndVisible()
            }
            else if url.host == "post" {
               
                if !PostTypeDetail.shared.postType.isNil {
                    switch PostTypeDetail.shared.postType {
                    case "TextCommentVC":
                        let event =  UIStoryboard(storyboard: .home).instantiateViewController(withClass: TextCommentVC.self)!
                        event.postId = Int(url.lastPathComponent)
                        self.window?.rootViewController = event
                        self.window?.makeKeyAndVisible()
                    case "UrlCommentVC":
                        let event =  UIStoryboard(storyboard: .home).instantiateViewController(withClass: UrlCommentVC.self)!
                        event.getPost = Int(url.lastPathComponent)
                        self.window?.rootViewController = event
                        self.window?.makeKeyAndVisible()
                    default:
                        let event =  UIStoryboard(storyboard: .home).instantiateViewController(withClass: OtherCommentVC.self)!
                        event.getPost = Int(url.lastPathComponent)
                        self.window?.rootViewController = event
                        self.window?.makeKeyAndVisible()
                    }
                }
                else {
                    print("Function Not Work")
                }
                
            }
            print(url)
            
        }
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
    static func rootToLogin(){
        //        let storyboard = UIStoryboard(name: "AuthenticationVC", bundle: nil)
        //
        //        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //        //initialViewController.selectedIndex = 0
        //        self.window?.rootViewController = initialViewController
        //        self.window?.makeKeyAndVisible()
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
    
    func GotoHome(){
        let tabBar = StoryboardRouter.tabbar()
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        print("*****LoginStatus:LogIN---SceneDelegateTrue")
    }
    func GotoLogIn(){
        let storyboard = UIStoryboard(name: "AuthenticationVC", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        print("*****LoginStatus:LogOut---SceneDelegateFalse")
    }
}

