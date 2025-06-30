//
//  HomeTabFilter.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/12/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import Foundation


enum HomeTabFilter: String {
    case all = "All"
    case new = "New"
    case going = "Attending"
    case saved = "Saved"
    case passed = "Passed"
    case previous = "Previous"
    case industry = "Industry"
    case applied = "Applied"
    case requested = "Requested"
    case active = "Active"
    case inactive = "Inactive"
    case none
    
    static var userEvent: [HomeTabFilter] {
        return [.new, .going, .requested, .saved, .passed]
    }
    
    static var companyEvent: [HomeTabFilter] {
        return [.all, .going, .saved, .previous]
    }
    
    static var job: [HomeTabFilter] {
        return [.all, .industry, .saved, .applied]
    }
    
    static var news: [HomeTabFilter] {
        return [.all, .saved]
    }
    
    static var industryEvents: [HomeTabFilter] {
        return [.all, .previous]
    }
    
    static var industryJobs: [HomeTabFilter] {
        return [.active, .inactive]
    }
}

extension HomeTabFilter {
    
    func getFilter(tab filter: HomeTabs) -> String {
        
        switch self {
        case .all:
            if LoggedUserDetails.shared.user?.type == userType.company.rawValue { return filter == .jobs ? "my_jobs" : "all" }
            else { return "all_posts"}//"all" }
            
        case .new:
            return "all_posts"
        case .going:
            return "upcoming"
        case .saved:
            return "saved"
        case .passed:
            return "passed"
        case .previous:
            return "previous"
        case .industry:
            return "industry"
        case .applied:
            return "applied"
        case .requested:
            return "requested"
        case .none:
            return "all_posts"
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        }
        
    }
    
}
