//
//  FeaturedData.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import Foundation

enum FeaturedData: IdentifiableItem {
    var id: Int {
        switch self {
        case .event(let summary):
            return summary.id
        case .performer(let performer):
            return performer.id
        }
    }
    case performer(performer: SGPerformerSummary)
    case event(summary: SGEventSummary)
}
