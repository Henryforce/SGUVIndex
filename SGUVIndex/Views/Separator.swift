//
//  Separator.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 25/12/20.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
//            .foregroundColor(Color.black)
            .frame(height: 2, alignment: .center)
            .padding(.leading, 16)
            .padding(.trailing, 16)
    }
}
