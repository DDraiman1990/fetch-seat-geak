//
//  NetworkServiceTests.swift
//  
//
//  Created by Dan Draiman on 6/13/21.
//

import Quick
import Nimble
import RxSwift

@testable import fetch_seat_geek

class NetworkServiceTests: QuickSpec {
    
    override func spec() {
        var disposeBag = DisposeBag()
        let stubbedRequest = URLRequest(url: URL(string: "http://www.mockrequest.com")!)
        
        func createSut(
            plugins: [NetworkPlugin],
            onRequestMade: ((URLRequest) -> Void)? = nil
        ) -> NetworkService {
            let session = URLSessionMock()
            session.onUrl = { url in
                onRequestMade?(URLRequest(url: url))
            }
            session.onUrlRequest = onRequestMade
            return NetworkService(
                session: session,
                plugins: plugins)
        }
        
        describe("Network Requests") {
            beforeEach {
                disposeBag = .init()
            }
            
            context("Given a request is made via Route") {
                it("should be identical to a manually build URLRequest") {
                    let path = "http://www.test.com/"
                    let route = GenericRoute(
                        path: path,
                        method: .get,
                        body: nil,
                        headers: nil,
                        parameters: nil)
                    var manualRequest = URLRequest(url: URL(string: path)!)
                    manualRequest.httpMethod = "GET"
                    
                    expect(manualRequest.url?.absoluteString)
                        .to(equal(route.urlRequest.url?.absoluteString))
                    
                    let sut = createSut(plugins: []) { urlRequest in
                        expect(manualRequest.url?.absoluteString)
                            .toEventually(
                                equal(urlRequest.url?.absoluteString),
                                timeout: .milliseconds(500))
                    }
                    sut
                        .makeRequest(route: route)
                        .subscribeToResult { _ in }
                        .disposed(by: disposeBag)
                }
            }
            
            context("Given no plugin added") {
                it("should keep the request the same") {
                    let sut = createSut(plugins: []) { urlRequest in
                        expect(stubbedRequest)
                            .toEventually(equal(urlRequest), timeout: .milliseconds(500))
                    }
                    sut
                        .makeRequest(request: stubbedRequest)
                        .subscribeToResult { _ in }
                        .disposed(by: disposeBag)
                }
                
                it("should respond with the same URL") {
                    let sut = createSut(plugins: [])
                    sut
                        .makeRequest(request: stubbedRequest)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let result):
                                expect(result.response?.url)
                                    .toEventually(equal(stubbedRequest.url), timeout: .milliseconds(500))
                            default:
                                fail("Request failed")
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
            context("Given modifer plugin added") {
                beforeEach {
                    disposeBag = .init()
                }
                let modifiedUrl = URLRequest(url: URL(string: "http://www.modified.com/")!)
                let modifierPlugin = NetworkPluginMock { _ in
                    return modifiedUrl
                }
                
                it("should modify the request") {
                    let sut = createSut(plugins: [modifierPlugin]) { urlRequest in
                        expect(stubbedRequest)
                            .toEventuallyNot(equal(urlRequest), timeout: .milliseconds(500))
                        expect(urlRequest)
                            .toEventually(equal(modifiedUrl), timeout: .milliseconds(500))
                    }
                    sut
                        .makeRequest(request: stubbedRequest)
                        .subscribeToResult { _ in }
                        .disposed(by: disposeBag)
                }
                
                it("should respond with the same URL") {
                    let sut = createSut(plugins: [])
                    sut
                        .makeRequest(request: stubbedRequest)
                        .subscribeToResult { result in
                            switch result {
                            case .success(let result):
                                expect(result.response?.url)
                                    .toEventually(equal(stubbedRequest.url), timeout: .milliseconds(500))
                            default:
                                fail("Request failed")
                            }
                        }
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
