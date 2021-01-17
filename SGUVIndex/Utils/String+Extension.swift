//
//  String+Extension.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 17/1/21.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
