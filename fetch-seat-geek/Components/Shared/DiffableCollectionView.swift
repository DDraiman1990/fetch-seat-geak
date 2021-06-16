//
//  DiffableCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import Foundation
import Combine
import UIKit

class DiffableCollectionView<SectionModel: Hashable, ItemModel: Hashable>: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - Internal Types
    
    struct DiffableCellRegistration {
        var reuseId: String
        var type: CellType
        
        enum CellType {
            case fromNib(nib: UINib?)
            case fromClass(type: AnyClass)
        }
    }
    
    struct DiffableSectionData {
        var model: SectionModel
        var items: [ItemModel]
    }
    
    typealias CellTypeForModel = (ItemModel) -> DiffableCellRegistration
    typealias CellDequeue = (UICollectionViewCell, IndexPath, ItemModel) -> UICollectionViewCell
    typealias SizeForItem = ((ItemModel, IndexPath) -> CGSize)
    typealias DidSelectItem = ((ItemModel, IndexPath) -> Void)
    typealias DidSnapToItem = ((ItemModel, IndexPath) -> Void)
    typealias RefreshRequest = ((@escaping () -> Void) -> Void)
    
    // MARK: - Callbacks
    
    private var cellTypeForModel: CellTypeForModel
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
    
    // MARK: - Properties | Private
    override var backgroundColor: UIColor? {
        get {
            return collection.backgroundColor
        }
        set {
            collection.backgroundColor = newValue
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
    
    private lazy var datasource = UICollectionViewDiffableDataSource<SectionModel, ItemModel>(collectionView: collection) { [weak self] collectionView, indexPath, itemModel in
        return self?.dequeueCell(collectionView: collectionView,
                                 indexPath: indexPath,
                                 itemModel: itemModel)
    }
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.backgroundView = EmptyListBackground(title: "This list is empty", body: "You don't have any content yet.", image: UIImage(systemName: "table", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)))
        return collection
    }()
    
    // MARK: - Lifecycle
    
    init(layout: UICollectionViewLayout,
         inverted: Bool = false,
         cellTypeForModel: @escaping CellTypeForModel,
         onDequeueCell: @escaping CellDequeue) {
        self.inverted = inverted
        self.cellTypeForModel = cellTypeForModel
        self.onDequeueCell = onDequeueCell
        super.init(frame: .zero)
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
                             itemModel: ItemModel) -> UICollectionViewCell {
        let cellRegData = cellTypeForModel(itemModel)
        registerIfNeeded(registration: cellRegData)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellRegData.reuseId,
            for: indexPath)
        if inverted {
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
        return onDequeueCell(cell, indexPath, itemModel)
    }
    
    private func registerIfNeeded(registration: DiffableCellRegistration) {
        guard !registeredCells.contains(registration.reuseId) else {
            return
        }
        switch registration.type {
        case .fromClass(let type):
            collection.register(type, forCellWithReuseIdentifier: registration.reuseId)
        case .fromNib(let nib):
            collection.register(nib, forCellWithReuseIdentifier: registration.reuseId)
        }
    }
    
    private func update(sections: [DiffableSectionData],
                        animated: Bool = false,
                        completion: (() -> Void)? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, ItemModel>()
        sections.forEach {
            snapshot.appendSections([$0.model])
            snapshot.appendItems($0.items, toSection: $0.model)
        }
        DispatchQueue.main.async {
            self.datasource.apply(snapshot, animatingDifferences: animated, completion: completion)
        }
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
        guard let indexPath = datasource.indexPath(for: item) else {
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
        guard let item = datasource.itemIdentifier(for: indexPath) else {
            return
        }
        didSelectItem?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = datasource.itemIdentifier(for: indexPath) else {
            return .init(width: 0, height: 0)
        }
        return sizeForItem?(item, indexPath) ?? UICollectionViewFlowLayout.automaticSize
    }
    
    private func snapToNearestCellIfNeeded() {
        if snaps {
            guard let nearest = collection.nearestCellToCenter(),
                  let entry = datasource.itemIdentifier(for: nearest) else {
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
        
    func set(snapshot: [DiffableSectionData],
             animated: Bool = true,
             completion: (() -> Void)? = nil) {
        update(sections: snapshot, animated: animated, completion: completion)
        collection.backgroundView?.isHidden = !snapshot.isEmpty
    }
    
    func getSnapshot() -> [DiffableSectionData] {
        let snapshot = datasource.snapshot()
        let sections = snapshot.sectionIdentifiers
        return sections.map {
            let items = snapshot.itemIdentifiers(inSection: $0)
            return DiffableSectionData(model: $0,
                                       items: items)
        }
    }
}