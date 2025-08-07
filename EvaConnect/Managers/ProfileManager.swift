//
//  ProfileManager.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/7/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation
//import IHProgressHUD
import SVProgressHUD
import Alamofire
import UIKit
//import FirebaseDatabase

class ProfileManager {
    
    static let shared = ProfileManager()
    typealias completionHandler = ([UserConnection]?, String?,  [PendingBlockResponse]) -> Void
    private init() { }
    
    func addConnection(id: Int, completion: @escaping (String, String) -> Void) {
        let parameters: AFParameters = ["receiver_id": id, "sender_id": LoggedUserDetails.shared.user?.id ?? 0,
                                        "status": "pending", "modified_by_id": LoggedUserDetails.shared.user?.id ?? 0]
        SVProgressHUD.show()
        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { [weak self] (result: Result<GenericResponse>) in
            SVProgressHUD.dismiss()
            self?.handleSwitch(result: result, message: "Your connection is created successfully", completion: completion)
        }
    }
    
    func updateConnection(id: Int, completion: @escaping (String, String) -> Void) {
        let parameters: AFParameters = ["id": id, "modified_by_id": LoggedUserDetails.shared.user?.id ?? 0,
                                        "modified_datetime": Date().toString(formatter: .standardDateWithTime),
                                        "status": "active"]
        let endPoint = EndPoints.updateConnection + "\(id)"
        SVProgressHUD.show()
        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { [weak self] (result: Result<GenericResponse>) in
            SVProgressHUD.dismiss()
            if isIndivisualUser {
                self?.handleSwitch(result: result, message: "Connection Added!!", completion: completion)
            } else {
                self?.handleSwitch(result: result, message: "Follower Added!!", completion: completion)
            }
        }
    }
    
    func deleteConnection(id: Int, completion: @escaping (String, String) -> Void) {
        
        let parameters: AFParameters = ["id": id, "modified_by_id": LoggedUserDetails.shared.user?.id ?? 0,
                                        "modified_datetime": Date().toString(formatter: .standardDateWithTime),
                                        "status": "deactivate"]
        let endPoint = EndPoints.updateConnection + "\(id)"
        SVProgressHUD.show()
        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { [weak self] (result: Result<GenericResponse>) in
            SVProgressHUD.dismiss()
            if isIndivisualUser {
                self?.handleSwitch(result: result, message: "Connection Removed!!", completion: completion)
            } else {
                self?.handleSwitch(result: result, message: "Follower Removed!!", completion: completion)
            }
        }
//        let endPoint = EndPoints.deleteConnection + "/\(id)"
//        IHProgressHUD.show()
//        NetworkManagerr.request(endPoint, method: .delete) { [weak self] (result: Result<GenericResponse>) in
//            IHProgressHUD.dismiss()
//            self?.handleSwitch(result: result, message: "Your Connection is Remove Successfully", completion: completion)
//        }
    }
    
    func blockConnection(id: Int, isBlock: Bool = true, completion: @escaping (String, String) -> Void) {
//        let parameters: AFParameters = ["receiver_id": id, "sender_id": LoggedUserDetails.shared.user?.id, "status": isBlock ? "deleted" : "active"]
        let parameters: AFParameters = ["target_user_key": id]
        SVProgressHUD.show()
        NetworkManagerr.request(EndPoints.blockUser, method: .post, parameters: parameters) { [weak self] (result: Result<GenericResponse>) in
            SVProgressHUD.dismiss()
            self?.handleSwitch(result: result, message: "Connection is \(isBlock ? "block" : "unblock") successfully", completion: completion)
        }
    }
    
    func fetchUserDetail(userId: Int, showLoader: Bool = true, showPush: Bool = false, completion: @escaping (EvaUser?, String?) -> Void) {
        if showLoader { SVProgressHUD.show() }
        let url = "\(EndPoints.userDetail)" // /\(userId)/?view=\(showPush ? "true" : "false")"
        NetworkManagerr.request(url, method: .get) { (result: Result<LoginStruct>) in
            if showLoader { SVProgressHUD.dismiss() }
            switch result {
            case .success(let user):
                if user.error { completion(nil, user.message) }
                if let user = user.data?.first { completion(user, nil) }
                else { completion(nil, "Unable to get user info") }
            case .failure(let error):
                print("error", error)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    private func handleSwitch(result: Result<GenericResponse>, message: String, completion: (String, String) -> Void) {
        switch result {
        case .success(let success):
            if success.error {
                completion("Error", success.message)
                return
            }
            completion("Success", message)
        case .failure(let failure):
            completion("Error", failure.localizedDescription)
        }
    }
}

extension ProfileManager {
    
    private func handleResultRequest(result: Result<PendingBlockFilterModel>, completion: completionHandler) {
        switch result {
        case .success(let success):
            if success.error {
                completion(nil, success.message, [])
            } else if success.data.isEmpty {
                completion(nil, success.message, [])
            } else {
                var users = [UserConnection?]()
                success.data.forEach({ userData in
                    var sender = userData.sender
                    var receiver = userData.receiver
                    sender?.connectionID = userData.id
                    receiver?.connectionID = userData.id
                    users.append(sender)
                    users.append(receiver)
                })
                completion(users.filter({ $0?.id != LoggedUserDetails.shared.user?.id }).compactMap({ $0 }), nil, success.data)
            }
        case .failure(let failure):
            completion(nil, failure.localizedDescription, [])
        }
    }
    
    func getConnection(type: EvaConnectionType, completion: @escaping completionHandler) {
//        let url = type == .pending ? EndPoints.pendingConnections :  EndPoints.blockConnection
        let url = EndPoints.blockConnection
        NetworkManagerr.request(url) { (result: Result<PendingBlockFilterModel>) in
            switch result {
            case .success(let success):
                if success.error {
                    completion(nil, success.message, [])
                } else if success.data.isEmpty {
                    completion(nil, success.message, [])
                } else {
                    var users = [UserConnection?]()
                    success.data.forEach({ userData in
                        var sender = userData.sender
                        var receiver = userData.receiver
                        sender?.connectionID = userData.id
                        receiver?.connectionID = userData.id
                        users.append(sender)
                        users.append(receiver)
                    })
                    completion(users.filter({ $0?.id != LoggedUserDetails.shared.user?.id }).compactMap({ $0 }), nil, success.data)
                }
            case .failure(let failure):
                completion(nil, failure.localizedDescription, [])
            }
        }
    }
    
    func performGlobalSearch(search: String, filter: String, completion: @escaping completionHandler) {
        var params: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "filter": filter, "search_key": search, "connection_status": "active"]
        if filter == SearchTags.companies.filterKey {
            params["connection_status"] = nil
            NetworkManagerr.request(EndPoints.searhDashboard, method: .post, parameters: params) { (result: Result<ConnectionFilterModel>) in
                switch result {
                case .success(let success):
                    if success.error {
                        completion(nil, success.message, [])
                    } else if success.data.isEmpty {
                        completion(nil, success.message, [])
                    } else {
                        completion(success.data.filter({ $0.id != LoggedUserDetails.shared.user?.id }), nil, [])
                    }
                case .failure(let failure):
                    completion(nil, failure.localizedDescription, [])
                }
            }
        } else {
            NetworkManagerr.request(EndPoints.searhDashboard, method: .post, parameters: params) { (result: Result<PendingBlockFilterModel>) in
                self.handleResultRequest(result: result, completion: completion)
            }
        }
    }
    
//    func performSearch(query: String, status: String, completion: @escaping completionHandler) {
//        let params: AFParameters = ["user_id": "\(LoggedUserDetails.shared.user?.id)", "filter": status, "first_name": query.name.first, "last_name": query.name.last]
//        guard let url = params.getURL(EndPoints.getFilterConnectionNew) else { return }
//        NetworkManagerr.request(url) { (result: Result<PendingBlockFilterModel>) in
//            self.handleResultRequest(result: result, completion: completion)
//        }
//    }
    
    func performSearch(query: String, status: String, completion: @escaping completionHandler) {
        let params: AFParameters = ["user_id": "\(LoggedUserDetails.shared.user?.id ?? 0)", "connection_status": status, "first_name": query.name.first]
        guard let url = params.getURL(EndPoints.getFilterConnectionNew) else { return }
        NetworkManagerr.request(url, method: .post, parameters: params) { (result: Result<PendingBlockFilterModel>) in
            self.handleResultRequest(result: result, completion: completion)
        }
    }
    
    func getConnectionStatus(targetId: String, completion: @escaping(Bool) -> Void) {
        let params: AFParameters = ["user_id": "\(LoggedUserDetails.shared.user?.id ?? 0)", "target_user_key": targetId]
        guard let url = params.getURL(EndPoints.connectionStatus) else { return }
        
        NetworkManagerr.request(url) { (result: Result<Wrapper<[ConnectionStatus]>>) in
            switch result {
            case .success(let rsl):
                completion(rsl.data.first?.isBlocked ?? false)
            case .failure(let error):
                print("getConnectionStatus: error", error.localizedDescription)
                completion(false)
            }
        }
    }
}


extension ProfileManager {
    
    func updateProfile(params: Parameters, images: [UIImage]? = nil, completion: @escaping (Bool, String) -> Void) {
        
        guard let id = LoggedUserDetails.shared.user?.id else { return }
        var tempParams: Parameters = ["modified_by_id": id, "modified_datetime": Date().toString(formatter: .standardDateWithTime)]
        params.forEach({ tempParams[$0.key] = $0.value })
        SVProgressHUD.show()
        
        if let images = images {
            NetworkManagerr.requestWithImages(EndPoints.editProfile, images: images, imageName: "user_image",
                                              method: .patch, parameters: tempParams) { (succesfulUpload, error) in
                if let _ = succesfulUpload {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let loginUser = try jsonDecoder.decode(LoginStruct.self, from: (succesfulUpload?.data)!)
                        if let data = loginUser.data, let user = data.first, !loginUser.error  {
                            BaseVC.saveUser(user: user)
                            LoggedUserDetails.shared.updateUser(userModel: user)
                            completion(false, "Profile Updated")
                        }
                    } catch {
                        completion(true, error.localizedDescription)
                    }
                }
                SVProgressHUD.dismiss()
            }
            return
        }
        
        
        NetworkManagerr.request(EndPoints.editProfile, method: .patch, parameters: tempParams) { (result: Result<LoginStruct>) in
            SVProgressHUD.dismiss()
            self.handleLogin(result: result, completion: completion)
        }
    }
    
    private func handleLogin(result: Result<LoginStruct>, completion: @escaping (Bool, String) -> Void) {
        switch result {
        case .success(let success):
            if !success.error, let user = success.data?.first {
                BaseVC.saveUser(user: user)
                LoggedUserDetails.shared.updateUser(userModel: user)
            }
            completion(success.error, success.message)
        case .failure(let failure):
            completion(true, failure.localizedDescription)
        }
    }
    
    func resetPassword(email: String, code: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let params: Parameters = ["email": email, "verification_code": code, "new_password": password]
        SVProgressHUD.show()
        NetworkManagerr.request(EndPoints.resetPassword, method: .post, parameters: params) { (result: Result<GenericResponse>) in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let success):
                completion(success.error, success.message)
            case .failure(let failure):
                completion(true, failure.localizedDescription)
            }
        }
    }
    
}

extension ProfileManager {
    
//    func getLastMessage(receiverId: Int, completion: @escaping (Conversation?) -> Void) {
//        let ref = fb.handler.ref.child("users/\(LoggedUserDetails.shared.user?.id ?? 0)/chats/\(receiverId)")
//        ref.queryOrdered(byChild: "last_update_time").queryLimited(toLast: 2).observeSingleEvent(of: .value, with: { snap in
//            if let firstSnapshot = snap.children.compactMap({ $0 as? DataSnapshot }).first, let lastSnapshot = snap.children.compactMap({ $0 as? DataSnapshot }).last {
//                print("snapshot", lastSnapshot)
//                //completion(firstSnapshot.key == "\(receiverId)" ? Conversation(snapshot: dataSnapShot) : nil)
//            } else {
//                completion(nil)
//            }
//        })
//    }
    
}

extension ProfileManager {
    
    func fetchPosts(uid: Int, limit: Int = 5, offset: Int = 0, completion: @escaping ([DashboardItem], String?) -> Void) {
        let url = "\(EndPoints.homeFilterPosts)?limit=\(limit)&offset=\(0)"
        let param: AFParameters = ["user_id": LoggedUserDetails.shared.user?.id ?? 0, "filter": "my_posts", "user_key": uid]
        
        NetworkManagerr.request(url, method: .post, parameters: param) { (result: Result<DashboardItemRoot>) in
            switch result {
            case .success(let value):
                completion((value.error ?? false ? [] : value.data) ?? [], value.error ?? false ? value.message : nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            default:
                break
            }
        }
    }
    
}
