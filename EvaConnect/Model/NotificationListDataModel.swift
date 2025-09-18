//
//  NotificationListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 18/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
//NotificationListDataModel

// MARK: - Welcome
struct NotificationListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: NotificationList?
}

// MARK: - DataClass
struct NotificationList: Codable {
    let pushBrowser: Int?
    let email: Int?
    let meetingRequested: Int?
    let meetingCancelled: Int?
    let meetingRescheduled: Int?
    let meetingReminder: Int?
    let messages: Int?
    let postComments: Int?
    let postLikes: Int?
    let connectionRequest: Int?
    let newConnections: Int?
    let profileViews: Int?
    let newEvents: Int?
    let newJobPost: Int?
    let newUpdate: Int?
    let companyPostUpdates: Int?
    let calendarReminders: Int?
    let meetingReminders: Int?
    
    enum CodingKeys: String, CodingKey {
        case pushBrowser = "push_browser"
        case email = "email"
        case meetingRequested = "meeting_requested"
        case meetingCancelled = "meeting_cancelled"
        case meetingRescheduled = "meeting_rescheduled"
        case meetingReminder = "meeting_reminder"
        case messages = "messages"
        case postComments = "post_comments"
        case postLikes = "post_likes"
        case connectionRequest = "connection_request"
        case newConnections = "new_connections"
        case profileViews = "profile_views"
        case newEvents = "new_events"
        case newJobPost = "new_job_post"
        case newUpdate = "new_update"
        case companyPostUpdates = "company_post_updates"
        case calendarReminders = "calendar_reminders"
        case meetingReminders = "meeting_reminders"
    }
}
