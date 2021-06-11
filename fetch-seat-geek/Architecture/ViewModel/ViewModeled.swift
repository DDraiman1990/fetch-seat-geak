//
//  ViewModeled.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation

/// An object expecting to be modeled by a view model
protocol ViewModeled {
    associatedtype Model: DataModel
    associatedtype Update = Any?
    associatedtype Interaction
}

/// Simply a protocol to wrap model data for ViewModel and require an empty
/// state.
protocol DataModel: Equatable {
    init()
}
