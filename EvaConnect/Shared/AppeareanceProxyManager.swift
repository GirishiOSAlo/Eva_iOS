//
//  AppeareanceProxyManager.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class AppearanceProxyManager {
    
    private let theme: Theme = DefaultTheme()
    static let shared = AppearanceProxyManager()
    public let network: NetWorkStatusChangeable

    
    private init () {
        if #available(iOS 12.0, *) {
            network = NetworkStatus.shared
        } else {
            network = ReachabilityStatus.shared
        }
    }
    
    func applyDefaultControllsApperance() {

        theme.apply(for: UIApplication.shared)

    }
    
}
