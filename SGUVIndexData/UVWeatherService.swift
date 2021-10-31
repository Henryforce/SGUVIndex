//
//  UVWeatherService.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import Foundation
import Combine

public protocol UVWeatherService {
    func fetchUV() async throws -> UVData
}

public enum UVWeatherServiceError: Error {
    case empty
}

final class StandardUVWeatherService: UVWeatherService {
    static let urlString = "https://api.data.gov.sg/v1/environment/uv-index"
    private lazy var url = URL(string: StandardUVWeatherService.urlString)!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUV() async throws -> UVData {
        let response = try await session.data(from: url)
        let uvData = try JSONDecoder.iso8601Decoder.decode(UVData.self, from: response.0)
        
        guard let firstItem = uvData.items.first else {
            throw UVWeatherServiceError.empty
        }
        
        return UVData(
            items: [
                UVItem(
                    timestamp: firstItem.timestamp,
                    updateTimestamp: firstItem.updateTimestamp,
                    records: firstItem.records.sorted { $0.timestamp > $1.timestamp }
                )
            ],
            apiInfo: uvData.apiInfo
        )
    }
    
}
