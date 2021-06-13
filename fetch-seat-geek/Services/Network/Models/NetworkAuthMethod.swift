//
//  NetworkAuthMethod.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

enum NetworkAuthMethod {
    /// Will add the key and value to the query parameters.
    case apiKey(key: String, value: String)
    /// Will add the user and password to the request.
    case basicAuth(user: String, password: String)
}
