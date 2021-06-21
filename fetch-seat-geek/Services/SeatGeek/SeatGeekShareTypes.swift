//
//  SeatGeekShareTypes.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

enum SeatGeekShareData: ShareData {
    case event(event: SGEvent, image: UIImage?)
    var subject: String {
        switch self {
        case .event:
            return R.string.main.share_event_title()
        }
    }
    var body: String? {
        switch self {
        case .event(let event, _):
            let dateString = AppConstants
                .DateFormatters
                .fullDateAndTimeFormatter
                .string(from: event.datetimeLocal)
            return R.string.main.share_event_body_(
                event.title,
                dateString,
                event.venue.fullAddress)
        }
    }
    var subUrlPath: String? {
        switch self {
        case .event:
            return nil
        }
    }
    var image: UIImage? {
        switch self {
        case .event(_, let image):
            return image
        }
    }
    var spacesAfterTitle: Int {
        switch self {
        case .event:
            return 1
        }
    }
    var baseUrl: URL {
        switch self {
        case .event(let event, _):
            return URL(string: event.url)!
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .event:
            return []
        }
    }
}
