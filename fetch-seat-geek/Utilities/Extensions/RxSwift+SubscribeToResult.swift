//
//  RxSwift+SubscribeToResult.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/12/21.
//

import RxSwift

extension Observable {
    func subscribeToResult(_ result: @escaping (Result<Element, Error>) -> Void) -> Disposable {
        return subscribe { element in
            result(.success(element))
        } onError: { error in
            result(.failure(error))
        }
    }
    
    func subscribeToValue(_ result: @escaping (Element) -> Void) -> Disposable {
        return subscribe { element in
            result(element)
        }
    }
}
