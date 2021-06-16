//
//  NetworkServicing.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
import RxSwift

/// Service capable of making network requests.
protocol NetworkServicing {
    func makeRequest(request: URLRequest) -> Observable<NetworkResult>
    func makeRequest(route: Route) -> Observable<NetworkResult>
}
