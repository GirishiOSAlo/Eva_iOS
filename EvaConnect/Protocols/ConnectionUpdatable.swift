//
//  ConnectionUpdatable.swift
//  EvaConnect
//
//  Created by usama on 17/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Alamofire

protocol ConnectionUpdatable {
    
    func updateConnection(id: Int, declined: Bool, completion: @escaping (Bool?, Error?) -> Void)

}


extension ConnectionUpdatable {

    func updateConnection(id: Int, declined: Bool, completion: @escaping (Bool?, Error?) -> Void) {

        let status = declined ? "decline" : "active"
        let parameters: AFParameters = [  "modified_by_id": LoggedUserDetails.shared.user?.id ?? 0,
                                          "status": status,
                                          "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        
        
        let endPoint = EndPoints.updateConnection + "/\(id)/"

        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in

            if response.result.isSuccess {

                let jsonDecoder = JSONDecoder()

                do {

                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        completion(true, nil)
                    }
                } catch {
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}

extension ConnectionVC: ConnectionUpdatable { }
//extension RecommededVC: ConnectionUpdatable { }
