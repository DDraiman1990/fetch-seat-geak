//
//  EventsCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class EventsCollectionView: UIView, CollectionViewContaining {
    var onSelectedItem: ((IndexPath) -> Void)?
    
    private lazy var collection: CollectionView<Int, SGEventSummary> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal(spacing: 8)) { _, _ -> CGSize in
            let height = self.frame.height - 8
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
        collection.insetForSection = { _ in
            return .init(top: 0, left: 20, bottom: 0, right: 0)
        }
        collection.didSelectItem = { [weak self] _, ip in
            self?.onSelectedItem?(ip)
        }
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
