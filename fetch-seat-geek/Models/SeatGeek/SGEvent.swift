//
//  SeatGeekEvent.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SGEvent: Decodable {
    var stats: SGEventStats
    var title: String
    var url: String
    var datetimeLocal: Date
    var datetimeUtc: Date
    var announceDate: Date
    var visibleUntil: Date
    var timeTbd: Bool
    var dateTbd: Bool
    var performers: [SGPerformer]
    var venue: SGVenue
    var shortTitle: String
    var score: Float
    var taxonomies: [SGTaxonomy]
    var links: [SGLink]?
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
