//
//  Array+ValidIndex.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import Foundation

extension Array {
    func isValidIndex(_ index: Int) -> Bool {
        return indices ~= index
    }
    
    func elementIfExists(index: Int) -> Element? {
        guard isValidIndex(index) else {
            return nil
        }
        return self[index]
    }
}
