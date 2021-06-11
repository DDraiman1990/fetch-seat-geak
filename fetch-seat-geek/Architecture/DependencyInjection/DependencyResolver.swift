//
//  DependencyResolver.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import Foundation

protocol DependencyResolving {
    func add<T>(_ injectable: T)
    func resolve<T>() -> T
    
    static var shared: DependencyResolving { get }
}

class DependencyResolver: DependencyResolving {
    
    private var storage = [Any]()
    static let shared: DependencyResolving = DependencyResolver()
    private init() {}
    
    func add<T>(_ injectable: T) {
        storage.append(injectable)
    }

    func resolve<T>() -> T {
        guard let match = storage
                .filter({ ($0 as? T) != nil})
                .first as? T else {
            fatalError("\(T.self) has not been added as an injectable object.")
        }
        return match
    }
}

