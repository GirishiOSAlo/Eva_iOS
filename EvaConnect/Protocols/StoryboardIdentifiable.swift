//
//  StoryboardIdentifiable.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }
