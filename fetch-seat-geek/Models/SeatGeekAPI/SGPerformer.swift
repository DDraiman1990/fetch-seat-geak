//
//  SGPerformer.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation

struct SGPerformerSummary: Hashable, IdentifiableItem {
    var id: Int
    var name: String
    var shortName: String
    var image: String
    var hasUpcomingEvents: Bool
}

struct SGPerformer: Decodable, Hashable {
    var name: String
    var shortName: String
    var url: String
    var image: String
    var images: SGPerformerImages
    var score: Float
    var slug: String
    var taxonomies: [SGTaxonomy]
    var id: Int
    var hasUpcomingEvents: Bool
    var links: [SGLink]?
    var genres: [SGGenre]?
    
    enum CodingKeys: String, CodingKey {
        case name, url, image, images, score, slug, taxonomies, id, links, genres
        case shortName = "short_name"
        case hasUpcomingEvents = "has_upcoming_events"
    }
    
    var toSummary: SGPerformerSummary {
        return .init(
            id: id,
            name: name,
            shortName: shortName,
            image: image,
            hasUpcomingEvents: hasUpcomingEvents)
    }
}
