//
//  MockCoreLogger.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
@testable import fetch_seat_geek

class CoreLoggerMock: CoreLogger {
    struct Log {
        var string: String
        var level: LogLevel
    }
    var logs: [Log] = []
    func log(_ string: String, logLevel: LogLevel) {
        logs.append(.init(string: string, level: logLevel))
    }
}
