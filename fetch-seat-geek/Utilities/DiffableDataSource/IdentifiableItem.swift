//
//  IdentifiableItem.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import Foundation

/// iOS 12 friendly Identifiable
protocol IdentifiableItem: Hashable {
    associatedtype IDType: Hashable
    var id: IDType { get }
}
