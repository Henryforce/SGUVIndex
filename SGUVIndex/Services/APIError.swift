//
//  APIError.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 2/1/21.
//

import Foundation

public enum APIError: Error {
    case noNetwork
    case invalid
    case empty
    case outdated
    case unknown
}
