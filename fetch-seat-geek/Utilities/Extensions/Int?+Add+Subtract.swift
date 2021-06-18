//
//  Dictionary+Add+Subtract.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/17/21.
//

import Foundation

extension Optional where Wrapped == Int {
    func add(value: Int) -> Int {
        return (self ?? 0) + value
    }
    
    func subtract(value: Int, maxValue: Int? = nil) -> Int {
        let result = (self ?? 0) - value
        if let maxValue = maxValue {
            return max(maxValue, result)
        }
        return result
    }
}
