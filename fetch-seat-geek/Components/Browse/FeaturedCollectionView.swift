//
//  FeaturedInnerCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class FeaturedInnerCollectionView: UIView, CollectionViewContaining {
    var onSelectedItem: ((IndexPath) -> Void)?
    
    private var autoScrollTimer: Timer?
    
    enum FeaturedData: IdentifiableItem {
        var id: Int {
            switch self {
            case .event(let summary):
                return summary.id
            case .performer(let performer):
                return performer.id
            }
        }
        case performer(performer: SGPerformerSummary)
        case event(summary: SGEventSummary)
    }
    
    private lazy var collection: CollectionView<Int, FeaturedData> = .init(
        layout: AppConstants.Collections.Layouts.horizontalSnap()) { _, _ -> CGSize in
            let width = self.frame.width - 40
            let height = self.frame.height - 20
            return .init(width: width, height: height)
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
    
    init() {
        super.init(frame: .zero)
        addSubview(collection)
        collection.anchor(in: self)
        collection.insetForSection = { _ in
            return .init(horizontal: 20, vertical: 0)
        }
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.infiniteScrollable = true
        collection.didSelectItem = { [weak self] _, ip in
            self?.onSelectedItem?(ip)
        }
        setupAutoScrollTimer()
    }
    
    private func setupAutoScrollTimer() {
        startAutoScrollTimer()
        collection.onUserBeginScroll = { [weak self] in
            self?.stopAutoScrollTimer()
        }
        
        collection.onUserEndScroll = { [weak self] in
            self?.startAutoScrollTimer()
        }
    }
    
    private func startAutoScrollTimer() {
        autoScrollTimer = Timer
            .scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            self.collection.scrollToNextCell(animated: true)
        }
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(data: [FeaturedData]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ]) { [weak self] in
            //To ensure always at the middle of the infinite scroll
            self?.collection.scrollToFirst(animated: false)
        }
    }
}
