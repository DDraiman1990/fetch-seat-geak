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
            let height = self.frame.height - 20
            let width = self.frame.width * 0.4
            return .init(width: width, height: height)
        } cellTypeForModel: { data in
            return .init(
                reuseId: EventSummarySmallCell.cellId,
                type: .fromClass(type: EventSummarySmallCell.self))
        } onDequeuedCell: { cell, indexPath, data -> UICollectionViewCell in
            (cell as? EventSummarySmallCell)?.setup(event: data)
            return cell
        }
    
    init() {
        super.init(frame: .zero)
        addSubview(collection)
        collection.anchor(in: self)
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(data: [SGEventSummary]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ])
    }
}
