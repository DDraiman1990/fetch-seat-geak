//
//  TrackedViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//


import UIKit
import RxSwift
import RxCocoa
import Nuke

final class TrackedViewModel: ViewModel {
    typealias Consumer = TrackedViewController
    
    // MARK: - Properties | Dependencies
    
    private let seatGeekInteractor: SeatGeekInteracting
    private let trackedManager: TrackedManaging

    // MARK: - Properties | ViewModel
    
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init(pageTitle: R.string.main.tracked_tab_title()))
    
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
    
    private let disposeBag = DisposeBag()
    private var eventCache: [Int: SGEvent] = [:]

    // MARK: - Lifecycle
    
    init(resolver: DependencyResolving) {
        self.seatGeekInteractor = resolver.resolve()
        self.trackedManager = resolver.resolve()
        
        trackedManager
            .onTrackedChanged
            .subscribeToValue { trackedIds in
            self.fetchTrackedEvents()
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .viewLoaded:
            fetchTrackedEvents()
        case .eventTapped(let id):
            let eventDetails = PageFactory.eventsDetails(eventId: id)
            presentRelay.onNext(eventDetails)
        }
    }
    
    // MARK: - Methods | Data Fetching
    
    private func fetchTrackedEvents() {
        var requests: [Observable<SGEvent>] = []
        for id in trackedManager.trackedIds {
            if let event = self.eventCache[id] {
                requests.append(Observable.just(event))
            } else {
                let request = seatGeekInteractor
                    .getEvent(id: "\(id)")
                    .do(onNext: { [weak self] event in
                        self?.eventCache[event.id] = event
                    })

                requests.append(request)
            }
        }
        Observable.merge(requests).toArray()
            .subscribe { [weak self] events in
                self?.valueRelay.mutableValue.events = events.map { event -> Consumer.TrackedEvent in
                    let price = event.stats.lowestPrice
                    let priceText = "\(price ?? 0)+"
                    let dateText = AppConstants
                        .DateFormatters
                        .shortDateFormatter
                        .string(from: event.datetimeLocal)
                    let subtitle = "\(dateText) at \(event.venue.displayLocation)"
                    return Consumer.TrackedEvent(
                        id: event.id,
                        title: event.title,
                        subtitle: subtitle,
                        price: price != nil ? priceText : nil,
                        imageUrl: event.eventImageUrl,
                        isTracked: true)
                }
            } onFailure: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
}
