//
//  URLSessionWrapper.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 2/1/21.
//

import Foundation

protocol URLSessionWrapper {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

final class StandardURLSessionWrapper: URLSessionWrapper {
    
    private let urlSession: URLSession
    
    init(
        urlSession: URLSession
    ) {
        self.urlSession = urlSession
    }
    
    convenience init() {
        let urlSession = URLSession(configuration: .default)
        self.init(urlSession: urlSession)
    }
    
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        urlSession.dataTask(
            with: url,
            completionHandler: completionHandler
        )
    }
    
}
