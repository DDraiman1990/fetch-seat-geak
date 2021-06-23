//
//  TrackableView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import UIKit

protocol TrackableView: UIView {
    var trackTapped: ((Int) -> Void)? { get set }
}
