//
//  EventsCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class EventsCollectionView: UIView {
    private lazy var collection: CollectionView<Int, SGEventSummary> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal()) { _, _ -> CGSize in
            let dim = min(self.frame.width, self.frame.height) - 10
            return .init(width: dim, height: dim)
        } cellTypeForModel: { data in
            return .init(
                reuseId: EventSummarySmallCell.cellId,
                type: .fromClass(type: EventSummarySmallCell.self))
        } onDequeuedCell: { cell, indexPath, data -> UICollectionViewCell in
            (cell as? EventSummarySmallCell)?.setup(event: data)
            return cell
        }

    func set(data: [SGEventSummary]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ])
    }
}
