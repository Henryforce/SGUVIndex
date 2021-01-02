//
//  WidgetView.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI
import WidgetKit

struct UVWidgetView: View {
    let data: UVWidgetData
//    let foregroundColor: Color = .white
    
    var body: some View {
        VStack(spacing: 2) {
            Spacer()
            Text(Localization.localize(.singapore))
                .font(.init(.robotoBlack, size: 17))
            Text(Localization.localize(.uv))
                .font(.init(.montserratRegular, size: 14))
            Separator()
            Text(data.uvValue)
                .font(.init(.montserratBold, size: 28))
            if data.isValueValid {
                Text(data.uvDescription)
                    .font(.init(.montserratRegular, size: 10))
            }
            Separator()
            Text(Localization.localize(.lastUpdated))
                .font(.init(.montserratRegular, size: 9))
            Text(data.date, style: .time)
                .font(.init(.montserratRegular, size: 9))
            Spacer()
        }
        .background(Color.widgetBackground)
    }
}

#if DEBUG
struct UVWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            UVWidgetView(data: .previewData).previewContext(WidgetPreviewContext(family: .systemSmall))
//            WidgetView(data: .previewData).previewContext(WidgetPreviewContext(family: .systemMedium))
//            WidgetView(data: .previewData).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
#endif
