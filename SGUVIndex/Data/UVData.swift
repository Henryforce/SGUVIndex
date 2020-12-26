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
    
    public init(items: [UVItem], apiInfo: APIInfo) {
        self.items = items
        self.apiInfo = apiInfo
    }

    enum CodingKeys: String, CodingKey {
        case items
        case apiInfo = "api_info"
    }
}

// MARK: - APIInfo
public struct APIInfo: Codable {
    public let status: String
    
    public init(status: String) {
        self.status = status
    }
}

extension APIInfo {
    static var healthy: APIInfo = {
        APIInfo(status: "healthy")
    }()
}

// MARK: - Item
public struct UVItem: Codable {
    public let timestamp: Date
    public let updateTimestamp: Date
    public let records: [UVDataRecord]
    
    public init(
        timestamp: Date,
        updateTimestamp: Date,
        records: [UVDataRecord]
    ) {
        self.timestamp = timestamp
        self.updateTimestamp = updateTimestamp
        self.records = records
    }

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
    
    public init(
        value: Int,
        timestamp: Date
    ) {
        self.value = value
        self.timestamp = timestamp
    }
}
