//
//  LinkedInModels.swift
//  EvaConnect
//
//  Created by usama on 02/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String
    
    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}
// MARK: - LinkedInProfileModel
struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let profilePicture: ProfilePicture
    let id: String
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String
    
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
    }
}

// MARK: - ProfilePicture
struct ProfilePicture: Codable {
    let displayImage: DisplayImage
    
    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}
