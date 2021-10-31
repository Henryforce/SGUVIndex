//
//  UVView.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 24/12/20.
//

import SwiftUI

struct UVView: View {
    let title: String = "UV"
    let uvValue: String
    let uvDescription: String
    let date: Date
    let index: Int
    let foregroundColor: Color = .white
    
    @State private var opacity: Double = .zero
    @State private var hasAnimated: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            Text(date, style: .time)
                .font(.init(.montserratRegular, size: 12))
                .frame(width: 80, alignment: .leading)
                .padding(.zero)
            
            Spacer()
            
            Text(uvValue)
                .font(.init(.montserratBold, size: 36))
                .frame(width: 80, alignment: .center)
                .padding(.zero)
            
            Spacer()
            
            Text(uvDescription)
                .font(.init(.montserratRegular, size: 12))
                .frame(width: 80, alignment: .trailing)
                .padding(.zero)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .opacity(self.opacity)
        .onAppear() {
            guard !hasAnimated else { return }
            hasAnimated = true
            let animation = Animation.easeIn(duration: 0.35).delay(0.04 * Double(index))
            self.opacity = .zero
            withAnimation(animation) {
                self.opacity = 1.0
            }
        }
    }
}
