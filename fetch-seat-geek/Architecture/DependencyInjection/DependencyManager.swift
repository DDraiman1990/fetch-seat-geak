//
//  DependencyManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

protocol DependencyManaging {}

final class DependencyManager: DependencyManaging {
    private let _logger: Logger = OSLogger(category: "fetch-seat-geak")
        
    init() {
        let resolver = DependencyResolver.shared
        resolver.add(_logger)
    }
}

