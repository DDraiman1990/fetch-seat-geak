//
//  SeatGeekEvent.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
import CoreLocation

struct SeatGeekEvent: Decodable {
    var stats: EventStats
    var title: String
    var url: String
    var datetimeLocal: Date
    var datetimeUtc: Date
    var announceDate: Date
    var visibleUntil: Date
    var timeTbd: Bool
    var dateTbd: Bool
    var performers: [SeatGeekPerformer]
    var venue: SeatGeekVenue
    var shortTitle: String
    var score: Float
    var taxonomies: [EventTaxonomy]
    var links: [SeatGeekLink]?
    var type: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case stats, title, url, performers, venue, score, taxonomies, type, id
        case shortTitle = "short_title"
        case datetimeLocal = "datetime_local"
        case datetimeUtc = "datetime_utc"
        case announceDate = "announce_date"
        case visibleUntil = "visible_until_utc"
        case timeTbd = "time_tbd"
        case dateTbd = "date_tbd"
    }
}

struct SeatGeekPerformer: Decodable {
    var name: String
    var shortName: String
    var url: String
    var image: String
    var images: PerformerImages
    var score: Float
    var slug: String
    var taxonomies: [EventTaxonomy]
    var id: Int
    var hasUpcomingEvents: Bool
    var links: [SeatGeekLink]?
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case name, url, image, images, score, slug, taxonomies, id, links, genres
        case shortName = "short_name"
        case hasUpcomingEvents = "has_upcoming_events"
    }
}

struct SeatGeekVenue: Decodable {
    var name: String
    var address: String
    var extendedAddress: String?
    var city: String?
    var postalCode: String?
    var state: String?
    var country: String?
    var location: SeatGeekLocation
    var url: String
    var score: Float
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case name, address, city, state, country, location, url, score, id
        case extendedAddress = "extended_address"
        case postalCode = "postal_code"
    }
}

struct SeatGeekLocation: Decodable {
    var lat: Double
    var lon: Double
    
    var toLocation: CLLocationCoordinate2D {
        return .init(latitude: lat, longitude: lon)
    }
}

struct SeatGeekLink: Decodable {
    var id: Int?
    var provider: String
    var url: String
}

struct PerformerImages: Decodable {
    var large: String?
    var huge: String?
    var small: String?
    var medium: String?
}

struct EventStats: Decodable {
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

struct EventTaxonomy: Decodable {
    var name: String
    var id: Int?
    var parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case parentId = "parent_id"
    }
}

struct SeatGeekMetadata: Decodable {
    var total: Int
    var took: Int
    var page: Int
    var perPage: Int
    var geolocation: SeatGeekLocation?
    
    enum CodingKeys: String, CodingKey {
        case total, took, page, geolocation
        case perPage = "per_page"
    }
}

struct Genre: Decodable {
    var id: Int
    var name: String?
    var slug: String
    var image: String?
}
