//
//  FirebaseDataHandler.swift
//  ySkolar
//
//  Created by Muhammad Sajad on 01/03/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
//import FirebaseDatabase

class FirebaseHandler {
//    static let handler = FirebaseHandler()
//
//    lazy var ref: DatabaseReference = {
//        return Database.database().reference()
//    }()
    
//    func startSession(with sessionResponse: EvaUser, _ completion: ((Bool) -> Void)? = nil) {
//        Auth.auth().signIn(withCustomToken: user.token) { (authResult, error) in
//             guard let _ = authResult?.user, error == nil else {
//                 print("Failed to authenticate user with firebase \(String(describing: error?.localizedDescription))")
//                 completion?(false)
//                 return
//             }
//             completion?(true)
//         }
//     }
    
//    func createUserIfNotExist(with profile: EvaUser, _ completion: ((Bool) -> Void)? = nil) {
//        self.ref.child("users").child("\(profile.id)").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
//            if snapshot.hasChild("name") {
//                completion?(false)
//            } else {
//                self?.ref.child("users/\(profile.id)/name").setValue(profile.fullName)
//                self?.ref.child("users/\(profile.id)/imageName").setValue(profile.userImage)
//            }
//        })
//    }
    
//    func createUser(with profile: EvaUser, _ completion: ((Bool) -> Void)? = nil) {
//        self.ref.child("users/\(profile.id)/name").setValue(profile.username)
//        self.ref.child("users/\(profile.id)/imageName").setValue(profile.userImage)
//    }
    
//    func updateUserImage(with profile: EvaUser, _ completion: ((Bool) -> Void)? = nil) {
//        self.ref.child("users").child("\(profile.id)").child("imageName").setValue(profile.userImage)
//    }
//
//    func endSession() {
//        LoggedUserDetails.shared.fcmToken = nil
        //YSDataController.shared.syncFCMToken()
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError {
//            print("Failed to sign out of firebase: \(signOutError.localizedDescription)")
//        }
//    }
}


