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
    
    static func stub() -> SGPerformerSummary {
        let firstName = (Bool.random() ? "Justin" : "Dodo") + "\(Int.random(in: 1...1000))"
        let lastName = (Bool.random() ? "Bieber" : "Gomez") + "\(Int.random(in: 1...1000))"
        return .init(
            id: Int.random(in: 1...100000),
            name: "\(firstName) \(lastName)",
            shortName: firstName,
            image: "https://seatgeek.com/images/performers-landscape/bad-bunny-7b9cd4/616548/huge.jpg",
            hasUpcomingEvents: Bool.random())
    }
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
}
