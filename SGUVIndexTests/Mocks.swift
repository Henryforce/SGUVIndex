//
//  Mocks.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import Foundation
import Combine
@testable import SGUVIndex

final class MockUVWeatherService: UVWeatherService {
    var data: UVData = .dataToday
    func fetchUV() -> AnyPublisher<UVData, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension UVData {
    static var dataToday: UVData = {
        let currentDate = Date()
        let updateTimestamp = currentDate.addingTimeInterval(100)
        return UVData(
            items: [
                UVItem(
                    timestamp: currentDate,
                    updateTimestamp: updateTimestamp,
                    records: [
                        UVDataRecord(
                            value: .zero,
                            timestamp: currentDate
                        )
                    ]
                )
            ],
            apiInfo: .healthy
        )
    }()
    
    static var dataYesterday: UVData = {
        let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let updateTimestamp = currentDate.addingTimeInterval(100)
        return UVData(
            items: [
                UVItem(
                    timestamp: currentDate,
                    updateTimestamp: updateTimestamp,
                    records: [
                        UVDataRecord(
                            value: .zero,
                            timestamp: currentDate
                        )
                    ]
                )
            ],
            apiInfo: .healthy
        )
    }()
}

extension HomeConstants {
    static var testing: HomeConstants {
        HomeConstants(
            loadBufferTime: .zero,
            loadOffset: .zero
        )
    }
}
