//
//  BrowseSection.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/19/21.
//

import UIKit

enum BrowseSection: Equatable {
    case featured(data: [FeaturedInnerCollectionView.FeaturedData])
    case justForYou(data: [SGEventSummary])
    case trendingEvents(data: [SGEventSummary])
    case recentlyViewed(data: [SGEventSummary])
    case browseCategories(data: [SGGenre])
    case justAnnounced(data: [SGEventSummary])
    case category(genre: SGGenre, data: [SGEventSummary])
    
    var header: String? {
        switch self {
        case .featured:
            return nil
        case .justForYou:
            return "Just for you"
        case .trendingEvents:
            return "Trending events"
        case .recentlyViewed:
            return "Recently viewed events"
        case .browseCategories:
            return "Browse by category"
        case .justAnnounced:
            return "Just announced"
        case .category(let genre, _):
            return genre.name.capitalized
        }
    }
    
    var hasHeader: Bool {
        return header != nil
    }
    
    var separator: Bool {
        switch self {
        case .featured:
            return false
        default:
            return true
        }
    }
    
    var dataCount: Int {
        switch self {
        case .featured(let data):
            return data.count
        case .justForYou(let data):
            return data.count
        case .trendingEvents(let data):
            return data.count
        case .recentlyViewed(let data):
            return data.count
        case .browseCategories(let data):
            return data.count
        case .justAnnounced(let data):
            return data.count
        case .category(_, let data):
            return data.count
        }
    }
    
    var numOfRows: Int {
        if dataCount == 0 {
            return 0
        }
        return hasHeader ? 2 : 1
    }
    
    private func cellId(isHeader: Bool) -> String {
        if isHeader {
            return ViewAllHeaderCell.cellId
        }
        switch self {
        case .featured:
            return FeaturedInnerCollectionCell.cellId
        case .justForYou, .recentlyViewed, .justAnnounced, .category:
            return EventsInnerCollectionCell.cellId
        case .trendingEvents:
            //TODO: implement TrendingCollectionView and cell
//                return TrendingInnerCollectionCell.cellId
            return ""
        case .browseCategories:
            return GenresInnerCollectionCell.cellId
        }
    }
    
    func registerCellIfNeeded(table: UITableView) {
        if hasHeader {
            table.register(
                ViewAllHeaderCell.self,
                forCellReuseIdentifier: ViewAllHeaderCell.cellId)
        }
        switch self {
        case .featured:
            table.register(
                FeaturedInnerCollectionCell.self,
                forCellReuseIdentifier: FeaturedInnerCollectionCell.cellId)
        case .justForYou, .recentlyViewed, .justAnnounced, .category:
            table.register(
                EventsInnerCollectionCell.self,
                forCellReuseIdentifier: EventsInnerCollectionCell.cellId)
        case .trendingEvents:
            //TODO: implement TrendingCollectionView and cell
//                table.register(
//                    TrendingInnerCollectionCell.self,
//                    forCellReuseIdentifier: TrendingInnerCollectionCell.cellId)
            break
        case .browseCategories:
            table.register(
                GenresInnerCollectionCell.self,
                forCellReuseIdentifier: GenresInnerCollectionCell.cellId)
        }
    }
    
    func cellHeight(indexPath: IndexPath) -> CGFloat {
        let isHeader = indexPath.row == 0 && hasHeader
        if isHeader {
            return 60
        }
        switch self {
        case .featured:
            return 230
        case .justForYou, .recentlyViewed, .justAnnounced, .category:
            return 230
        case .trendingEvents:
            //TODO: implement TrendingCollectionView and cell
//                table.register(
//                    TrendingInnerCollectionCell.self,
//                    forCellReuseIdentifier: TrendingInnerCollectionCell.cellId)
            return 360
        case .browseCategories:
            return 120
        }
    }
    
    func dequeue(from table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        registerCellIfNeeded(table: table)
        let isHeader = indexPath.row == 0 && hasHeader
        let cell = table.dequeueReusableCell(
            withIdentifier: cellId(isHeader: isHeader),
            for: indexPath)
        (cell as? ViewAllHeaderCell)?.setup(title: self.header ?? "")
        switch self {
        case .featured(let data):
            (cell as? FeaturedInnerCollectionCell)?.setup(data: data)
        case .justForYou(let data):
            (cell as? EventsInnerCollectionCell)?.setup(data: data)
        case .trendingEvents(let data):
            //                (cell as? FeaturedInnerCollectionCell)?.setup(data: data)
            break
        case .recentlyViewed(let data):
            (cell as? EventsInnerCollectionCell)?.setup(data: data)
        case .browseCategories(let data):
            (cell as? GenresInnerCollectionCell)?.setup(data: data)
        case .justAnnounced(let data):
            (cell as? EventsInnerCollectionCell)?.setup(data: data)
        case .category(_, let data):
            (cell as? EventsInnerCollectionCell)?.setup(data: data)
        }
        if isHeader || !separator {
            cell.hideSeparator()
        }
        return cell
    }
}
