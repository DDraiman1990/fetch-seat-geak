//
//  SeatGeekRoutes.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import UIKit

enum NetworkConstants {
    enum Headers {
        static let json = ["Content-Type": "application/json"]
    }
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol Route {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

enum SeatGeekRoutes: Route {
    var path: String {
        let base = "https://api.seatgeek.com/2"
        switch self {
        case .events(let request):
            return "\(base)/\(request.path)"
        case .performers(let request):
            return "\(base)/\(request.path)"
        case .venues(let request):
            return "\(base)/\(request.path)"
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
    
    var headers: [String : String]? {
        switch self {
        case .events(let request):
            return request.headers
        case .performers(let request):
            return request.headers
        case .venues(let request):
            return request.headers
        }
    }
    
    case events(request: EventsRequest)
    case performers(request: PerformersRequest)
    case venues(request: VenuesRequest)
    
    enum EventsRequest: Route {
        var path: String {
            let base = "events"
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
        
        var headers: [String : String]? {
            return NetworkConstants.Headers.json
        }
        
        case all
        case get(id: String)
    }
    enum PerformersRequest: Route {
        var path: String {
            let base = "performers"
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
        
        var headers: [String : String]? {
            return NetworkConstants.Headers.json
        }
        
        case all
        case get(id: String)
    }
    enum VenuesRequest: Route {
        var path: String {
            let base = "venues"
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
        
        var headers: [String : String]? {
            return NetworkConstants.Headers.json
        }
        
        case all
        case get(id: String)
    }
}
