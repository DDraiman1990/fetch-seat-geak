//
//  UITableView+HideSeparator.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import UIKit

extension UITableViewCell {
    func hideSeparator() {
        separatorInset = .init(top: 0, left: .infinity, bottom: 0, right: 0)
    }
}
