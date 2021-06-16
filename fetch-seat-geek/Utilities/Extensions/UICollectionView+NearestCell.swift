//
//  UICollectionView+NearestCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

extension UICollectionView {
    func nearestCellToCenter() -> IndexPath? {
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex: IndexPath?
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)
            }
        }
        return closestCellIndex
    }
    
    
    /// Will scroll to the cell closet to center
    func scrollToNearestCellToCenter() {
        guard let indexPath = nearestCellToCenter() else {
            return
        }
        self.scrollToItem(at: indexPath,
                          at: .centeredHorizontally,
                          animated: true)
    }
}
