//
//  InterviewSchdule.swift
//  EvaConnect
//
//  Created by usama on 10/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - InterviewSceduleRoot
struct InterviewScheduleRoot: Codable {
    let error: Bool
    let message: String
    let data: [InterviewScheduleDetails]
}

// MARK: - Datum
struct InterviewScheduleDetails: Codable {
    let id, jobID, userID, jobApplicationID: Int
    let interviewDate, interviewTime, createdDatetime: String
    let createdByID: Int
    let os, status, invitationStatus: String

    enum CodingKeys: String, CodingKey {
        case id
        case jobID = "job_id"
        case userID = "user_id"
        case jobApplicationID = "job_application_id"
        case interviewDate = "interview_date"
        case interviewTime = "interview_time"
        case createdDatetime = "created_datetime"
        case createdByID = "created_by_id"
        case os, status
        case invitationStatus = "invitation_status"
    }
}
