//
//  JobAdModel.swift
//  EvaConnect
//
//  Created by Metis on 05/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct JobDetailRoot: Codable {
    let error: Bool
    let message: String
    let data: [JobDetail]
}

// MARK: - Datum
struct JobDetail: Codable {
    let id, userID: Int
    let modifiedByID: Int?
    let jobTitle, jobNature, jobType , jobSector, position: String?
    let weeklyHours, location: String?
    let salary,activeHours: Int?
    let content, jobImage: String?
    let jobVideo: String?
    let commentCount, applicantCount, likeCount, createdByID: Int?
    let createdDatetime: String?
    let modifiedDatetime: String?
    let os, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case jobTitle = "job_title"
        case jobNature = "job_nature"
        case jobSector = "job_sector"
        case jobType = "job_type"
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
        case activeHours = "active_hours"
    }
}
