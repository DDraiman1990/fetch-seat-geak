//
//  ScrollAware.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import UIKit

protocol ScrollAware {
    func onScrolling(
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets)
    func onScrollingStopped(
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets)
}

extension ScrollAware {
    func onScrollingStopped(
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets) {}
}
