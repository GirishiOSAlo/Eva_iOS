//
//  AllHomePost.swift
//  EvaConnect
//
//  Created by Metis on 14/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct DashboardItemRoot: Codable {
    let error: Bool
    let message: String?
    let data: [DashboardItem]
}

// MARK: - Datum
struct DashboardItem: Codable {
    var id: Int
    var userID: Int?
    var user: EvaUser?
    var jobTitle: String?
    var jobNature: String?
    var jobtype : TypeJobEnum?
    var jobSector: String?
    var position, weeklyHours, location: String?
    var salary: Int?
    var content: String?
    var jobImage: String?
    var commentCount: Int
    var applicantCount: Int?
    var isJobLike: Int?
    var isApplied: Int?
    var likeCount, createdByID: Int?
    var createdDatetime: String?
    var modifiedByID: Int?
    var modifiedDatetime: String?
    var type: TypePostEnum?
    var os: String?
    var status: String?
    var isURL: Bool?
    var postVideo: String?
    var isConnected: IsConnected?
    var connectionId:Int?
    var isReceiver: Bool?
    var isPostLike: Int?
    var createdDate: String?
    var postImage: [String?]?
    var connectionID: Int?
    var eventName, eventCity,eventAddress, eventStartDate: String?
    var isEventLike: Int?
    var eventImage: [String]?
    var newsSource: HomeNewsSource?
    var title, summary, author, published: String?
    var link: String?
    var image: String?
    var isNewsLike: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case user
        case jobtype = "job_type"
        case connectionId
        case isNewsLike = "is_news_like"
        case jobTitle = "job_title"
        case jobNature = "job_nature"
        case jobSector = "job_sector"
        case position
        case eventAddress = "address"
        case newsSource = "news_source"
        case title, summary, author, published, link, image
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
        case isURL = "is_url"
        case postVideo = "post_video"
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case isPostLike = "is_post_like"
        case createdDate = "created_date"
        case postImage = "post_image"
        case connectionID = "connection_id"
        case eventName = "name"
        case eventCity = "city"
        case eventStartDate = "start_date"
        case isEventLike = "is_event_like"
        case eventImage = "event_image"
    }
}// MARK: - NewsSource

struct HomeNewsSource: Codable {
    let id: Int
    let name: String
    let image: String
    let status: Status
    let url: String?
}
enum TypeJobEnum: String, Codable {

    case evening = "Evening"
    case fullTime = "Full Time"
    case morning = "Morning"
    case nights = "Nights"
    case partTime = "Part Time"
    case termTime = "Term Time"
    case weekends = "Weekends"
}
enum TypePostEnum: String, Codable {
    case event = "event"
    case job = "job"
    case post = "post"
    case news = "news"
}
// MARK: - User
struct HomeUser: Codable {
    
    let id: Int?
    let userImage: String?
    let totalConnection: Int?
    let firstName: String?
    let lastName: String?
    let bioData: String?
    let address: String?
    let companyName: String?
    let field: String?
    let designation: String?
    let isLinkedin: Int?
    let linkedinImageURL: String?
    let facebookImageURL: String?
    let isFacebook: Int?
    let workAviation, sector, city, country: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userImage = "user_image"
        case totalConnection = "total_connection"
        case firstName = "first_name"
        case lastName = "last_name"
        case bioData = "bio_data"
        case address
        case companyName = "company_name"
        case field, designation
        case isLinkedin = "is_linkedin"
        case linkedinImageURL = "linkedin_image_url"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case workAviation = "work_aviation"
        case sector, city, country
    }
}
