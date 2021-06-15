//
//  OSLogger.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import os
import Foundation

/// System logging for Swift using Apple's recommended log levels.
/// This logger is based on os_log.
public final class OSLogger {
    
    // MARK: - Properties | Dependecies
    
    private var core: CoreLogger
    private var crashReporter: CrashReporter? = nil
    
    // MARK: - Properties | Configuration
    
    /// Whether OSLogger should log data to the given CrashReporter
    public var crashReporting: Bool = true
    
    /// Configures which metadata will be formatted into the log string.
    private var logFormat = LogFormat()
    
    // MARK: - Lifecycle
    
    public init(
        core: CoreLogger,
        crashReporter: CrashReporter? = nil) {
        self.core = core
        self.crashReporter = crashReporter
    }
    
    // MARK: - Methods | Logging
    
    /// Logs messages to logging targets
    ///
    /// - Parameters:
    ///   - logLevel: the level to log to, by severity.
    ///   - object: object or message to be logged.
    ///   - filename: name of the file the logging was called from.
    ///   - line: line number, in file, the logging was called from.
    ///   - column: column number, in file, the logging was called from.
    ///   - function: name of function, in file, the logging was called from.
    private func log(_ metadata: LogMetadata) {
        let formattedObject = format(with: metadata)
        core.log(formattedObject, logLevel: metadata.logLevel)
        logToCrashReporterIfNeeded(
            "%@",
            formattedObject,
            logLevel: metadata.logLevel)
    }
    
    
    /// Will return a string formatted with the chosen LogFormat
    ///
    /// - Parameters:
    ///   - object: object to print.
    ///   - logLevel: the level of logging.
    ///   - filename: filename calling the log.
    ///   - line: line, in file, calling the log.
    ///   - column: column, in file, calling the log.
    ///   - function: function, in file, calling the log.
    /// - Returns: Formatted String.
    private func format(with metadata: LogMetadata) -> String {
        let iconString = logFormat.showIcons ?
            "[\(metadata.logLevel.icon)] " : ""
        let fileString = logFormat.showFilename ?
            "[\(sourceFileName(from: metadata.filename))] " : ""
        let lineString = logFormat.showLine ?
            "Line:\(metadata.line) " : ""
        let columnString = logFormat.showColumn ?
            "Column:\(metadata.column)" : ""
        let lineColumnString = logFormat.noFileLocation ?
            "" : "[\(lineString)\(columnString)] "
        let functionString = logFormat.showFunction ?
            "[\(metadata.function)]" : ""
        let metadataString = "\(iconString)\(fileString)\(lineColumnString)\(functionString)"
        let formattedString = "\(metadataString.isEmpty ? "" : metadataString + ": ")\(metadata.object)"
        return formattedString
    }
    
    // MARK: Methods | Helpers
    
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private func sourceFileName(from filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    /// Logs the formatted message to CrashReporter
    ///
    /// - Parameters:
    ///   - msg: message format to log.
    ///   - args: objects to be formatted into the message.
    private func logToCrashReporterIfNeeded(
        _ msg: StaticString,
        _ formattedString: String,
        logLevel: LogLevel) {
        if crashReporting {
            switch logLevel {
            case .default, .info:
                if let crashReporter = crashReporter {
                    if crashReporter.allowsInterpolatedStrings {
                        crashReporter.crashLog(formattedString)
                    } else {
                        crashReporter.crashLog(msg, formattedString)
                    }
                }
            default: break
            }
        }
    }
    
    /// Logs the given error to CrashReporter
    ///
    /// - Parameters:
    ///   - error: error to be logged.
    private func recordError(_ error: Error) {
        if crashReporting {
            crashReporter?.recordError(error)
        }
    }
}

// MARK: - OSLogger + Logger

extension OSLogger: Logger {
    public func set(userId: String?) {
        crashReporter?.set(userId: userId)
    }
    
    public func set(crashReporter: CrashReporter?) {
        self.crashReporter = crashReporter
    }
    
    public func set(format: LogFormat) {
        self.logFormat = format
    }
    
    public func error(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        let metadata = LogMetadata(
            object: object,
            logLevel: .error,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
    
    public func error(
        _ error: Error,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        recordError(error)
        let metadata = LogMetadata(
            object: error.localizedDescription,
            logLevel: .error,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
    public func info(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        let metadata = LogMetadata(
            object: object,
            logLevel: .info,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
    public func debug(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        let metadata = LogMetadata(
            object: object,
            logLevel: .debug,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
    public func fault(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        let metadata = LogMetadata(
            object: object,
            logLevel: .fault,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
    public func `default`(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        let metadata = LogMetadata(
            object: object,
            logLevel: .default,
            filename: filename,
            line: line,
            column: column,
            function: function)
        log(metadata)
    }
}

