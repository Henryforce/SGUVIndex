//
//  ContentView.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    let foregroundColor: Color = .white
    
    init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("UV Levels")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(foregroundColor)
                .padding(.top, 40)
                .padding(.bottom, 2)
                
            Text(Date(), style: .date)
                .fontWeight(.semibold)
                .font(.title2)
                .foregroundColor(foregroundColor)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.uvItems, id: \.date) { item in
                        UVView(uvValue: item.uvValue,
                               uvDescription: item.uvDescription,
                               date: item.date)
                    }
                }
            }
            
        }.onAppear() {
            viewModel.load()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 2.0, y: 2.0)))
    }
}

struct UVView: View {
    let title: String = "UV"
    let uvValue: String
    let uvDescription: String
    let date: Date
    let foregroundColor: Color = .white
    
    var body: some View {
        HStack {
            Spacer()
            Text(uvDescription + " - " + uvValue)
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(foregroundColor)
            Text("at")
                .fontWeight(.semibold)
                .font(.caption2)
                .foregroundColor(foregroundColor)
            Text(date, style: .time)
                .fontWeight(.semibold)
                .font(.caption)
                .foregroundColor(foregroundColor)
            Spacer()
        }
    }
}
