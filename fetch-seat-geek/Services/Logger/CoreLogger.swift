//
//  CoreLogger.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
import OSLog

public protocol CoreLogger {
    func log(_ string: String, logLevel: LogLevel)
}

extension OSLog: CoreLogger {
    public func log(_ string: String, logLevel: LogLevel) {
        os_log(
            "%@",
            log: self,
            type: logLevel.osLogLevel,
            string)
    }
}
