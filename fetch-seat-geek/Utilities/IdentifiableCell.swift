//
//  IdentifiableCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

protocol IdentifiableCell {
    static var cellId: String { get }
}

typealias IdentifiableCollectionCell = UICollectionViewCell & IdentifiableCell
typealias IdentifiableTableCell = UITableViewCell & IdentifiableCell
