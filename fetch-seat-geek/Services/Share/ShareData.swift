//
//  ShareData.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

protocol ShareData {
    var subject: String { get }
    var body: String? { get }
    var subUrlPath: String? { get }
    var image: UIImage? { get }
    var spacesAfterTitle: Int { get }
    var baseUrl: URL { get }
    var queryItems: [URLQueryItem] { get }
}
