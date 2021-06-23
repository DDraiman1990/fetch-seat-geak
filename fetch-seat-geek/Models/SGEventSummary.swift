//
//  SGEventSummary.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

struct SGEventSummary: IdentifiableItem {
    var id: Int
    var banner: SGBanner?
    var title: String
    var date: Date
    var venueName: String
    var venueLocation: String
    var ticketPrice: String?
    var canBeTracked: Bool
    var imageUrl: String
}

struct SGBanner: Hashable {
    var text: String
    var textColor: UIColor
    var backgroundColor: UIColor
    var font: UIFont = .systemFont(ofSize: 15)
}
