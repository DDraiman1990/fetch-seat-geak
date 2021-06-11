//
//  Combine+CancelBag.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Combine
import Foundation

// MARK: - Combine CancelBag

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
