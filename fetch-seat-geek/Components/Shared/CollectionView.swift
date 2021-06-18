//
//  CollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import Foundation
import Combine
import UIKit

class CollectionView<ItemCell: IdentifiableCollectionCell,
                     SectionModel: Hashable,
                     ItemModel: IdentifiableItem>:
    UIView,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate {
    
    // MARK: - Internal Types
    
    typealias CellDequeue = (UICollectionViewCell, IndexPath, ItemModel) -> UICollectionViewCell
    typealias SizeForItem = ((ItemModel, IndexPath) -> CGSize)
    typealias DidSelectItem = ((ItemModel, IndexPath) -> Void)
    typealias DidSnapToItem = ((ItemModel, IndexPath) -> Void)
    typealias RefreshRequest = ((@escaping () -> Void) -> Void)
    
    // MARK: - Callbacks
    
    private var onDequeueCell: CellDequeue
    var sizeForItem: SizeForItem?
    var didSelectItem: DidSelectItem?
    var didSnapToItem: DidSnapToItem?
    var lastSnapped: IndexPath?
    var onRefreshRequested: RefreshRequest? {
        didSet {
            refreshControl = onRefreshRequested != nil ? .init() : nil
            refreshControl?.addTarget(self, action: #selector(refreshRequested), for: .valueChanged)
            collection.refreshControl = refreshControl
        }
    }
    
    var showsHorizontalScrollIndicator: Bool {
        get {
            collection.showsHorizontalScrollIndicator
        }
        set {
            collection.showsHorizontalScrollIndicator = newValue
        }
    }
    
    var showsVerticalScrollIndicator: Bool {
        get {
            collection.showsVerticalScrollIndicator
        }
        set {
            collection.showsVerticalScrollIndicator = newValue
        }
    }
    
    var bounces: Bool {
        get {
            collection.bounces
        }
        set {
            collection.bounces = newValue
        }
    }
    
    // MARK: - Properties | Private
    
    override var backgroundColor: UIColor? {
        get {
            return collection.backgroundColor
        }
        set {
            collection.backgroundColor = newValue
        }
    }
   
    private var items: [[ItemModel]] = []

    /// Whether or not the cell will snap on scroll.
    /// - Warning: will set decelerationRate to fast if snaps and normal if not.
    var snaps: Bool = false {
        didSet {
            collection.decelerationRate = snaps ? .fast : .normal
        }
    }
    private var refreshControl: UIRefreshControl?
    private var registeredCells: Set<String> = []
    private let inverted: Bool
    
    // MARK: - Properties | Public
    
    var layout: UICollectionViewLayout {
        return collection.collectionViewLayout
    }
        
    // MARK: - UI Components
    private lazy var dataSource = DiffableDataSource<SectionModel, ItemModel>(
        collectionView: collection) { [weak self] collectionView, indexPath, itemModel in
        return self?.dequeueCell(collectionView: collectionView,
                                 indexPath: indexPath,
                                 item: itemModel)
    }
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.backgroundView = EmptyListBackground(
            title: "This list is empty",
            body: "You don't have any content yet.",
            image: R.image.binaculars())
        return collection
    }()
    
    // MARK: - Lifecycle
    
    init(layout: UICollectionViewLayout,
         inverted: Bool = false,
         sizeForItem: @escaping SizeForItem,
         onDequeuedCell: @escaping CellDequeue) {
        self.inverted = inverted
        self.onDequeueCell = onDequeuedCell
        self.sizeForItem = sizeForItem
        super.init(frame: .zero)
        collection.register(ItemCell.self,
                            forCellWithReuseIdentifier: ItemCell.cellId)
        collection.setCollectionViewLayout(layout, animated: false)
        if inverted {
            collection.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
        addSubview(collection)
        collection.anchor(in: self)
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Helpers
    
    @objc private func refreshRequested() {
        onRefreshRequested?({ [weak self] in
            self?.refreshControl?.endRefreshing()
        })
    }
    
    private func dequeueCell(collectionView: UICollectionView,
                             indexPath: IndexPath,
                             item: ItemModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCell.cellId,
            for: indexPath)
        if inverted {
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
        return onDequeueCell(cell, indexPath, item)
    }
    
    private func update(
        sections: [DiffableDataSource<SectionModel, ItemModel>.SectionEntry],
        animated: Bool = false,
        completion: (() -> Void)? = nil) {
        self.dataSource.set(data: sections)
    }
    
    // MARK: - Public API
    
    func set(layout: UICollectionViewLayout,
             animated: Bool = true,
             completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            self.collection.setCollectionViewLayout(layout,
                                                    animated: animated,
                                                    completion: completion)
        }
    }
    
    func scroll(toIndexPath indexPath: IndexPath,
                scrollPosition: UICollectionView.ScrollPosition,
                animated: Bool = true) {
        DispatchQueue.main.async {
            self.collection.scrollToItem(at: indexPath,
                                         at: scrollPosition,
                                         animated: animated)
        }
    }
    
    func scroll(toItem item: ItemModel,
                scrollPosition: UICollectionView.ScrollPosition,
                animated: Bool = true) {
        guard let indexPath = dataSource.indexPath(for: item) else {
            return
        }
        DispatchQueue.main.async {
            self.collection.scrollToItem(at: indexPath,
                                    at: scrollPosition,
                                    animated: animated)
        }
    }
    
    func set(emptyBackgroundView: UIView?) {
        DispatchQueue.main.async {
            self.collection.backgroundView = emptyBackgroundView
        }
    }
    
    func cellForRow(indexPath: IndexPath) -> UICollectionViewCell? {
        return self.collection.cellForItem(at: indexPath)
    }
    
    func softReload() {
        DispatchQueue.main.async {
            self.collection.performBatchUpdates(nil, completion: nil)
        }
    }
        
    // MARK: - UITableViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.item(for: indexPath) else {
            return
        }
        didSelectItem?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource.item(for: indexPath) else {
            return .init(width: 0, height: 0)
        }
        return sizeForItem?(item, indexPath) ?? UICollectionViewFlowLayout.automaticSize
    }
    
    private func snapToNearestCellIfNeeded() {
        if snaps {
            guard let nearest = collection.nearestCellToCenter(),
                  let entry = dataSource.item(for: nearest) else {
                return
            }
            
            didSnapToItem?(entry, nearest)
            self.collection
                .scrollToItem(at: nearest,
                                         at: .centeredHorizontally,
                                         animated: true)
        }
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearestCellIfNeeded()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToNearestCellIfNeeded()
        }
    }
        
    func set(sections: [DiffableDataSource<SectionModel, ItemModel>.SectionEntry],
             animated: Bool = true,
             completion: (() -> Void)? = nil) {
        update(sections: sections, animated: animated, completion: completion)
        collection.backgroundView?.isHidden = !sections.isEmpty
    }
    
    func getData() -> [DiffableDataSource<SectionModel, ItemModel>.SectionEntry] {
        return dataSource.data
    }
}
