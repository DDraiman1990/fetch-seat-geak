//
//  SGPerformerSummary.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/23/21.
//

import Foundation

struct SGPerformerSummary: Hashable, IdentifiableItem {
    var id: Int
    var name: String
    var shortName: String
    var image: String
    var hasUpcomingEvents: Bool
}
