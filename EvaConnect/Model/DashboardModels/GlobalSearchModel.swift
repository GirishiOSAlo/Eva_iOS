//
//  GlobalSearchModel.swift
//  EvaConnect
//
//  Created by Pranay Barua on 08/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation

// MARK: - SearchDataModel
struct SearchDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [SearchResult]?
}

//// MARK: - DataClass
//struct SearchDataClass: Codable {
//    let currentPage: Int?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let nextPageURL: String?
//    let path: String?
//    let perPage: Int?
//    let prevPageURL: String?
//    let to, total: Int?
//    let searchResults: [SearchResult]?
//
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to, total
//        case searchResults = "search_results"
//    }
//}
//
//// MARK: - Link
//struct Link: Codable {
//    let url: String?
//    let label: String?
//    let active: Bool?
//}

// MARK: - SearchResult
struct SearchResult: Codable {
    let content, id, source: String?
    
    enum CodingKeys: String, CodingKey {
        case id, source
        case content = "matched_value"
    }
}


// MARK: ------RecentSearchModel--------
struct RecentSearchModel: Codable {
    let error: Bool?
    let message: String?
    let data: [RecentSearchData]?
}

// MARK: - Datum
struct RecentSearchData: Codable {
    let id: Int?
    let search: String?
}

// MARK: - GlobalSearchDataModel
struct GlobalSearchDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: [GlobalSearchDataClass]?
}

// MARK: - DataClass
struct GlobalSearchDataClass: Codable {
    let news: [SearchNews]?
    let jobs: [SearchJob]?
    let posts: [SearchPost]?
    let events: [SearchEvent]?
    let connections: [SearchConnection]?
}

// MARK: - Event
struct SearchEvent: Codable {
    let name: String?
    let id: String?
    let city, address, startDate, endDate: String?
    let createdDate: String?
    let image, bannerImage: String?
    let source: String?
    
    enum CodingKeys: String, CodingKey {
        case name, id, city, address
        case startDate = "start_date"
        case endDate = "end_date"
        case createdDate = "created_date"
        case image
        case bannerImage = "banner_image"
        case source
    }
}

// MARK: - News
struct SearchNews: Codable {
    let id: String?
    let title, newsSource: String?
    let newsSourceImage: String?
    let published: String?
    let image: String?
    let source, relativeTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case newsSource = "news_source"
        case newsSourceImage = "news_source_image"
        case published, image, source
        case relativeTime = "relative_time"
    }
}

// MARK: - Post
struct SearchPost: Codable {
    let id, userID, isURL: String?
        let postVideo: String?
    let createdByID, modifiedByID, content, postImage: String?
        let createdDatetime: String?
        let userName: String?
        let userImage, postImageURL: String?
        let postDocument: String?
        let fileDocumentName, postLikeStatus, postID, postCreatedByID: String?
        let source: String?
        let postDocumentSize: String?
        let postImages: [String]?
        let isPostLike: Int?
        let type: TypePostEnum?
        let count: Count?

        enum CodingKeys: String, CodingKey {
            case id, userID
            case isURL = "is_url"
            case postVideo = "post_video"
            case createdByID, modifiedByID, content, postImage
            case createdDatetime = "created_datetime"
            case userName = "user_name"
            case userImage = "user_image"
            case postImageURL = "post_image_url"
            case postDocument = "post_document"
            case fileDocumentName = "file_document_name"
            case postLikeStatus = "post_like_status"
            case postID = "post_id"
            case postCreatedByID = "created_by_id"
            case source
            case postDocumentSize = "post_document_size"
            case postImages = "post_image"
            case isPostLike, type, count
}
}

// MARK: - SearchConnection
struct SearchConnection: Codable {
    let id: String?
    let firstName, lastName: String?
    let userImage, isOnline: String?
    let designation, companyName, source, fullName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
        case designation
        case companyName = "company_name"
        case source
        case fullName = "full_name"
        case isOnline = "is_online"
    }
}

// MARK: - SearchJob
struct SearchJob: Codable {
    let id, content, position, jobTitle: String?
    let jobSector, location, salary, jobType: String?
    let image: String?
    let source, applicationCount: String?
    let isApplied: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, content, position
        case jobTitle = "job_title"
        case jobSector = "job_sector"
        case location, salary
        case jobType = "job_type"
        case image, source
        case applicationCount = "application_count"
        case isApplied
    }
}

// MARK: - Count
struct Count: Codable {
    let likeCount, commentCount, shareCount: String?
    
    enum CodingKeys: String, CodingKey {
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case shareCount = "share_count"
    }
}

