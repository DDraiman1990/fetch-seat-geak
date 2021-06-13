//
//  FileHelper.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

enum FileHelper {
    static func readPlist(path: String?) -> NSDictionary? {
        guard let path = path else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }
}
