//
//  UVWeatherService.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import Foundation
import Combine

public enum APIError: Error {
    case noNetwork
    case invalid
    case outdated
    case unknown
}

public protocol UVWeatherService {
    func fetchUV() -> AnyPublisher<UVData, Error>
}

final class StandardUVWeatherService: UVWeatherService {
    
    private let url = URL(string: "https://api.data.gov.sg/v1/environment/uv-index")!
    
    init() {}
    
    func fetchUV() -> AnyPublisher<UVData, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UVData.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}