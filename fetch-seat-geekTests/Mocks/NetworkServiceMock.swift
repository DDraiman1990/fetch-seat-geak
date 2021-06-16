//
//  NetworkServiceMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
import RxSwift
@testable import fetch_seat_geek

class NetworkServiceMock: NetworkServicing {
    enum FakeResponse {
        case error(error: Error)
        case success(result: NetworkResult)
    }
    var responseToSend: FakeResponse = .error(error: NSError())
    
    private func response() -> Observable<NetworkResult> {
        switch responseToSend {
        case .error(let error):
            return Observable.error(error)
        case .success(let result):
            return Observable.just(result)
        }
    }
    
    func makeRequest(request: URLRequest) -> Observable<NetworkResult> {
        response()
    }
    
    func makeRequest(route: Route) -> Observable<NetworkResult> {
        response()
    }
}
