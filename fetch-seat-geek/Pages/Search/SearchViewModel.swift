//
//  SearchViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

final class SearchViewModel: ViewModel {
    typealias Consumer = SearchViewController
    
    // MARK: - Properties | Dependencies
    
    private let seatGeekInteractor: SeatGeekInteracting
    private let logger: Logger
    
    // MARK: - Properties | ViewModel
    
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init())
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<Consumer.Model>> {
        return valueRelay.asObservable().toModelUpdate()
    }
    
    private let presentRelay: PublishSubject<UIViewController> = .init()
    var presentPublisher: Observable<UIViewController> {
        return presentRelay.share().asObservable()
    }
    
    // MARK: - Properties
    
    private lazy var debouncer = QueryDebouncer<String, MainScheduler>(debounce: .milliseconds(750), queue: .instance, removeDups: true) { [weak self] text in
        self?.search(text: text)
    }
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    init(resolver: DependencyResolving) {
        self.seatGeekInteractor = resolver.resolve()
        self.logger = resolver.resolve()
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .eventTapped(let id):
            let eventDetails = PageFactory.eventsDetails(eventId: id)
            presentRelay.onNext(eventDetails)
        case .searchTermChanged(let text):
            debouncer.send(value: text ?? "")
        case .viewLoaded:
            break
        }
    }
    
    // MARK: - Methods | Data Fetching
    
    private func search(text: String) {
        seatGeekInteractor
            .getAllEvents(queries: [
                .search(term: text)
            ])
            .subscribeToResult { [weak self] result in
                switch result {
                case .success(let response):
                    self?.valueRelay.mutableValue.results = response.events.map {
                        $0.toSummary
                    }
                case .failure(let error):
                    self?.logger.error(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
