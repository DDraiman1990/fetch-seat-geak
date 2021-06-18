//
//  CollectionCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class InnerCollectionTableCell<SectionModel: Hashable,
                                     ItemModel: IdentifiableItem>: UITableViewCell {
    
    typealias CellDequeue = (UICollectionViewCell, IndexPath, ItemModel) -> UICollectionViewCell
    typealias SizeForItem = ((ItemModel, IndexPath) -> CGSize)
    typealias DidSelectItem = ((ItemModel, IndexPath) -> Void)
    typealias CellTypeForModel = (ItemModel) -> CollectionView<SectionModel, ItemModel>.DiffableCellRegistration
    
    // MARK: - Callbacks
    
    private var onDequeueCell: CellDequeue?
    private var cellTypeForModel: CellTypeForModel?
    private var sizeForItem: SizeForItem?
    private var didSelectItem: DidSelectItem?
    
    private lazy var collectionView: CollectionView<SectionModel, ItemModel> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal(),
        sizeForItem: { [weak self] model, ip in
            return self?.sizeForItem?(model, ip) ?? .zero
        },
        cellTypeForModel: { [weak self] model in
            return self?.cellTypeForModel?(model) ?? .init(reuseId: "", type: .fromClass(type: UICollectionViewCell.self))
        },
        onDequeuedCell: { [weak self] cell, ip, model in
            return self?.onDequeueCell?(cell, ip, model) ?? UICollectionViewCell()
        })

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.anchor(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(
        onDequeueCell: @escaping CellDequeue,
        cellTypeForModel: @escaping CellTypeForModel,
        sizeForItem: @escaping SizeForItem,
        didSelectItem: @escaping DidSelectItem) {
        self.onDequeueCell = onDequeueCell
        self.cellTypeForModel = cellTypeForModel
        self.sizeForItem = sizeForItem
        collectionView.didSelectItem = didSelectItem
    }
}
