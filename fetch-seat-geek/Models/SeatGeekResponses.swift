//
//  SeatGeekResponses.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SeatGeekEventsResponse: Decodable {
    var events: [SeatGeekEvent]
    var meta: SeatGeekMetadata
}

struct SeatGeekPerformersResponse: Decodable {
    var performers: [SeatGeekPerformer]
    var meta: SeatGeekMetadata
}

struct SeatGeekVenuesResponse: Decodable {
    var venues: [SeatGeekVenue]
    var meta: SeatGeekMetadata
}

