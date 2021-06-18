//
//  GenresCollectionView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class GenresCollectionView: UIView {
    private lazy var collection: CollectionView<Int, SGGenre> = .init(
        layout: AppConstants.Collections.Layouts.basicHorizontal()) { _, _ -> CGSize in
            let dim = min(self.frame.width, self.frame.height) - 10
            return .init(width: dim, height: dim)
        } cellTypeForModel: { data in
            return .init(
                reuseId: GenreSummaryCell.cellId,
                type: .fromClass(type: GenreSummaryCell.self))
        } onDequeuedCell: { cell, indexPath, data -> UICollectionViewCell in
            (cell as? GenreSummaryCell)?.setup(genre: data)
            return cell
        }

    func set(data: [SGGenre]) {
        collection.set(sections: [
            .init(section: 0, items: data)
        ])
    }
}
