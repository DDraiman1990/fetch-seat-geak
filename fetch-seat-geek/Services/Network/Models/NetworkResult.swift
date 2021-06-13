//
//  NetworkResult.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

/// HTTP Request result
struct NetworkResult {
    let httpStatusCode: Int?
    let data: Data?
}
