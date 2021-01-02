//
//  MockURLSessionDataTask.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 2/1/21.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    
    var resumeWasCalledCount = 0
    override func resume() {
        resumeWasCalledCount += 1
    }
}
