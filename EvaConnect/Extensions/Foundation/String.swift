//
//  String.swift
//  EvaConnect
//
//  Created by usama on 17/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension String {
    
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = self.data(using: .utf8) else { return nil }
//        do {
//            return try NSAttributedString(
//                data: data,
//                options: [
//                    .documentType: NSAttributedString.DocumentType.html,
//                    .characterEncoding: String.Encoding.utf8.rawValue
//                ],
//                documentAttributes: nil
//            )
//        } catch {
//            print("HTML to Attributed String Error: \(error)")
//            return nil
//        }
//    }
    
    func htmlToAttributedString(withFont font: UIFont, color: UIColor = .label) -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            // Apply custom font and color to entire string
            let fullRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.font, value: font, range: fullRange)
            attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
            
            return attributedString
        } catch {
            print("HTML to Attributed String Error: \(error)")
            return nil
        }
    }
    
    public var length: Int {
        return self.count
    }
    
    func in24hourFormat() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "HH:mm"
        return date.isNil ? self : dateFormatter.string(from: date!)
    }

    func in12HourFormat(format: String = Constants.DateFormats.hms, isUTC: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if isUTC {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        if let date12 = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: date12)
        }
        return ""
    }
    
    func convertToDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
    func date(formatter: DateFormatter = .apiBody) -> Date? {
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func dateTime(isUTC: Bool = false) -> (day: String, time: String)? {
    
        if let createdDate = self.date(formatter: isUTC ? .standardDateWithTimeUTC : .standardDateWithTime) {
            
            let components = Calendar.current.dateComponents([.month, .year, .day, .hour, .minute, .second], from: createdDate)
            let createdDateStr = Date.dateToString(date: createdDate)
            let todayDateStr = Date.dateToString(date: Date())
            let yesterdayDateStr = Date.dateToString(date: Date().addingTimeInterval(-86400))
            
            let time = String(format: "%d:%d:%d", components.hour!, components.minute!, components.second!).in12HourFormat()
            var day = ""
//
            if(createdDateStr == todayDateStr) {
                day = TODAY
            } else if(createdDateStr == yesterdayDateStr) {
                day = YESTERDAY
            } else {
                day = createdDate.toString()
            }
            
            return (day, time)
            
        }
        
        return nil
    }
    
    func stringDateFormatter(inputFormatter: DateFormatter = .standardDateWithTime,
                  outputFormatter: DateFormatter = .timeOnly) -> String {
        if let date = self.date(formatter: inputFormatter) {
            let timeOnly =  date.toString(formatter: outputFormatter)
            return timeOnly
        }
        return ""
    }
    
    func timeOnly(isUTC: Bool = false) -> String {
        stringDateFormatter(inputFormatter: isUTC ? .standardDateWithTimeUTC : .standardDateWithTime, outputFormatter: .timeOnly)
    }
    
    func dateOnly() -> String {
        stringDateFormatter(outputFormatter: .dayMonth)
    }
    
    func standardDate(isUTC: Bool = false) -> String {
        stringDateFormatter(inputFormatter: isUTC ? .apiBodyUTC : .apiBody, outputFormatter: .standardDate)
    }
    
    func formatDate(reverse: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else { return ""}
        formatter.dateFormat = reverse ? "d MMM" : "MMM d"
        return formatter.string(from: date) 
    }
    
    func fetchUrlFromString() -> String {
        var urlString: String!
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            let url = self[range]
            urlString = String(url)
            print(url)
        }
        return urlString
    }
    
    var trim: String { self.trimmingCharacters(in: .whitespaces) }
    
    func widthHeightForView(font: UIFont = UIFont(name: UIFont.DefaultFontStyle.regular.fontName, size: 14)!,
                            height: CGFloat = .greatestFiniteMagnitude, width: CGFloat = .greatestFiniteMagnitude,
                            numberOfLines: Int = 1) -> (width: CGFloat, height: CGFloat) {
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0, width: width, height: height))
        label.numberOfLines = numberOfLines
        label.font = font
        label.text = self
        label.sizeToFit()
        return (width: label.frame.width, height: label.frame.height)
    }
    
    func calculateMaxLines(width: CGFloat, font: UIFont = UIFont(name: UIFont.DefaultFontStyle.regular.fontName, size: 16)!) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = self as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    var link: URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        let matches = detector.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))
        return matches.first?.url
    }
}

//MARK:REGEX
extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    func fileWithExtension() -> String {
        
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent + "." + URL(fileURLWithPath: self).pathExtension
    }
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
    var encodeEmoji: String {
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,100}").evaluate(with: self)
    }
    
    var isValidMobile: Bool {
        let mobileRegex = "^[6-9]\\d{9}$"
        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: self)
    }
    
    var isValidPassword:Bool{
//        return NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z@\\d]{8,30}$").evaluate(with: self)
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$").evaluate(with: self)
    }
    //return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$").evaluate(with: self)
    
    //"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])([a-zA-Z0-9]{8,})$"
    
    var isValidDisplayName:Bool{
        return NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z\\d]{1,100}$").evaluate(with: self)
    }
    var isValidURL: Bool {
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
//            // it is a link, if the match covers the whole string
//            return match.range.length == self.utf16.count
//        } else {
//            return false
//        }
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$").evaluate(with: self)
    }

    
    var name: (first: String, last: String) {
        let split = self.split(separator: " ").map(String.init)
        let lastName = (split.last == self ? "" : split.last) ?? ""
        let firstName = self.replacingOccurrences(of: lastName, with: "")
        return (firstName.trim, lastName.trim)
    }
    
//    var bool: Bool? {
//        switch self.lowercased() {
//        case "true":
//            return true
//        case "false":
//            return false
//        default:
//            return false
//        }
//    }
    
    func convertedDate(from inputFormat: String, to outputFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = inputFormat
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = outputFormat
        return formatter.string(from: date)
    }
    
    func formattedCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today"
        }
        
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
           calendar.isDate(date, inSameDayAs: tomorrow) {
            return "Tomorrow"
        }
        
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday"
        }
        
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
}
