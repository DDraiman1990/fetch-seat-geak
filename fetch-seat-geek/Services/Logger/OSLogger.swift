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
///
/// - Note
public final class OSLogger {
    
    // MARK: - Properties | Dependecies
    private var log: OSLog
    private var crashReporter: CrashReporter? = nil
    
    // MARK: - Properties | Configuration
    
    /// Whether OSLogger should log data to the given CrashReporter
    public var crashReporting: Bool = true
    
    /// Configures which metadata will be formatted into the log string.
    private var logFormat = LogFormat()
    
    // MARK: - Properties | Testing & Debug
    
    internal var lastLog: LogMetadata?
    internal var lastLogFormattedString: String?
    internal var lastIconString: String?
    internal var lastFileString: String?
    internal var lastLineString: String?
    internal var lastColumnString: String?
    internal var lastFunctionString: String?
    
    // MARK: - Lifecycle
    
    public init(category: String,
         crashReporter: CrashReporter? = nil) {
        let subsystem = Bundle.main.bundleIdentifier
            ?? "General Subsystem"
        log = OSLog(subsystem: subsystem, category: category)
        self.crashReporter = crashReporter
    }
    
    // MARK: - Logging
    
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
        lastLog = metadata
        let formattedObject = format(with: metadata)
        os_log("%@",
               log: log,
               type: metadata.logLevel.osLogLevel,
               formattedObject)
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
        
        lastIconString = iconString
        lastFileString = fileString
        lastLineString = lineString
        lastColumnString = columnString
        lastFunctionString = functionString
        lastLogFormattedString = formattedString
        
        return formattedString
    }
    
    // MARK: Private helpers
    
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
    private func logToCrashReporterIfNeeded(_ msg: StaticString,
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
    
    public static let stub: Logger = OSLogger(category: "stub")
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
    
    public func error(_ object: Any,
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
    
    public func error(_ error: Error, filename: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
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
    public func info(_ object: Any,
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
    public func debug(_ object: Any,
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
    public func fault(_ object: Any,
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
    public func `default`(_ object: Any,
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

