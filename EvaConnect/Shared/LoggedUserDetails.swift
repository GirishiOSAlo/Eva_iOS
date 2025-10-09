import Foundation
//import Firebase

class LoggedUserDetails {
    
    static let shared = LoggedUserDetails()
    private(set) var user: EvaUser?
    
    private(set) var token: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.userToken)
            //return UserDefaults.standard.string(forKey: UserDefaultKeys.sessionToken)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.sessionToken)
        }
    }
    
//    var fcmToken: String? {
//        didSet {
//            syncFCMToken()
//        }
//    }
    
    private init() { }

     func updateToken(tokenString: String) {
        token = tokenString
    }
    
     func updateUser(userModel: EvaUser) {
        user = userModel
    }
    
    func logoutUser() {
        myUserDefaults.user = ""
        myUserDefaults.isIndivisualUser = false
        user = nil
        resetDefaults()
    }
    
    var isSession: Bool {
        return token != nil
    }
    
//     func syncFCMToken() {
//        if let id = user?.id {
//             var token = fcmToken
//            if isSession && token.isNil {
//                Messaging.messaging().token { token, error in
//                  if let error = error {
//                    print("Error fetching FCM registration token: \(error)")
//                  } else if let token = token {
//                    print("FCM registration token: \(token)")
//                      self.token = token
//                      FirebaseHandler.handler.ref.child("users/\(id)/fcm-token").setValue(token)
//                  }
//                }
//             } else {
//                 FirebaseHandler.handler.ref.child("users/\(id)/fcm-token").setValue(token)
//             }
//         }
//     }
}

extension LoggedUserDetails {
    
    private func resetDefaults() {
        let deviceToken = myUserDefaults.deviceToken
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
       myUserDefaults.deviceToken = deviceToken
    }
    
    
    
}
