//
//  Font+Extension.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 30/12/20.
//

import SwiftUI

enum AppFont: String {
    case robotoRegular = "Roboto-Regular"
    case robotoBold = "Roboto-Bold"
    case robotoBlack = "Roboto-Black"
    
    case montserratRegular = "Montserrat-Regular"
    case montserratSemiBold = "Montserrat-SemiBold"
    case montserratBold = "Montserrat-Bold"
    case montserratBlack = "Montserrat-Black"
}

extension Font {
    init(_ appFont: AppFont, size: CGFloat) {
        self = Font.custom(appFont.rawValue, size: size)
    }
    
    static func printAllFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
}
