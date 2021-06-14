//
//  SeatGeekRoutes.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import UIKit

enum SeatGeekRoutes: Route {
    private static var basePath: String {
        "https://api.seatgeek.com/2"
    }
    
    var path: String {
        switch self {
        case .events(let request):
            return request.path
        case .performers(let request):
            return request.path
        case .venues(let request):
            return request.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .events(let request):
            return request.method
        case .performers(let request):
            return request.method
        case .venues(let request):
            return request.method
        }
    }
    
    var headers: [URLQueryItem]? {
        switch self {
        case .events(let request):
            return request.headers
        case .performers(let request):
            return request.headers
        case .venues(let request):
            return request.headers
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .events(let request):
            return request.urlRequest
        case .performers(let request):
            return request.urlRequest
        case .venues(let request):
            return request.urlRequest
        }
    }
    
    var body: Data? {
        switch self {
        case .events(let request):
            return request.body
        case .performers(let request):
            return request.body
        case .venues(let request):
            return request.body
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .events(let request):
            return request.parameters
        case .performers(let request):
            return request.parameters
        case .venues(let request):
            return request.parameters
        }
    }
    
    case events(request: EventsRequest)
    case performers(request: PerformersRequest)
    case venues(request: VenuesRequest)
    
    enum EventsRequest: Route {
        var path: String {
            let base = "\(basePath)/events"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [String : String]? {
            switch self {
            case .all(let perPage, let page):
                return [
                    "per_page": "\(perPage)",
                    "page": "\(page)"
                ]
            default:
                return nil
            }
        }
        
        case all(perPage: Int, page: Int)
        case get(id: String)
    }
    enum PerformersRequest: Route {
        var path: String {
            let base = "\(basePath)/performers"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [String : String]? {
            switch self {
            case .all(let perPage, let page):
                return [
                    "per_page": "\(perPage)",
                    "page": "\(page)"
                ]
            default:
                return nil
            }
        }
        
        case all(perPage: Int, page: Int)
        case get(id: String)
    }
    enum VenuesRequest: Route {
        var path: String {
            let base = "\(basePath)/venues"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [String : String]? {
            switch self {
            case .all(let perPage, let page):
                return [
                    "per_page": "\(perPage)",
                    "page": "\(page)"
                ]
            default:
                return nil
            }
        }
        
        case all(perPage: Int, page: Int)
        case get(id: String)
    }
}
