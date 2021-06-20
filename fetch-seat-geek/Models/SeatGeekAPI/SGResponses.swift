//
//  SeatGeekResponses.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SGEventsResponse: Decodable {
    var events: [SGEvent]
    var meta: SGMetadata
}
struct SGPerformersResponse: Decodable {
    var performers: [SGPerformer]
    var meta: SGMetadata
}
struct SGVenuesResponse: Decodable {
    var venues: [SGVenue]
    var meta: SGMetadata
}

struct SGGenresResponse: Decodable {
    var genres: [SGGenre]
    var meta: SGMetadata
}

struct SGBrowseGenresResponse {
    var genres: [(String, [SGEvent])]
}
