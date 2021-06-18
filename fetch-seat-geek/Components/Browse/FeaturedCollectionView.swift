//
//  FeaturedInnerCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class FeaturedInnerCollectionView: UIView {
    enum FeaturedData: IdentifiableItem {
        var id: Int {
            switch self {
            case .event(let summary):
                return summary.id
            case .performer(let performer):
                return performer.id
            }
        }
        case performer(performer: SGPerformer)
        case event(summary: SGEventSummary)
    }
    
    private lazy var collection: CollectionView<Int, FeaturedData> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal()) { _, _ -> CGSize in
            let dim = min(self.frame.width, self.frame.height) - 10
            return .init(width: dim, height: dim)
        } cellTypeForModel: { data -> CollectionView<Int, FeaturedData>.DiffableCellRegistration in
            switch data {
            case .event:
                return .init(
                    reuseId: EventSummaryLargeCell.cellId,
                    type: .fromClass(type: EventSummaryLargeCell.self))
            case .performer:
                return .init(
                    reuseId: PerformerSummaryCell.cellId,
                    type: .fromClass(type: PerformerSummaryCell.self))
            }
        } onDequeuedCell: { cell, indexPath, data -> UICollectionViewCell in
            switch data {
            case .performer(let performer):
                (cell as? PerformerSummaryCell)?.setup(performer: performer)
            case .event(let summary):
                (cell as? EventSummaryLargeCell)?.setup(event: summary)
            }
            return cell
        }

    func set(data: [FeaturedData]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ])
    }
}
