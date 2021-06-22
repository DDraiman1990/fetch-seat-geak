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
    
    init(suiteName: String) {
        self.defaults = UserDefaults(suiteName: suiteName) ?? .standard
    }
    
    func store<T: Codable>(_ value: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        defaults.setValue(data, forKey: key)
    }
    
    func get<T: Codable>(key: String) throws -> T {
        guard let value = defaults.value(forKey: key) else {
            throw DatabaseError.noValue
        }
        guard let data = value as? Data else {
            throw DatabaseError.loadedItemNotStorable
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
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
