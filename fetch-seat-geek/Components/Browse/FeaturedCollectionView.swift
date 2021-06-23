//
//  FeaturedInnerCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class FeaturedInnerCollectionView: UIView, CollectionViewContaining, TrackableView {
    
    // MARK: - Properties
    
    var onSelectedItem: ((IndexPath) -> Void)?
    var trackTapped: ((Int) -> Void)?
    private var trackedIds: Set<Int> = []
    private var autoScrollTimer: Timer?
    
    // MARK: - UI Components
    
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
        } onDequeuedCell: { [weak self] cell, indexPath, data in
            switch data {
            case .performer(let performer):
                (cell as? PerformerSummaryCell)?.setup(performer: performer)
            case .event(let summary):
                let summaryCell = cell as? EventSummaryLargeCell
                summaryCell?.setup(event: summary)
                let isTracked = self?.trackedIds.contains(summary.id) ?? false
                summaryCell?.set(isTracked: isTracked)
                summaryCell?.trackTapped = { [weak self] in
                    self?.trackTapped?(data.id)
                }
            }
            return cell
        }
    
    // MARK: - Lifecycle
    
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setup
    
    private func setupAutoScrollTimer() {
        startAutoScrollTimer()
        collection.onUserBeginScroll = { [weak self] in
            self?.stopAutoScrollTimer()
        }
        
        collection.onUserEndScroll = { [weak self] in
            self?.startAutoScrollTimer()
        }
    }
    
    // MARK: - Methods | Timer
    
    private func startAutoScrollTimer() {
        autoScrollTimer = Timer
            .scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            self.collection.scrollToNextCell(animated: true)
        }
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
    }

    // MARK: - Methods | Setters
    
    func set(data: [FeaturedData]) {
        // To prevent reloading and reseting to first index
        guard data != collection.getData().first?.items else {
            return
        }
        collection.set(sections: [
            .init(section: 0, items: data)
        ]) { [weak self] in
            //To ensure always at the middle of the infinite scroll
            self?.collection.scrollToFirst(animated: false)
        }
    }
    
    func set(trackedIds: Set<Int>) {
        self.trackedIds = trackedIds
        collection.reload(sections: [0])
    }
}
