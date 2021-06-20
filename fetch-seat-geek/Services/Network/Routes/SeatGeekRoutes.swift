//
//  SeatGeekRoutes.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import UIKit

enum SeatGeekRoutes: Route {
    enum Constants {
        static let basePath = "https://api.seatgeek.com/2"
        enum Subpaths {
            static let recommendation = "recommendations"
            static let events = "events"
            static let performers = "performers"
            static let venues = "venues"
            static let genres = "genres"
        }
        
        enum Parameters {
            static let perPage = "per_page"
            static let pageNumber = "page"
            static let performerId = "performers.id"
            static let eventId = "events.id"
            static let sort = "sort"
        }
        
        enum DateFormatters {
            static let dateTimeFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-mm-dd"
                return formatter
            }()
        }
        
        enum EventTypes {
            static let comedy = "comedy"
            static let musicFestivals = "music_festival"
            static let broadwayShows = "broadway_tickets_national"
            static let concerts = "concerts"
            static let sports = "sports"
        }
    }
    
    private static var basePath: String {
        Constants.basePath
    }
    
    var path: String {
        switch self {
        case .recommendations(let request):
            return request.path
        case .events(let request):
            return request.path
        case .performers(let request):
            return request.path
        case .venues(let request):
            return request.path
        case .genres(let request):
            return request.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .recommendations(let request):
            return request.method
        case .events(let request):
            return request.method
        case .performers(let request):
            return request.method
        case .venues(let request):
            return request.method
        case .genres(let request):
            return request.method
        }
    }
    
    var headers: [URLQueryItem]? {
        switch self {
        case .recommendations(let request):
            return request.headers
        case .events(let request):
            return request.headers
        case .performers(let request):
            return request.headers
        case .venues(let request):
            return request.headers
        case .genres(let request):
            return request.headers
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .recommendations(let request):
            return request.urlRequest
        case .events(let request):
            return request.urlRequest
        case .performers(let request):
            return request.urlRequest
        case .venues(let request):
            return request.urlRequest
        case .genres(let request):
            return request.urlRequest
        }
    }
    
    var body: Data? {
        switch self {
        case .recommendations(let request):
            return request.body
        case .events(let request):
            return request.body
        case .performers(let request):
            return request.body
        case .venues(let request):
            return request.body
        case .genres(let request):
            return request.body
        }
    }
    
    var parameters: [RouteParameter]? {
        switch self {
        case .recommendations(let request):
            return request.parameters
        case .events(let request):
            return request.parameters
        case .performers(let request):
            return request.parameters
        case .venues(let request):
            return request.parameters
        case .genres(let request):
            return request.parameters
        }
    }
    
    case events(request: EventsRequest)
    case performers(request: PerformersRequest)
    case venues(request: VenuesRequest)
    case recommendations(request: RecommendationsRequest)
    case genres(request: GenresRequest)
    
    enum GenresRequest: Route {
        var path: String {
            let base = "\(basePath)/\(Constants.Subpaths.genres)"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [RouteParameter]? {
            switch self {
            default:
                return nil
            }
        }
        
        case all
        case get(id: String)
    }
    
    enum RecommendationsRequest: Route {
        var path: String {
            let base = "\(basePath)/\(Constants.Subpaths.recommendation)"
            switch self {
            default:
                return base
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [RouteParameter]? {
            switch self {
            case .byEvent(let eventId, let queries):
                let eventIdParam = RouteParameter(
                    name: Constants.Parameters.eventId,
                    value: "\(eventId)")
                return queries.flatMap { $0.toRouteParameters() } + [eventIdParam]
            case .byPerformers(let performersIds, let queries):
                let idsParam = performersIds.map {
                    RouteParameter(
                        name: Constants.Parameters.performerId,
                        value: "\($0)")
                }
                return queries.flatMap { $0.toRouteParameters() } + idsParam
            }
        }
        
        case byEvent(eventId: Int, queries: [SeatGeekQuery])
        case byPerformers(performersIds: [Int], queries: [SeatGeekQuery])
    }
    
    enum EventsRequest: Route {
        var path: String {
            let base = "\(basePath)/\(Constants.Subpaths.events)"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [RouteParameter]? {
            switch self {
            case .all(let queries):
                return queries.flatMap { $0.toRouteParameters() }
            default:
                return nil
            }
        }
        
        case all(queries: [SeatGeekQuery])
        case get(id: String)
    }
    enum PerformersRequest: Route {
        var path: String {
            let base = "\(basePath)/\(Constants.Subpaths.performers)"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [RouteParameter]? {
            switch self {
            case .all(let queries):
                return queries.flatMap { $0.toRouteParameters() }
            default:
                return nil
            }
        }
        
        case all(queries: [SeatGeekQuery])
        case get(id: String)
    }
    enum VenuesRequest: Route {
        var path: String {
            let base = "\(basePath)/\(Constants.Subpaths.venues)"
            switch self {
            case .all:
                return base
            case .get(let id):
                return "\(base)/\(id)"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [URLQueryItem]? {
            return [Headers.json]
        }
        
        var body: Data? {
            return nil
        }
        
        var parameters: [RouteParameter]? {
            switch self {
            case .all(let queries):
                return queries.flatMap { $0.toRouteParameters() }
            default:
                return nil
            }
        }
        
        case all(queries: [SeatGeekQuery])
        case get(id: String)
    }
}

protocol RouteQuery {
    func toRouteParameters() -> [RouteParameter]
}

enum SeatGeekQuery: RouteQuery {
    case hasUpcomingEvents
    case pagination(query: PaginationQuery)
    case hasGenres(genreNames: [String])
    case primaryGenre(is: String)
    case hasEventType(types: [String])
    case search(term: String)
    case inState(state: String)
    case inCountry(country: String)
    case inPostalCode(postalCode: String)
    case inCity(city: String)
    case afterDate(date: Date)
    case withinDateRange(from: Date, to: Date)
    case atDate(date: Date)
    case inGeoLocation(query: GeoLocationQuery)
    case sort(query: SortQuery)
    
    func toRouteParameters() -> [RouteParameter]  {
        switch self {
        case .hasUpcomingEvents:
            return [
                .init(name: "has_upcoming_events", value: "true")
            ]
        case .pagination(let query):
            return query.toRouteParameters()
        case .hasGenres(let genreNames):
            return genreNames.map {
                .init(name: "genres.slug", value: $0)
            }
        case .primaryGenre(let primary):
            return [
                .init(name: "genres[primary].slug", value: primary)
            ]
        case .search(let term):
            return [
                .init(name: "q", value: term)
            ]
        case .inState(let state):
            return [
                .init(name: "state", value: state)
            ]
        case .inCountry(let country):
            return [
                .init(name: "country", value: country)
            ]
        case .inPostalCode(let postalCode):
            return [
                .init(name: "postal_code", value: postalCode)
            ]
        case .inCity(let city):
            return [
                .init(name: "city", value: city)
            ]
        case .afterDate(let date):
            let dateString =
                SeatGeekRoutes
                .Constants
                .DateFormatters
                .dateTimeFormatter
                .string(from: date)
            return [
                .init(name: "datetime_utc.gt", value: dateString)
            ]
        case .withinDateRange(let from, let to):
            let formatter = SeatGeekRoutes
                .Constants
                .DateFormatters
                .dateTimeFormatter
            let fromString = formatter.string(from: from)
            let toString = formatter.string(from: to)
            return [
                .init(name: "datetime_utc.gte", value: fromString),
                .init(name: "datetime_utc.lte", value: toString)
            ]
        case .sort(let query):
            return query.toRouteParameters()
        case .atDate(let date):
            let dateString = SeatGeekRoutes
                .Constants
                .DateFormatters
                .dateTimeFormatter
                .string(from: date)
            return [
                .init(name: "datetime_utc", value: dateString)
            ]
        case .inGeoLocation(let query):
            return query.toRouteParameters()
        case .hasEventType(let types):
            return types.map {
                RouteParameter(name: "taxonomies.name", value: $0)
            }
        }
    }
}

struct GeoLocationQuery: RouteQuery {
    enum DistanceUnits: String {
        case mi, km
    }
    var lat: Double
    var lon: Double
    var units: DistanceUnits = .mi
    var range: Int?
    
    func toRouteParameters() -> [RouteParameter] {
        var params: [RouteParameter] = [
            .init(name: "lat",
                  value: "\(lat)"),
            .init(name: "lon",
                  value: "\(lon)")
        ]
        if let range = range {
            params.append(.init(name: "range", value: "\(range)\(units.rawValue)"))
        }
        return params
    }
}

struct PaginationQuery: RouteQuery {
    var perPage: Int
    var currentPage: Int
    
    func toRouteParameters() -> [RouteParameter] {
        return [
            .init(name: SeatGeekRoutes
                    .Constants.Parameters.perPage,
                  value: "\(perPage)"),
            .init(name: SeatGeekRoutes
                    .Constants.Parameters.pageNumber,
                  value: "\(currentPage)")
        ]
    }
}

struct SortQuery: RouteQuery {
    enum SortField: String {
        case dateLocal = "datetime_local"
        case dateUtc = "datetime_utc"
        case announceDate = "announce_date"
        case id = "id"
        case score = "score"
    }
    enum SortDirection: String {
        case ascending = "asc", descending = "desc"
    }
    
    var field: SortField
    var direction: SortDirection
    
    func toRouteParameters() -> [RouteParameter] {
        return [
            .init(
                name: SeatGeekRoutes
                    .Constants.Parameters.sort,
                value: "\(field.rawValue).\(direction.rawValue)")
        ]
    }
}
