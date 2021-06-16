//
//  SeatGeekInteractorTests.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Quick
import Nimble
import RxSwift

@testable import fetch_seat_geek

class SeatGeekInteractorTests: QuickSpec {
    override func spec() {
        var disposeBag = DisposeBag()
        var resultBuilder: NetworkResultBuilder!
        var mockNetwork: NetworkServiceMock!
        var mockLogger: LoggerMock!
        var sut: SeatGeekInteractor!
        
        enum Responses {
            enum Files {
                static let allEvents = "EventsResponse"
                static let getEvent = "GetEventResponse"
                static let allPerformers = "PerformersResponse"
                static let getPerformer = "GetPerformerResponse"
                static let allVenues = "VenuesResponse"
                static let getVenue = "GetVenueResponse"
            }
            enum Fields {
                static let getEventId = 5176112
                static let getPerformerId = 11591
                static let getVenueId = 4965
            }
        }
        
        beforeEach {
            resultBuilder = NetworkResultBuilder()
            resultBuilder.url = URL(string: "http://www.test.com")!
            mockNetwork = NetworkServiceMock()
            mockLogger = LoggerMock()
            sut = SeatGeekInteractor(
                networkService: mockNetwork,
                logger: mockLogger)
        }
        context("Valid responses") {
            describe("Given a valid getEvent response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.getEvent
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getEvent(id: "")
                        .subscribeToResult { result in
                            switch result {
                            case .success(let event):
                                expect(event.id)
                                    .toEventually(
                                        equal(Responses.Fields.getEventId),
                                        timeout: .milliseconds(500))
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            describe("Given a valid allEvents response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.allEvents
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getAllEvents(page: 1, perPage: 10)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let events):
                                print()
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            describe("Given a valid getPerformer response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.getPerformer
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getPerformer(id: "")
                        .subscribeToResult { result in
                            switch result {
                            case .success(let performer):
                                expect(performer.id)
                                    .toEventually(
                                        equal(Responses.Fields.getPerformerId),
                                        timeout: .milliseconds(500))
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            describe("Given a valid allPerformers response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.allPerformers
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getAllPerformers(page: 1, perPage: 10)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let performers):
                                print()
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            describe("Given a valid getVenue response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.getVenue
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getVenue(id: "")
                        .subscribeToResult { result in
                            switch result {
                            case .success(let venue):
                                expect(venue.id)
                                    .toEventually(
                                        equal(Responses.Fields.getVenueId),
                                        timeout: .milliseconds(500))
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            describe("Given a valid allVenues response") {
                it("Should return a successful decoded result") {
                    resultBuilder.responseFileName = Responses.Files.allVenues
                    mockNetwork.responseToSend = .success(result: resultBuilder.build()!)
                    sut
                        .getAllVenues(page: 1, perPage: 10)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let venues):
                                print()
                            default:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
        }
        
        context("Error responses") {
            
        }
    }
}
