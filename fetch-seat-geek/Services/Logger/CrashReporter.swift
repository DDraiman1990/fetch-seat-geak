//
//  CrashReporter.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

/// Represents a service tracking errors and logs related to crashes.
public protocol CrashReporter {
    
    var allowsInterpolatedStrings: Bool { get }
    
    /// Will create a log with the context of a crash.
    ///
    /// - Parameters:
    ///   - message: The message we want to pass with the format we want.
    ///   - args: the variables we wish to be formatted into our message.
    /// - Warning: message using string interpolation will not work properly.
    func crashLog(_ message: StaticString,
                  _ args: CVarArg...)
    
    /// Will create a log with the context of a crash.
    ///
    /// - Parameters:
    ///   - message: The interpolated string message we want to pass.
    func crashLog(_ message: String)
    
    /// Will log and record the given error
    ///
    /// - Parameter error: error we want to log.
    func recordError(_ error: Error)
    
    func set(userId: String?)
}
