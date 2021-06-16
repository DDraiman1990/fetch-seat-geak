//
//  LoggerTests.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/14/21.
//

import Quick
import Nimble
import RxSwift

@testable import fetch_seat_geek

class LoggerTests: QuickSpec {

    override func spec() {
        struct TestError: LocalizedError {
            var errorDescription: String? {
                return "ErrorDescription"
            }
        }
        func createSut(
            core: CoreLogger,
            crashReporter: CrashReporter?) -> OSLogger {
            let logger = OSLogger(core: core, crashReporter: crashReporter)
            return logger
        }
        
        var core: CoreLoggerMock!
        var reporter: CrashReporterMock!
        var sut: OSLogger!
        
        beforeEach {
            core = CoreLoggerMock()
            reporter = CrashReporterMock()
            sut = createSut(core: core, crashReporter: reporter)
        }
        
        context("Log levels") {
            beforeEach {
                sut.set(format: LogFormat(allAs: false))
            }
            let testString = "TestString"
            describe("given a string is logged in info level") {
                it("should log it to info level") {
                    sut.info(testString)
                    expect(core.logs[0].string).to(equal(testString))
                    expect(core.logs[0].level).to(equal(.info))
                }
            }
            describe("given a string is logged in error level") {
                it("should log it to error level") {
                    sut.error(testString)
                    expect(core.logs[0].string).to(equal(testString))
                    expect(core.logs[0].level).to(equal(.error))
                }
            }
            describe("given a string is logged in default level") {
                it("should log it to default level") {
                    sut.default(testString)
                    expect(core.logs[0].string).to(equal(testString))
                    expect(core.logs[0].level).to(equal(.default))
                }
            }
            describe("given a string is logged in debug level") {
                it("should log it to debug level") {
                    sut.debug(testString)
                    expect(core.logs[0].string).to(equal(testString))
                    expect(core.logs[0].level).to(equal(.debug))
                }
            }
            describe("given a string is logged in fault level") {
                it("should log it to fault level") {
                    sut.fault(testString)
                    expect(core.logs[0].string).to(equal(testString))
                    expect(core.logs[0].level).to(equal(.fault))
                }
            }
        }
        
        context("Logged errors") {
            beforeEach {
                sut.set(format: LogFormat(allAs: false))
            }
            
            describe("given an error logged as an object") {
                it("should log its description") {
                    sut.error(TestError())
                    expect(core.logs[0].string).to(equal(TestError().errorDescription))
                }
            }
        }
        
        context("Crash reports") {
            beforeEach {
                sut.set(format: LogFormat(allAs: false))
            }
            describe("Given crash reporting is set") {
                it("should not log crashes if crash logging is turned off") {
                    let testString = "test"
                    sut.crashReporting = false
                    sut.info(testString)
                    expect(reporter.crashesLogged).to(beEmpty())
                }
                
                it("should log crashes if crash logging is turned on") {
                    let testString = "test"
                    sut.crashReporting = true
                    sut.info(testString)
                    expect(reporter.crashesLogged[0]).to(equal(testString))
                }
                
                it("should only log crash events if level is default or info") {
                    let testInfoString = "testInfoString"
                    let testDefaultString = "testDefaultString"
                    let testErrorString = "testErrorString"
                    sut.crashReporting = true
                    sut.info(testInfoString)
                    sut.default(testDefaultString)
                    sut.error(testErrorString)
                    expect(reporter.crashesLogged[0]).to(equal(testInfoString))
                    expect(reporter.crashesLogged[1]).to(equal(testDefaultString))
                    expect(reporter.crashesLogged.count).to(equal(2))
                }
            }
        }
    }
}

