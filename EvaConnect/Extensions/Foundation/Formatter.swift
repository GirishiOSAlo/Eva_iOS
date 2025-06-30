//
//  Formatter.swift
//  EvaConnect
//
//  Created by usama on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

public extension Formatter {
    
    static let standardDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    static let standardEuropeanDate: DateFormatter = {
          let formatter = DateFormatter()
          formatter.calendar = Calendar.current
          formatter.locale = Locale.current
          formatter.dateFormat = "dd-MM-yyyy"
          return formatter
      }()
    
    static let standardDateWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let standardDateWithTimeUTC: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let standardTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    static let apiBody: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let apiBodyUTC: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    static let standardTimeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh mm a"
        return formatter
    }()
    
    static let timeOnly: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "hh:mm a"
         return formatter
     }()
    
    static let timeOnlyUTC: DateFormatter = {
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone(identifier: "UTC")
         formatter.dateFormat = "hh:mm a"
         return formatter
     }()
    
    static let combinedDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MM-yyyy h:mm a"
        return formatter
    }()
    
    static let combinedStandardDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd h:mm a"
        return formatter
    }()
}
