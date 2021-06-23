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
        var disposeBag = DisposeBag()
        var mockLogger: LoggerMock!
        var sut: TrackedManager!
        
        beforeEach {
            disposeBag = .init()
            mockLogger = LoggerMock()
            
        }
        
        describe("Tracked changes") {
            context("Given event added") {
                it("should send onTrackedChanged event") {
                    
                }
            }
        }
    }
}
