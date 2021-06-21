//
//  SGVenue.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SGVenue: Decodable, Hashable {
    var name: String
    var nameV2: String
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
    var links: [SGLink]
    var timezone: String
    var hasUpcomingEvents: Bool
    var numOfUpcomingEvents: Int
    var slug: String
    var popularity: Int
    var capacity: Int
    var displayLocation: String
    
    var fullAddress: String {
        if let extended = self.extendedAddress {
            return "\(address), \(extended)"
        }
        return address
    }

    enum CodingKeys: String, CodingKey {
        case name, address, city, state, country, location, url, score, id
        case links, timezone, slug, popularity, capacity
        case extendedAddress = "extended_address"
        case postalCode = "postal_code"
        case nameV2 = "name_v2"
        case hasUpcomingEvents = "has_upcoming_events"
        case numOfUpcomingEvents = "num_upcoming_events"
        case displayLocation = "display_location"
    }
}
