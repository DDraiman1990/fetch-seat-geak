//
//  LogMetadata.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

struct LogMetadata {
    let object: Any
    let logLevel: LogLevel
    let filename: String
    let line: Int
    let column: Int
    let function: String
}
