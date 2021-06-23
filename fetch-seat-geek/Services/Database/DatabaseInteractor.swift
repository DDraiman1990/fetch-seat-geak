//
//  DatabaseInteractor.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import Foundation

protocol DatabaseInteracting {
    func store<T: Codable>(_ value: T, forKey key: String) throws
    func get<T: Codable>(key: String) throws -> T
}

final class DatabaseInteractor: DatabaseInteracting {
    private let defaults: UserDefaults
    private let logger: Logger
    
    init(suiteName: String?,
         logger: Logger) {
        self.logger = logger
        if let name = suiteName,
           let defaults = UserDefaults(suiteName: name) {
            logger.debug("Initialized DatabaseInteractor with suiteName \(name)")
            self.defaults = defaults
        } else {
            self.defaults = .standard
            logger.debug("Initialized DatabaseInteractor with standard")
        }
    }
    
    func store<T: Codable>(_ value: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        defaults.setValue(data, forKey: key)
        logger.debug("Stored \(value) for key \(key)")
    }
    
    func get<T: Codable>(key: String) throws -> T {
        guard let value = defaults.value(forKey: key) else {
            throw DatabaseError.noValue
        }
        guard let data = value as? Data else {
            throw DatabaseError.loadedItemNotStorable
        }
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        logger.debug("Fetched decoded value for key \(key) is \(decoded)")
        return decoded
    }
}

enum DatabaseError: LocalizedError {
    case loadedItemNotStorable
    case noValue
    var errorDescription: String? {
        switch self {
        case .noValue:
            return R.string.services.database_error_no_value()
        case .loadedItemNotStorable:
            return R.string.services.database_error_not_storable()
        }
    }
}
