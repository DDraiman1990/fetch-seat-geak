//
//  DependencyManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

protocol DependencyManaging {}

final class DependencyManager: DependencyManaging {
    private let _logger: Logger = OSLogger(category: "fetch-seat-geak")
    private let apiKeysManager = APIKeysManager()
    private lazy var _networkService: NetworkServicing = NetworkService(
        session: .shared,
        plugins: [
            NetworkAuthPlugin.init(
                authMethod: .apiKey(
                    key: AppConstants.Keys.seatGeekClientIdParamName,
                    value: apiKeysManager.values[AppConstants.Keys.seatGeekStoredClientId] ?? "")),
            NetworkLoggerPlugin(logger: _logger)
        ])
        
    init() {
        let resolver = DependencyResolver.shared
        resolver.add(_logger)
        resolver.add(_networkService)
    }
}

