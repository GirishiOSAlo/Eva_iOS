//
//  FBData.swift
//  EvaConnect
//
//  Created by usama on 02/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

struct FBData {
    let name: String
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let imageUrl: NSDictionary
}

struct SignUpDetails {
    
    var firstName: String?
    var lastName: String?
    var url: String?
    var email: String
    let password: String?
    var userType: UserType?
    var sector: Int?
    var subSector: String?
    var workAviationType: String?
    var jobTitle: String?
    var about: String?
    var company: String?
    var companyId: Int?
    var city: String?
    var country: String?
    var dateOfBirth: String?
    var userImage: UIImage?
    var userImageURI: String?
    var otherSector: Bool?
    let socialMedia: SocialMedia?
    var language: String?
    var phoneNo: String?
    var linkedIn: String?
}

enum UserType: String {
    case company, user
}


extension SignUpDetails {
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        firstName = nil
        lastName = nil
        userType = nil
        workAviationType = nil
        sector = nil
        city = nil
        country = nil
        socialMedia = nil
        userImage = nil
        userImageURI = nil
        jobTitle = nil
        company = nil
        otherSector = false
    }
    
    init(email: String) {
        self.email = email
        password = nil
        firstName = nil
        lastName = nil
        userType = nil
        workAviationType = nil
        sector = nil
        city = nil
        country = nil
        socialMedia = nil
        userImage = nil
        userImageURI = nil
        jobTitle = nil
        company = nil
        otherSector = false
    }
}

enum SocialMedia: String, Decodable {
    case facebook
    case linkedin
}
