//
//  NetworkAuthPlugin.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

/// Will attach the required auth credentials, depending on the method, to
/// each request before it is made.
class NetworkAuthPlugin: NetworkPlugin {
    private let authMethod: NetworkAuthMethod
    func respond(to request: URLRequest) -> URLRequest {
        guard let originalUrl = request.url else {
            return request
        }
        var components = URLComponents(
            url: originalUrl,
            resolvingAgainstBaseURL: false)
        switch authMethod {
        case .apiKey(let key, let value):
            var queryItems = components?.queryItems ?? .init()
            queryItems.append(.init(name: key, value: value))
            components?.queryItems = queryItems
        case .basicAuth(let user, let password):
            components?.user = user
            components?.password = password
        }
        guard let url = components?.url else {
            return request
        }
        return URLRequest(url: url)
    }
    
    init(authMethod: NetworkAuthMethod) {
        self.authMethod = authMethod
    }
}
