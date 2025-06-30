//
//  UIDatePicker.swift
//  EvaConnect
//
//  Created by usama on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UIDatePicker {
    
    func setValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = +2
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
//        components.year = -1
//        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = currentDate
        self.maximumDate = maxDate
    }
    
    
}
