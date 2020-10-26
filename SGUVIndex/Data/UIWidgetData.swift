//
//  UIWidgetData.swift
//  SGWeatherData
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI
import WidgetKit

public struct UVWidgetData: TimelineEntry {
    public let date: Date
    public let uvValue: String
    public let uvDescription: String
    
    public init(date: Date, uvValue: String, uvDescription: String) {
        self.date = date
        self.uvValue = uvValue
        self.uvDescription = uvDescription
    }
}

extension UVWidgetData {
    static var previewData: UVWidgetData = {
        UVWidgetData(date: Date(),
                     uvValue: "-",
                     uvDescription: "")
    }()
}
