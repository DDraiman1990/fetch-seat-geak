//
//  DatabaseInteractorMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/22/21.
//

import Foundation
import RxSwift
@testable import fetch_seat_geek

final class DatabaseInteractorMock: DatabaseInteracting {
    var throwError: Error?
    var returnValue: String = ""
    var storedData: Data?
    var getData: Data?
    
    init<T: Codable>(storedData: T?) {
        if let data = storedData {
            setStoredData(from: data)
        }
    }
    
    func setStoredData<T: Codable>(from model: T) {
        self.storedData = try? JSONEncoder().encode(model)
    }
    
    func store<T>(_ value: T, forKey key: String) throws where T : Decodable, T : Encodable {
        if let error = throwError {
            throw error
        }
        self.storedData = try? JSONEncoder().encode(value)
    }
    
    func get<T>(key: String) throws -> T where T : Decodable, T : Encodable {
        if let error = throwError {
            throw error
        }
        return try! JSONDecoder().decode(T.self, from: storedData!)
    }
}
