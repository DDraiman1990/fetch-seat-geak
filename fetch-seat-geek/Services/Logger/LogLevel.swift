//
//  LogLevel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation
import os

public enum LogLevel: String {
    case `default`, info, debug, error, fault
    
    var osLogLevel: OSLogType {
        switch self {
        case .default: return .default
        case .info: return .info
        case .debug: return .debug
        case .error: return .error
        case .fault: return .fault
        }
    }
    
    var icon: String {
        switch self {
        case .default: return "đ"
        case .info: return "âšī¸"
        case .debug: return "đ"
        case .error: return "â ī¸"
        case .fault: return "đĨ"
        }
    }
}
