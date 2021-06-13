//
//  NetworkLoggerPlugin.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

/// Will log the url of each request.
class NetworkLoggerPlugin: NetworkPlugin {
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func respond(to request: URLRequest) -> URLRequest {
        guard let url = request.url else {
            return request
        }
        let urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false)
        logger.info(String(describing: urlComponents))
        return request
    }
}
