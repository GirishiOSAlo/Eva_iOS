//
//  SharedControllerAttributes.swift
//  EvaConnect
//
//  Created by usama on 16/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum AttendeeStatus: String {
    case going = "Going"
    case notGoing = "Not Going"
    case maybe = "May be"
    case pending = "Pending"
}

enum HomeTabs: String, CaseIterable {
    //case posts, events, jobs, news
    case news, events, jobs, posts
    case industryEvents, industryJobs, industryPost
    
    var selectedIndex: Int {
        switch self {
//        case .posts:
//            return 0
//        case .events:
//            return 1
//        case .jobs:
//            return 2
//        case .news:
//            return 3
        case .news, .industryEvents:
            return 0
        case .events, .industryJobs:
            return 1
        case .jobs, .industryPost:
            return 2
        case .posts:
            return 3

        }
    }
    
    var getPostEndPoint: String {
        switch self {
//        case .posts:
//            return EndPoints.getAllHomePost
//        case .events:
//            return EndPoints.homeFilterEvents
//        case .jobs:
//            return EndPoints.homeFilterJobs
//        case .news:
//            return EndPoints.getAllHomeNews
        case .news:
            return EndPoints.getAllHomeNews
        case .events, .industryEvents:
            return EndPoints.homeFilterEvents
        case .jobs:
            return EndPoints.homeFilterJobs
        case .posts:
            return EndPoints.getPostList
        case .industryJobs:
            return EndPoints.homeFilterJobs
        case .industryPost:
            return EndPoints.getPostList
        }
    }
    
    var deletePostEndPoint: String {
        switch self {
//        case .posts:
//            return EndPoints.deletePost
//        case .events:
//            return EndPoints.deleteEvent
//        case .jobs:
//            return EndPoints.deleteJob
//        case .news:
//            return ""
        case .news:
            return ""
        case .events:
            return EndPoints.deleteEvent
        case .jobs:
            return EndPoints.deleteJob
        case .posts:
            return EndPoints.deletePost
        case .industryEvents:
            return ""
        case .industryJobs:
            return ""
        case .industryPost:
            return ""
        }
    }
    
    var likePostKey: String {
        switch self {
//        case .posts:
//            return "post_id"
//        case .events:
//            return "event_id"
//        case .jobs:
//            return "job_id"
//        case .news:
//            return "rss_news_id"
        case .news:
            return "rss_news_id"
        case .events:
            return "event_id"
        case .jobs:
            return "job_id"
        case .posts:
            return "post_id"
        case .industryEvents:
            return "event_id"
        case .industryJobs:
            return "job_id"
        case .industryPost:
            return "post_id"
        }
    }
    
    var likeType: TypePostEnum {
        switch self {
//        case .posts:
//            return .post
//        case .events:
//            return .event
//        case .jobs:
//            return .job
//        case .news:
//            return .news
        case .news:
            return .news
        case .events:
            return .event
        case .jobs:
            return .job
        case .posts:
            return .post

        case .industryEvents:
            return .event
        case .industryJobs:
            return .job
        case .industryPost:
            return .post
        }
    }
}

enum EditProfile: String {
    case profilePicture = "Change Profile Picture"
    case companyLogo = "Change Company Logo"
    case jobTitle = "Edit Job Title"
    case bio = "Edit Bio"
    case companyBio = "Edit Company Bio"
    case password = "Change Password"
    case location = "Edit Location"
    
    static var user: [EditProfile] {
        [.profilePicture, .jobTitle, .bio, .password, .location]
    }
    
    static var company: [EditProfile] {
        [.companyLogo, .companyBio, .password, .location]
    }
}

enum UserSetting: String, CaseIterable {
    case profile = "Profile Information"
    case notification = "Notification"
    case rss = "News Categories"
    case blockList = "Block List"
    case security = "Change Password"
    case help = "Help"
    case language = "Region & Language"
    case terms = "Terms of Services"
    case cookies = "Cookies Policy"
    case privacy = "Privacy Policy"
    case account = "Private/Public Account"
}

struct Participants {
    let id: Int
    let name: String
    let designation: String?
    let imageUrl: String?
}

enum ViewerType {
    case creator, invited
}

protocol AttendeesProvidable {
    func convertAttendeeToPartcipant(attendee: UserConnection) -> Participants
    func convertUserToParticipant(connection: User) -> Participants
    func convertAttendeeToUser(attendee: UserConnection) -> User
}

extension AttendeesProvidable {
//    func convertAttendeeToPartcipant(attendee: Attendee) -> Participants {
//        Participants(id: attendee.id, name: attendee.user.fullName, designation: attendee.user.designation, imageUrl: attendee.user.userImage)
//    }
//    func convertUserToParticipant(connection: User) -> Participants {
//        Participants(id: connection.id, name: connection.fullName, designation: connection.designation, imageUrl: connection.userImage)
//    }
    
//    func convertAttendeeToUser(attendee: Attendee) -> User {
//        User(id: attendee.userID, firstName: attendee.user.firstName ?? "", email: attendee.user.email ?? "", uniqueCode: attendee.user.uniqueCode, lastName: attendee.user.lastName,
//             username: attendee.user.username ?? "", dateOfBirth: attendee.user.dateOfBirth, userImage: attendee.user.userImage, city: attendee.user.city,
//             country: attendee.user.country, bioData: attendee.user.bioData, type: attendee.user.type, status: attendee.user.status ?? "", address: attendee.user.address,
//             companyName: attendee.user.companyName, field: attendee.user.field, designation: attendee.user.designation, isConnected: attendee.user.isConnected?.rawValue,
//             isReceiver: attendee.user.isReceiver == "true", isOnline: false, lastOnlineDateTime: nil, connectionID: attendee.user.connectionID, isNotifications: attendee.user.is_notifications)
//    }
}

//extension MeetingViewVC: AttendeesProvidable { }
//extension EventViewVC: AttendeesProvidable { }
//extension EventCommentVC: AttendeesProvidable { }
//extension CreateMeetingVC: AttendeesProvidable { }


