//
//  Font+Extension.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 30/12/20.
//

import SwiftUI

enum AppFont: String {
    case regular = "Roboto-Regular"
    case bold = "Roboto-Bold"
    case black = "Roboto-Black"
}

extension Font {
    init(_ appFont: AppFont, size: CGFloat) {
        self = Font.custom(appFont.rawValue, size: size)
    }
}
