//
//  SearchTags.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 3/2/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation

enum SearchTags: String, CaseIterable {
    case all = "All"
    case posts = "Posts"
    case followers = "Followers"
    case connections = "Connections"
    case companies = "Companies"
    case news = "News"
    case events = "Events"
    
    private static var companiesFilter: [SearchTags] {
        return [.posts, .followers, .events]
    }
    
    private static var userFilter: [SearchTags] {
        return [.posts, .connections, .companies, .news, .events]
    }
    
    static var filter: [SearchTags] {
        return LoggedUserDetails.shared.user?.type == userType.company.rawValue ? companiesFilter : userFilter
    }
}


extension SearchTags {
    
    var filterKey: String {
        switch self {
        case .all:
            return "all"
        case .posts:
            return "post"
        case .followers:
            return "connections"
        case .connections:
            return "connections"
        case .companies:
            return "companies"
        case .news:
            return "news"
        case .events:
            return "event"
        }
    }
    
    var isHome: Bool {
        return self == .news || self == .events || self == .posts
    }
    
    var homeTab: HomeTabs {
        switch self {
        case .posts:
            return .posts
        case .news:
            return .news
        default:
            return .events
        }
    }
    
}
