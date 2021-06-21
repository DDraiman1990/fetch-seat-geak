//
//  SeatGeekInteractor.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
import RxSwift

protocol SeatGeekInteracting {
    func getAllEvents(queries: [SeatGeekQuery]) -> Observable<SGEventsResponse>
    func getEvent(id: String) -> Observable<SGEvent>
    func getAllPerformers(queries: [SeatGeekQuery]) -> Observable<SGPerformersResponse>
    func getPerformersWithUpcoming() -> Observable<SGPerformersResponse>
    func getPerformer(id: String) -> Observable<SGPerformer>
    func getAllVenues(queries: [SeatGeekQuery]) -> Observable<SGVenuesResponse>
    func getVenue(id: String) -> Observable<SGVenue>
    func getGenre(id: String) -> Observable<SGGenre>
    func getAllGenres() -> Observable<SGGenresResponse>
    func getBrowseCategories() -> Observable<SGBrowseGenresResponse>
    func recommendedEvents(
        byEventId: Int,
        queries: [SeatGeekQuery]
    ) -> Observable<SGEventsResponse>
    func recommendedEvents(
        byPerformersIds: [Int], 
        queries: [SeatGeekQuery]
    ) -> Observable<SGEventsResponse>
}

class SeatGeekInteractor: SeatGeekInteracting {
    
    // MARK: - Properties | Dependencies
    
    private let networkService: NetworkServicing
    private let logger: Logger
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }
            throw NetworkError.decodingError
        })
        return decoder
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    init(
        networkService: NetworkServicing,
        logger: Logger) {
        self.networkService = networkService
        self.logger = logger
    }
    
    // MARK: - Methods | Helpers
    
    private func request<T: Decodable>(route: Route) -> Observable<T> {
        return networkService
            .makeRequest(route: route)
            .map { networkResult -> T in
                guard let data = networkResult.data,
                      let model = try? self.decoder.decode(T.self, from: data) else {
                    throw NetworkError.decodingError
                }
                return model
            }
            .asObservable()
    }
    
    // MARK: - Methods | SeatGeekInteracting
    
    func getAllEvents(queries: [SeatGeekQuery]) -> Observable<SGEventsResponse> {
        return request(
            route: SeatGeekRoutes
                .events(request: .all(queries: queries)))
    }
    
    func getEvent(id: String) -> Observable<SGEvent> {
        return request(
            route: SeatGeekRoutes
                .events(request: .get(id: id)))
    }
    
    func getAllPerformers(queries: [SeatGeekQuery]) -> Observable<SGPerformersResponse> {
        return request(
            route: SeatGeekRoutes
                .performers(request: .all(queries: queries)))
    }
    
    func getPerformer(id: String) -> Observable<SGPerformer> {
        return request(
            route: SeatGeekRoutes
                .performers(request: .get(id: id)))
    }
    
    func getPerformersWithUpcoming() -> Observable<SGPerformersResponse> {
        return request(
            route: SeatGeekRoutes
                .performers(request: .all(queries: [
                    .hasUpcomingEvents,
                    .sort(query: .init(field: .score, direction: .descending)),
                    .pagination(query: .init(perPage: 4, currentPage: 1))
                ])))
    }
    
    func getAllVenues(queries: [SeatGeekQuery]) -> Observable<SGVenuesResponse> {
        return request(
            route: SeatGeekRoutes
                .venues(request: .all(queries: queries)))
    }
    
    func getVenue(id: String) -> Observable<SGVenue> {
        return request(
            route: SeatGeekRoutes
                .venues(request: .get(id: id)))
    }
    
    func recommendedEvents(
        byEventId id: Int,
        queries: [SeatGeekQuery]
    ) -> Observable<SGEventsResponse> {
        return request(
            route: SeatGeekRoutes
                .recommendations(request: .byEvent(
                                    eventId: id,
                                    queries: queries)))
    }
    
    func recommendedEvents(
        byPerformersIds ids: [Int],
        queries: [SeatGeekQuery]
    ) -> Observable<SGEventsResponse> {
        return request(
            route: SeatGeekRoutes
                .recommendations(request: .byPerformers(
                                    performersIds: ids,
                                    queries: queries)))
    }
    
    func getAllGenres() -> Observable<SGGenresResponse> {
        return request(
            route: SeatGeekRoutes.genres(request: .all))
    }
    
    func getGenre(id: String) -> Observable<SGGenre> {
        return request(
            route: SeatGeekRoutes.genres(request: .get(id: id)))
    }
    
    private func categoryRequest(category: String
    ) -> Observable<SGEventsResponse> {
        return request(route: SeatGeekRoutes.events(request: .all(queries: [
            SeatGeekQuery.hasEventType(types: [category]),
            .sort(query: .init(field: .score, direction: .descending)),
            .pagination(query: .init(perPage: 10, currentPage: 1))
        ])))
    }
    
    func getBrowseCategories() -> Observable<SGBrowseGenresResponse> {
        let broadwayShowsRequest = categoryRequest(category: SeatGeekRoutes.Constants.EventTypes.broadwayShows)
        let comedyRequest = categoryRequest(category: SeatGeekRoutes.Constants.EventTypes.comedy)
        let concertsRequest = categoryRequest(category: SeatGeekRoutes.Constants.EventTypes.concerts)
        let sportsRequest = categoryRequest(category: SeatGeekRoutes.Constants.EventTypes.sports)
        let musicFestivalsRequest = categoryRequest(category: SeatGeekRoutes.Constants.EventTypes.musicFestivals)
        return Observable.zip([
            sportsRequest,
            comedyRequest,
            concertsRequest,
            musicFestivalsRequest,
            broadwayShowsRequest
        ])
        .map { response -> SGBrowseGenresResponse in
            return SGBrowseGenresResponse.init(genres: [
                .init(name: "Sports",
                      slug: SeatGeekRoutes.Constants.EventTypes.sports,
                      evnets: response[0].events),
                .init(name: "Comedy",
                      slug: SeatGeekRoutes.Constants.EventTypes.comedy,
                      evnets: response[1].events),
                .init(name: "Concerts",
                      slug: SeatGeekRoutes.Constants.EventTypes.concerts,
                      evnets: response[2].events),
                .init(name: "Music Festivals",
                      slug: SeatGeekRoutes.Constants.EventTypes.musicFestivals,
                      evnets: response[3].events),
                .init(name: "Broadway Shows",
                      slug: SeatGeekRoutes.Constants.EventTypes.broadwayShows,
                      evnets: response[4].events)
            ])
        }
    }
}
