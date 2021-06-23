//
//  Array+Diff.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

/// Diffable datasource for collection views that supports iOS 12 or below.
class DiffableDataSource<Section: Hashable, Item: IdentifiableItem>: NSObject, UICollectionViewDataSource {
    
    // MARK: - Private Models & Aliases
    
    typealias DataState = [Item.IDType: (IndexPath, Item)]
    struct SectionEntry {
        var section: Section
        var items: [Item]
    }
    
    enum Update<T>: CustomStringConvertible {
        case remove(T)
        case add(T)
        case move(from: T, to: T)
        case reload(T)
        
        var description: String {
            switch self {
            case .remove(let index):
                return "Remove from \(index)"
            case .add(let index):
                return "Add to \(index)"
            case .move(from: let from, to: let to):
                return "Move from \(from) to \(to)"
            case .reload(let index):
                return "reload \(index)"
            }
        }
    }
    
    // MARK: - Properties
    
    private(set) var data: [SectionEntry] = []
    private weak var collection: UICollectionView?
    private let cellProvider: (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    var infiniteScrollable: Bool = false

    //State Tracking
    private var lastState: DataState = [:]
    private var sectionCount: Int = 0
    private lazy var itemCount: [Int: Int] = [:]

    // MARK: - Computed Values & Constants
    
    var firstRow: Int {
        if infiniteScrollable {
            return (data.count * infiniteModifier) - data.count
        }
        return 0
    }
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    //To allow "infinite" cyclic scrolling we have to multiply rows by this modifier.
    let infiniteModifier = 30
    
    // MARK: - Lifecycle
    
    init(collectionView: UICollectionView, cellProvider: @escaping (UICollectionView, IndexPath, Item) -> UICollectionViewCell?) {
        self.collection = collectionView
        self.cellProvider = cellProvider
        super.init()
        collection?.dataSource = self
    }
    
    // MARK: - Methods | State Calculations
    
    private func state(from data: [SectionEntry]) -> DataState {
        var diff: DataState = [:]
        for section in data.enumerated() {
            let sectionNum = section.offset
            section.element.items.enumerated().forEach {
                diff[$0.element.id] = (IndexPath(item: $0.offset, section: sectionNum), $0.element)
            }
        }
        return diff
    }
    
    private func getItemActions(
        newData: [SectionEntry],
        newDataState: DataState
    ) -> [Update<IndexPath>] {
        let last = lastState
        let allNewItems = newData.flatMap { $0.items }.map { $0.id }
        let allItems = data.flatMap { $0.items }.map { $0.id }
        let toRemove: [Update<IndexPath>] = Set(allItems).subtracting(Set(allNewItems)).compactMap {
            guard let info = last[$0] else {
                return nil
            }
            return Update<IndexPath>.remove(info.0)
        }
        var actions: [Update<IndexPath>] = toRemove
        for id in allNewItems {
            if let info = newDataState[id] {
                if let oldInfo = last[id] {
                    if info.0 == oldInfo.0 {
                        if info.1 != oldInfo.1 {
                            //Same Index, different data
                            actions.append(.reload(info.0))
                        }
                    } else {
                        actions.append(.move(from: oldInfo.0, to: info.0))
                    }
                } else {
                    actions.append(.add(info.0))
                }
            }
        }

        return actions
    }
    
    private func getSectionActions(newData: [SectionEntry]) -> [Update<Int>] {
        let diffInSections = newData.count - data.count
        let lastSection = data.count
        switch diffInSections {
        case let x where x < 0:
            return ((lastSection - abs(diffInSections))..<lastSection)
                .map { Update.remove($0) }
        case let x where x > 0:
            return ((lastSection..<lastSection + diffInSections))
                .map { Update.add($0) }
        default:
            return []
        }
    }
    
    private func animateChanges(
        newData: [SectionEntry],
        newDataState: DataState,
        completion: (() -> Void)? = nil) {
        let actions = getItemActions(
            newData: newData,
            newDataState: newDataState)
        let sectionActions = getSectionActions(newData: newData)

        self.lastState = newDataState
        self.data = newData
        DispatchQueue.main.async {
            self.collection?.performBatchUpdates {
                sectionActions.forEach {
                    switch $0 {
                    case .add(let section):
                        self.collection?.insertSections([section])
                        self.sectionCount += 1
                        self.itemCount[section] = 0
                    case .move(let current, let dest):
                        self.collection?.moveSection(current, toSection: dest)
                    case .reload(let section):
                        self.collection?.reloadSections([section])
                    case .remove(let section):
                        self.collection?.deleteSections([section])
                        self.sectionCount -= 1
                        self.itemCount[section] = 0
                    }
                }
                actions.forEach {
                    switch $0 {
                    case .add(let ip):
                        self.collection?.insertItems(at: [ip])
                        self.itemCount[ip.section] = self.itemCount[ip.section].add(value: 1)
                    case .move(let current, let dest):
                        self.collection?.moveItem(at: current, to: dest)
                        self.itemCount[dest.section] = self.itemCount[dest.section].add(value: 1)
                        self.itemCount[current.section] = self.itemCount[current.section].subtract(value: 1, maxValue: 0)
                    case .reload(let ip):
                        self.collection?.reloadItems(at: [ip])
                    case .remove(let ip):
                        self.collection?.deleteItems(at: [ip])
                        self.itemCount[ip.section] = self.itemCount[ip.section].subtract(value: 1, maxValue: 0)
                    }
                }
            } completion: { _ in
                completion?()
            }
        }
    }
    
    // MARK: - Methods | Public
    
    func set(
        data: [SectionEntry],
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        let diff = state(from: data)
        if animated {
            animateChanges(
                newData: data,
                newDataState: diff,
                completion: completion)
        } else {
            self.lastState = diff
            self.data = data
            self.sectionCount = data.count
            data.enumerated().forEach {
                self.itemCount[$0.offset] = $0.element.items.count
            }
            DispatchQueue.main.async {
                self.collection?.reloadData()
            }
        }
    }
    
    // MARK: - Methods | Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (itemCount[section] ?? 0) * (infiniteScrollable ? infiniteModifier : 1)
    }
    
    func isValid(indexPath: IndexPath) -> Bool {
        guard let section = data.elementIfExists(index: indexPath.section) else {
            return false
        }
        if infiniteScrollable {
            let validRowRange = 0..<(section.items.count * infiniteModifier)
            return validRowRange ~= indexPath.item
        }
        return section.items.isValidIndex(indexPath.item)
    }
    
    func selectionData(for indexPath: IndexPath) -> (Item, IndexPath)? {
        guard let section = data.elementIfExists(index: indexPath.section) else {
            return nil
        }
        let modifiedRow = indexPath.item % section.items.count
        guard let item = section.items.elementIfExists(index: modifiedRow) else {
            return nil
        }
        return (item, IndexPath(item: modifiedRow, section: indexPath.section))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = data.elementIfExists(index: indexPath.section) else {
            return UICollectionViewCell()
        }
        let modifiedRow = indexPath.item % section.items.count
        guard let item = section.items.elementIfExists(index: modifiedRow) else {
            return UICollectionViewCell()
        }
        return cellProvider(collectionView, indexPath, item) ?? UICollectionViewCell()
    }
    
    func indexPath(for item: Item) -> IndexPath? {
        return lastState[item.id]?.0
    }
    
    func item(for indexPath: IndexPath) -> Item? {
        guard let section = data.elementIfExists(index: indexPath.section) else {
            return nil
        }
        let modifiedRow = indexPath.item % section.items.count
        return section.items.elementIfExists(index: modifiedRow)
    }
}
