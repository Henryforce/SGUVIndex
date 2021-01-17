//
//  SnapshotMockUVWeatherService.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 17/1/21.
//

import Foundation
import Combine

final class SnapshotMockUVWeatherService: UVWeatherService {
    func fetchUV() -> AnyPublisher<UVData, Error> {
        Just(
            UVData(
                items: [
                    UVItem(
                        timestamp: Date(),
                        updateTimestamp: Date(),
                        records: [
                            UVDataRecord(value: 0, timestamp: Date(timeIntervalSince1970: 1609455600)),
                            UVDataRecord(value: 1, timestamp: Date(timeIntervalSince1970: 1609459200)),
                            UVDataRecord(value: 3, timestamp: Date(timeIntervalSince1970: 1609462800)),
                            UVDataRecord(value: 4, timestamp: Date(timeIntervalSince1970: 1609466400)),
                            UVDataRecord(value: 6, timestamp: Date(timeIntervalSince1970: 1609470000)),
                            UVDataRecord(value: 11, timestamp: Date(timeIntervalSince1970: 1609473600))
                        ]
                    )
                ],
                apiInfo: APIInfo(status: "Active")
            )
        ).setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
