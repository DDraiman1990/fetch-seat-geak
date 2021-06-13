//
//  NetworkPlugin.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

/// A middleware for each network request.
protocol NetworkPlugin {
    func respond(to request: URLRequest) -> URLRequest
}
