//
//  UserNotificationSetting.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 3/15/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

enum UserNotificationSetting: String, CaseIterable {
    case message = "Messages"
    case comment = "Post Comments"
    case likes = "Post Likes"
    case connectionRequest = "Connection Requests"
    case newConnection = "New Connections"
    case followers = "New Follower"
    case profileView = "Profile Views"
    case suggestedConnections = "Suggested Connections"
    case newEvent = "New Events"
    case newJobPost = "New Job Post"
    case newsUpdate = "News Update"
    case companyPostUpdate = "Company Post Updates"
    case event = "Event Interests"
    case applicants = "Job Applicants"
    case calendarReminder = "Calendar Reminders"
    case meetingReminder = "Meeting Reminders"
}

extension UserNotificationSetting {
    
    var apiKey: String {
        switch self {
        case .message:
            return "message"
        case .comment:
            return "post_comments"
        case .likes:
            return "post_likes"
        case .followers:
            return "connection_requests"
        case .profileView:
            return "profile_views"
        case .event:
            return "event_interests"
        case .applicants:
            return "job_applicants"
        case .calendarReminder:
            return "calendar_reminder"
        case .meetingReminder:
            return "meeting_reminders"
        case .connectionRequest:
            return "connection_requests"
        case .newConnection:
            return "connection_requests"
        case .suggestedConnections:
            return "suggested_connections"
        case .newEvent:
            return "new_events"
        case .newJobPost:
            return "new_job_post"
        case .newsUpdate:
            return "news_update"
        case .companyPostUpdate:
            return "post_updates"
        }
    }
    
    static var user: [UserNotificationSetting] {
        return [.message, .comment, .likes, .connectionRequest, .profileView, .suggestedConnections, .newEvent, .newJobPost, .newsUpdate,
                .companyPostUpdate, .calendarReminder, .meetingReminder]
    }
    
    static var company: [UserNotificationSetting] {
        return [.message, .comment, .likes, .followers, .profileView, .event, .applicants, .calendarReminder, .meetingReminder]
    }
    
}
