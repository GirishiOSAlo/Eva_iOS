//
//  Timeago.swift
//  EvaConnect
//
//  Created by usama on 22/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct TimeAgo {
    
    enum Component {
        case year(Int)
        case month(Int)
        case week(Int)
        case day(Int)
        case hour(Int)
        case minute(Int)
        case second(Int)
        case justNow
    }
    
    var short = ""
    var long = ""
    
    init(with date: Date) {
        calculate(date)
    }
    
    private mutating func configure(with component: Component) {
        switch component {
        case .year(let y):
            short = "\(y)y"
            if y >= 2 {
                long = "\(y) years ago"
                return
            }
            if y >= 1 {
                long = "Last year"
            }
        case .month(let m):
            short = "\(m)m"
            if m >= 2 {
                long = "\(m) months ago"
                return
            }
            
            if m >= 1 {
                long = "Last month"
            }
            
        case .week(let w):
            short = "\(w)w"
            if w >= 2 {
                long = "\(w) weeks ago"
                return
            }
            
            if w >= 1 {
                long = "Last week"
            }
            
        case .day(let d):
            short = "\(d)d"
            if d >= 2 {
                long = "\(d) days ago"
                return
            }
            
            if d >= 1 {
                long = "Yesterday"
            }
            
        case .hour(let h):
            short = "\(h)h"
            if h >= 2 {
                long = "\(h) hours ago"
                return
            }
            
            if h >= 1 {
                long = "An hour ago"
            }
            
        case .minute(let m):
            short = "\(m)min"
            if m >= 2 {
                long = "\(m) minutes ago"
                return
            }
            
            if m >= 1 {
                long = "A minute ago"
            }
            
        case .second(let s):
            short = "\(s)s"
            long = "\(s) seconds ago"
            
        case .justNow:
            long = "Just now"
            short = "now"
        }
    }
    
    private mutating func calculate(_ date: Date) {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        
        let components = calendar.dateComponents(unitFlags, from: date, to: now)
        
        if let year = components.year,
            year >= 2 || year >= 1 {
            configure(with: Component.year(year))
            return
        }
        
        if let month = components.month,
            month >= 2 || month >= 1 {
            configure(with: .month(month))
            return
        }
        
        if let week = components.weekOfYear,
            week >= 2 || week >= 1 {
            configure(with: .week(week))
            return
        }
        
        if let day = components.day,
            day >= 2 || day >= 1 {
            configure(with: .day(day))
            return
        }
        
        if let hour = components.hour,
            hour >= 2 || hour >= 1 {
            configure(with: .hour(hour))
            return
        }
        
        if let minute = components.minute,
            minute >= 2 || minute >= 1 {
            configure(with: .minute(minute))
            return
        }
        
        if let second = components.second, second >= 3 {
            configure(with: .second(second))
            return
        }
        
        configure(with: .justNow)
        
    }
}


