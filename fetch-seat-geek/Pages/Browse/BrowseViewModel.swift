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
        var slug: String
        var events: [SGEventSummary]
    }

    private struct TableData: Equatable {
        var featured: [FeaturedData]?
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
                        categorySlug: $0.slug,
                        data: $0.events)
                }
            }
            return sections
        }
    }
    // MARK: - Properties | Dependencies
    
    private let seatGeekInteractor: SeatGeekInteracting
    private let trackedManager: TrackedManaging
    private let logger: Logger
    
    // MARK: - Properties | ViewModel
    
    private let tableDataRelay: BehaviorRelay<TableData> = .init(value: .init())
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init(location: "Joliet, IL", dates: "All Dates"))
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<BrowseViewController.Model>> {
        return valueRelay.share().asObservable().toModelUpdate()
    }
    
    private let presentRelay: PublishSubject<UIViewController> = .init()
    var presentPublisher: Observable<UIViewController> {
        return presentRelay.share().asObservable()
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(resolver: DependencyResolving) {
        self.seatGeekInteractor = resolver.resolve()
        self.trackedManager = resolver.resolve()
        
        tableDataRelay
            .asObservable()
            .subscribeToValue { [weak self] data in
                self?.valueRelay.mutableValue.sections = data.sections
            }
            .disposed(by: disposeBag)
        trackedManager
            .onTrackedChanged
            .subscribeToValue { [weak self] ids in
                self?.valueRelay.mutableValue.trackedIds = ids
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .viewLoaded:
            fetchBrowseData()
        case .viewAppeared:
            break
        case .onTapped(row: let row, section: let section):
            onTapped(row: row, section: section)
        case .trackTappedFor(id: let id):
            trackedManager.toggleTracked(id: id)
                .subscribeToValue { [weak self] isTracked in
                    self?.logger.info("Id \(id) is now \(isTracked ? "tracked" : "untracked")")
                }
                .disposed(by: disposeBag)
        case .tappedViewAll(section: let section):
            logger.info("Should show more for section \(section.header ?? "N/A") if I had time to implement it")
        case .tappedDateAndLocation:
            logger.info("Should show date selection if I had time to implement it")
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
            .subscribeToResult { [weak self] result in
                switch result {
                case .success(let tupleResponse):
                    let featuredEvents = tupleResponse
                        .0
                        .events
                        .map {
                            FeaturedData.event(summary: $0.toSummary)
                        }
                    let featuredPerformers = tupleResponse
                        .1
                        .performers
                        .map {
                            FeaturedData
                                .performer(performer: $0.toSummary)
                        }
                    let combined = featuredEvents + featuredPerformers
                    self?.tableDataRelay.mutableValue.featured = combined.shuffled()
                case .failure(let error):
                    self?.logger.error(error)
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
            .subscribeToResult { [weak self] result in
                switch result {
                case .success(let response):
                    self?.tableDataRelay.mutableValue.browseCategories = response.genres
                case .failure(let error):
                    self?.logger.error(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchCategories() {
        seatGeekInteractor
            .getBrowseCategories()
            .subscribeToResult { [weak self] result in
                switch result {
                case .success(let response):
                    self?.tableDataRelay.mutableValue.genres = response.genres.map {
                        return GenreSection(
                            name: $0.name,
                            slug: $0.slug,
                            events: $0.evnets.map { $0.toSummary })
                    }
                case .failure(let error):
                    self?.logger.error(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func onSelected(event: SGEventSummary) {
        logger.info("Selected \(event.id)")
        let eventDetails = PageFactory.eventsDetails(eventId: event.id)
        presentRelay.onNext(eventDetails)
    }
    
    private func onSelected(genre: SGGenre) {
        logger.info("Should show genre \(genre.name) details if I had time to implement this.")
    }
    
    private func onSelected(performer: SGPerformerSummary) {
        logger.info("Should show performer \(performer.name) details if I had time to implement this.")
    }
    
    private func onSelected(index: Int,
                            from featured: [FeaturedData]) {
        if let data = featured.elementIfExists(index: index) {
            switch data {
            case .event(let summary):
                onSelected(event: summary)
            case .performer(let performer):
                onSelected(performer: performer)
            }
        }
    }
    
    private func onSelected(eventIndex: Int, from events: [SGEventSummary]) {
        if let event = events.elementIfExists(index: eventIndex) {
            onSelected(event: event)
        }
    }
    
    private func onSelected(genreIndex: Int, from genres: [SGGenre]) {
        if let genre = genres.elementIfExists(index: genreIndex) {
            onSelected(genre: genre)
        }
    }
    
    private func onTapped(row: Int, section: BrowseSection) {
        switch section {
        case .browseCategories(let genres):
            onSelected(genreIndex: row, from: genres)
        case .category(_, _, let events):
            onSelected(eventIndex: row, from: events)
        case .featured(let featuredData):
            onSelected(index: row, from: featuredData)
        case .justAnnounced(let events):
            onSelected(eventIndex: row, from: events)
        case .justForYou(let events):
            onSelected(eventIndex: row, from: events)
        case .recentlyViewed(let events):
            onSelected(eventIndex: row, from: events)
        case .trendingEvents(let events):
            onSelected(eventIndex: row, from: events)
        }
    }
}
