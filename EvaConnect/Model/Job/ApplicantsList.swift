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
    let applicationsCount: String?
    let image: String?
    let value: String?
    let application: [UserConnection]?

    enum CodingKeys: String, CodingKey {
        case id, jobTitle, position, location, description
        case applicationsCount = "applications_count"
        case image, value, application
    }
}

// MARK: - Application
struct Application: Codable {
    let id: Int?
    let content, applicationAttachment, applicationAttachmentURL: String?
    let userID: Int?
    let firstName, lastName, companyName: String?
    let username: String?
    let userImage: String?
    let isOnline: Bool?
    let createdDate: String?
    let createdByID: Int?

    enum CodingKeys: String, CodingKey {
        case id, content
        case applicationAttachment = "application_attachment"
        case applicationAttachmentURL = "application_attachment_url"
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case companyName = "company_name"
        case username
        case userImage = "user_image"
        case isOnline = "is_online"
        case createdDate = "created_date"
        case createdByID = "created_by_id"
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
