//
//  NetworkConnection.swift
//  EvaConnect
//
//  Created by Metis on 27/10/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Network
@available(iOS 12.0, *)
class NetworkConnection {
    
    static let shared = NetworkConnection()
    
    var monitor = NWPathMonitor()
    
   
    private init(){}
    func startObserving() {
       // self.monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    func observedInternet(completional: @escaping (InternetStatus?) -> Void) {
        monitor.pathUpdateHandler = {
            path in
            switch path.status {
            
            case .satisfied:
           
                    completional(.internetConnected)
                
              
            case .requiresConnection:
                
                completional(.requiredInternet)
                
            case .unsatisfied:
                
                
                    completional(.noInternet)
                    
                
                
            @unknown default:
                fatalError()
            }
        }
    }
    
}

enum InternetStatus: String {
    case noInternet = "No Internet Service"
    case internetConnected = "Internet Service available"
    case requiredInternet = "Internet Connection Required"
    
}
