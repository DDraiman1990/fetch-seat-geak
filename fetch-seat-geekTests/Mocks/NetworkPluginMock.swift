//
//  NetworkPluginMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
@testable import fetch_seat_geek

class NetworkPluginMock: NetworkPlugin {
    var onRespondingToRequest: (URLRequest) -> URLRequest
    
    init(onRespond: @escaping (URLRequest) -> URLRequest) {
        self.onRespondingToRequest = onRespond
    }
    
    func respond(to request: URLRequest) -> URLRequest {
        return onRespondingToRequest(request)
    }
}
