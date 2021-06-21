//
//  Route.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

protocol Route {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [URLQueryItem]? { get }
    var urlRequest: URLRequest { get }
    var parameters: [RouteParameter]? { get }
}

struct RouteParameter: Equatable {
    var name: String
    var value: String
}

extension Route {
    var urlRequest: URLRequest {
        var components = URLComponents(string: path)
        components?.queryItems = parameters?.map {
            return URLQueryItem(name: $0.name, value: $0.value)
        }
        let url = components?.url
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach {
            request.addValue($0.value ?? "", forHTTPHeaderField: $0.name)
        }
        return request
    }
}
