//
//  SGEventStats.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGEventStats: Decodable {
    var listingCount: Int?
    var averagePrice: Int?
    var lowestPrice: Int?
    var highestPrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case listingCount = "listing_count"
        case averagePrice = "average_price"
        case lowestPrice = "lowest_price"
        case highestPrice = "highest_price"
    }
}
