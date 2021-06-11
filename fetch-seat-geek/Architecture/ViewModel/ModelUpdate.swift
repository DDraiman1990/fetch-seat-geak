//
//  ModelUpdate.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import Combine
import UIKit

/// Any change to the model will invoke this update.
struct ModelUpdate<T: DataModel>: Equatable {
    var oldValue: T?
    var newValue: T
}

extension Publisher where Output: DataModel, Failure == Never {
    func toModelUpdate() -> AnyPublisher<ModelUpdate<Output>, Never> {
        return self
            .removeDuplicates()
            .scan((nil, Output())) {
                ($0.1, $1)
            }
            .map { tuple in
                return ModelUpdate(oldValue: tuple.0, newValue: tuple.1)
            }
            .eraseToAnyPublisher()
    }
}
