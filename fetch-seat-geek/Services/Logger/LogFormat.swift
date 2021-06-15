//
//  LogFormat.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

/// The configuration for what metadata will be displayed in the logged message.
public struct LogFormat {
    
    public init(
        showIcons: Bool = true,
        showFilename: Bool = true,
        showLine: Bool = true,
        showColumn: Bool = true,
        showFunction: Bool = true) {
        self.showIcons = showIcons
        self.showLine = showLine
        self.showFilename = showFilename
        self.showColumn = showColumn
        self.showFunction = showFunction
    }
    
    public init(allAs value: Bool) {
        self.showIcons = value
        self.showLine = value
        self.showFilename = value
        self.showColumn = value
        self.showFunction = value
    }
    
    var showIcons: Bool
    var showFilename: Bool
    var showLine: Bool
    var showColumn: Bool
    var showFunction: Bool
    
    /// If the location inside the file (line and column) are displayed in this
    /// format.
    var noFileLocation: Bool {
        return !showLine && !showColumn
    }
}
