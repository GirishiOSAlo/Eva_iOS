//
//  DashboardJobDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct DashboardJobDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: DashboardJobData?
}

// MARK: - DataClass
struct DashboardJobData: Codable {
    let total, currentPage, lastPage: Int?
    let prevPageURL: String?
    let nextPageURL: String?
    let jobs: [DashboardJob]?

    enum CodingKeys: String, CodingKey {
        case total
        case currentPage = "current_page"
        case lastPage = "last_page"
        case prevPageURL = "prev_page_url"
        case nextPageURL = "next_page_url"
        case jobs
    }
}

// MARK: - Job
struct DashboardJob: Codable {
    let id, userID, user: Int?
    let jobTitle: String?
    let jobNature: String?
    let jobtype, jobSector, companyName, companylogo: String?
    let userimage, position: String?
    let weeklyHours: String?
    let location: String?
    let salary: Int?
    let currencyName, currencySymbol, content: String?
    let jobImage: String?
    let attendees, commentCount, applicantCount, isJobLike: Int?
    let isApplied, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime, type, os: String?
    let status: Int?
    let isURL: Bool?
    let postVideo, isConnected: String?
    let connectionID: Int?
    let isReceiver: Bool?
    let saved: Int?
    let createdOn: String?
    
    enum CodingKeys: String, CodingKey {
        case id, userID, user, jobTitle, jobNature
        case jobtype = "jobtype "
        case jobSector = "jobSector "
        case companyName, companylogo, userimage, position, weeklyHours, location, salary, currencyName, currencySymbol, content, jobImage, attendees, commentCount, applicantCount, isJobLike, isApplied, likeCount, createdByID, createdDatetime, modifiedByID, modifiedDatetime, type, os, status, isURL, postVideo, isConnected
        case connectionID = "connectionId"
        case isReceiver, saved
        case createdOn = "created_on"
    }
}
