//
//  DateUtils.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

struct DateUtils {
    static func parseDate(from dateString: String) -> Date? {
        let formats = [
            "yyyy-MM-dd",
            "dd-MMM-yyyy",
            "dd-MM-yyyy",
            "MM/dd/yyyy",
            "yyyy/MM/dd",
            "dd MMM yyyy",
            "MMM dd, yyyy",
            "yyyyMMdd",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss"
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    static func formatTo24Hour(timestamp: Double) -> String {
        // If timestamp is in seconds (10 digits), convert to ms
        let ts = (String(Int64(timestamp)).count == 10) ? timestamp * 1000 : timestamp
        
        let date = Date(timeIntervalSince1970: ts / 1000) // convert ms → seconds
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB") // 24-hour format
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
}
