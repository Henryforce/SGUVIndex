//
//  MockURLSessionWrapper.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 2/1/21.
//

import Foundation
@testable import SGUVIndex

final class MockURLSessionWrapper: URLSessionWrapper {
    
    init() { }
    
    var dataTask: URLSessionDataTask?
    var dataTaskData: Data?
    var dataTaskUrlResponse: URLResponse?
    var dataTaskError: Error?
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        completionHandler(dataTaskData, dataTaskUrlResponse, dataTaskError)
        return dataTask ?? MockURLSessionDataTask()
    }
    
}
