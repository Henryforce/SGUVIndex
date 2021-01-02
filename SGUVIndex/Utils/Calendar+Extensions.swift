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
        if let timeZone = TimeZone(identifier: "SGT") {
           calendar.timeZone = timeZone
        }
        return calendar
    }()
}
