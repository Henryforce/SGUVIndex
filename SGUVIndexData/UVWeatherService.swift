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

final class StandardUVWeatherService: UVWeatherService {
    
    private let urlString = URL(string: "https://api.data.gov.sg/v1/environment/uv-index")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUV() async throws -> UVData {
        let response = try await session.data(from: urlString)
        return try JSONDecoder.iso8601Decoder.decode(UVData.self, from: response.0)
    }
    
}
