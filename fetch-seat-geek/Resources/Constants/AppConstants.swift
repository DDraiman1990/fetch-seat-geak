//
//  AppConstants.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

enum AppConstants {
    enum Keys {
        static let seatGeekStoredClientId = "seat-geek-client"
        static let seatGeekClientIdParamName = "client_id"
    }
    
    enum Logs {
        static let category = "fetch-seat-geak"
        static let logFormat = LogFormat()
    }
}
