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
    
    private struct GenreSection: Equatable {
        var name: String
        var events: [SGEventSummary]
    }

    private struct TableData: Equatable {
        var featured: [FeaturedInnerCollectionView.FeaturedData]?
        var justForYou: [SGEventSummary]?
        var trendingEvents: [SGEventSummary]?
        var recentlyViewed: [SGEventSummary]?
        var browseCategories: [SGGenre]?
        var justAnnounced: [SGEventSummary]?
        var genres: [GenreSection]?

        var sections: [BrowseSection] {
            var sections: [BrowseSection] = []
            if let featured = featured {
                sections.append(.featured(data: featured))
            }
            if let justForYou = justForYou {
                sections.append(.justForYou(data: justForYou))
            }
            if let trendingEvents = trendingEvents {
                sections.append(.trendingEvents(data: trendingEvents))
            }
            if let recentlyViewed = recentlyViewed {
                sections.append(.recentlyViewed(data: recentlyViewed))
            }
            if let browseCategories = browseCategories {
                sections.append(.browseCategories(data: browseCategories))
            }
            if let justAnnounced = justAnnounced {
                sections.append(.justAnnounced(data: justAnnounced))
            }
            if let genres = genres {
                return sections + genres.map {
                    BrowseSection.category(
                        name: $0.name,
                        data: $0.events)
                }
            }
            return sections
        }
    }
    // MARK: - Properties | Dependencies
    
    private let seatGeekInteractor: SeatGeekInteracting
    
    // MARK: - Properties | ViewModel
    
    private let tableDataRelay: BehaviorRelay<TableData> = .init(value: .init())
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init(location: "Joliet, IL", dates: "All Dates"))
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<BrowseViewController.Model>> {
        return valueRelay.asObservable().toModelUpdate()
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(resolver: DependencyResolving) {
        self.seatGeekInteractor = resolver.resolve()
        
        tableDataRelay
            .asObservable()
            .subscribeToValue { data in
                self.valueRelay.mutableValue.sections = data.sections
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .viewAppeared:
            break
        case .viewLoaded:
            fetchBrowseData()
        }
    }
    
    // MARK: - Methods | Data Fetching
    
    private func fetchBrowseData() {
        fetchFeatured()
        fetchGenres()
        fetchCategories()
    }
    
    private func fetchFeatured() {
        let allEvents = seatGeekInteractor.getAllEvents(queries: [
            .sort(query: .init(field: .score, direction: .descending)),
            .pagination(query: .init(perPage: 4, currentPage: 1))
        ])
        let upcomingPerformers = seatGeekInteractor.getPerformersWithUpcoming()
        Observable.zip(allEvents, upcomingPerformers)
            .subscribeToResult { result in
                switch result {
                case .success(let tupleResponse):
                    let featuredEvents = tupleResponse
                        .0
                        .events
                        .map {
                            FeaturedInnerCollectionView
                                .FeaturedData
                                .event(summary: $0.toSummary)
                        }
                    let featuredPerformers = tupleResponse
                        .1
                        .performers
                        .map {
                            FeaturedInnerCollectionView
                                .FeaturedData
                                .performer(performer: $0.toSummary)
                        }
                    let combined = featuredEvents + featuredPerformers
                    self.tableDataRelay.mutableValue.featured = combined.shuffled()
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchRecentlyViewedEvents() {
        //TODO: Implement if you find the time
    }
    
    private func fetchUserRecommendations() {
        //TODO: Implement if you find the time
    }
    
    private func fetchGenres() {
        seatGeekInteractor
            .getAllGenres()
            .subscribeToResult { result in
                switch result {
                case .success(let response):
                    self.tableDataRelay.mutableValue.browseCategories = response.genres
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchCategories() {
        seatGeekInteractor
            .getBrowseCategories()
            .subscribeToResult { result in
                switch result {
                case .success(let response):
                    self.tableDataRelay.mutableValue.genres = response.genres.map {
                        return GenreSection(
                            name: $0.0,
                            events: $0.1.map { $0.toSummary })
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func mockData() {
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
            .category(name: "A", data: [.stub(), .stub(), .stub(), .stub()]),
            .category(name: "B", data: [.stub(), .stub(), .stub(), .stub()]),
            .category(name: "C", data: [.stub(), .stub(), .stub(), .stub()]),
            .category(name: "D", data: [.stub(), .stub(), .stub(), .stub()]),
            .category(name: "E", data: [.stub(), .stub(), .stub(), .stub()])
        ]
        valueRelay.accept(.init(sections: sections))
    }
}
