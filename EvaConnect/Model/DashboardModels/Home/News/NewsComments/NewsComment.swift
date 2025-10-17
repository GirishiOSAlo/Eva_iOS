//
//  NewsComment.swift
//  EvaConnect
//
//  Created by Metis on 06/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
struct NewsCommentRoot: Codable {
    let error: Bool
    let message: String
    let data: [NewsComment]
}
// MARK: - Datum
struct NewsComment: Codable {
    let id, modifiedByID, rssNewsID, isCommentLike, likeCount: Int?
    let user: CommentUserData?
    let createdDate, content: String?
    let createdByID: StringOrInt?
    let createdDatetime: String
    let modifiedDatetime: String?
    let os, status: String?
    var time: String {
        if let date = createdDatetime.date(formatter: .standardDateWithTime) {
            let timeOnly =  date.toString(formatter: .timeOnly)
            return timeOnly
        }
        return ""
    }

    enum CodingKeys: String, CodingKey {
        case id, isCommentLike, likeCount
        case rssNewsID = "rss_news_id"
        case user
        case createdDate = "created_date"
        case content
        case createdByID = "created_by_id"
        case createdDatetime = "created_datetime"
        case modifiedByID = "modified_by_id"
        case modifiedDatetime = "modified_datetime"
        case os, status
    }
}
