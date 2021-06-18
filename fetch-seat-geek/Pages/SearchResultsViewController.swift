//
//  SearchResultsViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    private var category: ResultCategory
    
    private lazy var collectionView: CollectionView<SearchResultCell, String, SearchResultEntry>
        = .init(layout: UICollectionViewFlowLayout()) { entry, indexPath in
            return .init(width: 100, height: 100)
        } onDequeuedCell: { [weak self] cell, _, entry in
            return self?.setup(cell: cell, entry: entry) ?? cell
        }


    
    init(category: ResultCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(
        cell: UICollectionViewCell,
        entry: SearchResultEntry
    ) -> UICollectionViewCell {
        //TODO: setup
        return cell
    }
}

enum ResultCategory: String {
    case venues, events, performers
}

enum SearchResultEntry: IdentifiableItem {
    var id: Int {
        switch self {
        case .venue(venue: let venue):
            return venue.id
        case .event(event: let event):
            return event.id
        case .performer(performer: let performer):
            return performer.id
        }
    }
    case venue(venue: SGVenue)
    case event(event: SGEvent)
    case performer(performer: SGPerformer)
}

final class SearchResultCell: IdentifiableCollectionCell {
    public static let cellId = "SearchResultCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
