//
//  NetworkServiceMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
import Combine
@testable import fetch_seat_geek

class NetworkServiceMock: NetworkServicing {
    enum FakeResponse {
        case error(error: Error)
        case success(result: NetworkResult)
    }
    var responseToSend: FakeResponse = .error(error: NSError())
    
    private func response() -> AnyPublisher<NetworkResult, Error> {
        switch responseToSend {
        case .error(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .success(let result):
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func makeRequest(request: URLRequest) -> AnyPublisher<NetworkResult, Error> {
        response()
    }
    
    func makeRequest(route: Route) -> AnyPublisher<NetworkResult, Error> {
        response()
    }
}
