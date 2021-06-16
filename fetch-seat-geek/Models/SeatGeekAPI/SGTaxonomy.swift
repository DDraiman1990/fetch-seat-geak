//
//  SGTaxonomy.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation

struct SGTaxonomy: Decodable, Hashable {
    var name: String
    var id: Int?
    var parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case parentId = "parent_id"
    }
}
