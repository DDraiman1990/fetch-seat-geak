//
//  Comparable+Clamp.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/17/21.
//

import Foundation

extension Comparable {
    func clamp(lower: Self, upper: Self) -> Self {
        return min(upper, max(lower, self))
    }
}
