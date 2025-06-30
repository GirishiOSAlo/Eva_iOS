//
//  NetworkManager.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Alamofire
import Network
//import IHProgressHUD
import UIKit
import SVProgressHUD

typealias AFParameters = Parameters
class NetworkManagerr {
    
    class func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        completionHandler: @escaping (DataResponse<Any>) -> Void) {

//        var defaultHeaders = [
//            "Os" : "iOS",
//            "Content-Type": "application/json"
//        ]
            
        var defaultHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = (UserDefaults.standard.value(forKey: "UserToken")) {
            defaultHeaders["Authorization"] = "Bearer \(token)"
        } else {
//            defaultHeaders["Authorization"] = "Bearer \("3|L2rlXRK1WCl8pJcfERKCtuw00iE4C3oMhQsZPPZY")"
        }

        if let headers = headers {
            for (key, value) in headers {
                defaultHeaders[key] = value
            }
        }
        
            print("URL: \(url)")
            print("headers are \(defaultHeaders)")
            print("params are \(String(describing: parameters))")
            print("method is \(method)")
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: defaultHeaders).responseJSON { (response) in

                            if response.result.error?.localizedDescription == Constants.InternetConnection.Offline.rawValue {
                                OfflineInternetHandler.shared.noInternetAlert(title: "No Internet Connection", message: "Please Check your Internet")
                            }
                            else {
                                completionHandler(response)
                            }                           
        }
    }
    
    class func request<T: Decodable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil,
                                     encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil,
                                     completionHandler: @escaping (Result<T>) -> Void) {
        var defaultHeaders = ["Os" : "iOS", "Content-Type": "application/json"]
        if let token = (UserDefaults.standard.value(forKey: "UserToken")) { defaultHeaders["Authorization"] = "Bearer \(token)" }
        
//        if let headers = headers {
//            headers.forEach({ defaultHeaders[$0.key] = $0.value })
//        }
        
        if let headers = headers {
            for (key, value) in headers {
                defaultHeaders[key] = value
            }
        }
        print("headers:",defaultHeaders)
        print("Method:",method)
        
        print("parameters:",parameters)
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: defaultHeaders).responseJSON { response in
            if response.result.error?.localizedDescription == Constants.InternetConnection.Offline.rawValue {
                OfflineInternetHandler.shared.noInternetAlert(title: "No Internet Connection", message: "Please Check your Internet")
                completionHandler(.failure(response.result.error!))
            } else if let error = response.result.error {
                print("url", url, "json", String(data: response.data!, encoding: .utf8) ?? "invalid json")
                completionHandler(.failure(error))
            } else {
                print("url", url, "json", String(data: response.data!, encoding: .utf8) ?? "invalid json")
                do { completionHandler(.success(try JSONDecoder().decode(T.self, from: response.data!))) }
                catch let error {
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    class func requestWithImages( _ url: URLConvertible,
                                  images: [UIImage],
                                  imageName: String,
                                  method: HTTPMethod = .post,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = JSONEncoding.default,
                                  headers: HTTPHeaders? = nil,
                                  completionHandler: @escaping (DataResponse<Any>?, Error?) -> Void) {
        
        var defaultHeaders = [
            "Os" : "iOS"
        ]
        
        if let _ = LoggedUserDetails.shared.user {
            defaultHeaders["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: "UserToken") ?? "")"
        }
        
        if let headers = headers {
            for (key, value) in headers {
                defaultHeaders[key] = value
            }
        }
        
        Alamofire.upload(multipartFormData: { (multiFormData) in
            
            if images.count > 0 {
                images.forEach { (image) in
                    
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    multiFormData.append(imageData!, withName: imageName, fileName: "image.jpg", mimeType: "image/png")
                }
            }
            
            for (key, value) in parameters! {
                
                if key == "attendees" {
                    for id in value as! [Int] {
                        multiFormData.append("\(id)".data(using: String.Encoding.utf8)!, withName: "attendees")
                    }
                } else {
                    multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    
                }
            }
        }, to: url, method: method, headers: defaultHeaders) { (result) in
            
            switch result {
            case .success(let successfulResponse, _, _):
                
                successfulResponse.responseJSON { (response) in
                    completionHandler(response, nil)
                }
                
            case .failure(let error):
                completionHandler(nil, error)

            }
        }
    }
}

class OfflineInternetHandler {
 
    static var shared = OfflineInternetHandler()
    private init (){}
    let noInternetVC = NoInternetVC(nibName: "NoInternetVC", bundle: nil)

    
    func noInternetAlert(title: String, message: String) {
        
        
            if !self.noInternetVC.isBeingPresented {
                
                self.noInternetVC.modalTransitionStyle = .crossDissolve
                self.noInternetVC.modalPresentationStyle = .overFullScreen
                
                    UIApplication.shared.keyWindow!.rootViewController?.present(self.noInternetVC, animated: true, completion: nil)
                    
                
            } else {
                UIApplication.shared.keyWindow!.rootViewController?.navigationController?.pushViewController(self.noInternetVC, animated: true)
            }
        SVProgressHUD.dismiss()
       
   }
    
}

//class popupHandler {
// 
//    static var shared = popupHandler()
//    private init (){}
//    let popupvc = CommonPopupVC(nibName: "CommonPopupVC", bundle: nil)
//    
//    func noInternetAlert() {
//
//            if !self.popupvc.isBeingPresented {
//                
//                self.popupvc.modalTransitionStyle = .crossDissolve
//                self.popupvc.modalPresentationStyle = .popover
//                
//                    UIApplication.shared.keyWindow!.rootViewController?.present(self.popupvc, animated: true, completion: nil)
//            } else {
//                UIApplication.shared.keyWindow!.rootViewController?.navigationController?.pushViewController(self.popupvc, animated: true)
//            }
//   }
//    
//}
