//
//  CollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import Foundation
import Combine
import UIKit

class CollectionView<SectionModel: Hashable,
                     ItemModel: IdentifiableItem>:
    UIView,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate {
    
    // MARK: - Internal Types
    
    struct DiffableCellRegistration {
        var reuseId: String
        var type: CellType
        
        enum CellType {
            case fromNib(nib: UINib?)
            case fromClass(type: AnyClass)
        }
    }
    
    typealias InsetForSection = (Int) -> UIEdgeInsets
    typealias CellDequeue = (UICollectionViewCell, IndexPath, ItemModel) -> UICollectionViewCell
    typealias SizeForItem = ((ItemModel, IndexPath) -> CGSize)
    typealias DidSelectItem = ((ItemModel, IndexPath) -> Void)
    typealias DidSnapToItem = ((ItemModel, IndexPath) -> Void)
    typealias RefreshRequest = ((@escaping () -> Void) -> Void)
    typealias CellTypeForModel = (ItemModel) -> DiffableCellRegistration
    
    // MARK: - Callbacks
    
    private var onDequeueCell: CellDequeue
    private var cellTypeForModel: CellTypeForModel
    var insetForSection: InsetForSection?
    var sizeForItem: SizeForItem?
    var didSelectItem: DidSelectItem?
    var didSnapToItem: DidSnapToItem?
    var lastSnapped: IndexPath?
    var onUserBeginScroll: (() -> Void)?
    var onUserEndScroll: (() -> Void)?
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
    
    var infiniteScrollable: Bool {
        get {
            dataSource.infiniteScrollable
        }
        set {
            dataSource.infiniteScrollable = newValue
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
    
    var isPagingEnabled: Bool {
        get {
            return collection.isPagingEnabled
        }
        set {
            collection.isPagingEnabled = newValue
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
         cellTypeForModel: @escaping CellTypeForModel,
         onDequeuedCell: @escaping CellDequeue) {
        self.inverted = inverted
        self.cellTypeForModel = cellTypeForModel
        self.onDequeueCell = onDequeuedCell
        self.sizeForItem = sizeForItem
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
    
    private func dequeueCell(collectionView: UICollectionView,
                             indexPath: IndexPath,
                             item: ItemModel) -> UICollectionViewCell {
        let cellRegData = cellTypeForModel(item)
        registerIfNeeded(registration: cellRegData)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellRegData.reuseId,
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
        self.dataSource.set(
            data: sections,
            animated: animated,
            completion: completion)
    }
    
    func scrollToNextCell(animated: Bool) {
        guard let nearest = collection.nearestCellToCenter() else {
            return
        }
        let nextIndex = IndexPath(item: nearest.row + 1, section: nearest.section)
        if infiniteScrollable {
            guard self.dataSource.isValid(indexPath: nextIndex) else {
                return
            }
        } else {
            guard self.dataSource.data.isValidIndex(nextIndex.section),
                  self.dataSource.data[nextIndex.section].items.isValidIndex(nextIndex.row) else {
                return
            }
        }
        
        self.collection
            .scrollToItem(at: nextIndex,
                          at: .centeredHorizontally,
                          animated: animated)
    }
    
    func scrollToFirst(animated: Bool) {
        let firstRow = dataSource.firstRow
        let indexPath = IndexPath(item: firstRow, section: 0)
        collection.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated)
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
        guard let data = dataSource.selectionData(for: indexPath) else {
            return
        }
        didSelectItem?(data.0, data.1)
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

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //TODO: Handle getting close to the end of the infinite scrolling and
        // make sure to scroll back to the current cell - modifier.
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onUserBeginScroll?()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onUserEndScroll?()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection?(section) ?? .init(constant: 0)
    }
}
