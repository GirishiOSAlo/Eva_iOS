//
//  JobDetailsDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 03/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

//JobDetailsDataModel
// MARK: - Welcome
struct JobDetailsDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [JobDetailsData]?
}

// MARK: - Datum
struct JobDetailsData: Codable {
//    let comments: [JSONAny]?
    let id: Int?
    let userID: Int?
    let user: JobDetailsUser?
    let jobTitle: String?
    let jobNature: String?
    let jobtype, jobDescription: String?
    let listingDuration: Int?
    let jobSector, position: String?
    let weeklyHours: String?
    let location: String?
    let salary: Int?
    let content: String?
    let jobImage: String?
    let attendees, commentCount, applicantCount, isJobLike: Int?
    let isApplied, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, type, os, status: String?
    let isURL: Bool?
    let postVideo, isConnected: String?
    let connectionID: Int?
    let isReceiver: Bool?
    let saved: Int?
    let createdOn: String?
    let tempImage: String?
    let isJobSave: Int?
    let createdByUser: String?

    enum CodingKeys: String, CodingKey {
//        case comments
        case id, userID, user, jobTitle, jobNature, jobtype
        case jobDescription = "job_description"
        case listingDuration = "listing_duration"
        case jobSector, position, weeklyHours, location, salary, content, jobImage, attendees, commentCount, applicantCount, isJobLike, isApplied, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, type, os, status, isURL, postVideo, isConnected
        case connectionID = "connectionId"
        case isReceiver, saved
        case createdOn = "created_on"
        case tempImage = "temp_image"
        case isJobSave
        case createdByUser = "created_by_user"
    }
}

// MARK: - User
struct JobDetailsUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: Bool?
    let connectionID, bioData, uniqueCode: String?
    let dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: String?
    let companyName, workAviation, type, otherSector: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case bioData = "bio_data"
        case uniqueCode = "unique_code"
        case dateOfBirth = "date_of_birth"
        case status
        case userImage = "user_image"
        case createdByID = "created_by_id"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case companyName = "company_name"
        case workAviation = "work_aviation"
        case type
        case otherSector = "other_sector"
        case language
    }
}
