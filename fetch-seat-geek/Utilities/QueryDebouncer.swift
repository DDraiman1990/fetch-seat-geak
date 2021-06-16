//
//  QueryDebouncer.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import RxSwift

/// A simple object to debounce an equatable query.
///
/// - Example: If you want to debounce a search query on the main thread:
/// ```
/// let searchDebouncer = QueryDebouncer<String, DispatchQueue>(0.5, .main, removeDups: true) { term in
/// // do something with `term`...
///}
///```
final class QueryDebouncer<T: Equatable, S: SchedulerType> {
    typealias OnValueReceived =  (T) -> Void
    private let disposeBag = DisposeBag()
    private var debouncer: PublishSubject<T> = .init()
    
    init(debounce: DispatchTimeInterval,
         queue: S,
         removeDups: Bool = true,
         onValueReceived: @escaping OnValueReceived) {
        debouncer(removeDups: removeDups)
            .debounce(debounce, scheduler: queue)
            .subscribe { value in
                onValueReceived(value)
            }
            .disposed(by: disposeBag)
    }
    
    private func debouncer(removeDups: Bool) -> Observable<T> {
        if removeDups {
            return debouncer
                .distinctUntilChanged()
                .asObservable()
        }
        return debouncer
            .asObservable()
    }
    
    func send(value: T) {
        debouncer.onNext(value)
    }
}

