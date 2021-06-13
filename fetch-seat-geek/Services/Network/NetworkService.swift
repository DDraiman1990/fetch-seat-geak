//
//  NetworkService.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation
import Combine

/// Simple networking service based on the most basic URLSession data tasks.
final class NetworkService: NetworkServicing {
    
    // MARK: - Properties | Dependencies
    
    private let session: URLSession
    private let plugins: [NetworkPlugin]
    
    // MARK: - Lifecycle
    
    init(session: URLSession,
         plugins: [NetworkPlugin]) {
        self.session = session
        self.plugins = plugins
    }
    
    // MARK: - Methods | Networking
    
    func makeRequest(route: Route) -> AnyPublisher<NetworkResult, Error> {
        return makeRequest(request: route.urlRequest)
    }
    
    func makeRequest(request: URLRequest) -> AnyPublisher<NetworkResult, Error> {
        var request = request
        plugins.forEach {
            request = $0.respond(to: request)
        }
        return Future<NetworkResult, Error> { [weak self] promise in
            self?.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let status = response as? HTTPURLResponse
                    let result = NetworkResult(response: status,
                                               data: data)
                    promise(.success(result))
                }
            }
            .resume()
        }
        .eraseToAnyPublisher()
    }
}
