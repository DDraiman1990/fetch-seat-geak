//
//  BrowseViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit
import RxSwift
import RxCocoa

final class BrowseViewModel: ViewModel {
    typealias Consumer = BrowseViewController
        
    // MARK: - Properties | ViewModel
    
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init())
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<BrowseViewController.Model>> {
        return valueRelay.asObservable().toModelUpdate()
    }
    
    // MARK: - Lifecycle
    
    init() {
        let featuredData: [FeaturedInnerCollectionView.FeaturedData] = [
            FeaturedInnerCollectionView.FeaturedData.event(summary: .stub()),
            FeaturedInnerCollectionView.FeaturedData.event(summary: .stub()),
            FeaturedInnerCollectionView.FeaturedData.performer(performer: .stub()),
            FeaturedInnerCollectionView.FeaturedData.performer(performer: .stub())
        ]
        let justForYouEvents: [SGEventSummary] = [SGEventSummary](repeating: .stub(), count: Int.random(in: 1...4))
        let trendingEvents: [SGEventSummary] = [SGEventSummary](repeating: .stub(), count: Int.random(in: 1...4))
        let recentlyViewed: [SGEventSummary] = [SGEventSummary](repeating: .stub(), count: Int.random(in: 1...4))
        let browseCategories: [SGGenre] = [SGGenre](repeating: .stub(), count: Int.random(in: 3...10))
        let justAnnounced: [SGEventSummary] = [SGEventSummary](repeating: .stub(), count: Int.random(in: 1...4))
        let sections: [BrowseSection] = [
            .featured(data: featuredData),
            .justForYou(data: justForYouEvents),
//            .trendingEvents(data: trendingEvents),
            .recentlyViewed(data: recentlyViewed),
            .browseCategories(data: browseCategories),
            .justAnnounced(data: justAnnounced),
            .category(genre: .stub(), data: [.stub(), .stub(), .stub(), .stub()]),
            .category(genre: .stub(), data: [.stub(), .stub(), .stub(), .stub()]),
            .category(genre: .stub(), data: [.stub(), .stub(), .stub(), .stub()]),
            .category(genre: .stub(), data: [.stub(), .stub(), .stub(), .stub()]),
            .category(genre: .stub(), data: [.stub(), .stub(), .stub(), .stub()])
        ]
        valueRelay.accept(.init(sections: sections))
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        }
    }
}

