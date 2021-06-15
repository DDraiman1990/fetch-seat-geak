//
//  NetworkResultBuilder.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
import UIKit
@testable import fetch_seat_geek

class NetworkResultBuilder {
    var responseFileName: String?
    var url: URL?
    
    private func readFile(named: String) -> Data? {
        guard let path = Bundle(for: type(of: self))
                .path(forResource: named, ofType: "json") else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
    
    func build() -> NetworkResult? {
        guard let url = self.url,
              let filename = responseFileName else {
            return nil
        }
        let response = HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        return NetworkResult(response: response, data: readFile(named: filename))
    }
}
