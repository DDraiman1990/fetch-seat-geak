//
//  LoggerMock.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
@testable import fetch_seat_geek

struct LogEvent {
    let level: LogLevel
    var object: Any
    var filename: String
    var line: Int
    var column: Int
    var function: String
}

class LoggerMock: Logger {
    var userId: String?
    var crashReporter: CrashReporter?
    var format: LogFormat = .init()
    var logs: [LogEvent] = []
    
    func set(userId: String?) {
        self.userId = userId
    }
    
    func set(crashReporter: CrashReporter?) {
        self.crashReporter = crashReporter
    }
    
    func set(format: LogFormat) {
        self.format = format
    }
    
    func `default`(
        _ object: Any,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .default,
                        object: object,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
    
    func debug(
        _ object: Any,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .debug,
                        object: object,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
    
    func error(
        _ error: Error,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .error,
                        object: error.localizedDescription,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
    
    func error(
        _ object: Any,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .error,
                        object: object,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
    
    func fault(
        _ object: Any,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .fault,
                        object: object,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
    
    func info(
        _ object: Any,
        filename: String,
        line: Int,
        column: Int,
        function: String) {
        logs.append(.init(
                        level: .info,
                        object: object,
                        filename: filename,
                        line: line,
                        column: column,
                        function: function))
    }
}

struct LoggedArgedCrashed {
    var message: StaticString
    var args: [CVarArg]
}

class CrashReporterMock: CrashReporter {
    var allowsInterpolatedStrings: Bool = false
    var argCrashesLogged: [LoggedArgedCrashed] = []
    var crashesLogged: [String] = []
    var errorsRecorded: [Error] = []
    var userId: String?
    
    func crashLog(_ message: StaticString,
                  _ args: CVarArg...) {
        argCrashesLogged.append(.init(message: message, args: args))
    }

    func crashLog(_ message: String) {
        crashesLogged.append(message)
    }

    func recordError(_ error: Error) {
        errorsRecorded.append(error)
    }
    
    func set(userId: String?) {
        self.userId = userId
    }
}
