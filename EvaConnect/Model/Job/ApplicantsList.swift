//
//  ApplicantsList.swift
//  EvaConnect
//
//  Created by Pranay Barua on 11/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation

// MARK: - ApplicantListModel
struct ApplicantListModel: Codable {
    let error: Bool?
    let message: String?
    let data: [ApplicantListData]?
}

// MARK: - Datum
struct ApplicantListData: Codable {
    let id: Int?
    let jobTitle, position, location, description: String?
    let applicationsCount: Int?
    let image: String?
    let value: String?
    let application: [ApplicationList]?
    //let application: [UserConnection]?

    enum CodingKeys: String, CodingKey {
        case id, jobTitle, position, location, description
        case applicationsCount = "applications_count"
        case image, value, application
    }
}

// MARK: - Application
struct ApplicationList: Codable {
    let id: Int?
    let content: String?
    let applicationAttachment, applicationAttachmentURL: String?
    let userID: Int?
    let firstName, lastName: String?
    let username, designation: String?
    let userImage: String?
    let companyName, onlineStatus, createdDate: String?
    let createdByID: StringOrInt?
    let resume: String?
    
    enum CodingKeys: String, CodingKey {
        case id, content
        case applicationAttachment = "application_attachment"
        case applicationAttachmentURL = "application_attachment_url"
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case username, designation
        case userImage = "user_image"
        case companyName = "company_name"
        case onlineStatus = "online_status"
        case createdDate = "created_date"
        case createdByID = "created_by_id"
        case resume
    }
}


// MARK: - EmployeeListDataModel
struct EmployeeListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [Employees]?
}

// MARK: - Datum
struct Employees: Codable {
    let id: Int?
    let firstName: String?
    let lastName, designation: String?
    let userImageURL, loginStatus : String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case designation
        case userImageURL = "user_image_url"
        case loginStatus = "login_status"
    }
}
