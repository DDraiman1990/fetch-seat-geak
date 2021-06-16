//
//  ModelUpdate.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import RxSwift
import UIKit

/// Any change to the model will invoke this update.
struct ModelUpdate<T: DataModel>: Equatable {
    var oldValue: T?
    var newValue: T
}

extension Observable where Element: DataModel {
    func toModelUpdate() -> Observable<ModelUpdate<Element>> {
        return self
            .distinctUntilChanged()
            .scan((nil, Element())) { ($0.1, $1) }
            .map {
                return ModelUpdate(oldValue: $0.0, newValue: $0.1)
            }
            .asObservable()
    }
}
