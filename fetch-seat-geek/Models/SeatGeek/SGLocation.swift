//
//  SGLocation.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/14/21.
//

import Foundation
import CoreLocation

struct SGLocation: Decodable {
    var lat: Double
    var lon: Double
    
    var toLocation: CLLocationCoordinate2D {
        return .init(latitude: lat, longitude: lon)
    }
}
