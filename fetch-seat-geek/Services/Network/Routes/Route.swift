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
        var components = URLComponents(string: path)
        components?.queryItems = parameters?.map {
            let (key, value) = $0
            return URLQueryItem(name: key, value: value)
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
