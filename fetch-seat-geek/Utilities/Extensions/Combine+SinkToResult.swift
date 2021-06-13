//
//  Combine+SinkToResult.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/12/21.
//

import Combine

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
}
