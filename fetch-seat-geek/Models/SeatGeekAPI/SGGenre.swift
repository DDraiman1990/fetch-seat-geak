//
//  SGGenre.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGGenre: Decodable, IdentifiableItem {
    var id: Int
    var name: String
    var slug: String
    var image: String?
    
    static func stub() -> SGGenre {
        let name = (Bool.random() ? "Funk" : "Foonk") + "\(Int.random(in: 1...1000))"
        return .init(
            id: Int.random(in: 1...100000),
            name: name,
            slug: name,
            image: Bool.random() ? nil : "https://seatgeek.com/images/performers-landscape/justin-bieber-787108/2446/huge.jpg")
    }
}
