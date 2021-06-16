//
//  QueryDebouncer.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import Combine

/// A simple object to debounce an equatable query.
///
/// - Example: If you want to debounce a search query on the main thread:
/// ```
/// let searchDebouncer = QueryDebouncer<String, DispatchQueue>(0.5, .main, removeDups: true) { term in
/// // do something with `term`...
///}
///```
final class QueryDebouncer<T: Equatable, S: Scheduler> {
    typealias OnValueReceived =  (T) -> Void
    private var subscriptions = Set<AnyCancellable>()
    private var debouncer: PassthroughSubject<T, Never> = .init()
    
    init(debounce: S.SchedulerTimeType.Stride,
         queue: S,
         removeDups: Bool = true,
         onValueReceived: @escaping OnValueReceived) {
        debouncer(removeDups: removeDups)
            .debounce(for: debounce, scheduler: queue)
            .sink(receiveValue: { value in
                onValueReceived(value)
            }).store(in: &subscriptions)
    }
    
    private func debouncer(removeDups: Bool) -> AnyPublisher<T, Never> {
        if removeDups {
            return debouncer
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        return debouncer
            .eraseToAnyPublisher()
    }
    
    func send(value: T) {
        debouncer.send(value)
    }
}

