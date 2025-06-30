//
//  OnlineStatusManager.swift
//  EvaConnect
//
//  Created by usama on 13/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

class OnlineStatusManager {
    
    class func updateOnlineStatus(isOnline: Bool = true) {
        if !LoggedUserDetails.shared.user.isNil{
            var parameters: AFParameters = [ "is_online": isOnline,
                                             "modified_by_id": myUserDefaults.userId ]  //LoggedUserDetails.shared.user!.id ]
            
            if !isOnline {
                let dateString = Date().toString(formatter: .standardDateWithTime)
                parameters["last_online_datetime"] = dateString
            }
            
            let details = EndPoints.userDetail + "\(myUserDefaults.userId)/"  //LoggedUserDetails.shared.user!.id)/"
            NetworkManagerr.request(details, method: .patch, parameters: parameters) { (response) in
                
                if response.result.isSuccess {
                    
                    do  {
                        
                        let jsonDecoder = JSONDecoder()
                        let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                        print(genericResponse)
                        
                    } catch {
                        
                    }
                }
            }
        }
        
    }
}
