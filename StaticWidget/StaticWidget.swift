//
//  StaticWidget.swift
//  StaticWidget
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private let userDefaults = StandardUserDefaultsManager()
    
    func placeholder(in context: Context) -> UVWidgetData {
        UVWidgetData.previewData
    }

    func getSnapshot(in context: Context, completion: @escaping (UVWidgetData) -> ()) {
        completion(UVWidgetData.previewData)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        UVWidgetNetwork.getData(
            currentDate: Date(),
            userDefaults: userDefaults
        ) { (data, nextUpdate) in
            completion(
                Timeline(
                    entries: data,
                    policy: .after(nextUpdate)
                )
            )
        }
    }
    
}

@main
struct StaticWidget: Widget {
    let kind: String = "StaticWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UVWidgetView(data: entry)
        }
        .configurationDisplayName(Localization.localize(.uvLevels))
        .description("View UV data")
    }
}
