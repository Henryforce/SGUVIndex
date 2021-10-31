//
//  UVWeatherServiceTests.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 31/10/21.
//

import XCTest
@testable import SGUVIndex

final class UVWeatherServiceTests: XCTestCase {

    private var sut: StandardUVWeatherService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: sessionConfiguration)
        sut = StandardUVWeatherService(session: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
    }

    func testFetchReturnValidSortedValues() async throws {
        // Given
        let url = URL(string: StandardUVWeatherService.urlString)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = try JSONEncoder.iso8601Encoder.encode(UVData.mock)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        // When
        let uvData = try await sut.fetchUV()

        // Then
        XCTAssertEqual(uvData.items.first?.records.first?.value, 11)
        XCTAssertEqual(uvData.items.first?.records.last?.value, 0)
    }

}

extension UVData {
    static let mock = UVData(
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
}
