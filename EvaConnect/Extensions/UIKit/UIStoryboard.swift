//
//  UIStoryboard.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    enum Storyboard: String {
        
        case main = "Main"
        case home = "Home"
        case chat = "Chat"
        case settings = "Settings"
        case authentication = "AuthenticationVC"
        case meeting = "Meetings"
        case dashboard = "Dashboard"
        case profile = "Profile"
        case connection = "Connection"
        case jobs = "Jobs"
        case share = "Share"
        case post = "Post"
        
        var filename: String {
            return rawValue
        }
    }
    
    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
    
    
    func instantiateViewController<T>() -> T where T: StoryboardIdentifiable {

        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}
