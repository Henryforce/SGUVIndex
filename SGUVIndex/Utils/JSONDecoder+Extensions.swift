//
//  JSONDecoder+Extensions.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 31/12/20.
//

import Foundation

extension JSONDecoder {
    static var iso8601Decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension JSONEncoder {
    static var iso8601Encoder: JSONEncoder {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .iso8601
        return decoder
    }
}
