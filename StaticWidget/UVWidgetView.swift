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
    let foregroundColor: Color = .white
    
    var body: some View {
        VStack {
            Text("Singapore")
                .fontWeight(.heavy)
                .foregroundColor(foregroundColor)
            Spacer()
            Text("UV")
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(foregroundColor)
            HStack {
                Spacer()
                Text(data.uvDescription)
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(foregroundColor)
                Text(data.uvValue)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(foregroundColor)
                Spacer()
            }
            Spacer()
            Text("Last Updated")
                .fontWeight(.medium)
                .font(.footnote)
                .foregroundColor(foregroundColor)
            Text(data.date, style: .time)
                .fontWeight(.light)
                .font(.caption)
                .foregroundColor(foregroundColor)
        }
        .padding(.leading, 4)
        .padding(.trailing, 4)
        .padding(.top, 16)
        .padding(.bottom, 16)
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 5.0)))
//        .background(LinearGradient(gradient: Gradient(colors: [data.backgroundColor, .white]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 5.0)))
//        .background(data.backgroundColor.opacity(0.4))
//        .background(Color.green)
//        .cornerRadius(5)
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
