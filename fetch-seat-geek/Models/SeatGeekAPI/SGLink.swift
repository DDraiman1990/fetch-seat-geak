//
//  SGLink.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGLink: Decodable, Hashable {
    var id: Int?
    var provider: String
    var url: String
}
