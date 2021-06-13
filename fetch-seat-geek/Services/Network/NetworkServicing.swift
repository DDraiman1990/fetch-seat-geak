//
//  NetworkServicing.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
import Combine

/// Service capable of making network requests.
protocol NetworkServicing {
    func makeRequest(request: URLRequest) -> AnyPublisher<NetworkResult, Error>
    func makeRequest(route: Route) -> AnyPublisher<NetworkResult, Error>
}
