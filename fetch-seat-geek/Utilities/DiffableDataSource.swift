//
//  Array+Diff.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

protocol IdentifiableItem: Hashable {
    associatedtype IDType: Hashable
    var id: IDType { get }
}

class DiffableDataSource<Section: Hashable, Item: IdentifiableItem>: NSObject, UICollectionViewDataSource {
    
    struct SectionEntry {
        var section: Section
        var items: [Item]
    }
    
    typealias DataState = [Item.IDType: (IndexPath, Item)]
    private(set) var data: [SectionEntry] = []
    private lazy var itemCount: [Int: Int] = [:]
    private var lastState: DataState = [:]
    private weak var collection: UICollectionView?
    private let cellProvider: (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    private var sectionCount: Int = 0
    
    init(collectionView: UICollectionView, cellProvider: @escaping (UICollectionView, IndexPath, Item) -> UICollectionViewCell?) {
        self.collection = collectionView
        self.cellProvider = cellProvider
        super.init()
        collection?.dataSource = self
    }
    
    func state(from data: [SectionEntry]) -> DataState {
        var diff: DataState = [:]
        for section in data.enumerated() {
            let sectionNum = section.offset
            section.element.items.enumerated().forEach {
                diff[$0.element.id] = (IndexPath(item: $0.offset, section: sectionNum), $0.element)
            }
        }
        return diff
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
    
    func getItemActions(newData: [SectionEntry]) -> [Update<IndexPath>] {
        let diff = state(from: newData)
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
            if let info = diff[id] {
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

        self.lastState = diff
        return actions
    }
    
    func getSectionActions(newData: [SectionEntry]) -> [Update<Int>] {
        let diffInSections = newData.count - self.data.count
        let lastSection = self.data.count
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
    
    func set(data: [SectionEntry]) {
        let actions = getItemActions(newData: data)
        let sectionActions = getSectionActions(newData: data)
        
        self.data = data
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
                print("Diff resolved")
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount[section] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.section].items[indexPath.row]
        return cellProvider(collectionView, indexPath, item) ?? UICollectionViewCell()
    }
    
    func indexPath(for item: Item) -> IndexPath? {
        return lastState[item.id]?.0
    }
    
    func item(for indexPath: IndexPath) -> Item? {
        guard data.indices ~= indexPath.section,
              data[indexPath.section].items.indices ~= indexPath.row else {
            return nil
        }
        return data[indexPath.section].items[indexPath.row]
    }
    
    var isEmpty: Bool {
        return data.isEmpty
    }
}
