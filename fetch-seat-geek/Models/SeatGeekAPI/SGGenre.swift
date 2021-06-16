//
//  SGGenre.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGGenre: Decodable, Hashable {
    var id: Int
    var name: String?
    var slug: String
    var image: String?
}
