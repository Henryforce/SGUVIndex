//
//  StaticWidget.swift
//  StaticWidget
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import WidgetKit
import SwiftUI
import Combine

struct Provider: TimelineProvider {
    
    var cancellable: AnyCancellable?
    
    func placeholder(in context: Context) -> UVWidgetData {
        UVWidgetData.previewData
    }

    func getSnapshot(in context: Context, completion: @escaping (UVWidgetData) -> ()) {
        let entry = UVWidgetData.previewData
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        UVWidgetNetwork.getData(currentDate: Date()) { (data, nextUpdate) in
            let timeline = Timeline(entries: data,
                                    policy: .after(nextUpdate))
            completion(timeline)
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
