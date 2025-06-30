//
//  ApiManagerClass.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiManagerClass: NSObject {
    public static let sharedManager: SessionManager = {
       let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30 //for response form Server
        configuration.timeoutIntervalForResource = 30
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    //MARK:Post
      class func requestPostURL(_ strURL: String,params:Parameters, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void) {
            let header = [
                "Content-Type":"application/json"
            ]
        self.sharedManager.request(strURL, method: .post, parameters: params, encoding:JSONEncoding.default, headers: header).responseJSON { (response) in
                if  response.result.isSuccess {
                    if response.response?.statusCode == 200{
                        let data = JSON(response.result.value!)
                        if data["status"].stringValue == "success" || data["status"].stringValue == "ok" && data["code"].stringValue == "200"{
                        success(data["result"])
                        }
                        else {
                            failure(NSError(domain: "ND", code: 412, userInfo: nil))
                          }
                        //completionHandler: @escaping (DataResponse<Any>) -> Void)
                    }
                }
                if response.result.isFailure
                {
                    failure(NSError())
                }
        }
    }
    //MARK:Patch
      class func requestPatchURL(_ strURL: String,params:Parameters, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void) {
            let header = [
                "Content-Type":"application/json"
            ]
        self.sharedManager.request(strURL, method: .patch, parameters: params, encoding:JSONEncoding.default, headers: header).responseJSON { (response) in
                if  response.result.isSuccess {
                    if response.response?.statusCode == 200{
                        let data = JSON(response.result.value!)
                        if data["status"].stringValue == "success" || data["status"].stringValue == "ok" && data["code"].stringValue == "200"{
                        success(data["result"])
                        }
                        else {
                            failure(NSError(domain: "ND", code: 412, userInfo: nil))
                          }
                        //completionHandler: @escaping (DataResponse<Any>) -> Void)
                    }
                }
                if response.result.isFailure
                {
                    failure(NSError())
                }
        }
    }
    //MARK:GET
          class func requestGetURL(_ strURL: String,params:Parameters, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void) {
              let header = [
                  "Content-Type":"application/json"
              ]
             self.sharedManager.request(strURL, method: .get, parameters: params, encoding:URLEncoding.default, headers: header).responseJSON { (response) in
                  if  response.result.isSuccess {
                      if response.response?.statusCode == 200{
                        let data = JSON(response.result.value!)
                          if data["status"].stringValue == "success" && data["code"].stringValue == "200"{
                              success(data["result"])
                          } else {
                              failure(NSError(domain: "ND", code: 412, userInfo: nil))
                          }
                          
                      }
                  }
                  if response.result.isFailure{                failure(NSError())
                  }
                  
              }
          }
}
