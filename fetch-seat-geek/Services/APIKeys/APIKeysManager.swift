//
//  APIKeysManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/12/21.
//

import Foundation

protocol APIKeysManaging {
    var values: [String: String] { get }
}

final class APIKeysManager: APIKeysManaging {
    
    // MARK: - Properties
    
    private let keys: [String: String]
    var values: [String : String] {
        return keys
    }
    
    // MARK: - Lifecycle
    
    init() {
        guard let keys = FileHelper
                .readPlist(path: R.file.apiKeysPlist()?.path) as? [String: String] else {
            fatalError("Failed to get required API keys. Contact developer to acquire plist file")
        }
        self.keys = keys
    }
}
