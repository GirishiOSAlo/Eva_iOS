//
//  UserDefaultKeys.swift
//  EvaConnect
//
//  Created by usama on 13/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static let sessionToken = "SignedInSessionToken"
    static let profileID = "ProfileID"
    static let userToken = "UserToken"
}

class myUserDefaults {
    
    public static var isPrivate: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isPrivate")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isPrivate")
        }
    }
    
    public static var awsAccess: String {
        get {
            UserDefaults.standard.string(forKey: "awsAccess") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "awsAccess")
        }
    }
    
    public static var fullName: String {
        get {
            UserDefaults.standard.string(forKey: "fullName") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "fullName")
        }
    }
    
    public static var emailAdd: String {
        get {
            UserDefaults.standard.string(forKey: "emailAdd") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "emailAdd")
        }
    }
    
    public static var user: String {
        get {
            UserDefaults.standard.string(forKey: "user") ?? "user"
        } set {
            UserDefaults.standard.set(newValue, forKey: "user")
        }
    }
    
    public static var userId: Int {
        get {
            UserDefaults.standard.integer(forKey: "userId")
        } set {
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
    }
    
    public static var bio: String {
        get {
            UserDefaults.standard.string(forKey: "bio") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "bio")
        }
    }
    
    public static var websiteUrl: String {
        get {
            UserDefaults.standard.string(forKey: "websiteUrl") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "websiteUrl")
        }
    }
    
    public static var mobileNo: String {
        get {
            UserDefaults.standard.string(forKey: "mobileNo") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "mobileNo")
        }
    }
    
    public static var linkedIn: String {
        get {
            UserDefaults.standard.string(forKey: "linkedIn") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "linkedIn")
        }
    }
    
    public static var region: String {
        get {
            UserDefaults.standard.string(forKey: "region") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "region")
        }
    }
    
    public static var DOB: String {
        get {
            UserDefaults.standard.string(forKey: "DOB") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "DOB")
        }
    }
    
    public static var Language: String {
        get {
            UserDefaults.standard.string(forKey: "Language") ?? "English"
        } set {
            UserDefaults.standard.set(newValue, forKey: "Language")
        }
    }
    
    public static var sector: String {
        get {
            UserDefaults.standard.string(forKey: "sector") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "sector")
        }
    }
    
    public static var token: String {
        get {
            UserDefaults.standard.string(forKey: "token") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    public static var subSector: String {
        get {
            UserDefaults.standard.string(forKey: "subSector") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "subSector")
        }
    }
    
    public static var deviceToken: String {
        get {
            UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
        }
    }
    
    
    
    public static var companyName: String {
        get {
            UserDefaults.standard.string(forKey: "companyName") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "companyName")
        }
    }
    
    public static var userImage: String {
        get {
            UserDefaults.standard.string(forKey: "userImage") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "userImage")
        }
    }
    
    public static var jobTitle: String {
        get {
            UserDefaults.standard.string(forKey: "jobTitle") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "jobTitle")
        }
    }
    
    public static var companyId: Int {
        get {
            UserDefaults.standard.integer(forKey: "companyId")
        } set {
            UserDefaults.standard.set(newValue, forKey: "companyId")
        }
    }
    
    public static var password: String {
        get {
            UserDefaults.standard.string(forKey: "password") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "password")
        }
    }
    
    public static var Cat_id: String {
        get {
            UserDefaults.standard.string(forKey: "Cat_id") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "Cat_id")
        }
    }
}
