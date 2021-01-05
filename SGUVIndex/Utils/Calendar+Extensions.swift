//
//  Calendar+Extensions.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 31/12/20.
//

import Foundation

extension Calendar {
    static var singapore: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT+8")!
        return calendar
    }()
}
