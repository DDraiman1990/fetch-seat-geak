//
//  SGVenue.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SGVenue: Decodable {
    var name: String
    var address: String
    var extendedAddress: String?
    var city: String?
    var postalCode: String?
    var state: String?
    var country: String?
    var location: SGLocation
    var url: String
    var score: Float
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case name, address, city, state, country, location, url, score, id
        case extendedAddress = "extended_address"
        case postalCode = "postal_code"
    }
}
