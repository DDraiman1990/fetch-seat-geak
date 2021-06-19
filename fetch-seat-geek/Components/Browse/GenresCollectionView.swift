//
//  GenresCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class GenresCollectionView: UIView {
    private lazy var collection: CollectionView<Int, SGGenre> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal(spacing: 12)) { _, _ -> CGSize in
            let height = self.frame.height - 20
            let width = self.frame.width * 0.35
            return .init(width: width, height: height)
        } cellTypeForModel: { data in
            return .init(
                reuseId: GenreSummaryCell.cellId,
                type: .fromClass(type: GenreSummaryCell.self))
        } onDequeuedCell: { cell, indexPath, data -> UICollectionViewCell in
            (cell as? GenreSummaryCell)?.setup(genre: data)
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
    
    func set(data: [SGGenre]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ])
    }
}
