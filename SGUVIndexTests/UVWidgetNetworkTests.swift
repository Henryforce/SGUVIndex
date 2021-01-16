//
//  SGWeatherTests.swift
//  SGWeatherTests
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import XCTest
@testable import SGUVIndex

final class UVWidgetNetworkTests: XCTestCase {

    private var userDefaults: MockUserDefaultsManager!
    private var urlSession: MockURLSessionWrapper!
    
    override func setUpWithError() throws {
        userDefaults = MockUserDefaultsManager()
        urlSession = MockURLSessionWrapper()
    }

    override func tearDownWithError() throws {
        userDefaults = nil
        urlSession = nil
    }

    func testGetDataReturnsValidDataOnSuccessfulDataTask() throws {
        // Given
        let expectedUVIndex = UVIndex.low(.zero)
        let dataTask = MockURLSessionDataTask()
        let emptyItemsData = validSingleItem.data(using: .utf8)
        let currentDate = Date(timeIntervalSince1970: 1609560195) // 2021-01-02 04:03:15 +0000
        urlSession.dataTask = dataTask
        urlSession.dataTaskData = emptyItemsData
        var resultData: [UVWidgetData]?
        
        // When
        UVWidgetNetwork.getData(
            currentDate: currentDate,
            userDefaults: userDefaults,
            urlSession: urlSession
        ) { (data, date) in
            resultData = data
        }
        
        // Then
        XCTAssertEqual(dataTask.resumeWasCalledCount, 1)
        XCTAssertEqual(resultData!.first!.uvValue, String(expectedUVIndex.index()))
        XCTAssertEqual(resultData!.first!.uvDescription, expectedUVIndex.name())
    }
    
    func testGetDataReturnsPreviewDataOnErrorDataTask() throws {
        // Given
        let dataTask = MockURLSessionDataTask()
        urlSession.dataTask = dataTask
        urlSession.dataTaskError = APIError.unknown
        let currentDate = Date(timeIntervalSince1970: 1609588799) // 2021-01-02T11:59:59+00:00
        var resultData: [UVWidgetData]?
        
        // When
        UVWidgetNetwork.getData(
            currentDate: currentDate,
            userDefaults: userDefaults,
            urlSession: urlSession
        ) { (data, date) in
            resultData = data
        }
        
        // Then
        XCTAssertEqual(dataTask.resumeWasCalledCount, 1)
        XCTAssertEqual(resultData!.first!.uvValue, "-")
        XCTAssertEqual(resultData!.first!.uvDescription, "")
    }
    
    func testGetDataReturnsPreviewDataInACallMadeAfterAvailableHours() throws {
        // Given
        let dataTask = MockURLSessionDataTask()
        urlSession.dataTask = dataTask
        urlSession.dataTaskError = APIError.unknown
        let currentDate = Date(timeIntervalSince1970: 1609588800) // 2021-01-02T12:00:00+00:00 , 12PM UTC, 8PM SGT is the current cutoff time for the last UV retrieval
        var resultData: [UVWidgetData]?
        
        // When
        UVWidgetNetwork.getData(
            currentDate: currentDate,
            userDefaults: userDefaults,
            urlSession: urlSession
        ) { (data, date) in
            resultData = data
        }
        
        // Then
        XCTAssertEqual(dataTask.resumeWasCalledCount, .zero)
        XCTAssertEqual(resultData!.first!.uvValue, "-")
        XCTAssertEqual(resultData!.first!.uvDescription, "")
    }

}

extension UVWidgetNetworkTests {
    var emptyItems: String {
        """
        {
            "items": [
              {}
            ],
            "api_info": {
              "status": "healthy"
            }
        }
        """
    }
    
    var validSingleItem: String {
        """
        {
          "items": [
            {
              "timestamp": "2021-01-02T15:00:00+08:00",
              "update_timestamp": "2021-01-02T15:05:07+08:00",
              "index": [
                {
                  "value": 0,
                  "timestamp": "2021-01-02T15:00:00+08:00"
                }
              ]
            }
          ],
          "api_info": {
            "status": "healthy"
          }
        }
        """
    }
}
