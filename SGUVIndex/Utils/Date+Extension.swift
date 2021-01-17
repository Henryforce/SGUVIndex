//
//  Date+Extension.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import Foundation

extension Date {
    var monthComponent: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT+8")!
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
            .capitalizingFirstLetter()
    }
    var dayComponent: String {
        if Locale.current.languageCode?.contains("en") ?? false {
            let day = Calendar.singapore.component(.day, from: self)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .ordinal
            return numberFormatter.string(from: NSNumber(value: day))!
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "GMT+8")!
            dateFormatter.dateFormat = Localization.localize(.dayFormat)
            return dateFormatter.string(from: self)
        }
    }
}
