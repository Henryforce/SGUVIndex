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
    }
    var dayComponent: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT+8")!
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
}
