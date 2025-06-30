//
//  CompanyJobModel.swift
//  EvaConnect
//
//  Created by Metis on 25/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CompanyJobListRoot: Codable {
    let error: Bool
    let message: String
    let data: [CompanyJobs]?
}

// MARK: - Datum
struct CompanyJobs: Codable {
    let id, userID ,activeHours: Int?
    let jobTitle, jobNature, jobSector, position: String?
    let weeklyHours, location: String?
    let salary: Int?
    let content: String?
    let jobImage: String?
    let jobVideo: String?
    let commentCount, applicantCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedDatetime: String?
    let modifiedByID : Int?
    let os, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case activeHours = "active_hours"
        case userID = "user_id"
        case jobTitle = "job_title"
        case jobNature = "job_nature"
        case jobSector = "job_sector"
        case position
        case weeklyHours = "weekly_hours"
        case location, salary, content
        case jobImage = "job_image"
        case jobVideo = "job_video"
        case commentCount = "comment_count"
        case applicantCount = "applicant_count"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}
