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
}
