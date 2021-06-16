//
//  SearchResultsViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit
//
//final class SearchResultsViewController: UIViewController {
//    private var category: ResultCategory
//    private lazy var compLayout: UICollectionViewCompositionalLayout = {
//        return UICollectionViewCompositionalLayout { sectionNum, env in
//            let layoutSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .fractionalHeight(1))
//            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
//            item.contentInsets.trailing = 12
//            item.contentInsets.bottom = 12
//            let group = NSCollectionLayoutGroup.horizontal(
//                layoutSize: .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(200)),
//                subitems: [item])
//            let section = NSCollectionLayoutSection(group: group)
//            section.orthogonalScrollingBehavior = .continuous
//            return section
//        }
//    }()
//    
//    private lazy var collectionView: DiffableCollectionView<String, SearchResultEntry>
//        = .init(layout: compLayout) { entry in
//            switch entry {
//            case .event:
//                return .init(
//                    reuseId: EventSummaryCell.cellId,
//                    type: .fromClass(type: EventSummaryCell.self))
//            case .performer:
//                return .init(
//                    reuseId: PerformerSummaryCell.cellId,
//                    type: .fromClass(type: EventSummaryCell.self))
//            case .venue:
//                return .init(
//                    reuseId: VenueSummaryCell.cellId,
//                    type: .fromClass(type: VenueSummaryCell.self))
//            }
//        } onDequeueCell: { [weak self] cell, _, entry -> UICollectionViewCell in
//            return self?.setup(cell: cell, entry: entry) ?? cell
//        }
//
//    
//    init(category: ResultCategory) {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setup(
//        cell: UICollectionViewCell,
//        entry: SearchResultEntry
//    ) -> UICollectionViewCell {
//        //TODO: setup
//        return cell
//    }
//}
//
//enum ResultCategory: String {
//    case venues, events, performers
//}
//
//enum SearchResultEntry: Hashable {
//    case venue(venue: SGVenue)
//    case event(event: SGEvent)
//    case performer(performer: SGPerformer)
//}
