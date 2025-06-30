//
//  BaseExtension.swift
//  EvaConnect
//
//  Created by Metis on 17/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

extension BaseVC {
    
    func dateString(_ getDate: String)-> String {
        if getDate.isEmpty { return "" }
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date3 = dateFormatter.date(from: getDate)
        let dateComponents = calendar.component(.day, from: date3!)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM"
        return day!
    }
    
    func fbTimeStamp(_ getDate: String) -> String {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone.init(abbreviation: "UTC")
        let date = dateFormatter1.date(from: getDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let time = "\(dateFormatter.string(from: date!)), \(timeFormatter.string(from: date!))"
        return time
    }

    
    func timeAgo2(_ getDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        let date3 = dateFormatter.date(from: getDate)
        let calendar = Calendar.current
        let formatter: DateComponentsFormatter = {
            let _formatter = DateComponentsFormatter()
            _formatter.allowedUnits = [.day,.hour,.minute,.second]
            _formatter.unitsStyle = .short
            _formatter.maximumUnitCount = 1
            return _formatter
        }()
        // birthDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: picker.date))!
        let now = calendar.date(from: calendar.dateComponents([.year,.day, .weekOfMonth,.hour,.month,.minute,.second], from: Date()))!
        return  formatter.string(from: date3!, to: now)!
    }
}
