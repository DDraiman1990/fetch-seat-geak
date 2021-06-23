//
//  TrackedManagerTests.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import Quick
import Nimble
import RxSwift

@testable import fetch_seat_geek

class TrackedManagerTests: QuickSpec {
    
    override func spec() {
        let testId = 123
        var disposeBag = DisposeBag()
        var mockLogger: LoggerMock!
        var sut: TrackedManager!
        var mockDatabaseInteractor: DatabaseInteractorMock!
        
        
        func createSut(initialData: Set<Int> = .init()) {
            disposeBag = .init()
            mockLogger = .init()
            mockDatabaseInteractor = .init(storedData: initialData)
            sut = .init(
                databaseInteractor: mockDatabaseInteractor,
                logger: mockLogger)
        }
        
        describe("Tracked changes") {
            context("Given id is not tracked") {
                beforeEach {
                    createSut()
                    expect(sut.trackedIds)
                        .toNot(contain(testId))
                }
                it("should send onTrackedChanged event when added") {
                    sut
                        .onTrackedChanged
                        .skip(1)
                        .subscribeToValue({ ids in
                            expect(ids)
                                .toEventually(contain(testId))
                        })
                        .disposed(by: disposeBag)
                    sut
                        .addToTracked(id: testId)
                        .subscribeToResult { _ in}
                        .disposed(by: disposeBag)
                }
                it("should add the id to the trackedIds when added") {
                    sut
                        .addToTracked(id: testId)
                        .subscribeToResult { result in
                            switch result {
                            case .success:
                                expect(sut.trackedIds)
                                    .toEventually(contain(testId))
                            case .failure:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
                it("should add the id if toggled") {
                    sut
                        .toggleTracked(id: testId)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let isTracked):
                                expect(sut.trackedIds)
                                    .toEventually(contain(testId))
                                expect(isTracked)
                                    .toEventually(beTrue())
                            case .failure:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            
            context("Given id is already tracked") {
                beforeEach {
                    createSut(initialData: [testId])
                    expect(sut.trackedIds)
                        .to(contain(testId))
                }
                it("should send onTrackedChanged event when removed") {
                    sut
                        .onTrackedChanged
                        .skip(1)
                        .subscribeToValue({ ids in
                            expect(ids)
                                .toEventuallyNot(contain(testId))
                        })
                        .disposed(by: disposeBag)
                    sut
                        .removeFromTracked(id: testId)
                        .subscribeToResult { _ in}
                        .disposed(by: disposeBag)
                }
                it("should remove id from trackedIds when removed") {
                    sut
                        .removeFromTracked(id: testId)
                        .subscribeToResult { result in
                            switch result {
                            case .success:
                                expect(sut.trackedIds)
                                    .toEventuallyNot(contain(testId))
                            case .failure:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
                it("should remove id when toggled") {
                    sut
                        .toggleTracked(id: testId)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let isTracked):
                                expect(sut.trackedIds)
                                    .toEventuallyNot(contain(testId))
                                expect(isTracked)
                                    .toEventually(beFalse())
                            case .failure:
                                fail()
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
