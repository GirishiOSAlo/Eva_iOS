//
//  Date.swift
//  EvaConnect
//
//  Created by usama on 13/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

let TODAY: String = "Today"
let YESTERDAY: String = "Yesterday"

extension Date {
    
    func days(from date: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
        return days
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var millisecondsSince1970:Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    
    var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self) ?? Date()
    }
    
    var previousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }
    
    static func getDateStringFromTimeStamp(timeStamp: Double, dtFormatter: String) -> String {
        let date = Date(timeIntervalSince1970: timeStamp/1000.0)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = dtFormatter;
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
    
    static func getDateFromTimeStamp(timeStamp: Double, dtFormatter: String) -> Date? {
        let date = Date(timeIntervalSince1970: timeStamp/1000.0)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = dtFormatter
        let dateString = dayTimePeriodFormatter.string(from: date)
    
        return dayTimePeriodFormatter.date(from: dateString)
    }
    
    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale.current
        let myString = formatter.string(from: date)
        return myString
    }
    
    static func todaysDate() {
        
    }
        
    static func datePrettyFromTimestamp(_ timestamp: Double) -> (day: String, time: String)? {
        if let createdDate = Date.getDateFromTimeStamp(timeStamp: timestamp, dtFormatter: "YYYY-MM-dd'T'HH:mm:ssZ") {
            let createdDateStr = Date.dateToString(date: createdDate)
            let todayDateStr = Date.dateToString(date: Date())
            let yesterdayDateStr = Date.dateToString(date: Date().addingTimeInterval(-86400))
            
            var day = ""
            let time = Date.getDateStringFromTimeStamp(timeStamp: timestamp, dtFormatter: "hh:mm aa")
            
            if(createdDateStr == todayDateStr) {
                day = TODAY
            } else if(createdDateStr == yesterdayDateStr) {
                day = YESTERDAY
            } else {
                day = Date.getDateStringFromTimeStamp(timeStamp: timestamp, dtFormatter: "EEEE")
            }
            
            return (day, time)
        }
        return nil
    }
    
    func toString(formatter: DateFormatter = Formatter.standardDate) -> String {
        return formatter.string(from: self)
    }
 
    func yearMonthDayInt() -> Int? {
         let calendar = Calendar.current
         let components = calendar.dateComponents([.year], from: self)
         let year = components.year
         return year
     }
    
    func getElapsedInterval() -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day, .month, .year]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        
        var dateString: String?
        
        if self.timeIntervalSince(Date()) > -60*5 {
            dateString = NSLocalizedString("now", comment: "")
        } else {
            dateString = String.init(format: NSLocalizedString("%@ ago", comment: ""), locale: .current, formatter.string(from: self, to: Date())!)
        }
        
        return dateString ?? ""
    }
}
