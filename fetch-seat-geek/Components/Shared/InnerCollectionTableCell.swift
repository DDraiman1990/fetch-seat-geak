//
//  InnerCollectionTableCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

protocol CollectionViewContaining: UIView {
    var onSelectedItem: ((IndexPath) -> Void)? { get set }
}
