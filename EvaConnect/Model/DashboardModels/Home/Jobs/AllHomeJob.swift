//
//  AllHomeJob.swift
//  EvaConnect
//
//  Created by Metis on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct AllHomeJob: Codable {
    let error: Bool
    let message: String
    let data: [HomeJobModel]
}

// MARK: - Datum
struct HomeJobModel: Codable {
    var id, userID: Int?
    var user: HomeUser?
    var jobTitle: String?
    var jobNature: String?
    var jobSector, position, weeklyHours, location: String?
    var salary: Int?
    var content: String?
    var jobImage: String?
    var commentCount: Int?
    var applicantCount: Int?
    var isJobLike: Int?
    var isApplied, likeCount, createdByID: Int?
    var createdDatetime: String?
    var modifiedByID: Int?
    var modifiedDatetime: String?
    var type: Type?
    var os: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case user
        case jobTitle = "job_title"
        case jobNature = "job_nature"
        case jobSector = "job_sector"
        case position
        case weeklyHours = "weekly_hours"
        case location, salary, content
        case jobImage = "job_image"
        case commentCount = "comment_count"
        case applicantCount = "applicant_count"
        case isJobLike = "is_job_like"
        case isApplied = "is_applied"
        case likeCount = "like_count"
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case type, os, status
    }
}
