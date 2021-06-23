//
//  DatabaseInteractorMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/22/21.
//

import Foundation
import RxSwift
@testable import fetch_seat_geek

//
//final class DatabaseInteractorMock: DatabaseInteracting {
//    var throwError: Error?
//    var returnValue: String = ""
//    var storedValue: Any?
//    var getValue: Any?
//
//    func store<T>(_ value: T, forKey key: String) throws where T : Decodable, T : Encodable {
//        if let error = throwError {
//            throw error
//        }
//        self.storedValue = value
//    }
//
//    func get<T>(key: String) throws -> T where T : Decodable, T : Encodable {
//        if let error = throwError {
//            throw error
//        }
//        return T.init(from: MockDecoder())
//    }
//}
