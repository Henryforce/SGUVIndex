//
//  UVWeatherService.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import Foundation
import Combine

public protocol UVWeatherService {
    func fetchUV() -> AnyPublisher<UVData, Error>
}

final class StandardUVWeatherService: UVWeatherService {
    
    private static let urlString = URL(string: "https://api.data.gov.sg/v1/environment/uv-index")!
    
    init() {}
    
    func fetchUV() -> AnyPublisher<UVData, Error> {
        return URLSession.shared.dataTaskPublisher(for: Self.urlString)
            .map(\.data)
            .decode(type: UVData.self, decoder: JSONDecoder.iso8601Decoder)
            .eraseToAnyPublisher()
    }
    
}
