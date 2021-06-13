//
//  Dictionary+Merge.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/12/21.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    func combine(with dict: [Key: Value]) -> [Key: Value] {
        var copy = self
        copy.merge(dict: dict)
        return copy
    }
}
