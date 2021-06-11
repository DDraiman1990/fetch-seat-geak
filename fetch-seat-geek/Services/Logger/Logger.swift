//
//  Logger.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

/// System logging for Swift using Apple's recommended log levels.
///
/// - Warning:
///     - Don't be tempted to wrap the metadata parameters (line, column, etc) in a struct to be able to minimize the amount of parameters. The logging metadata must be a top-level parameters to be injected from the calling class.
///     - Wrapping it will cause the metadata to be injected by the Logger itself, causing the data to become irrelevant.
public protocol Logger {
    
    func set(userId: String?)
    func set(crashReporter: CrashReporter?)
    func set(format: LogFormat)
    
    /// Logs a formatted message using the default log level.
    /// - Attention
    /// Use this level to capture information about things that might result a failure.
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func `default`(_ object: Any,
                   filename: String,
                   line: Int,
                   column: Int,
                   function: String)
    
    /// Logs a formatted message using the debug log level.
    /// - Attention
    /// Use this level if you feel this information may be useful during development or while troubleshooting a specific problem.
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func debug(_ object: Any,
               filename: String,
               line: Int,
               column: Int,
               function: String)
    
    /// Logs a formatted message using the info log level.
    /// - Attention
    /// Use this level to capture information that may be helpful, but isn’t essential, for troubleshooting errors.
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func info(_ object: Any,
              filename: String,
              line: Int,
              column: Int,
              function: String)
    
    /// Logs a formatted message using the error log level.
    /// - Attention
    /// Error-level messages are intended for reporting process-level errors.
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func error(_ object: Any,
               filename: String,
               line: Int,
               column: Int,
               function: String)
    
    /// Logs an error using the error log level.
    /// - Attention
    /// Error-level messages are intended for reporting process-level errors.
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func error(_ error: Error,
               filename: String,
               line: Int,
               column: Int,
               function: String)
    
    /// Logs a formatted message using the fault log level.
    /// - Attention
    /// Fault-level messages are intended for capturing system-level or multi-process errors only
    ///
    /// Read [Apple's documentation](https://developer.apple.com/documentation/os/logging#2878604) for the specifics about this level.
    ///
    /// - Parameters:
    ///   - object: the object to log.
    ///   - filename: filename the log was called from.
    ///   - line: line, in file, the log was called from.
    ///   - column: column, in file, the log was called from.
    ///   - function: function, in file, the log was called from.
    func fault(_ object: Any,
               filename: String,
               line: Int,
               column: Int,
               function: String)
}

extension Logger {
    func error(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               function: String = #function) {
        self.error(object,
                   filename: filename,
                   line: line,
                   column: column,
                   function: function)
    }
    
    func error(_ error: Error, filename: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        self.error(error,
                   filename: filename,
                   line: line,
                   column: column,
                   function: function)
    }
    func info(_ object: Any,
              filename: String = #file,
              line: Int = #line,
              column: Int = #column,
              function: String = #function) {
        self.info(object,
                  filename: filename,
                  line: line,
                  column: column,
                  function: function)
    }
    func debug(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               function: String = #function) {
        self.debug(object,
                   filename: filename,
                   line: line,
                   column: column,
                   function: function)
    }
    func fault(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               function: String = #function) {
        self.fault(object,
                   filename: filename,
                   line: line,
                   column: column,
                   function: function)
    }
    func `default`(_ object: Any,
                   filename: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   function: String = #function) {
        self.default(object,
                     filename: filename,
                     line: line,
                     column: column,
                     function: function)
        
    }
}
