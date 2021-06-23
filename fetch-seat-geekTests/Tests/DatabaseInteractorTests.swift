//
//  DatabaseInteractorTests.swift
//  fetch-seat-geekTests
//
//  Created by Dan Draiman on 6/23/21.
//

import Quick
import Nimble
import RxSwift

@testable import fetch_seat_geek

class DatabaseInteractorTests: QuickSpec {
    
    override func spec() {
        let suiteName = "fetch-seat-geek-tests"
        let testKey = "testKey"
        let testString = "SomeValue"
        var sut: DatabaseInteractor!
        
        func createSut() {
            UserDefaults(suiteName: suiteName)?.removeAll()
            sut = .init(suiteName: suiteName)
        }
        beforeEach {
            
            createSut()
        }
        
        describe("Storing Objects") {
            context("given a string") {
                it("should store it succesffuly") {
                    do {
                        try sut.store("SomeString", forKey: testKey)
                    }
                    catch {
                        fail()
                    }
                }
            }
            
            context("given an int/double/float") {
                it("should store it succesffuly") {
                    do {
                        let a = 1
                        let b: Float = 1.0
                        let c: Double = 1.0
                        try sut.store(a, forKey: testKey + "a")
                        try sut.store(b, forKey: testKey + "b")
                        try sut.store(c, forKey: testKey + "c")
                    }
                    catch {
                        fail()
                    }
                }
            }
            
            context("given any collection") {
                it("should store it succesffuly") {
                    do {
                        let a = [1,2,3]
                        let b: Set<Int> = [1, 2, 3]
                        let c: [String: String] = ["a": "b"]
                        try sut.store(a, forKey: testKey + "a")
                        try sut.store(b, forKey: testKey + "b")
                        try sut.store(c, forKey: testKey + "c")
                    }
                    catch {
                        fail()
                    }
                }
            }
        }
        
        describe("Getting Objects") {
            context("given database contains object") {
                beforeEach {
                    try! sut.store(testString, forKey: testKey)
                }
                it("should get it succesffuly") {
                    do {
                        let string: String = try sut.get(key: testKey)
                        expect(string).to(equal(testString))
                    }
                    catch {
                        fail()
                    }
                }
            }
            
            context("given database doesn't contain object") {
                it("should throw an error") {
                    let test: String? = try? sut.get(key: testKey)
                    expect(test)
                        .to(beNil())
                    do {
                        let string: String = try sut.get(key: testKey)
                        fail()
                    }
                    catch {}
                }
            }
            
            context("given an int/double/float") {
                it("should store it succesffuly") {
                    do {
                        let a = 1
                        let b: Float = 1.0
                        let c: Double = 1.0
                        try sut.store(a, forKey: testKey + "a")
                        try sut.store(b, forKey: testKey + "b")
                        try sut.store(c, forKey: testKey + "c")
                    }
                    catch {
                        fail()
                    }
                }
            }
            
            context("given any collection") {
                it("should store it succesffuly") {
                    do {
                        let a = [1,2,3]
                        let b: Set<Int> = [1, 2, 3]
                        let c: [String: String] = ["a": "b"]
                        try sut.store(a, forKey: testKey + "a")
                        try sut.store(b, forKey: testKey + "b")
                        try sut.store(c, forKey: testKey + "c")
                    }
                    catch {
                        fail()
                    }
                }
            }
        }
    }
}

private extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach { tuple in
            removeObject(forKey: tuple.key)
        }
    }
}
