//
//  UVData.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import Foundation

// MARK: - Welcome
public struct UVData: Codable {
    public let items: [UVItem]
    public let apiInfo: APIInfo

    enum CodingKeys: String, CodingKey {
        case items
        case apiInfo = "api_info"
    }
}

// MARK: - APIInfo
public struct APIInfo: Codable {
    public let status: String
}

// MARK: - Item
public struct UVItem: Codable {
    public let timestamp: Date
    public let updateTimestamp: Date
    public let records: [UVDataRecord]

    enum CodingKeys: String, CodingKey {
        case timestamp
        case updateTimestamp = "update_timestamp"
        case records = "index"
    }
}

// MARK: - Index
public struct UVDataRecord: Codable {
    public let value: Int
    public let timestamp: Date
}
