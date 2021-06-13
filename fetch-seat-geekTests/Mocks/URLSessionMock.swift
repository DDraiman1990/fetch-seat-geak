//
//  URLSessionMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

class URLSessionMock: URLSession {
    typealias OnComplete = (Data?, URLResponse?, Error?) -> Void

    var onUrl: ((URL) -> Void)?
    var onUrlRequest: ((URLRequest) -> Void)?
    
    var data: Data?
    var error: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping OnComplete
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = HTTPURLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil)
        onUrl?(url)
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping OnComplete
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = HTTPURLResponse(
            url: request.url ?? URL(string: "")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil)
        onUrlRequest?(request)
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let resumeCallback: () -> Void

    init(resumeCallback: @escaping () -> Void) {
        self.resumeCallback = resumeCallback
    }
    
    override func resume() {
        resumeCallback()
    }
}
