//
//  UserDataHandler.swift
//  EvaConnect
//
//  Created by usama on 14/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Alamofire

enum UserRelation: String {
    case following = "following"
    case requested = "requested"
    case none = "none"
}

enum UserOnlineStatus: String {
    case active = "active"
    case inactive = "inactive"
    case unknown = "unknown"
}


class UserDataHandler {
    
    class func getUsers(pageNumber: Int,
                  pageSize: Int,
                  result:@escaping ([User]?, Error?) -> Void) {
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(LoggedUserDetails.shared.token ?? "")",
            "OS" : ApiCallerClass.OS
        ]
        
        let limit = "?limit=\(pageSize)"
        let offset = "&offset=\(pageNumber)"
        
        let parameters = [ "user_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id,
                           "connection_status": "active" ] as [String : Any]
        
        ApiManagerClass.sharedManager.request(EndPoints.getFilterConnection+limit+offset, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON {
            (response) in
            
            if response.error != nil {
                result(nil, response.error)
            } else {
                if  response.result.isSuccess {
                    
                    let jsonDecoder = JSONDecoder()
                    let connectionRoot = try? jsonDecoder.decode(ConnectionRoot.self, from: response.data!)
                    
                    if let connectionRoot = connectionRoot {
                        result(connectionRoot.data, nil)
                    }
                }
            }
        }
    }
}

