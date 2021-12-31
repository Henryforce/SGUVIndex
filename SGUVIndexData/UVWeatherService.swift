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
        let response = try await session.asyncData(from: url)
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

private extension URLSession {
    func asyncData(from url: URL) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await data(from: url)
        }
        // Fallback on earlier versions
        return try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                }  else {
                    continuation.resume(throwing: UVWeatherServiceError.empty)
                }
            }.resume()
        }
    }
}
