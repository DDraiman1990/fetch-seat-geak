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
    var ticketPrice: String
    var isTracked: Bool
    var canBeTracked: Bool
    var imageUrl: String
    
    static func stub() -> SGEventSummary {
        return .init(id: Int.random(in: 1...100000),
                     banner: Bool.random() ? nil : SGBanner.stub(),
                     title: "Some Event \(Int.random(in: 0...100000000000000))",
                     date: Date().addingTimeInterval(Double.random(in: 1...100000)),
                     venueName: "Venue \(Int.random(in: 0...1000))",
                     venueLocation: "Neverland, \(Int.random(in: 0...100000000000))",
                     ticketPrice: "\(Int.random(in: 1...300))+",
                     isTracked: Bool.random(),
                     canBeTracked: Bool.random(),
                     imageUrl: "https://seatgeek.com/images/performers-landscape/canadian-grand-prix-274211/9815/huge.jpg")
    }
}

struct SGBanner: Hashable {
    var text: String
    var textColor: UIColor
    var backgroundColor: UIColor
    var font: UIFont = .systemFont(ofSize: 15)
    
    static func stub() -> SGBanner {
        return .init(
            text: "\(Int.random(in: 200...10000))",
            textColor: .white,
            backgroundColor: UIColor.blue.withAlphaComponent(0.4))
    }
}
