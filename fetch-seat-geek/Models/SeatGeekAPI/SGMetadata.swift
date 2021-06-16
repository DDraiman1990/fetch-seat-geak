//
//  SGMetadata.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGMetadata: Decodable {
    var total: Int
    var took: Int
    var page: Int
    var perPage: Int
    var geolocation: SGLocation?
    
    enum CodingKeys: String, CodingKey {
        case total, took, page, geolocation
        case perPage = "per_page"
    }
}
