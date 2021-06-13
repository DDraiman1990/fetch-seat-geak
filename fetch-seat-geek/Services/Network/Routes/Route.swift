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
    var parameters: [String: String]? { get }
}

extension Route {
    var urlRequest: URLRequest {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach {
            request.addValue($0.value ?? "", forHTTPHeaderField: $0.name)
        }
        return request
    }
}
