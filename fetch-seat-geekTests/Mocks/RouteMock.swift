//
//  RouteMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
@testable import fetch_seat_geek

struct GenericRoute: Route {
    var path: String
    var method: HTTPMethod
    var body: Data?
    var headers: [URLQueryItem]?
    var parameters: [RouteParameter]?
    
    static var stub: Route {
        return GenericRoute(
            path: "https://www.someroute.sr",
            method: .get,
            body: nil,
            headers: [Headers.json],
            parameters: nil)
    }
}
