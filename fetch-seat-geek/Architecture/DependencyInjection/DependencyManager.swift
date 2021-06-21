//
//  DependencyManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation
import OSLog

protocol DependencyManaging {}

final class DependencyManager: DependencyManaging {
    private let _logger: Logger = {
        let subsystem = Bundle.main.bundleIdentifier
            ?? "General Subsystem"
        let osLog = OSLog(
            subsystem: subsystem,
            category: AppConstants.Logs.category)
        let logger = OSLogger(core: osLog)
        logger.set(format: AppConstants.Logs.logFormat)
        return logger
    }()
    private let _databaseInteractor: DatabaseInteracting = DatabaseInteractor(suiteName: AppConstants.Database.suiteName)
    private let apiKeysManager = APIKeysManager()
    
    private lazy var _trackedManager: TrackedManaging = TrackedManager(databaseInteractor: _databaseInteractor)
    private lazy var _networkService: NetworkServicing = NetworkService(
        session: .shared,
        plugins: [
            NetworkAuthPlugin.init(
                authMethod: .apiKey(
                    key: AppConstants.Keys.seatGeekClientIdParamName,
                    value: apiKeysManager.values[AppConstants.Keys.seatGeekStoredClientId] ?? "")),
            NetworkLoggerPlugin(logger: _logger)
        ])
    private lazy var _seatGeekInteractor = SeatGeekInteractor(
        networkService: _networkService,
        logger: _logger)
        
    init() {
        let resolver = DependencyResolver.shared
        resolver.add(_logger)
        resolver.add(_networkService)
        resolver.add(_seatGeekInteractor)
        resolver.add(_databaseInteractor)
        resolver.add(_trackedManager)
    }
}

