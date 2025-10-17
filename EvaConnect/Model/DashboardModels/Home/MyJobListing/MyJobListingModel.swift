//
//  MyJobListingModel.swift
//  EvaConnect
//
//  Created by Metis on 24/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllJobListing: Codable {
    let error: Bool
    let message: String
    let data: [JobListModel]
}

// MARK: - Datum
struct JobListModel: Codable {
    let id, userID: Int
    let jobTitle: String?
    let jobNature: String?
    let jobSector: String?
    let position: String?
    let weeklyHours: String?
    let location: String?
    let salary: Int?
    let content: String?
    let jobImage: String?
    var isJobLike : Int?
    let commentCount, applicantCount, isApplied, likeCount: Int
    let createdByID: StringOrInt?
    let createdDatetime: String?
    let modifiedByID: Int?
    let modifiedDatetime: String?
    let os: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case jobTitle = "job_title"
        case jobNature = "job_nature"
        case jobSector = "job_sector"
        case position
        case weeklyHours = "weekly_hours"
        case location, salary, content
        case jobImage = "job_image"
        case commentCount = "comment_count"
        case applicantCount = "applicant_count"
        case isApplied = "is_applied"
        case likeCount = "like_count"
        case isJobLike = "is_job_like"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}

enum JobNature: String, Codable {
    case annual = "annual"
}

enum JobSector: String, Codable {
    case itSystems = "ITSystems"
    case piolots = "Piolots"
    case security = "Security"
}

enum WeeklyHours: String, Codable {
    case the36HoursPerWeek = "36 hours(per week)"
    case the48HoursPerWeek = "48 hours(per week)"
}
