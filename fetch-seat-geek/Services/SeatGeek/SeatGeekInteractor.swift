//
//  SeatGeekInteractor.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import Foundation
import RxSwift

protocol SeatGeekInteracting {
    func getAllEvents(
        page: Int,
        perPage: Int
    ) -> Observable<SGEventsResponse>
    
    func getEvent(id: String) -> Observable<SGEvent>
    func getAllPerformers(
        page: Int,
        perPage: Int
    ) -> Observable<SGPerformersResponse>
    func getPerformer(id: String) -> Observable<SGPerformer>
    func getAllVenues(
        page: Int,
        perPage: Int
    ) -> Observable<SGVenuesResponse>
    func getVenue(id: String) -> Observable<SGVenue>
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
    
    func getAllEvents(
        page: Int,
        perPage: Int
    ) -> Observable<SGEventsResponse> {
        return request(route: SeatGeekRoutes
                        .events(request: .all(
                                        perPage: perPage,
                                        page: page)))
    }
    
    func getEvent(id: String) -> Observable<SGEvent> {
        return request(route: SeatGeekRoutes.events(request: .get(id: id)))
    }
    
    func getAllPerformers(
        page: Int,
        perPage: Int
    ) -> Observable<SGPerformersResponse> {
        return request(route: SeatGeekRoutes
                        .performers(request: .all(
                                        perPage: perPage,
                                        page: page)))
    }
    
    func getPerformer(id: String) -> Observable<SGPerformer> {
        return request(route: SeatGeekRoutes.performers(request: .get(id: id)))
    }
    
    func getAllVenues(
        page: Int,
        perPage: Int
    ) -> Observable<SGVenuesResponse> {
        return request(route: SeatGeekRoutes
                        .venues(request: .all(
                                        perPage: perPage,
                                        page: page)))
    }
    
    func getVenue(id: String) -> Observable<SGVenue> {
        return request(route: SeatGeekRoutes.venues(request: .get(id: id)))
    }
}
