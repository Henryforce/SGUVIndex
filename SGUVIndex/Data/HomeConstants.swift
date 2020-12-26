//
//  HomeConstants.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import UIKit

struct HomeConstants {
    let loadBufferTime: Double
    let loadOffset: CGFloat
    
    init(
        loadBufferTime: Double,
        loadOffset: CGFloat
    ) {
        self.loadBufferTime = loadBufferTime
        self.loadOffset = loadOffset
    }
}

extension HomeConstants {
    static var standard: HomeConstants {
        HomeConstants(
            loadBufferTime: 0.35,
            loadOffset: 35
        )
    }
}
